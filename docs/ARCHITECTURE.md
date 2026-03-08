# Arquitetura do Projeto NASA APOD

## Visão Geral

O app consome a API NASA APOD para exibir uma galeria paginada de imagens e vídeos astronômicos, com tela de detalhes para cada item. A estrutura segue uma separação em camadas entre apresentação, domínio, dados e infraestrutura compartilhada.

## Estrutura Atual

```text
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── di/
    │   ├── services/
    │   └── utils/
    ├── data/
    │   ├── data_source/
    │   ├── models/
    │   └── repository/
    ├── domain/
    │   ├── entities/
    │   └── usecase/
    └── presentation/
        ├── details/
        │   └── widgets/
        ├── home/
        │   └── widgets/
        └── home_cubit.dart
```

## Fluxo de Dados

```text
UI -> HomeCubit -> ApodImagesUsecase -> ImagesRepository
                                        |-> ImagesLocalDataSource
                                        |-> ImagesDataSource
```

Resumo do fluxo:

- a tela inicial cria `HomeCubit` via GetIt
- `HomeCubit` solicita imagens ao use case
- o repositório consulta primeiro o cache local por janela de paginação
- se não houver cache, busca na API remota
- a resposta remota é convertida em modelos, persistida localmente e transformada em entidades de domínio

## Camadas

### Presentation

Responsável por renderização, interação do usuário e transições de tela.

Pontos relevantes:

- [home_page.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/presentation/home/home_page.dart) decide entre loading inicial, erro inicial e conteúdo carregado.
- [home_state.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/presentation/home/home_state.dart) usa um único estado explícito com:
  - `HomeStatus`
  - `pagination`
  - `images`
  - `error`
- [home_cubit.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/presentation/home_cubit.dart) controla o carregamento inicial, paginação e mapeamento de erros para a UI.
- A lista principal usa renderização lazy com slivers para evitar build/layout de todos os cards de uma vez.
- [details_media.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/presentation/details/widgets/details_media.dart) concentra a lógica de hero, placeholder estável, imagem HD e vídeo.
- [error_panel.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/presentation/home/widgets/error_panel.dart) padroniza a UI de erro em forma de card com alerta e ação de retry.

### Domain

Responsável pelas regras centrais da aplicação.

Pontos relevantes:

- [apod_image.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/domain/entities/apod_image.dart) representa o item de APOD com semântica explícita:
  - `previewUrl`
  - `contentUrl`
  - `ApodMediaType`
- [pagination.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/domain/entities/pagination.dart) define a janela de paginação.
- [apod_images_usecase.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/domain/usecase/apod_images_usecase.dart) encapsula o caso de uso de carregar imagens.

### Data

Responsável por acesso a dados remotos, cache local e mapeamento.

Pontos relevantes:

- [images_data_source_impl.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/data/data_source/images_data_source_impl.dart) faz a chamada HTTP com Dio.
- O parsing do payload JSON acontece em isolate secundária com `Isolate.run(...)` para reduzir trabalho na main isolate.
- [images_local_data_source_impl.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/data/data_source/images_local_data_source_impl.dart) armazena metadados localmente por janela de paginação usando JSON em disco.
- [images_repository_impl.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/data/repository/images_repository_impl.dart) faz a orquestração entre cache local e fonte remota.
- [apod_image_model.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/data/models/apod_image_model.dart) faz serialização, desserialização e conversão para entidade.

## Injeção de Dependências

O projeto usa GetIt configurado em [injection_container.dart](/Users/alencar/Projects/personal/nasa_apod/lib/src/core/di/injection_container.dart), chamado por `bootstrap()` em [main.dart](/Users/alencar/Projects/personal/nasa_apod/lib/main.dart).

Dependências registradas:

- `Dio`
- `ImageDataSource`
- `ImagesLocalDataSource`
- `ImagesRepository`
- `ApodImagesUsecase`
- `HomeCubit`

`HomeCubit` é registrado como factory. O restante usa singleton lazy.

## Estado da Home

O estado da tela principal não usa mais herança entre subclasses de estado. Em vez disso, usa um objeto único com `status` explícito.

Estados suportados:

- `initial`
- `initialLoading`
- `loaded`
- `loadingMore`
- `initialError`
- `loadMoreError`

Isso evita acoplamento implícito de renderização por `is` checks e deixa as transições mais fáceis de testar.

## Estratégia de Cache

Atualmente existem dois tipos de cache:

- cache de bytes de imagem via `cached_network_image`
- cache de metadados APOD via `ImagesLocalDataSource`

O cache local de metadados:

- usa o diretório de suporte da aplicação
- salva arquivos JSON por `startDate`, `endDate` e `thumbs`
- acelera janelas já carregadas

## Tratamento de Erros

Exceções técnicas:

```text
BaseException
├── UsecaseException
├── NetworkException
├── DataSourceException
└── RepositoryException
```

Erros de UI:

- `HomeErrorType.network`
- `HomeErrorType.parsing`
- `HomeErrorType.unknown`

A apresentação converte erros técnicos em um `HomeError` tipado para decidir a mensagem e a experiência de retry.

## Performance

Melhorias já aplicadas:

- parsing remoto em isolate
- feed com renderização lazy
- throttling do trigger de paginação
- thumbnails menores para a lista
- espaço estável no topo da tela de detalhes para evitar layout shift

## Qualidade

O projeto possui cobertura automatizada para:

- entidades e use cases
- cubit e estado
- data source remoto e local
- repositório
- widget tests da home e tela de detalhes
- bootstrap e injeção de dependências

Comandos usados no dia a dia:

```bash
flutter analyze
flutter test
flutter test --coverage
```

## Dependências Principais

| Pacote | Versão | Propósito |
|--------|--------|-----------|
| `dio` | `^5.9.0` | Cliente HTTP |
| `bloc` | `^9.0.0` | Gerenciamento de estado |
| `flutter_bloc` | `^9.0.0` | Integração com Flutter |
| `get_it` | `^9.0.0` | Injeção de dependências |
| `equatable` | `^2.0.8` | Comparação de objetos |
| `cached_network_image` | `^3.4.1` | Cache e carregamento de imagens |
| `intl` | `^0.20.0` | Formatação de datas |
| `path_provider` | `^2.1.5` | Diretório para cache local |
| `youtube_player_flutter` | `^9.0.0` | Reprodução de vídeos |
