# Referência da API NASA APOD

## Visão Geral

O projeto consome a API pública da NASA para o serviço APOD (Astronomy Picture of the Day).

- **Base URL**: `https://api.nasa.gov/`
- **Documentação Oficial**: https://api.nasa.gov
- **Endpoint Principal**: `/planetary/apod`

## Autenticação

A API requer uma API Key que pode ser obtida gratuitamente em https://api.nasa.gov

### Configuração no Projeto

A API Key é passada via `--dart-define` no momento da execução:

```bash
flutter run --dart-define=apiKey=YOUR_API_KEY --dart-define=baseUrl=https://api.nasa.gov/
```

No código, as variáveis são acessadas via `String.fromEnvironment()`:

```dart
const baseUrl = String.fromEnvironment('baseUrl');
const apiKey = String.fromEnvironment('apiKey');
```

## Endpoints Utilizados

### GET /planetary/apod

Retorna a imagem astronômica do dia ou uma lista de imagens em um intervalo de datas.

#### Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `api_key` | string | Sim | Chave de API |
| `start_date` | string (YYYY-MM-DD) | Não | Data inicial para busca em intervalo |
| `end_date` | string (YYYY-MM-DD) | Não | Data final para busca em intervalo |
| `thumbs` | boolean | Não | Se true, retorna thumbnail para vídeos |
| `date` | string (YYYY-MM-DD) | Não | Data específica (não usar com start_date/end_date) |
| `count` | integer | Não | Quantidade aleatória de imagens |

#### Exemplo de Requisição

```
GET https://api.nasa.gov/planetary/apod?api_key=YOUR_KEY&start_date=2024-01-01&end_date=2024-01-10&thumbs=true
```

#### Exemplo de Resposta

```json
[
  {
    "date": "2024-01-01",
    "explanation": "Descrição detalhada da imagem...",
    "hdurl": "https://apod.nasa.gov/apod/image/2401/image_hd.jpg",
    "media_type": "image",
    "service_version": "v1",
    "title": "Título da Imagem",
    "url": "https://apod.nasa.gov/apod/image/2401/image.jpg"
  },
  {
    "date": "2024-01-02",
    "explanation": "Outra descrição...",
    "media_type": "video",
    "thumbnail_url": "https://img.youtube.com/vi/VIDEO_ID/0.jpg",
    "title": "Título do Vídeo",
    "url": "https://www.youtube.com/embed/VIDEO_ID"
  }
]
```

#### Campos da Resposta

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `date` | string | Data da imagem (YYYY-MM-DD) |
| `explanation` | string | Descrição detalhada |
| `hdurl` | string | URL da imagem em alta definição (apenas para imagens) |
| `media_type` | string | Tipo de mídia: "image" ou "video" |
| `title` | string | Título da imagem/vídeo |
| `url` | string | URL principal (imagem ou embed do YouTube) |
| `thumbnail_url` | string | Thumbnail para vídeos (requer `thumbs=true`) |
| `copyright` | string | Créditos (quando aplicável) |

## Mapeamento no Projeto

### Model → Entity

```dart
// ApodImageModel.fromMap()
ApodImageModel(
  date: DateTime.parse(json['date']),
  explanation: json['explanation'],
  hdImageUrl: json['media_type'] == 'video' ? json['url'] : json['hdurl'] ?? json['url'],
  title: json['title'],
  mediaType: json['media_type'],
  imageUrl: json['media_type'] == 'video' ? json['thumbnail_url'] : json['url'],
);

// toEntity()
ApodImage(
  date: date,
  description: explanation,
  imageUrl: imageUrl,
  title: title,
  mediaType: mediaType,
  hdImageUrl: hdImageUrl,
);
```

### Paginação

O projeto implementa paginação baseada em datas:

```dart
class Pagination {
  final DateTime startDate;
  final DateTime endDate;
  final bool thumbs;

  // Carrega 10 dias por vez
  factory Pagination.empty() {
    return Pagination(
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now(),
      thumbs: true,
    );
  }

  // Avança para o próximo período
  Pagination next() {
    return Pagination(
      startDate: startDate.subtract(const Duration(days: 10)),
      endDate: startDate.subtract(Duration(days: 1)),
      thumbs: thumbs,
    );
  }
}
```

## Tratamento de Erros

### Erros Comuns da API

| Código | Descrição | Tratamento |
|--------|-----------|------------|
| 403 | API Key inválida ou ausente | Verificar configuração |
| 429 | Rate limit excedido | Aguardar ou usar DEMO_KEY |
| 500 | Erro interno da API | Retry com backoff |

### Rate Limits

- **DEMO_KEY**: 30 requisições/hora, 50 requisições/dia
- **API Key registrada**: 1000 requisições/hora

## Dicas de Desenvolvimento

1. **Use DEMO_KEY para testes rápidos**: `api_key=DEMO_KEY`
2. **Cache de imagens**: O projeto usa `cached_network_image` para evitar re-downloads
3. **Vídeos**: Quando `media_type` é "video", a URL geralmente é um embed do YouTube
4. **Imagens sem HD**: Algumas imagens não têm `hdurl`, use `url` como fallback
