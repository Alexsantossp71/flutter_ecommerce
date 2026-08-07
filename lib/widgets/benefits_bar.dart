import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Barra de benefícios típica de e-commerce premium.
/// No mobile vira lista horizontal deslizável; no desktop, linha completa.
class BenefitsBar extends StatelessWidget {
  const BenefitsBar({super.key});

  static const _items = [
    (Icons.local_shipping_outlined, 'Frete grátis', 'acima de R\$ 199'),
    (Icons.swap_horiz, 'Troca fácil', '7 dias para devolver'),
    (Icons.lock_outline, 'Compra segura', 'dados protegidos'),
    (Icons.support_agent, 'Atendimento', 'WhatsApp 13 9xxxx-xxxx'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;
    final theme = Theme.of(context);

    final tiles = _items
        .map(
          (item) => _BenefitTile(icon: item.$1, title: item.$2, subtitle: item.$3),
        )
        .toList();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 20 : 12),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: tiles,
            )
          : SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tiles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => tiles[index],
              ),
            ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.sea.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.sea, size: 22),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ],
    );
  }
}
