#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tableau.py — la page de contrôle, construite à partir des fichiers de GT_Controle.

Lecture seule : ce script ne fait que lire les fichiers écrits par l'espion
(GT_Controle.mq5 / .mq4) et écrire une page HTML. Il ne parle à aucun terminal.

  python tableau.py                     # une page, puis s'arrête
  python tableau.py --boucle 60         # refait la page toutes les 60 s
  python tableau.py --dossier <chemin>  # autre dossier que celui des terminaux

Trois outils (définition de Denis, 24/09/2026) :
  A. Exécution : latence et spread (+ glissement par trade)
  B. Performance : trades en cours, creux, performances, creux maximal
  C. VPS : graphiques ouverts, bons robots, bons réglages
Ajouts validés le 24/09 : exposition et empilement, écart réel/test par robot,
glissement, marge et coupures, swaps.

Réglages de contrôle (facultatifs, à côté de ce script) :
  attendu.csv          compte;symbole;periode;robot;set;magic;nom
  references_test.csv  magic;nom;pf;gain_moyen;reussite_pct;trades_par_mois;source
  seuils.csv           nom;valeur   (voir SEUILS ci-dessous)
Toutes les heures affichées sont à l'heure de Paris.
"""
import argparse, csv, datetime as dt, html, json, os, statistics, sys, time

ICI = os.path.dirname(os.path.abspath(__file__))

SEUILS = {
    'empilement_positions': 5,      # positions d'un même côté sur un symbole
    'paquet_perte_pct': 2.0,        # perte cumulée au stop d'un paquet, % de l'équité
    'spread_multiple': 2.0,         # spread actuel contre médiane 24 h
    'marge_niveau_min': 500.0,      # niveau de marge en %
    'releve_muet_s': 120,           # plus vieux que ça = terminal muet
    'ping_ms_max': 150.0,
    'glissement_pts_alerte': 20.0,  # glissement moyen défavorable par symbole
    'ecart_test_pct': 30.0,         # écart réel/test jugé anormal
    'trades_min_ecart': 20,         # en dessous : pas de jugement réel/test
    'muet_multiple': 1.5,           # robot muet : silence > 1,5 × son plus long silence habituel (P95)
    'muet_min_h': 24.0,             # jamais d'alerte « muet » sous 24 h de marché ouvert
    'muet_ordres_min': 10,          # en dessous : pas assez d'historique pour juger
}


# ---------------------------------------------------------------- heure de Paris
def _dernier_dimanche(annee, mois):
    d = dt.date(annee, mois + 1, 1) - dt.timedelta(days=1) if mois < 12 else dt.date(annee, 12, 31)
    return d - dt.timedelta(days=(d.weekday() + 1) % 7)


def paris(utc):
    """UTC naïf -> heure de Paris (règle européenne, sans dépendre de tzdata)."""
    if utc is None:
        return None
    a = utc.year
    debut = dt.datetime.combine(_dernier_dimanche(a, 3), dt.time(1))
    fin = dt.datetime.combine(_dernier_dimanche(a, 10), dt.time(1))
    return utc + dt.timedelta(hours=2 if debut <= utc < fin else 1)


def lire_heure(s):
    try:
        return dt.datetime.strptime(s.strip(), '%Y.%m.%d %H:%M:%S')
    except (ValueError, AttributeError):
        return None


def hp(utc, fmt='%d/%m %H:%M'):
    p = paris(utc)
    return p.strftime(fmt) if p else '—'


# ---------------------------------------------------------------- lecture
def dossier_defaut():
    base = os.environ.get('APPDATA', os.path.expanduser('~'))
    return os.path.join(base, 'MetaQuotes', 'Terminal', 'Common', 'Files', 'GT_Controle')


def lire_csv(chemin):
    if not os.path.exists(chemin):
        return []
    with open(chemin, encoding='utf-8-sig', errors='replace', newline='') as f:
        return list(csv.DictReader(f, delimiter=';'))


def f(x, defaut=None):
    try:
        return float(str(x).replace(',', '.'))
    except (TypeError, ValueError):
        return defaut


def lire_set(chemin):
    """Fichier .set MT4/MT5 -> {nom: valeur}. MT5 ajoute ||début||pas||fin||Y après la valeur."""
    brut = open(chemin, 'rb').read()
    txt = brut.decode('utf-16') if brut[:2] in (b'\xff\xfe', b'\xfe\xff') else brut.decode('utf-8', 'replace')
    out = {}
    for l in txt.splitlines():
        l = l.strip()
        if not l or l.startswith(';') or '=' not in l:
            continue
        k, v = l.split('=', 1)
        if ',' in k and k.split(',')[-1].isdigit():   # MT4 : Lots,F=0 / Lots,1=...
            continue
        out[k.strip()] = v.split('||')[0].strip()
    return out


def valeurs_egales(a, b):
    fa, fb = f(a), f(b)
    if fa is not None and fb is not None:
        return abs(fa - fb) < 1e-9
    return str(a).strip().lower() == str(b).strip().lower()


def pct(v, n):
    if not v:
        return None
    v = sorted(v)
    return v[min(len(v) - 1, int(round(n / 100 * (len(v) - 1))))]


# ---------------------------------------------------------------- calculs
def serie_creux(valeurs):
    """[(t, v)] -> (creux courant, creux max, date du creux max, pic au creux max)."""
    pic, cmax, quand, pic_max = None, 0.0, None, None
    courant = 0.0
    for t, v in valeurs:
        if pic is None or v > pic:
            pic = v
        courant = pic - v
        if courant > cmax:
            cmax, quand, pic_max = courant, t, pic
    return courant, cmax, quand, pic_max


def heures_marche(t1, t2):
    """Heures entre t1 et t2 (UTC) sans les samedis et dimanches : un silence de week-end n'en est pas un."""
    if t2 <= t1:
        return 0.0
    h, t = 0.0, t1
    while t < t2:
        suivant = min(t2, dt.datetime.combine(t.date() + dt.timedelta(days=1), dt.time()))
        if t.weekday() < 5:
            h += (suivant - t).total_seconds() / 3600
        t = suivant
    return h


def robots_muets(ordres, maintenant, S):
    """Par magic : plus long silence habituel entre deux ordres posés (P95) et silence actuel."""
    par = {}
    for r in ordres:
        m, q = (r.get('magic') or '').strip(), lire_heure(r.get('utc_pose', ''))
        if m and m != '0' and q:
            par.setdefault(m, {'poses': [], 'nom': ''})['poses'].append(q)
            if r.get('commentaire'):
                par[m]['nom'] = r['commentaire']
    res = []
    for m, d in par.items():
        p = sorted(set(d['poses']))
        if len(p) < S['muet_ordres_min']:
            continue
        ecarts = sorted(heures_marche(a, b) for a, b in zip(p, p[1:]))
        p95 = ecarts[min(len(ecarts) - 1, int(0.95 * len(ecarts)))]
        seuil = max(S['muet_min_h'], S['muet_multiple'] * p95)
        silence = heures_marche(p[-1], maintenant)
        res.append({'magic': m, 'nom': d['nom'], 'dernier': p[-1], 'silence_h': silence,
                    'p95_h': p95, 'seuil_h': seuil, 'muet': silence > seuil})
    return sorted(res, key=lambda x: -x['silence_h'] / x['seuil_h'])



def analyser_compte(dossier, conf, maintenant):
    etat = json.load(open(os.path.join(dossier, 'etat.json'), encoding='utf-8-sig'))
    histo = lire_csv(os.path.join(dossier, 'historique.csv'))
    # equite_v2.csv : équité hors crédit du courtier ; l'ancien equite.csv comptait le crédit
    v2 = os.path.join(dossier, 'equite_v2.csv')
    equite = lire_csv(v2 if os.path.exists(v2) else os.path.join(dossier, 'equite.csv'))
    execs = lire_csv(os.path.join(dossier, 'executions.csv'))
    spreads = lire_csv(os.path.join(dossier, 'spreads.csv'))
    coupures = lire_csv(os.path.join(dossier, 'coupures.csv'))
    S = conf['seuils']
    cpt = etat['compte']
    num = str(cpt['numero'])
    alertes = []

    def alerte(niveau, outil, texte):
        alertes.append({'niveau': niveau, 'outil': outil, 'texte': texte})

    # ---- fraîcheur et terminal (C)
    releve = lire_heure(etat['releve_utc'])
    age = (maintenant - releve).total_seconds() if releve else 1e9
    term = etat['terminal']
    if age > S['releve_muet_s']:
        alerte('rouge', 'C', f"Terminal muet depuis {int(age // 60)} min : dernier relevé {hp(releve)}.")
    if not term['connecte']:
        alerte('rouge', 'C', 'Terminal déconnecté du courtier.')
    if not term['algo_autorise']:
        alerte('rouge', 'C', 'Bouton « Algo Trading » coupé : aucun robot ne peut trader.')
    if not term.get('compte_autorise_robots', True):
        alerte('rouge', 'C', 'Le courtier interdit le trading automatique sur ce compte.')

    # ---- B. performance : transactions fermées
    trades, depots, par_robot = [], [], {}
    for r in histo:
        t = lire_heure(r['utc'])
        net = sum(f(r[k], 0) for k in ('profit', 'swap', 'commission', 'frais'))
        if r['type'] == 'solde':
            depots.append((t, net))
            continue
        if r['type'] not in ('achat', 'vente'):
            continue
        trades.append((t, net, r))
        m = r['magic']
        d = par_robot.setdefault(m, {'magic': m, 'nets': [], 'swap': 0.0, 'commission': 0.0,
                                     'entrees': 0, 'dernier': None, 'symboles': set()})
        d['swap'] += f(r['swap'], 0)
        d['commission'] += f(r['commission'], 0) + f(r['frais'], 0)
        d['symboles'].add(r['symbole'])
        if r['entree'] == 'in':
            d['entrees'] += 1
        else:
            d['nets'].append((t, net))
        d['dernier'] = t
    trades.sort(key=lambda x: x[0] or dt.datetime.min)

    # courbe de solde reconstruite (dépôts + trades), pour le creux sur trades fermés
    evts = sorted([(t, v) for t, v in depots] + [(t, v) for t, v, _ in trades], key=lambda x: x[0] or dt.datetime.min)
    solde, courbe_solde = 0.0, []
    for t, v in evts:
        solde += v
        courbe_solde.append((t, solde))
    _, creux_ferme_max, creux_ferme_quand, pic_ferme = serie_creux(courbe_solde)

    def net_depuis(debut):
        return sum(v for t, v, _ in trades if t and t >= debut)
    jour_paris = paris(maintenant).replace(hour=0, minute=0, second=0)
    decal = paris(maintenant) - maintenant
    debut_jour = jour_paris - decal
    debut_semaine = debut_jour - dt.timedelta(days=jour_paris.weekday())
    debut_mois = jour_paris.replace(day=1) - decal
    perf = {
        'jour': net_depuis(debut_jour), 'semaine': net_depuis(debut_semaine),
        'mois': net_depuis(debut_mois), 'total': sum(v for _, v, _ in trades),
        'depots': sum(v for _, v in depots),
    }

    # creux sur l'équité (relevés minute), le vrai creux vécu, flottant compris
    serie_eq = [(lire_heure(r['utc']), f(r['equite'])) for r in equite if f(r['equite']) is not None]
    creux_eq, creux_eq_max, creux_eq_quand, pic_eq = serie_creux(serie_eq)
    eq_now = cpt['equite']
    if serie_eq:
        pic_eq_courant = max(v for _, v in serie_eq)
        creux_eq = max(0.0, pic_eq_courant - eq_now)
    else:
        pic_eq_courant = eq_now
    perf.update({
        'creux_courant': creux_eq, 'creux_courant_pct': 100 * creux_eq / pic_eq_courant if pic_eq_courant else 0,
        'creux_max_equite': creux_eq_max, 'creux_max_equite_pct': 100 * creux_eq_max / pic_eq if pic_eq else 0,
        'creux_max_equite_quand': creux_eq_quand,
        'creux_max_ferme': creux_ferme_max, 'creux_max_ferme_pct': 100 * creux_ferme_max / pic_ferme if pic_ferme else 0,
        'creux_max_ferme_quand': creux_ferme_quand,
        'suivi_depuis': serie_eq[0][0] if serie_eq else None,
        'premier_trade': trades[0][0] if trades else None,
    })

    # ---- robots : noms, performance, swaps, écart réel/test (ajouts 2 et 5)
    noms = {a['magic']: a.get('nom') or a.get('robot') for a in conf['attendu'] if a.get('magic')}
    refs = {r['magic']: r for r in conf['references']}
    robots = []
    for m, d in par_robot.items():
        nets = [v for _, v in d['nets']]
        gains = sum(v for v in nets if v > 0)
        pertes = -sum(v for v in nets if v < 0)
        _, cmax, _, _ = serie_creux([(t, c) for t, c in _cumul(d['nets'])])
        rob = {
            'magic': m, 'nom': noms.get(m) or (refs.get(m, {}).get('nom')) or '',
            'symboles': ', '.join(sorted(d['symboles'])),
            'trades': len(nets), 'net': sum(nets),
            'pf': gains / pertes if pertes else None,
            'reussite': 100 * sum(1 for v in nets if v > 0) / len(nets) if nets else None,
            'moyen': statistics.mean(nets) if nets else None,
            'creux_max': cmax, 'swap': d['swap'], 'commission': d['commission'],
            'dernier': d['dernier'], 'ecarts': [],
        }
        ref = refs.get(m)
        if ref:
            n_ok = len(nets) >= S['trades_min_ecart']
            for cle, lib in (('pf', 'PF'), ('moyen', 'gain moyen'), ('reussite', 'réussite')):
                cle_ref = {'moyen': 'gain_moyen', 'reussite': 'reussite_pct'}.get(cle, cle)
                v_test = f(ref.get(cle_ref))
                v_reel = rob[cle]
                if v_test is None or v_reel is None:
                    continue
                e = 100 * (v_reel - v_test) / abs(v_test) if v_test else None
                rob['ecarts'].append({'lib': lib, 'test': v_test, 'reel': v_reel, 'ecart': e, 'jugeable': n_ok})
                if n_ok and e is not None and e < -S['ecart_test_pct']:
                    alerte('orange', '+2', f"Robot {rob['nom'] or m} : {lib} réel {v_reel:.2f} contre {v_test:.2f} au test ({e:+.0f} %).")
            rob['source_test'] = ref.get('source', '')
        robots.append(rob)
    robots.sort(key=lambda r: -r['trades'])

    # ---- positions et exposition (ajout 1)
    positions = etat['positions']
    paquets = {}
    for p in positions:
        k = (p['symbole'], p['sens'])
        g = paquets.setdefault(k, {'symbole': p['symbole'], 'sens': p['sens'], 'n': 0, 'lots': 0.0,
                                   'flottant': 0.0, 'perte_sl': 0.0, 'sans_stop': 0, 'magics': set()})
        g['n'] += 1
        g['lots'] += p['volume']
        g['flottant'] += p['profit'] + p['swap']
        g['magics'].add(str(p['magic']))
        if p['perte_au_sl'] is None:
            g['sans_stop'] += 1
        else:
            g['perte_sl'] += p['perte_au_sl']
    for g in paquets.values():
        g['perte_sl_pct'] = 100 * -g['perte_sl'] / eq_now if eq_now else 0
        if g['n'] >= S['empilement_positions']:
            alerte('rouge', '+1', f"Empilement : {g['n']} {g['sens']}s sur {g['symbole']} ({g['lots']:.2f} lot), flottant {g['flottant']:+.2f}.")
        if g['sans_stop']:
            alerte('orange', '+1', f"{g['sans_stop']} position(s) {g['sens']} sur {g['symbole']} sans stop : perte du paquet non plafonnée.")
        elif g['perte_sl_pct'] > S['paquet_perte_pct']:
            alerte('rouge', '+1', f"Paquet {g['sens']} {g['symbole']} : {g['perte_sl']:.2f} si tous les stops sont touchés ({g['perte_sl_pct']:.1f} % de l'équité).")

    # ---- marge et coupures (ajout 4)
    nm = cpt['niveau_marge']
    if positions and 0 < nm < S['marge_niveau_min']:
        alerte('rouge', '+4', f"Niveau de marge {nm:.0f} % (appel de marge à {cpt['appel_marge']:.0f} %, stop out à {cpt['stop_out']:.0f} %).")
    sept_j = maintenant - dt.timedelta(days=7)
    coup = [c for c in coupures if (lire_heure(c['debut_utc']) or dt.datetime.min) >= sept_j]
    coup_tot = sum(f(c['duree_s'], 0) for c in coup)
    if coup:
        alerte('orange' if coup_tot < 300 else 'rouge', '+4',
               f"{len(coup)} coupure(s) de connexion en 7 jours, {coup_tot / 60:.1f} min au total.")

    # ---- A. exécution : ping, délai serveur, spread, glissement
    h24 = maintenant - dt.timedelta(hours=24)
    pings = [f(r['ping_ms']) for r in equite if (lire_heure(r['utc']) or dt.datetime.min) >= h24 and f(r['ping_ms'])]
    if term['ping_ms'] > S['ping_ms_max']:
        alerte('orange', 'A', f"Latence vers le courtier {term['ping_ms']:.0f} ms (seuil {S['ping_ms_max']:.0f}).")
    ex_sym = {}
    for r in execs:
        e = ex_sym.setdefault(r['symbole'], {'glis': [], 'glis_arg': 0.0, 'delai': [], 'spread': [], 'n': 0})
        e['n'] += 1
        if f(r['glissement_points']) is not None:
            e['glis'].append(f(r['glissement_points']))
            e['glis_arg'] += f(r['glissement_argent'], 0)
        if f(r['delai_serveur_ms']) is not None:
            e['delai'].append(f(r['delai_serveur_ms']))
        if f(r['spread_points']) is not None:
            e['spread'].append(f(r['spread_points']))
    execution = []
    for s, e in sorted(ex_sym.items()):
        ligne = {
            'symbole': s, 'n': e['n'],
            'glis_moyen': statistics.mean(e['glis']) if e['glis'] else None,
            'glis_p95': pct(e['glis'], 95), 'glis_argent': e['glis_arg'],
            'glis_defavorables': sum(1 for g in e['glis'] if g > 0),
            'delai_med': statistics.median(e['delai']) if e['delai'] else None,
            'delai_p95': pct(e['delai'], 95),
            'spread_med': statistics.median(e['spread']) if e['spread'] else None,
        }
        execution.append(ligne)
        if ligne['glis_moyen'] is not None and ligne['glis_moyen'] > S['glissement_pts_alerte']:
            alerte('orange', 'A', f"Glissement moyen défavorable sur {s} : {ligne['glis_moyen']:.1f} points ({ligne['glis_argent']:+.2f} au total).")
    sp_hist = {}
    for r in spreads:
        if (lire_heure(r['utc']) or dt.datetime.min) >= h24 and f(r['moyen']) is not None:
            sp_hist.setdefault(r['symbole'], []).append((f(r['moyen']), f(r['max'], 0)))
    spread_tab = []
    for sp in etat['spreads']:
        h = sp_hist.get(sp['symbole'], [])
        med = statistics.median([m for m, _ in h]) if h else None
        mx = max((x for _, x in h), default=None)
        spread_tab.append({'symbole': sp['symbole'], 'actuel': sp['spread_points'], 'med24': med, 'max24': mx})
        if med and sp['spread_points'] > S['spread_multiple'] * med and sp['spread_points'] > 5:
            alerte('orange', 'A', f"Spread {sp['symbole']} à {sp['spread_points']} points, contre {med:.0f} de médiane sur 24 h.")

    # ---- C. graphiques, robots et réglages
    graphiques = etat['graphiques']
    for g in graphiques:  # MT5 renvoie « NULL » comme nom quand le graphique n'a pas de robot
        if g['etat'] == 'aucun_robot' or str(g.get('robot', '')).upper() == 'NULL':
            g['robot'] = ''
    attendu = [a for a in conf['attendu'] if a.get('compte', '').strip() in ('', num)]
    controle_c = []
    vus = set()
    for a in attendu:
        trouve = None
        for g in graphiques:
            if g['id'] in vus:
                continue
            if (g['symbole'].lower() == a['symbole'].strip().lower()
                    and (not a.get('periode') or g['periode'].upper() == a['periode'].strip().upper())
                    and g['robot'].lower() == a['robot'].strip().lower()):
                trouve = g
                break
        ligne = {'attendu': a, 'graphique': trouve, 'diff': [], 'statut': 'ok'}
        if not trouve:
            ligne['statut'] = 'absent'
            alerte('rouge', 'C', f"Robot attendu absent : {a['robot']} sur {a['symbole']} {a.get('periode', '')}.")
        else:
            vus.add(trouve['id'])
            nom_set = (a.get('set') or '').strip()
            if nom_set:
                chemin = os.path.join(conf['dossier_sets'], nom_set)
                if not os.path.exists(chemin):
                    ligne['statut'] = 'set_introuvable'
                    alerte('orange', 'C', f"Réglage de référence {nom_set} introuvable dans {conf['dossier_sets']}.")
                elif not trouve['reglages']:
                    ligne['statut'] = 'reglages_illisibles'
                    alerte('orange', 'C', f"Réglages de {a['robot']} sur {a['symbole']} illisibles ({trouve['etat']}).")
                else:
                    ref = lire_set(chemin)
                    for k, v in ref.items():
                        if k not in trouve['reglages']:
                            ligne['diff'].append((k, v, '(absent)'))
                        elif not valeurs_egales(v, trouve['reglages'][k]):
                            ligne['diff'].append((k, v, trouve['reglages'][k]))
                    if ligne['diff']:
                        ligne['statut'] = 'reglages_differents'
                        alerte('rouge', 'C', f"{a['robot']} sur {a['symbole']} : {len(ligne['diff'])} réglage(s) différent(s) de {nom_set}.")
        controle_c.append(ligne)
    inattendus = [g for g in graphiques if g['robot'] and g['etat'] != 'espion' and g['id'] not in vus]
    if attendu:
        for g in inattendus:
            alerte('orange', 'C', f"Robot non prévu : {g['robot']} sur {g['symbole']} {g['periode']}.")

    # C : robot chargé mais muet (aucun ordre posé depuis plus longtemps que d'habitude)
    muets = robots_muets(lire_csv(os.path.join(dossier, 'ordres.csv')), maintenant, S)
    for r in muets:
        if r['muet']:
            alerte('rouge', 'C', f"Robot muet : {r['nom'] or r['magic']} (magic {r['magic']}) n'a posé aucun ordre depuis "
                                 f"{hp(r['dernier'])}, soit {r['silence_h']:.0f} h de marché ; son plus long silence habituel est "
                                 f"{r['p95_h']:.0f} h.")

    ordre = {'rouge': 0, 'orange': 1}
    alertes.sort(key=lambda a: ordre.get(a['niveau'], 2))
    return {
        'etat': etat, 'releve': releve, 'age': age, 'alertes': alertes, 'perf': perf, 'robots': robots,
        'positions': positions, 'paquets': sorted(paquets.values(), key=lambda g: -g['n']),
        'coupures': coup, 'coupures_total_s': coup_tot, 'pings': pings, 'execution': execution,
        'executions_recentes': execs[-15:][::-1], 'spreads': spread_tab, 'controle_c': controle_c,
        'inattendus': inattendus, 'attendu_defini': bool(attendu),
        'courbe_equite': serie_eq, 'courbe_solde': courbe_solde,
    }


def _cumul(nets):
    s, out = 0.0, []
    for t, v in sorted(nets, key=lambda x: x[0] or dt.datetime.min):
        s += v
        out.append((t, s))
    return out


# ---------------------------------------------------------------- page
CSS = """
:root{--fond:#f6f7f9;--carte:#fff;--texte:#1c2230;--doux:#5d6677;--trait:#e2e5ea;
--rouge:#c62828;--rouge-f:#fdecea;--orange:#b26a00;--orange-f:#fff4e0;--vert:#2e7d32;--vert-f:#e8f5e9;--bleu:#2458a6}
@media (prefers-color-scheme:dark){:root{--fond:#12151b;--carte:#1b1f27;--texte:#e6e8ec;--doux:#98a0ad;--trait:#2c323d;
--rouge:#ef6b6b;--rouge-f:#3a1d1f;--orange:#f0a64a;--orange-f:#3a2c17;--vert:#6cc070;--vert-f:#1b3320;--bleu:#79a6ef}}
*{box-sizing:border-box}body{margin:0;background:var(--fond);color:var(--texte);font:14px/1.45 system-ui,-apple-system,Segoe UI,Roboto,sans-serif}
main{max-width:1200px;margin:0 auto;padding:16px}
h1{font-size:20px;margin:0 0 4px}h2{font-size:16px;margin:0 0 10px}h3{font-size:14px;margin:14px 0 6px;color:var(--doux)}
.sous{color:var(--doux);font-size:13px}
.carte{background:var(--carte);border:1px solid var(--trait);border-radius:10px;padding:14px 16px;margin:12px 0}
.tuiles{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:10px}
.tuile{border:1px solid var(--trait);border-radius:8px;padding:8px 10px}.tuile b{display:block;font-size:18px}
.tuile span{color:var(--doux);font-size:12px}
table{width:100%;border-collapse:collapse;font-size:13px}th,td{padding:5px 8px;border-bottom:1px solid var(--trait);text-align:right;white-space:nowrap}
th{color:var(--doux);font-weight:600}th:first-child,td:first-child{text-align:left}td.g{text-align:left}
.defile{overflow-x:auto}
.al{padding:6px 10px;border-radius:6px;margin:4px 0}.al.rouge{background:var(--rouge-f);color:var(--rouge)}
.al.orange{background:var(--orange-f);color:var(--orange)}.ok{background:var(--vert-f);color:var(--vert);padding:6px 10px;border-radius:6px}
.pos{color:var(--vert)}.neg{color:var(--rouge)}.badge{font-size:11px;padding:1px 6px;border-radius:9px;border:1px solid var(--trait);color:var(--doux)}
svg{width:100%;height:120px;display:block}
"""


def e(x):
    return html.escape(str(x))


def n(v, d=2, signe=False):
    if v is None:
        return '—'
    s = f"{v:+,.{d}f}" if signe else f"{v:,.{d}f}"
    return s.replace(',', ' ').replace('.', ',')


def cls(v):
    return '' if v is None else ('pos' if v > 0 else 'neg' if v < 0 else '')


def courbe_svg(serie, couleur='var(--bleu)'):
    pts = [(t, v) for t, v in serie if t and v is not None]
    if len(pts) < 2:
        return '<p class="sous">Pas encore assez de relevés pour tracer la courbe.</p>'
    t0, t1 = pts[0][0], pts[-1][0]
    vs = [v for _, v in pts]
    lo, hi = min(vs), max(vs)
    if hi == lo:
        hi = lo + 1
    span = max(1.0, (t1 - t0).total_seconds())
    if len(pts) > 600:
        pas = len(pts) // 600 + 1
        pts = pts[::pas] + [pts[-1]]
    coords = ' '.join(f"{1000 * (t - t0).total_seconds() / span:.1f},{110 - 100 * (v - lo) / (hi - lo):.1f}" for t, v in pts)
    return (f'<svg viewBox="0 0 1000 120" preserveAspectRatio="none" role="img" aria-label="courbe">'
            f'<polyline fill="none" stroke="{couleur}" stroke-width="2" vector-effect="non-scaling-stroke" points="{coords}"/></svg>'
            f'<div class="sous">{hp(t0)} → {hp(t1)} · de {n(lo)} à {n(hi)}</div>')


def page_compte(a):
    et, c, t, p = a['etat'], a['etat']['compte'], a['etat']['terminal'], a['perf']
    dev = c['devise']
    o = []
    o.append(f'<section class="carte"><h1>Compte {e(c["numero"])} · {e(c["courtier"])} '
             f'<span class="badge">{"RÉEL" if c["reel"] else "démo"}</span></h1>'
             f'<div class="sous">{e(c["serveur"])} · relevé {hp(a["releve"], "%d/%m %H:%M:%S")} (heure de Paris)'
             f' · ping {n(t["ping_ms"], 0)} ms · {"connecté" if t["connecte"] else "DÉCONNECTÉ"}'
             f' · Algo Trading {"actif" if t["algo_autorise"] else "COUPÉ"}</div>')
    if a['alertes']:
        for al in a['alertes']:
            o.append(f'<div class="al {al["niveau"]}"><b>[{e(al["outil"])}]</b> {e(al["texte"])}</div>')
    else:
        o.append('<div class="ok">Aucune alerte.</div>')
    o.append('</section>')

    # B
    o.append('<section class="carte"><h2>B · Performance</h2><div class="tuiles">')
    for lib, v, s in (('Solde', c['solde'], False), ('Équité', c['equite'], False),
                      ('Flottant', c['equite'] - c['solde'], True), ("Aujourd'hui", p['jour'], True),
                      ('Cette semaine', p['semaine'], True), ('Ce mois', p['mois'], True),
                      ('Depuis le début', p['total'], True)):
        o.append(f'<div class="tuile"><span>{lib}</span><b class="{cls(v) if s else ""}">{n(v, 2, s)} {e(dev)}</b></div>')
    o.append(f'<div class="tuile"><span>Creux actuel (équité)</span><b>{n(p["creux_courant"])} · {n(p["creux_courant_pct"], 2)} %</b></div>')
    o.append(f'<div class="tuile"><span>Creux max (équité, depuis {hp(p["suivi_depuis"], "%d/%m")})</span>'
             f'<b>{n(p["creux_max_equite"])} · {n(p["creux_max_equite_pct"], 2)} %</b><span>{hp(p["creux_max_equite_quand"])}</span></div>')
    o.append(f'<div class="tuile"><span>Creux max (trades fermés, depuis {hp(p["premier_trade"], "%d/%m/%y")})</span>'
             f'<b>{n(p["creux_max_ferme"])} · {n(p["creux_max_ferme_pct"], 2)} %</b><span>{hp(p["creux_max_ferme_quand"])}</span></div>')
    o.append('</div><h3>Équité (relevé chaque minute)</h3>' + courbe_svg(a['courbe_equite']))

    o.append('<h3>Par robot (trades fermés) · swaps · écart réel contre test</h3><div class="defile"><table>'
             '<tr><th>Robot</th><th>Symboles</th><th>Trades</th><th>Net</th><th>PF</th><th>Réussite</th>'
             '<th>Gain moyen</th><th>Creux max</th><th>Swaps</th><th>Commissions</th><th>Dernier</th><th>Réel contre test</th></tr>')
    for r in a['robots']:
        if r['ecarts']:
            ec = '<br>'.join(f"{e(x['lib'])} {n(x['reel'])} / {n(x['test'])} ({n(x['ecart'], 0, True)} %)"
                             + ('' if x['jugeable'] else ' <span class="badge">trop tôt</span>') for x in r['ecarts'])
        else:
            ec = '<span class="sous">référence de test à fournir</span>'
        o.append(f'<tr><td>{e(r["nom"] or "")} <span class="badge">{e(r["magic"])}</span></td><td class="g">{e(r["symboles"])}</td>'
                 f'<td>{r["trades"]}</td><td class="{cls(r["net"])}">{n(r["net"], 2, True)}</td><td>{n(r["pf"])}</td>'
                 f'<td>{n(r["reussite"], 0)} %</td><td>{n(r["moyen"], 2, True)}</td><td>{n(r["creux_max"])}</td>'
                 f'<td class="{cls(r["swap"])}">{n(r["swap"], 2, True)}</td><td>{n(r["commission"], 2, True)}</td>'
                 f'<td>{hp(r["dernier"])}</td><td class="g">{ec}</td></tr>')
    o.append('</table></div></section>')

    # Exposition + positions
    o.append('<section class="carte"><h2>Exposition par symbole et par sens · empilement</h2>')
    if a['paquets']:
        o.append('<div class="defile"><table><tr><th>Symbole</th><th>Sens</th><th>Positions</th><th>Lots</th>'
                 '<th>Flottant</th><th>Si tous les stops sont touchés</th><th>% équité</th><th>Sans stop</th><th>Robots</th></tr>')
        for g in a['paquets']:
            o.append(f'<tr><td>{e(g["symbole"])}</td><td>{e(g["sens"])}</td><td>{g["n"]}</td><td>{n(g["lots"])}</td>'
                     f'<td class="{cls(g["flottant"])}">{n(g["flottant"], 2, True)}</td><td>{n(g["perte_sl"], 2, True)}</td>'
                     f'<td>{n(g["perte_sl_pct"], 2)} %</td><td>{g["sans_stop"] or ""}</td><td class="g">{e(", ".join(sorted(g["magics"])))}</td></tr>')
        o.append('</table></div><h3>Positions en cours</h3><div class="defile"><table><tr><th>Ouverture</th><th>Symbole</th>'
                 '<th>Sens</th><th>Lots</th><th>Prix</th><th>Stop</th><th>Objectif</th><th>Profit</th><th>Swap</th><th>Robot</th></tr>')
        for q in sorted(a['positions'], key=lambda q: q['ouverture_utc']):
            o.append(f'<tr><td>{hp(lire_heure(q["ouverture_utc"]))}</td><td>{e(q["symbole"])}</td><td>{e(q["sens"])}</td>'
                     f'<td>{n(q["volume"])}</td><td>{q["prix"]}</td><td>{q["sl"] or "—"}</td><td>{q["tp"] or "—"}</td>'
                     f'<td class="{cls(q["profit"])}">{n(q["profit"], 2, True)}</td><td>{n(q["swap"], 2, True)}</td>'
                     f'<td class="g">{e(q["magic"])} {e(q["commentaire"])}</td></tr>')
        o.append('</table></div>')
    else:
        o.append('<p class="sous">Aucune position ouverte.</p>')
    o.append(f'<h3>Marge</h3><p>Niveau {n(c["niveau_marge"], 0) if c["marge"] else "— (aucune marge utilisée)"} %'
             f' · marge libre {n(c["marge_libre"])} {e(dev)} · appel à {n(c["appel_marge"], 0)} %, stop out à {n(c["stop_out"], 0)} % · levier 1:{c["levier"]}</p></section>')

    # A
    o.append('<section class="carte"><h2>A · Exécution : latence, spread, glissement</h2><div class="tuiles">')
    pg = a['pings']
    o.append(f'<div class="tuile"><span>Ping actuel</span><b>{n(t["ping_ms"], 0)} ms</b></div>')
    o.append(f'<div class="tuile"><span>Ping médian 24 h</span><b>{n(statistics.median(pg), 0) if pg else "—"} ms</b></div>')
    o.append(f'<div class="tuile"><span>Ping 95e centile 24 h</span><b>{n(pct(pg, 95), 0)} ms</b></div>')
    o.append(f'<div class="tuile"><span>Coupures 7 jours</span><b>{len(a["coupures"])} · {n(a["coupures_total_s"] / 60, 1)} min</b></div>')
    o.append('</div><h3>Spreads (points)</h3><div class="defile"><table><tr><th>Symbole</th><th>Actuel</th><th>Médiane 24 h</th><th>Max 24 h</th></tr>')
    for s in a['spreads']:
        o.append(f'<tr><td>{e(s["symbole"])}</td><td>{s["actuel"]}</td><td>{n(s["med24"], 1)}</td><td>{n(s["max24"], 0)}</td></tr>')
    o.append('</table></div><h3>Par symbole, depuis le début du suivi (glissement positif = défavorable)</h3>')
    if a['execution']:
        o.append('<div class="defile"><table><tr><th>Symbole</th><th>Exécutions</th><th>Glissement moyen (pts)</th><th>95e centile</th>'
                 '<th>Défavorables</th><th>Coût total</th><th>Délai serveur médian</th><th>95e centile</th><th>Spread médian à l\'exécution</th></tr>')
        for x in a['execution']:
            o.append(f'<tr><td>{e(x["symbole"])}</td><td>{x["n"]}</td><td>{n(x["glis_moyen"], 1, True)}</td><td>{n(x["glis_p95"], 1, True)}</td>'
                     f'<td>{x["glis_defavorables"]}</td><td class="{cls(-x["glis_argent"])}">{n(-x["glis_argent"], 2, True)}</td>'
                     f'<td>{n(x["delai_med"], 0)} ms</td><td>{n(x["delai_p95"], 0)} ms</td><td>{n(x["spread_med"], 0)}</td></tr>')
        o.append('</table></div><h3>Dernières exécutions</h3><div class="defile"><table><tr><th>Heure</th><th>Symbole</th><th>Sens</th>'
                 '<th>Entrée/sortie</th><th>Ordre</th><th>Lots</th><th>Demandé</th><th>Obtenu</th><th>Glissement</th><th>Délai</th><th>Spread</th><th>Ping</th></tr>')
        for r in a['executions_recentes']:
            o.append(f'<tr><td>{hp(lire_heure(r["utc"]), "%d/%m %H:%M:%S")}</td><td>{e(r["symbole"])}</td><td>{e(r["sens"])}</td>'
                     f'<td>{e(r["entree"])}</td><td>{e(r["type_ordre"])}</td><td>{e(r["volume"])}</td><td>{e(r["prix_demande"]) or "—"}</td>'
                     f'<td>{e(r["prix_obtenu"])}</td><td>{e(r["glissement_points"]) or "—"}</td><td>{e(r["delai_serveur_ms"]) or "—"} ms</td>'
                     f'<td>{e(r["spread_points"])}</td><td>{e(r["ping_ms"])} ms</td></tr>')
        o.append('</table></div>')
    else:
        o.append('<p class="sous">Aucune exécution depuis que l\'espion tourne : les chiffres apparaîtront au premier trade.</p>')
    o.append('</section>')

    # C
    o.append('<section class="carte"><h2>C · Graphiques, robots et réglages</h2>')
    if a['attendu_defini']:
        o.append('<div class="defile"><table><tr><th>Attendu</th><th>Symbole</th><th>Période</th><th>Réglage de référence</th><th>Statut</th></tr>')
        lib = {'ok': 'conforme', 'absent': 'ABSENT', 'set_introuvable': 'référence introuvable',
               'reglages_illisibles': 'réglages illisibles', 'reglages_differents': 'RÉGLAGES DIFFÉRENTS'}
        for l in a['controle_c']:
            at = l['attendu']
            st = lib[l['statut']] if (l['statut'] != 'ok' or at.get('set')) else 'robot présent (pas de réglage de référence)'
            o.append(f'<tr><td>{e(at["robot"])}</td><td>{e(at["symbole"])}</td><td>{e(at.get("periode", ""))}</td>'
                     f'<td class="g">{e(at.get("set", "") or "—")}</td><td class="g {"pos" if l["statut"] == "ok" else "neg"}">{e(st)}</td></tr>')
            for k, v_ref, v_vu in l['diff'][:30]:
                o.append(f'<tr><td></td><td colspan="2" class="g sous">{e(k)}</td><td class="g">attendu {e(v_ref)}</td><td class="g neg">chargé {e(v_vu)}</td></tr>')
        o.append('</table></div>')
    else:
        o.append('<p class="sous">Liste des robots attendus pas encore remplie (attendu.csv) : ci-dessous, ce qui est chargé.</p>')
    o.append('<h3>Tous les graphiques ouverts</h3><div class="defile"><table><tr><th>Symbole</th><th>Période</th><th>Robot</th><th>Réglages lus</th></tr>')
    for g in a['etat']['graphiques']:
        o.append(f'<tr><td>{e(g["symbole"])}</td><td>{e(g["periode"])}</td><td class="g">{e(g["robot"] or "—")}</td>'
                 f'<td class="g">{len(g["reglages"]) if g["reglages"] else e(g["etat"])}</td></tr>')
    o.append('</table></div></section>')
    return '\n'.join(o)


def construire(dossier, sortie, conf):
    maintenant = dt.datetime.now(dt.timezone.utc).replace(tzinfo=None, microsecond=0)
    comptes, erreurs = [], []
    if os.path.isdir(dossier):
        for nom in sorted(os.listdir(dossier)):
            d = os.path.join(dossier, nom)
            if os.path.exists(os.path.join(d, 'etat.json')):
                try:
                    comptes.append(analyser_compte(d, conf, maintenant))
                except Exception as ex:  # un compte illisible ne doit pas masquer les autres
                    erreurs.append(f'{nom} : {ex!r}')
    comptes.sort(key=lambda a: (not a['etat']['compte']['reel'], str(a['etat']['compte']['numero'])))
    rouges = sum(1 for a in comptes for al in a['alertes'] if al['niveau'] == 'rouge')
    corps = [f'<main><h1>Contrôle des comptes</h1><p class="sous">Page refaite {hp(maintenant, "%d/%m/%Y %H:%M:%S")} (heure de Paris) · '
             f'{len(comptes)} compte(s) · {rouges} alerte(s) rouge(s) · lecture seule, aucun ordre n\'est passé par ces outils</p>']
    if not comptes:
        corps.append(f'<div class="al orange">Aucun fichier de l\'espion trouvé dans {e(dossier)}. '
                     'GT_Controle est-il posé sur un graphique ?</div>')
    for er in erreurs:
        corps.append(f'<div class="al rouge">Compte illisible : {e(er)}</div>')
    for a in comptes:
        corps.append(page_compte(a))
    corps.append('</main>')
    doc = ('<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">'
           f'<meta http-equiv="refresh" content="60"><title>Contrôle des comptes</title><style>{CSS}</style></head><body>'
           + '\n'.join(corps) + '</body></html>')
    tmp = sortie + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as fo:
        fo.write(doc)
    os.replace(tmp, sortie)
    resume = {'refait_utc': maintenant.strftime('%Y.%m.%d %H:%M:%S'), 'comptes': [
        {'numero': a['etat']['compte']['numero'], 'reel': a['etat']['compte']['reel'],
         'equite': a['etat']['compte']['equite'], 'alertes': a['alertes']} for a in comptes]}
    with open(os.path.join(os.path.dirname(sortie), 'resume.json'), 'w', encoding='utf-8') as fo:
        json.dump(resume, fo, ensure_ascii=False, indent=1)
    return comptes


def charger_conf(args):
    seuils = dict(SEUILS)
    for r in lire_csv(os.path.join(args.reglages, 'seuils.csv')):
        if r.get('nom') in seuils and f(r.get('valeur')) is not None:
            seuils[r['nom']] = f(r['valeur'])
    return {
        'seuils': seuils,
        'attendu': [r for r in lire_csv(os.path.join(args.reglages, 'attendu.csv')) if r.get('robot')],
        'references': [r for r in lire_csv(os.path.join(args.reglages, 'references_test.csv')) if r.get('magic')],
        'dossier_sets': os.path.join(args.reglages, 'sets'),
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--dossier', default=dossier_defaut(), help="dossier GT_Controle des terminaux")
    ap.add_argument('--sortie', default=None, help='page HTML (défaut : tableau.html dans --dossier)')
    ap.add_argument('--reglages', default=ICI, help='dossier de attendu.csv, references_test.csv, seuils.csv, sets/')
    ap.add_argument('--boucle', type=int, default=0, help='refaire la page toutes les N secondes')
    args = ap.parse_args()
    sortie = args.sortie or os.path.join(args.dossier, 'tableau.html')
    os.makedirs(os.path.dirname(sortie) or '.', exist_ok=True)
    while True:
        comptes = construire(args.dossier, sortie, charger_conf(args))
        print(f"{dt.datetime.now():%H:%M:%S} page refaite : {sortie} ({len(comptes)} compte(s))", flush=True)
        if not args.boucle:
            break
        time.sleep(args.boucle)


if __name__ == '__main__':
    main()
