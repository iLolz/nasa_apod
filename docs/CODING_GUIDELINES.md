# Guia de Codificação - NASA APOD

## Convenções de Nomenclatura

### Arquivos
- **Entidades**: `nome_entidade.dart` (ex: `apod_image.dart`)
- **Models**: `nome_model.dart` (ex: `apod_image_model.dart`)
- **Data Sources**: `nome_data_source.dart` e `nome_data_source_impl.dart`
- **Repositories**: `nome_repository.dart` e `nome_repository_impl.dart`
- **Use Cases**: `nome_usecase.dart` (ex: `apod_images_usecase.dart`)
- **Cubits**: `nome_cubit.dart` (ex: `home_cubit.dart`)
- **States**: `nome_state.dart` (ex: `home_state.dart`)
- **Pages**: `nome_page.dart` (ex: `home_page.dart`)
- **Widgets**: `nome_widget.dart` ou nome descritivo (ex: `image_card.dart`)

### Classes
- **PascalCase** para todas as classes
- Sufixos indicam o tipo:
  - `Model` para DTOs
  - `Impl` para implementações
  - `Cubit` para gerenciadores de estado
  - `State` para estados
  - `Page` para telas
  - `Usecase` para casos de uso

### Variáveis e Métodos
- **camelCase** para variáveis e métodos
- Prefixo `_` para membros privados
- Nomes descritivos e autoexplicativos

## Estrutura de Classes

### Entity (Domínio)
```dart
class NomeEntity {
  final String campo1;
  final int campo2;

  NomeEntity({
    required this.campo1,
    required this.campo2,
  });
}
```

### Model (Dados)
```dart
class NomeModel {
  final String campo1;
  final int campo2;

  const NomeModel({
    required this.campo1,
    required this.campo2,
  });

  factory NomeModel.fromMap(Map<String, dynamic> json) {
    return NomeModel(
      campo1: json['campo_1'],
      campo2: json['campo_2'],
    );
  }

  NomeEntity toEntity() {
    return NomeEntity(
      campo1: campo1,
      campo2: campo2,
    );
  }
}
```

### Data Source (Interface)
```dart
abstract class NomeDataSource {
  const NomeDataSource();

  Future<List<NomeModel>> getItems(ParamsModel params);
}
```

### Data Source (Implementação)
```dart
class NomeDataSourceImpl extends NomeDataSource {
  final Dio _client;

  const NomeDataSourceImpl(this._client);

  @override
  Future<List<NomeModel>> getItems(ParamsModel params) async {
    try {
      final response = await _client.get('/endpoint', queryParameters: params.toMap());
      return (response.data as List).map((e) => NomeModel.fromMap(e)).toList();
    } catch (e) {
      if (e is BaseException) rethrow;
      throw DataSourceException(e.toString());
    }
  }
}
```

### Repository (Interface)
```dart
abstract class NomeRepository {
  const NomeRepository();

  Future<List<NomeEntity>> getItems(ParamsEntity params);
}
```

### Repository (Implementação)
```dart
class NomeRepositoryImpl extends NomeRepository {
  final NomeDataSource _dataSource;

  const NomeRepositoryImpl(this._dataSource);

  @override
  Future<List<NomeEntity>> getItems(ParamsEntity params) async {
    try {
      final paramsModel = ParamsModel.fromEntity(params);
      final response = await _dataSource.getItems(paramsModel);
      return response.map((e) => e.toEntity()).toList();
    } catch (e) {
      if (e is BaseException) rethrow;
      throw RepositoryException(e.toString());
    }
  }
}
```

### UseCase
```dart
class NomeUsecase {
  final NomeRepository _repository;

  NomeUsecase(this._repository);

  Future<List<NomeEntity>> call(ParamsEntity params) async {
    try {
      return await _repository.getItems(params);
    } catch (e) {
      if (e is BaseException) rethrow;
      throw UsecaseException(e.toString());
    }
  }
}
```

### Cubit
```dart
class NomeCubit extends Cubit<NomeState> {
  final NomeUsecase usecase;

  NomeCubit(this.usecase) : super(NomeStateInitial());

  Future<void> loadData() async {
    try {
      emit(NomeStateLoading());
      final result = await usecase.call(params);
      emit(NomeStateLoaded(result));
    } catch (e) {
      emit(NomeStateError());
    }
  }
}
```

### State com Equatable
```dart
abstract class NomeState extends Equatable {
  const NomeState();

  @override
  List<Object?> get props => [];
}

class NomeStateInitial extends NomeState {}

class NomeStateLoading extends NomeState {}

class NomeStateLoaded extends NomeState {
  final List<NomeEntity> items;

  const NomeStateLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class NomeStateError extends NomeState {}
```

## Boas Práticas

### 1. Widgets
- Use `const` sempre que possível
- Extraia widgets complexos para arquivos separados
- Agrupe widgets relacionados em pastas

### 2. Tratamento de Erros
- Sempre capture exceções em cada camada
- Relance exceções já tratadas (`BaseException`)
- Crie exceções específicas para cada camada

### 3. Injeção de Dependências
- Registre dependências na ordem correta (de baixo para cima)
- Use `registerLazySingleton` para singletons
- Use `registerFactory` para instâncias novas

### 4. Estados
- Estados devem ser imutáveis
- Use `copyWith` ou métodos de transformação
- Estenda `Equatable` para comparações eficientes

### 5. Navegação
- Use `Navigator.push` para navegação simples
- Considere named routes para apps maiores
- Use `Hero` para transições de imagem
