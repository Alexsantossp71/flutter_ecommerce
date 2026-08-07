import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Rodapé da loja.
/// Desktop: três colunas (marca, navegação, contato).
/// Mobile: versão compacta em pilha.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    return Container(
      color: AppTheme.deep,
      padding: EdgeInsets.fromLTRB(24, isDesktop ? 40 : 28, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _BrandColumn()),
                Expanded(child: _FooterColumn(
                  title: 'Navegação',
                  links: ['Início', 'Categorias', 'Novidades', 'Carrinho'],
                )),
                Expanded(child: _FooterColumn(
                  title: 'Contato',
                  links: ['Santos, SP — Brasil', 'contato@modapraia.com.br', '(13) 99999-0000'],
                )),
              ],
            )
          else ...[
            const _BrandColumn(),
            const SizedBox(height: 20),
            const _FooterColumn(
              title: 'Navegação',
              links: ['Início', 'Categorias', 'Novidades', 'Carrinho'],
            ),
            const SizedBox(height: 16),
            const _FooterColumn(
              title: 'Contato',
              links: ['Santos, SP — Brasil', 'contato@modapraia.com.br', '(13) 99999-0000'],
            ),
          ],
          const SizedBox(height: 24),
          Center(
            child: Text(
              '© 2026 Moda Praia Santos • Feito com Flutter • Demonstração sem vínculo comercial',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandColumn extends StatelessWidget {
  const _BrandColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MODA PRAIA SANTOS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Estilo litorâneo para todos os dias.\nProjeto de portfólio construído com Flutter.',
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.links});

  final String title;
  final List<String> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.gold,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              link,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}
