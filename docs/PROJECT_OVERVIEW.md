# NASA APOD - Visão Geral do Projeto

## 📱 Sobre o Aplicativo

O **NASA APOD** é um aplicativo Flutter que exibe as imagens astronômicas do dia da NASA (Astronomy Picture of the Day). O usuário pode navegar por uma lista de imagens, ver detalhes completos e assistir vídeos relacionados.

## 🎯 Funcionalidades

### Implementadas
- ✅ Listagem de imagens com scroll infinito
- ✅ Paginação por período de datas (10 dias por vez)
- ✅ Visualização de detalhes da imagem
- ✅ Suporte a vídeos do YouTube
- ✅ Cache de imagens
- ✅ Tratamento de erros com retry
- ✅ Animações de transição (Hero)

### Possíveis Melhorias Futuras
- ⬜ Sistema de favoritos
- ⬜ Busca por data específica
- ⬜ Compartilhamento de imagens
- ⬜ Download de imagens em HD
- ⬜ Modo offline com cache local
- ⬜ Tema claro/escuro
- ⬜ Internacionalização (i18n)

## 🏗️ Arquitetura

O projeto segue **Clean Architecture** com as seguintes camadas:

```
┌──────────────────────────────────────┐
│           Presentation               │  UI, Cubits, States
├──────────────────────────────────────┤
│             Domain                   │  Entities, UseCases
├──────────────────────────────────────┤
│              Data                    │  Models, Repositories, DataSources
├──────────────────────────────────────┤
│              Core                    │  Services, Utils
└──────────────────────────────────────┘
```

## 📂 Estrutura de Pastas

```
lib/
├── main.dart                          # Entry point
└── src/
    ├── core/
    │   ├── services/
    │   │   └── dio_service.dart       # Configuração do cliente HTTP
    │   └── utils/
    │       ├── exceptions.dart        # Hierarquia de exceções
    │       └── formatters.dart        # Formatadores de data
    ├── data/
    │   ├── data_source/
    │   │   ├── images_data_source.dart      # Interface
    │   │   └── images_data_source_impl.dart # Implementação
    │   ├── models/
    │   │   ├── apod_image_model.dart  # DTO da imagem
    │   │   └── pagination_model.dart  # DTO de paginação
    │   └── repository/
    │       ├── images_repository.dart      # Interface
    │       └── images_repository_impl.dart # Implementação
    ├── domain/
    │   ├── entities/
    │   │   ├── apod_image.dart        # Entidade de imagem
    │   │   └── pagination.dart        # Entidade de paginação
    │   └── usecase/
    │       └── apod_images_usecase.dart    # Caso de uso principal
    └── presentation/
        ├── home_cubit.dart            # Gerenciador de estado
        ├── home/
        │   ├── home_page.dart         # Tela principal
        │   ├── home_state.dart        # Estados da home
        │   └── widgets/
        │       ├── custom_error.dart  # Widget de erro
        │       └── loaded/
        │           ├── image_card.dart       # Card de imagem
        │           ├── images_list.dart      # Lista de imagens
        │           ├── load_more_error.dart  # Erro de load more
        │           └── loaded_state_widget.dart # Widget principal
        └── details/
            └── details_page.dart      # Tela de detalhes
```

## 🛠️ Stack Tecnológica

| Categoria | Tecnologia |
|-----------|------------|
| Framework | Flutter 3.13+ |
| Linguagem | Dart 3.1+ |
| Gerenciamento de Estado | BLoC/Cubit |
| Injeção de Dependências | GetIt |
| Cliente HTTP | Dio |
| Cache de Imagens | cached_network_image |
| Player de Vídeo | youtube_player_flutter |
| Comparação de Objetos | Equatable |
| Formatação de Datas | intl |

## 🚀 Como Executar

### Pré-requisitos
- Flutter 3.13.1 ou superior
- API Key da NASA (obter em https://api.nasa.gov)

### Configuração

1. Clone o repositório
2. Execute `flutter pub get`
3. Crie o arquivo `.vscode/launch.json`:

```json
{
  "configurations": [
    {
      "name": "Debug mode",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": [
        "--dart-define",
        "apiKey=SUA_API_KEY",
        "--dart-define",
        "baseUrl=https://api.nasa.gov/"
      ]
    }
  ]
}
```

4. Execute o projeto pelo VS Code ou:

```bash
flutter run --dart-define=apiKey=SUA_API_KEY --dart-define=baseUrl=https://api.nasa.gov/
```

## 📊 Fluxo de Dados

```
1. HomePage inicializa → Registra dependências no GetIt
2. HomeCubit.getImages() → Emite HomeStateLoading
3. ApodImagesUsecase.call() → Chama Repository
4. ImagesRepository.getImages() → Chama DataSource
5. ImagesDataSource.getImages() → Requisição HTTP via Dio
6. Resposta JSON → ApodImageModel.fromMap()
7. Model → Entity via toEntity()
8. HomeCubit → Emite HomeStateLoaded com lista de imagens
9. UI atualiza via BlocBuilder
```

## 🔗 Links Úteis

- [NASA APOD API](https://api.nasa.gov/)
- [Documentação Flutter](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [GetIt Package](https://pub.dev/packages/get_it)
