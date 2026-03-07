# Template para Nova Feature

Este documento serve como guia para criar novas features seguindo a arquitetura do projeto.

## Checklist de Criação

### 1. Camada de Domínio (`lib/src/domain/`)

- [ ] **Entity** (`entities/nome_entity.dart`)
  - Criar classe com propriedades imutáveis
  - Sem dependências externas

- [ ] **UseCase** (`usecase/nome_usecase.dart`)
  - Injetar Repository via construtor
  - Implementar método `call()`
  - Tratar exceções com `UsecaseException`

### 2. Camada de Dados (`lib/src/data/`)

- [ ] **Model** (`models/nome_model.dart`)
  - Criar `fromMap()` para deserialização
  - Criar `toEntity()` para conversão
  - Se necessário, criar `toMap()` para serialização

- [ ] **DataSource Interface** (`data_source/nome_data_source.dart`)
  - Definir contrato abstrato
  - Retornar Models

- [ ] **DataSource Implementation** (`data_source/nome_data_source_impl.dart`)
  - Injetar `Dio` via construtor
  - Implementar chamadas à API
  - Tratar exceções com `DataSourceException`

- [ ] **Repository Interface** (`repository/nome_repository.dart`)
  - Definir contrato abstrato
  - Receber e retornar Entities

- [ ] **Repository Implementation** (`repository/nome_repository_impl.dart`)
  - Injetar DataSource via construtor
  - Converter entre Models e Entities
  - Tratar exceções com `RepositoryException`

### 3. Camada de Apresentação (`lib/src/presentation/`)

- [ ] **State** (`nome_feature/nome_state.dart`)
  - Estender `Equatable`
  - Criar estados: Initial, Loading, Loaded, Error

- [ ] **Cubit** (`nome_feature/nome_cubit.dart` ou na raiz de presentation)
  - Injetar UseCase via construtor
  - Implementar métodos de ação
  - Emitir estados apropriados

- [ ] **Page** (`nome_feature/nome_page.dart`)
  - Configurar injeção de dependências (se necessário)
  - Usar `BlocProvider` e `BlocBuilder`

- [ ] **Widgets** (`nome_feature/widgets/`)
  - Extrair widgets reutilizáveis
  - Organizar em subpastas se necessário

### 4. Injeção de Dependências

Adicionar em `HomePage.initState()` ou criar um arquivo de configuração:

```dart
// DataSource
getIt.registerFactory<NomeDataSource>(
  () => NomeDataSourceImpl(getIt.get<Dio>()),
);

// Repository
getIt.registerFactory<NomeRepository>(
  () => NomeRepositoryImpl(getIt.get<NomeDataSource>()),
);

// UseCase
getIt.registerFactory<NomeUsecase>(
  () => NomeUsecase(getIt.get<NomeRepository>()),
);

// Cubit
getIt.registerSingleton<NomeCubit>(
  NomeCubit(getIt.get<NomeUsecase>()),
);
```

---

## Exemplo Prático: Feature "Favoritos"

### Estrutura de Arquivos

```
lib/src/
├── domain/
│   ├── entities/
│   │   └── favorite.dart
│   └── usecase/
│       ├── add_favorite_usecase.dart
│       ├── remove_favorite_usecase.dart
│       └── get_favorites_usecase.dart
├── data/
│   ├── models/
│   │   └── favorite_model.dart
│   ├── data_source/
│   │   ├── favorites_data_source.dart
│   │   └── favorites_data_source_impl.dart
│   └── repository/
│       ├── favorites_repository.dart
│       └── favorites_repository_impl.dart
└── presentation/
    └── favorites/
        ├── favorites_page.dart
        ├── favorites_state.dart
        ├── favorites_cubit.dart
        └── widgets/
            └── favorite_item.dart
```

### Código de Exemplo

#### Entity
```dart
// lib/src/domain/entities/favorite.dart
class Favorite {
  final String imageId;
  final DateTime addedAt;

  Favorite({
    required this.imageId,
    required this.addedAt,
  });
}
```

#### UseCase
```dart
// lib/src/domain/usecase/get_favorites_usecase.dart
class GetFavoritesUsecase {
  final FavoritesRepository _repository;

  GetFavoritesUsecase(this._repository);

  Future<List<Favorite>> call() async {
    try {
      return await _repository.getFavorites();
    } catch (e) {
      if (e is BaseException) rethrow;
      throw UsecaseException(e.toString());
    }
  }
}
```

#### State
```dart
// lib/src/presentation/favorites/favorites_state.dart
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Favorite> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
```

#### Cubit
```dart
// lib/src/presentation/favorites/favorites_cubit.dart
class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUsecase getFavoritesUsecase;
  final AddFavoriteUsecase addFavoriteUsecase;
  final RemoveFavoriteUsecase removeFavoriteUsecase;

  FavoritesCubit({
    required this.getFavoritesUsecase,
    required this.addFavoriteUsecase,
    required this.removeFavoriteUsecase,
  }) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    try {
      emit(FavoritesLoading());
      final favorites = await getFavoritesUsecase.call();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> addFavorite(String imageId) async {
    // Implementação
  }

  Future<void> removeFavorite(String imageId) async {
    // Implementação
  }
}
```
