# 🛍️ Flutter E-Commerce — Riverpod

Application e-commerce mobile développée avec **Flutter** et **Riverpod** dans le but de mettre en pratique une architecture en couches, la gestion d'état moderne avec Riverpod et la séparation entre logique métier, accès aux données et interface utilisateur.

L'application propose un catalogue de produits, la recherche, le filtrage, le tri, les favoris persistants, un panier d'achat et un profil utilisateur mocké.

---

## 📱 Fonctionnalités

### Catalogue

- Affichage des produits sous forme de grille
- Image, nom, marque, prix, note et stock
- Consultation du détail d'un produit
- Recherche par nom ou marque
- Filtrage par catégorie
- Tri :
  - pertinence
  - prix croissant
  - prix décroissant
  - meilleure note
  - nom A → Z

- Gestion des états de chargement et d'erreur

### ❤️ Favoris

- Ajouter ou retirer un produit des favoris
- Affichage de la liste des favoris
- Persistance locale des favoris
- Restauration des favoris après redémarrage de l'application

### 🛒 Panier

- Ajouter un produit au panier
- Augmenter la quantité
- Diminuer la quantité
- Supprimer un produit
- Vider le panier
- Calcul automatique du nombre total d'articles
- Calcul automatique du prix total
- Respect de la quantité maximale disponible en stock

### 👤 Profil

- Profil utilisateur mocké
- Nom
- Email
- Photo de profil
- Informations personnelles
- Historique des commandes
- Paiements
- Paramètres
- Déconnexion simulée

---

# 🏗️ Architecture

Le projet utilise une **architecture en couches** afin de séparer les responsabilités.

```text
lib/
│
├── core/
│   ├── enums/
│   ├── network/
│   └── theme/
│
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
│
├── providers/
│
├── presentation/
│   ├── pages/
│   └── widgets/
│
└── main.dart
```

L'idée générale est :

```text
┌──────────────────────────────┐
│         PRESENTATION         │
│                              │
│ Pages + Widgets              │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│           PROVIDERS          │
│                              │
│ State management + logique   │
│ applicative                  │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│             DATA             │
│                              │
│ Models + Repositories +      │
│ DataSources                  │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│             CORE             │
│                              │
│ Éléments partagés et         │
│ configuration technique      │
└──────────────────────────────┘
```

---

# 🧱 1. Core

Le dossier `core/` contient les éléments généraux et réutilisables de l'application.

Il ne contient pas de logique spécifique à un écran.

Exemple :

```text
core/
├── enums/
│   └── sort_option.dart
│
├── network/
│   └── dio_client.dart
│
└── theme/
    └── ...
```

## `enums/`

Contient les énumérations utilisées par la logique de l'application.

Exemple :

```dart
enum SortOption {
  none,
  priceAsc,
  priceDesc,
  ratingDesc,
  nameAsc,
}
```

L'utilisation d'un `enum` évite de manipuler des chaînes arbitraires comme :

```dart
'price_ascending'
'price_descending'
```

et rend le code plus sûr.

---

## `network/`

Contient la configuration réseau commune.

L'application utilise `Dio` pour communiquer avec l'API.

Le client HTTP est centralisé afin d'éviter de créer et configurer plusieurs instances de `Dio` dans différentes classes.

---

# 💾 2. Data

Le dossier `data/` est responsable de l'interaction avec les données.

```text
data/
├── models/
├── datasources/
└── repositories/
```

Cette couche ne doit pas connaître les widgets Flutter.

---

## `models/`

Les modèles représentent les données manipulées par l'application.

### Product

```text
Product
├── id
├── title
├── description
├── category
├── price
├── discountPercentage
├── rating
├── stock
├── brand
├── thumbnail
└── images
```

Le modèle possède notamment :

```dart
Product.fromJson(...)
```

pour transformer les données JSON provenant de l'API en objet Dart.

---

### CartItem

`CartItem` représente un produit placé dans le panier avec sa quantité.

```text
CartItem
├── Product product
└── int quantity
```

Il possède notamment :

```dart
copyWith()
```

afin de créer une nouvelle instance avec une quantité différente sans modifier directement l'objet existant.

---

### User

`User` représente l'utilisateur mocké de l'application.

```text
User
├── id
├── name
├── email
└── avatarUrl
```

---

# 🌐 3. DataSources

Les `DataSources` sont responsables de savoir **comment accéder aux données**.

Exemple :

```text
ProductRemoteDataSource
        │
        ▼
      Dio
        │
        ▼
    DummyJSON API
```

Le `ProductRemoteDataSource` récupère les produits depuis l'API et transforme les réponses JSON en objets `Product`.

Cette séparation permet de ne pas mettre des appels HTTP directement dans les widgets.

---

# 🔄 4. Repositories

Les repositories constituent une abstraction entre la logique applicative et les sources de données.

Conceptuellement :

```text
Provider
   ↓
Repository
   ↓
DataSource
   ↓
API / stockage local
```

Le provider n'a donc pas besoin de savoir si les données viennent :

- d'une API ;
- d'une base locale ;
- d'un fichier JSON ;
- d'une autre source.

Cette séparation rend l'application plus facile à tester et à faire évoluer.

---

# 🧠 5. Providers

Le dossier `providers/` contient la gestion d'état et la logique applicative utilisant Riverpod.

```text
providers/
├── product_provider.dart
├── cart_provider.dart
├── favorite_provider.dart
├── filter_providers.dart
└── profile_provider.dart
```

Les providers constituent le lien entre les données et la présentation.

---

# 📦 `product_provider.dart`

Le provider principal du catalogue est :

```dart
productsProvider
```

Il récupère les produits de manière asynchrone.

Conceptuellement :

```text
productsProvider
      │
      ├── loading
      ├── data
      └── error
```

Il utilise `AsyncValue`, ce qui permet à l'interface de traiter proprement les trois états.

Exemple :

```dart
final productsAsync = ref.watch(productsProvider);

productsAsync.when(
  loading: () {},
  error: (error, stackTrace) {},
  data: (products) {},
);
```

C'est particulièrement utile pour les appels API.

---

# 🔎 `filter_providers.dart`

Ce fichier regroupe les providers liés à la recherche, aux catégories et au tri.

## `searchProvider`

Stocke la recherche actuelle.

```text
''
```

au départ.

Lorsqu'un utilisateur écrit :

```text
phone
```

l'état devient :

```text
phone
```

---

## `categoryProvider`

Stocke la catégorie sélectionnée.

Par défaut :

```text
All
```

---

## `sortProvider`

Stocke le type de tri sélectionné.

Il utilise :

```dart
SortOption
```

plutôt qu'une chaîne de caractères.

---

## `categoriesProvider`

Construit automatiquement la liste des catégories à partir des produits récupérés.

```text
productsProvider
       ↓
categoriesProvider
       ↓
Liste des catégories
```

Les catégories ne sont donc pas codées manuellement dans l'interface.

---

## `filteredProductsProvider`

C'est un **provider dérivé**.

Il observe :

```text
productsProvider
searchProvider
categoryProvider
sortProvider
```

puis produit une nouvelle liste.

```text
             productsProvider
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
      Search     Category      Sort
        │           │           │
        └───────────┼───────────┘
                    ▼
      filteredProductsProvider
                    │
                    ▼
                 HomePage
```

La page `HomePage` n'a donc pas besoin d'implémenter elle-même les algorithmes de recherche, de filtrage ou de tri.

---

# ❤️ `favorite_provider.dart`

Le système de favoris utilise deux niveaux de logique.

## `favoritesProvider`

Il conserve les identifiants des produits favoris :

```dart
Set<int>
```

Exemple :

```text
{2, 5, 17}
```

Cela signifie que les produits `2`, `5` et `17` sont favoris.

Le notifier permet notamment :

```text
toggleFavorite()
```

pour ajouter ou supprimer un produit.

---

## Persistance locale

Les identifiants sont sauvegardés localement.

Conceptuellement :

```text
favoritesProvider
       │
       ▼
LocalDataSource
       │
       ▼
Stockage local
```

Au redémarrage :

```text
Stockage local
       ↓
favoritesProvider
       ↓
Application
```

Les favoris sont ainsi conservés.

---

## `favoriteProductsProvider`

C'est également un provider dérivé.

Il combine :

```text
productsProvider
+
favoritesProvider
```

pour obtenir :

```text
List<Product>
```

contenant uniquement les produits favoris.

```text
productsProvider ───────┐
                        ├──> favoriteProductsProvider
favoritesProvider ──────┘
```

La `FavoritesPage` n'a donc pas besoin de rechercher elle-même les produits correspondant aux IDs.

---

# 🛒 `cart_provider.dart`

Le panier est géré par un notifier.

L'état principal est :

```text
List<CartItem>
```

Chaque élément contient :

```text
Product
+
quantity
```

Le notifier contient les opérations métier du panier.

### Ajouter

```text
addProduct()
```

### Supprimer

```text
removeProduct()
```

### Augmenter

```text
increaseQuantity()
```

### Diminuer

```text
decreaseQuantity()
```

### Vider

```text
clearCart()
```

---

## Règles métier du panier

Les widgets ne décident pas eux-mêmes des règles.

Par exemple, une quantité ne doit pas :

```text
être inférieure à 1
```

et elle ne doit pas dépasser :

```text
le stock disponible
```

Ces règles sont appliquées dans le notifier.

---

## `cartTotalProvider`

Provider dérivé qui calcule le prix total :

```text
CartItem 1
prix × quantité
       +
CartItem 2
prix × quantité
       +
...
       ↓
Total
```

La logique du calcul n'est donc pas placée dans `CartPage`.

---

## `cartItemCountProvider`

Calcule le nombre total d'articles présents dans le panier.

Par exemple :

```text
Produit A → quantité 2
Produit B → quantité 3
Produit C → quantité 1

Total = 6 articles
```

---

# 👤 `profile_provider.dart`

Le profil est volontairement simple car l'exigence demande seulement un profil utilisateur mocké.

Il utilise :

```dart
Provider<User>
```

Le provider expose l'utilisateur à la présentation.

```text
userProvider
      ↓
User
      ↓
ProfilePage
```

Aucune API d'authentification n'est nécessaire pour cette fonctionnalité.

---

# 🎯 Pourquoi les providers ne sont-ils pas dans `presentation/` ?

Le choix architectural est volontaire.

`presentation/` représente principalement **ce que l'utilisateur voit et avec lequel il interagit** :

```text
Pages
Widgets
UI
```

Les providers contiennent quant à eux l'état et la logique applicative.

```text
presentation
      ↓
observe / déclenche
      ↓
providers
```

Ainsi, un widget n'a pas besoin de connaître les détails de la logique métier.

Par exemple, `CartItemCard` ne calcule pas le total du panier.

Il demande simplement :

```dart
ref
    .read(cartProvider.notifier)
    .increaseQuantity(product.id);
```

Le notifier s'occupe du comportement.

---

# 🎨 6. Presentation

Le dossier `presentation/` contient uniquement la partie destinée à l'utilisateur.

```text
presentation/
├── pages/
└── widgets/
```

## `pages/`

Les pages principales sont :

```text
pages/
├── home/
│   ├── home_page.dart
│   └── product_detail_page.dart
│
├── favorites/
│   └── favorites_page.dart
│
├── cart/
│   └── cart_page.dart
│
└── profile/
    └── profile_page.dart
```

---

## `widgets/`

Les composants réutilisables comprennent notamment :

```text
ProductCard
CartItemCard
```

L'objectif est d'éviter de répéter du code d'interface.

Par exemple, `ProductCard` est utilisé aussi bien dans le catalogue que dans les favoris.

---

# 🧭 Navigation

La navigation utilise `go_router`.

Le flux principal est :

```text
Home
├── Product Detail
├── Favorites
├── Cart
└── Profile
```

La page de détail reçoit l'identifiant du produit dans l'URL de navigation :

```text
/product/:productId
```

La page récupère ensuite le produit correspondant depuis `productsProvider`.

---

# 🔄 Flux complet de l'application

## Chargement du catalogue

```text
HomePage
   ↓
filteredProductsProvider
   ↓
productsProvider
   ↓
ProductRepository
   ↓
ProductRemoteDataSource
   ↓
Dio
   ↓
DummyJSON
```

---

## Ajout aux favoris

```text
ProductCard
   ↓
favoritesProvider.notifier
   ↓
toggleFavorite()
   ↓
LocalDataSource
   ↓
favoriteProductsProvider
   ↓
FavoritesPage
```

---

## Ajout au panier

```text
ProductCard
   ↓
cartProvider.notifier
   ↓
addProduct()
   ↓
cartProvider
   ├── cartTotalProvider
   └── cartItemCountProvider
            ↓
        CartPage
```

---

# 🧩 Providers utilisés

| Provider                   | Type / rôle         | Responsabilité                |
| -------------------------- | ------------------- | ----------------------------- |
| `productsProvider`         | Asynchrone          | Charger les produits          |
| `searchProvider`           | Notifier            | Recherche                     |
| `categoryProvider`         | Notifier            | Catégorie sélectionnée        |
| `sortProvider`             | Notifier            | Type de tri                   |
| `categoriesProvider`       | Provider dérivé     | Générer les catégories        |
| `filteredProductsProvider` | Provider dérivé     | Recherche + filtrage + tri    |
| `favoritesProvider`        | Notifier asynchrone | IDs des favoris + persistance |
| `favoriteProductsProvider` | Provider dérivé     | Produits favoris              |
| `cartProvider`             | Notifier            | État et logique du panier     |
| `cartTotalProvider`        | Provider dérivé     | Total du panier               |
| `cartItemCountProvider`    | Provider dérivé     | Nombre d'articles             |
| `userProvider`             | Provider            | Profil mock                   |

L'application dépasse donc largement l'exigence minimale de **5 providers distincts**.

---

# 🧠 Concepts Riverpod mis en pratique

Ce projet permet de pratiquer plusieurs concepts importants :

### `Provider`

Pour les données synchrones ou les dépendances simples.

Exemple :

```dart
userProvider
```

---

### `FutureProvider`

Pour les données récupérées de manière asynchrone.

Exemple conceptuel :

```dart
productsProvider
```

---

### `NotifierProvider`

Pour un état mutable accompagné de méthodes métier.

Exemples :

```text
cartProvider
searchProvider
categoryProvider
sortProvider
```

---

### `AsyncValue`

Pour représenter les différents états d'une opération asynchrone :

```text
AsyncLoading
AsyncData
AsyncError
```

---

### `ref.watch()`

Permet à un widget ou à un provider d'écouter un autre provider.

```dart
final products = ref.watch(productsProvider);
```

Lorsque l'état change, le consommateur est automatiquement reconstruit.

---

### `ref.read()`

Permet d'accéder à un provider sans établir une écoute.

Principalement utilisé pour déclencher une action :

```dart
ref
    .read(cartProvider.notifier)
    .addProduct(product);
```

---

### Providers dérivés

Plusieurs providers de notre application sont construits à partir d'autres providers.

Exemple :

```text
productsProvider
+
searchProvider
+
categoryProvider
+
sortProvider
        ↓
filteredProductsProvider
```

C'est l'un des concepts importants de Riverpod dans ce projet.

---

# 🛡️ Séparation des responsabilités

Une règle fondamentale du projet est :

> **Les widgets affichent et déclenchent des actions ; les providers portent l'état et la logique applicative ; la couche data s'occupe des données.**

Exemple avec le panier :

❌ Le widget ne doit pas faire :

```dart
total += product.price * quantity;
```

❌ Le widget ne doit pas décider :

```dart
if (quantity < product.stock) {
  ...
}
```

✅ Le widget demande :

```dart
ref
    .read(cartProvider.notifier)
    .increaseQuantity(product.id);
```

Puis le notifier applique les règles.

Cette organisation facilite :

- la maintenance ;
- le débogage ;
- les tests unitaires ;
- la réutilisation ;
- l'évolution de l'application.

---

# 📦 Technologies utilisées

- **Flutter**
- **Dart**
- **Riverpod**
- **Dio**
- **GoRouter**
- **SharedPreferences**
- **DummyJSON API**

---

# 🚀 Installation

Cloner le projet :

```bash
git clone <URL_DU_REPOSITORY>
```

Entrer dans le projet :

```bash
cd <NOM_DU_PROJET>
```

Installer les dépendances :

```bash
flutter pub get
```

Vérifier l'environnement Flutter :

```bash
flutter doctor
```

Lancer l'application :

```bash
flutter run
```

---

# 🧪 Vérification

Analyser le projet :

```bash
flutter analyze
```

Exécuter les tests :

```bash
flutter test
```

---

# 🎓 Objectif pédagogique

Ce projet a été réalisé comme exercice pratique de maîtrise du **state management avec Riverpod**.

Les objectifs principaux sont :

- comprendre la différence entre état UI et état applicatif ;
- séparer la logique métier des widgets ;
- comprendre les providers simples et dérivés ;
- travailler avec des données asynchrones ;
- utiliser `AsyncValue` ;
- comprendre `ref.watch()` et `ref.read()` ;
- construire des notifiers contenant de la logique métier ;
- persister un état localement ;
- structurer une application Flutter de manière maintenable.

---

# 📌 Architecture en résumé

```text
                         ┌───────────────────┐
                         │    Presentation   │
                         │                   │
                         │ Pages + Widgets   │
                         └─────────┬─────────┘
                                   │
                                   ▼
                         ┌───────────────────┐
                         │     Providers     │
                         │                   │
                         │ State + Business  │
                         │ Logic + Derived   │
                         │ Providers         │
                         └─────────┬─────────┘
                                   │
                                   ▼
                         ┌───────────────────┐
                         │       Data        │
                         │                   │
                         │ Models            │
                         │ Repositories      │
                         │ DataSources       │
                         └─────────┬─────────┘
                                   │
                          ┌────────┴────────┐
                          ▼                 ▼
                     DummyJSON        Local Storage
```

Cette architecture permet de garder une séparation claire entre **présentation, état/logique applicative et accès aux données**, tout en utilisant Riverpod comme mécanisme central de gestion d'état.
