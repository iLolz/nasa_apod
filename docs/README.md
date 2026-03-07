# 📚 Documentação NASA APOD

Bem-vindo à documentação do projeto NASA APOD. Esta pasta contém todos os documentos necessários para entender e contribuir com o projeto.

## Índice

| Documento | Descrição |
|-----------|-----------|
| [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) | Visão geral do projeto, funcionalidades e stack tecnológica |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Arquitetura Clean Architecture, fluxo de dados e princípios |
| [CODING_GUIDELINES.md](CODING_GUIDELINES.md) | Convenções de código, estrutura de classes e boas práticas |
| [FEATURE_TEMPLATE.md](FEATURE_TEMPLATE.md) | Template e checklist para criar novas features |
| [API_REFERENCE.md](API_REFERENCE.md) | Documentação da API NASA APOD e mapeamentos |

## Início Rápido

### Para entender o projeto
1. Comece pelo [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)
2. Entenda a arquitetura em [ARCHITECTURE.md](ARCHITECTURE.md)

### Para contribuir
1. Leia as [CODING_GUIDELINES.md](CODING_GUIDELINES.md)
2. Use o [FEATURE_TEMPLATE.md](FEATURE_TEMPLATE.md) para novas features

### Para integrar com a API
1. Consulte a [API_REFERENCE.md](API_REFERENCE.md)

## Mapa de Arquivos Principais

```
lib/
├── main.dart                              ← Entry Point
└── src/
    ├── core/
    │   ├── services/dio_service.dart      ← Config HTTP
    │   └── utils/
    │       ├── exceptions.dart            ← Exceções
    │       └── formatters.dart            ← Formatadores
    ├── data/
    │   ├── data_source/*_impl.dart        ← Chamadas API
    │   ├── models/*_model.dart            ← DTOs
    │   └── repository/*_impl.dart         ← Repositories
    ├── domain/
    │   ├── entities/*.dart                ← Entidades
    │   └── usecase/*.dart                 ← Casos de Uso
    └── presentation/
        ├── home_cubit.dart                ← Gerenciador Estado
        ├── home/
        │   ├── home_page.dart             ← Tela Principal
        │   └── home_state.dart            ← Estados
        └── details/details_page.dart      ← Tela Detalhes
```

## Diagrama de Dependências

```
                    ┌─────────────┐
                    │    main     │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │  HomePage   │ ◄── Injeção de Dependências
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
       ┌──────▼──────┐     │     ┌──────▼──────┐
       │  HomeCubit  │     │     │ DetailsPage │
       └──────┬──────┘     │     └─────────────┘
              │            │
       ┌──────▼──────┐     │
       │  UseCase    │     │
       └──────┬──────┘     │
              │            │
       ┌──────▼──────┐     │
       │ Repository  │     │
       └──────┬──────┘     │
              │            │
       ┌──────▼──────┐     │
       │ DataSource  │◄────┘
       └──────┬──────┘
              │
       ┌──────▼──────┐
       │  NASA API   │
       └─────────────┘
```
