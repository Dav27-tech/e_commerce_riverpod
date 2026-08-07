# Plan de Modernisation Progressive - V2

Ce plan couvre la modernisation de la partie haute de la page d'accueil et de la barre de navigation inférieure, en adoptant un style fluide et professionnel.

## User Review Required

> [!IMPORTANT]
> Les cartes de produits resteront inchangées dans cette étape pour assurer une transition progressive. Les modifications se concentrent sur le Header, les filtres, le bouton de tri et la barre de navigation.

## Proposed Changes

### [UI/UX] Modernisation du Header et des Filtres

#### [MODIFY] [home_page.dart](file:///C:/Users/LENOVO/StudioProjects/e_commerce_riverpod/lib/presentation/pages/home/home_page.dart)
- **Header (`_HomeHeader`)**:
    - Ajout d'une icône de cloche (notifications) stylisée en haut à droite.
    - Remplacement du texte "Bonjour 👋" par "Bienvenue" (style bold, moderne).
    - Ajout d'une illustration de bienvenue moderne sous la barre de recherche.
- **Filtres de Catégories**:
    - Remplacement des `FilterChip` par des capsules personnalisées animées (`AnimatedContainer`) avec des ombres douces.
- **Bouton de Tri**:
    - Design épuré avec un fond translucide et l'icône `tune_rounded`.

### [UI/UX] Amélioration de la Barre de Navigation

#### [MODIFY] [app_shell.dart](file:///C:/Users/LENOVO/StudioProjects/e_commerce_riverpod/lib/presentation/navigation/app_shell.dart)
- **Bottom Navigation Bar**:
    - Modernisation du style (éventuellement un aspect flottant ou avec des indicateurs plus fins).
    - Utilisation d'icônes "Rounded" pour plus de douceur.
    - Amélioration des transitions entre les onglets.

## Verification Plan

### Manual Verification
- Valider le nouveau Header (Cloche, Texte, Image).
- Tester la fluidité des boutons de catégories au clic.
- Vérifier l'aspect visuel de la barre de navigation sur différents écrans.
- S'assurer que la navigation entre les pages reste parfaitement fonctionnelle.
