# 🛒 Flutter E-commerce

> Aplicativo mobile de e-commerce em Flutter com home, categorias, novidades e detalhes de produto.

## 📌 Sobre

App de e-commerce desenvolvido em **Flutter** como projeto de estudo, com foco em uma experiência de compra completa:

- 🏠 **Home page** com slider de destaques e navegação por categorias
- 🗂️ **Categorias** com carrossel de produtos
- ✨ **Novidades** em grid
- 📦 **Detalhes do produto** com informações completas
- 📱 Interface responsiva e em português

## 🛠️ Tecnologias

- **Flutter** (Dart)
- Material Design
- Arquitetura simples por páginas (home, detalhes do produto, modelos de dados)

## 📁 Estrutura

```
lib/
├── main.dart                          # Ponto de entrada
├── model/
│   └── slidercategorias_model.dart    # Modelo de categorias/slider
├── pages/
│   └── homepage/
│       ├── home_page.dart             # Página principal
│       ├── slider.dart                # Slider de destaques
│       └── widgets/
│           ├── categories_slider.dart # Carrossel de categorias
│           └── novidades_grid.dart    # Grid de novidades
└── product_details/
    └── product_details.dart           # Tela de detalhes do produto
```

## 🚀 Como executar localmente

```bash
# 1. Clone o repositório
git clone https://github.com/Alexsantossp71/flutter_ecommerce.git
cd flutter_ecommerce

# 2. Instale as dependências
flutter pub get

# 3. Execute (emulador ou dispositivo conectado)
flutter run
```

## 👤 Autor

**Alexandre Ramos** — [github.com/Alexsantossp71](https://github.com/Alexsantossp71)

## 📄 Status

Projeto de estudo funcional (última atualização: janeiro/2023).
