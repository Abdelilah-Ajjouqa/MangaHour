# 01 — Requirements (Cahier des charges)

<aside>

**Cahier des charges — Manga Reader App (MVP)**
Arabic-first (RTL) manga/manhwa/manhua reader for Android & iOS, built with Flutter, backendless, using MangaDex + Jikan with local storage for user data.

</aside>

## 1. Contexte & objectif

- **But:** offrir une expérience de lecture rapide et confortable, pensée d'abord pour l'arabe (RTL), pour lire manga / manhwa / manhua.
- **Problème résolu:** la plupart des lecteurs gèrent mal l'arabe et le RTL (typographie, navigation, mise en page).
- **Périmètre MVP:** application mobile sans backend propre, alimentée par des APIs externes (MangaDex + Jikan), avec données utilisateur stockées localement.

## 2. Public cible

- Lecteurs du monde arabe (priorité absolue à l'arabe + RTL).
- Lecteurs préférant l'anglais (langue de secours).
- Utilisateurs mobiles Android & iOS (téléphones milieu de gamme inclus).

## 3. Langues & RTL

- **Arabe = langue par défaut**, support RTL complet (navigation, layouts, typographie, icônes directionnelles).
- **Anglais = fallback** quand l'arabe n'est pas disponible.
- Les chapitres priorisent les traductions arabes lorsqu'elles existent.

## 4. Exigences fonctionnelles (MVP)

| # | Fonctionnalité | Description | Priorité |
| --- | --- | --- | --- |
| F1 | Recherche / Catalogue | Rechercher et parcourir des titres (MangaDex) | Haute |
| F2 | Détails d'un titre | Couverture, synopsis, genres/tags, langues dispo | Haute |
| F3 | Liste des chapitres | Chapitres triés, filtrés par langue (arabe d'abord) | Haute |
| F4 | Lecteur (Reader) | Modes **paginé** (RTL/LTR) + **vertical** (scroll) | Haute |
| F5 | Progression de lecture | Sauvegarde auto (dernier chapitre + position) | Haute |
| F6 | Favoris / Bibliothèque | Ajouter/retirer des favoris (local) | Haute |
| F7 | Historique | Titres/chapitres récemment ouverts | Moyenne |
| F8 | Paramètres | Langue, mode de lecture, direction, cache | Moyenne |
| F9 | Cache / Hors-ligne léger | Mise en cache des images pendant la lecture | Moyenne |
| F10 | Gestion d'erreurs | États vides, retry, gestion rate limits | Haute |

## 5. Exigences non-fonctionnelles

- **Performance:** scroll fluide, préchargement des pages adjacentes, lecteur réactif sur appareils milieu de gamme.
- **Fiabilité:** comportement correct en réseau faible (retry, timeouts, messages clairs).
- **Sécurité / Vie privée:** données utilisateur stockées **uniquement sur l'appareil** (favoris, progression, cache).
- **Maintenabilité:** Clean Architecture + feature-first modular (code testable, modules isolés).
- **Compatibilité:** Android & iOS, support RTL natif.
- **Accessibilité:** tailles de texte lisibles, contrastes corrects, zones de tap confortables.

## 6. Contraintes techniques

- **Frontend:** Flutter (Clean Architecture + feature-first).
- **APIs externes:** MangaDex + Jikan uniquement (pas de scraping).
- **Stockage local:** Drift **ou** Isar (choix unique, décidé tôt).
- **Pas de backend** pour le MVP (NestJS envisagé après le MVP).

## 7. Parcours utilisateur principal

1. Ouvrir l'app → recherche / catalogue.
2. Ouvrir un titre → voir détails.
3. Choisir un chapitre → lire.
4. Reprendre la lecture (continue).
5. Ajouter/retirer un favori.

## 8. Hors périmètre (MVP)

- Comptes utilisateurs, synchronisation multi-appareils, sauvegarde cloud.
- Fonctions sociales (commentaires, partage, communauté).
- Paiements / abonnements.
- Moteur de recommandations (IA/ML).
- Backend personnalisé (NestJS après MVP).

## 9. Risques & dépendances

- **Dépendance APIs externes:** changements/limites de MangaDex ou Jikan peuvent casser des fonctionnalités → prévoir gestion d'erreurs + fallback.
- **Disponibilité des traductions arabes:** variable selon les titres → prévoir fallback anglais clair.
- **Performance images:** chapitres lourds → caching + préchargement obligatoires.
- **Conformité / droits:** afficher un disclaimer sur l'origine externe des contenus.

## 10. Critères d'acceptation (Definition of Done)

- Le RTL est naturel partout (pas de mise en page "miroir" cassée).
- L'utilisateur peut chercher → ouvrir → lire → reprendre → mettre en favori sans blocage.
- Les deux modes de lecture (paginé + vertical) fonctionnent avec sauvegarde de progression.
- L'app reste stable et fluide sur un appareil Android milieu de gamme.