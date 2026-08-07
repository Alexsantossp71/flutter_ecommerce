import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/catalog_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/benefits_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/site_footer.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

/// Tela inicial: hero banner, busca, categorias e grade responsiva
/// de produtos (2 colunas no celular até 5 no desktop).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  bool get _isDesktop => MediaQuery.sizeOf(context).width >= 900;

  int _columns(double width) {
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  double _aspectRatio(double width) {
    final cols = _columns(width);
    if (cols >= 4) return 0.8;
    if (cols == 3) return 0.74;
    return 0.68;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToProducts() {
    final target = _isDesktop ? 380.0 : 240.0;
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _openDetail(BuildContext context, String productId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(productId: productId),
      ),
    );
  }

  void _openCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final cart = context.watch<CartProvider>();
    final width = MediaQuery.sizeOf(context).width;
    final cols = _columns(width);
    final heroHeight = _isDesktop ? 360.0 : 230.0;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ===== Hero banner =====
          SliverAppBar(
            pinned: true,
            expandedHeight: heroHeight,
            backgroundColor: AppTheme.sea,
            foregroundColor: Colors.white,
            title: const Text('Moda Praia Santos'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () => _openCart(context),
                  tooltip: 'Carrinho',
                  icon: Badge(
                    isLabelVisible: cart.totalItems > 0,
                    label: Text('${cart.totalItems}'),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('images/hero-praia.jpg', fit: BoxFit.cover),
                  // véu para legibilidade
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppTheme.deep.withValues(alpha: 0.78),
                          Colors.transparent,
                          AppTheme.deep.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                  ),
                  // texto + CTA
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'VERÃO EM SANTOS',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Estilo litorâneo para\ntodos os dias',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isDesktop ? 34 : 26,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.gold,
                            foregroundColor: AppTheme.deep,
                            minimumSize: Size(_isDesktop ? 200 : 180, 46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          onPressed: _scrollToProducts,
                          icon: const Icon(Icons.arrow_downward, size: 18),
                          label: const Text(
                            'Ver novidades',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== Busca + categorias =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: catalog.setQuery,
                    decoration: const InputDecoration(
                      hintText: 'Buscar produto...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: catalog.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = catalog.categories[index];
                        return ChoiceChip(
                          label: Text(category),
                          selected: catalog.selectedCategory == category,
                          onSelected: (_) => catalog.setCategory(category),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== Benefícios (mobile e desktop) =====
          const SliverToBoxAdapter(child: BenefitsBar()),

          // ===== Título da seção =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 4),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppTheme.gold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nossos produtos',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _isDesktop ? 22 : 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!_isDesktop)
                    Text(
                      '${catalog.filtered.length} itens',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.ink.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ===== Grade de produtos =====
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                childAspectRatio: _aspectRatio(width),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = catalog.filtered[index];
                  return ProductCard(
                    product: product,
                    onTap: () => _openDetail(context, product.id),
                    onAddToCart: () {
                      cart.addProduct(product);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.name} adicionado ao carrinho',
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    },
                  );
                },
                childCount: catalog.loading ? 0 : catalog.filtered.length,
              ),
            ),
          ),

          if (catalog.loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (catalog.filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 56, color: AppTheme.sea),
                    const SizedBox(height: 12),
                    const Text(
                      'Nenhum produto encontrado',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ===== Rodapé (mobile e desktop) =====
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
