# Arquitetura do Projeto NASA APOD

## Visão Geral

Este projeto Flutter consome a API NASA APOD (Astronomy Picture of the Day) para exibir imagens astronômicas com suas descrições. A arquitetura segue os princípios de **Clean Architecture** com separação clara de responsabilidades.

## Estrutura de Camadas

```
lib/
├── main.dart                    # Ponto de entrada da aplicação
└── src/
    ├── core/                    # Utilitários e serviços compartilhados
    │   ├── services/            # Serviços de infraestrutura (ex: Dio)
    │   └── utils/               # Utilitários (exceções, formatadores)
    ├── data/                    # Camada de Dados
    │   ├── data_source/         # Fontes de dados (API, local)
    │   ├── models/              # Modelos de dados (DTOs)
    │   └── repository/          # Implementações de repositórios
    ├── domain/                  # Camada de Domínio (regras de negócio)
    │   ├── entities/            # Entidades de domínio
    │   └── usecase/             # Casos de uso
    └── presentation/            # Camada de Apresentação (UI)
        ├── home/                # Tela principal
        │   ├── widgets/         # Widgets específicos da home
        │   └── home_state.dart  # Estados do Cubit
        ├── details/             # Tela de detalhes
        └── home_cubit.dart      # Gerenciador de estado
```

## Fluxo de Dados

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION                                 │
│  ┌──────────┐    ┌───────────┐    ┌──────────────┐                 │
│  │  Widget  │───▶│   Cubit   │───▶│    State     │                 │
│  └──────────┘    └─────┬─────┘    └──────────────┘                 │
└────────────────────────│────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           DOMAIN                                     │
│                     ┌───────────┐                                   │
│                     │  UseCase  │                                   │
│                     └─────┬─────┘                                   │
│                           │                                         │
│                     ┌───────────┐                                   │
│                     │  Entity   │                                   │
│                     └───────────┘                                   │
└────────────────────────│────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│                            DATA                                      │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐                │
│  │ Repository │───▶│ DataSource │───▶│   Model    │                │
│  └────────────┘    └─────┬──────┘    └────────────┘                │
└──────────────────────────│──────────────────────────────────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  NASA API   │
                    └─────────────┘
```

## Princípios Aplicados

### 1. **Inversão de Dependência**
- Camadas superiores não dependem de implementações concretas
- Uso de abstrações (interfaces) para repositórios e data sources

### 2. **Separação de Responsabilidades**
- **Entities**: Objetos de domínio puros, sem dependências externas
- **Models**: DTOs para serialização/deserialização de JSON
- **Repository**: Orquestra a obtenção de dados
- **UseCase**: Contém a lógica de negócio

### 3. **Gerenciamento de Estado com BLoC/Cubit**
- `HomeCubit` gerencia o estado da tela principal
- Estados imutáveis com `Equatable`
- Pattern matching para renderização condicional

## Injeção de Dependências

O projeto utiliza **GetIt** para injeção de dependências, configurado em `HomePage.initState()`:

```dart
GetIt.I.registerLazySingleton<Dio>(() => DioService().setup());
GetIt.I.registerFactory<ImageDataSource>(() => ImagesDataSourceImpl(...));
GetIt.I.registerFactory<ImagesRepository>(() => ImagesRepositoryImpl(...));
GetIt.I.registerFactory<ApodImagesUsecase>(() => ApodImagesUsecase(...));
GetIt.I.registerSingleton<HomeCubit>(HomeCubit(...));
```

## Tratamento de Erros

Hierarquia de exceções customizadas:

```
BaseException
├── UsecaseException
├── NetworkException
├── DataSourceException
└── RepositoryException
```

## Tecnologias Utilizadas

| Pacote | Versão | Propósito |
|--------|--------|-----------|
| `dio` | ^5.3.2 | Cliente HTTP |
| `bloc` | ^8.1.2 | Gerenciamento de estado |
| `flutter_bloc` | ^8.1.3 | Integração BLoC com Flutter |
| `get_it` | ^7.6.4 | Injeção de dependências |
| `equatable` | ^2.0.5 | Comparação de objetos |
| `cached_network_image` | ^3.2.3 | Cache de imagens |
| `intl` | ^0.18.1 | Formatação de datas |
| `youtube_player_flutter` | ^8.1.2 | Player de vídeos do YouTube |
