# 🏖️ Moda Praia Santos

> E-commerce de moda praia com catálogo, busca, carrinho persistente e checkout — construído em **Flutter** e publicado no **GitHub Pages**.

**🔗 Demo ao vivo:** https://alexsantossp71.github.io/flutter_ecommerce/

---

## 📖 A história

Este projeto começou como um app de estudo (2023) com dados fixos no código — uma vitrine estática. Ele foi **reconstruído** com o objetivo de virar um case de portfólio:

| Antes (estudo) | Agora (portfólio) |
|---|---|
| Dados de produtos fixos na tela | **Catálogo via repositório** (camada de dados desacoplada) |
| Sem carrinho | **Carrinho real**: adicionar, quantidade, total e **persistência local** |
| Sem checkout | **Fluxo completo**: carrinho → checkout → pedido confirmado |
| Sem busca | **Busca e filtro por categoria** |
| Sem testes | **Testes unitários** do carrinho + **testes de widget** |
| Tema padrão do Flutter | **Identidade própria** (Moda Praia Santos) |

---

## 🛠️ Tecnologias

- **Flutter** (Dart 3) — UI multiplataforma
- **Provider** — gerenciamento de estado (carrinho e catálogo)
- **shared_preferences** — persistência do carrinho no navegador/dispositivo
- **GitHub Actions** — CI (analyze + testes) e deploy automático no GitHub Pages

---

## 🏗️ Arquitetura

```
lib/
├── main.dart                     # Bootstrap + providers
├── app.dart                      # MaterialApp + tema
├── theme/                        # Identidade visual (cores do litoral)
├── models/                       # Product, CartItem, Order
├── data/
│   ├── product_repository.dart   # Interface da fonte de produtos
│   └── demo_product_repository.dart  # Implementação demo (dados locais)
├── providers/
│   ├── cart_provider.dart        # Estado do carrinho + persistência
│   └── catalog_provider.dart     # Catálogo + busca + categoria
├── pages/                        # Home, detalhe, carrinho, checkout, sucesso
└── widgets/                      # ProductCard, formatação de moeda
```

O ponto-chave: **as telas dependem de `ProductRepository` (abstração)** — para trocar o demo por Firebase/API, basta criar uma nova implementação e injetá-la no `main.dart`, sem tocar em nenhuma tela.

---

## 🚀 Como executar localmente

```bash
git clone https://github.com/Alexsantossp71/flutter_ecommerce.git
cd flutter_ecommerce
flutter pub get
flutter run          # ou: flutter run -d chrome
```

### Testes

```bash
flutter analyze
flutter test
```

### Build web

```bash
flutter build web --release --base-href=/flutter_ecommerce/
```

---

## ✨ Funcionalidades

- 🛍️ **Catálogo** com 10 produtos de moda praia, categorias e busca
- ⭐ **Slider de destaques** na home
- 🛒 **Carrinho persistente** — sobrevive ao fechar o navegador
- 💳 **Checkout simulado completo**:
  - **Pix**: QR Code fictício (chave demo inexistente), código copia-e-cola
    e confirmação automática em 15s — experiência real, cobrança nenhuma
  - **Cartão**: processamento simulado de ~2,5s com tela de confirmação
- ✅ **Pedido confirmado** com número, resumo, entrega e forma de pagamento
- 📱 **Responsivo** (mobile → tablet → desktop) e pronto para PWA

> 🔒 **Segurança:** é 100% demonstração. O QR Code usa uma chave PIX que
> não existe em nenhum banco (nenhum pagamento é possível) e a interface
> deixa isso explícito ao usuário.

---

## 🗺️ Roadmap

- [ ] **Firebase Auth** — login e cadastro reais
- [ ] **Firestore** — produtos dinâmicos (substituir o repositório demo)
- [ ] **Histórico de pedidos** por usuário
- [ ] **Catálogo admin** para gerenciar produtos

---

## 📄 Licença

MIT — © 2026 Alexandre Ramos
