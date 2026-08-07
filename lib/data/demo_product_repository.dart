import '../models/product.dart';
import 'product_repository.dart';

/// Implementação demo: catálogo fixo com produtos de moda praia.
///
/// Substitua por uma implementação Firebase (ou API) quando o backend
/// estiver disponível — a interface [ProductRepository] não muda.
class DemoProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async => _products;

  static const List<Product> _products = [
    Product(
      id: 'camiseta-mar',
      name: 'Camiseta Básica Mar',
      description:
          'Camiseta em algodão premium, corte regular e toque macio. '
          'Perfeita para o dia a dia na cidade ou na praia.',
      price: 59.90,
      category: 'Moda',
      imageAsset: 'images/categorias/camisa2.png',
      isFeatured: true,
    ),
    Product(
      id: 'camiseta-listrada',
      name: 'Camiseta Listrada Surf',
      description:
          'Listras clássicas com modelagem confortável. '
          'Combina com bermuda e chinelo — visual praiano autêntico.',
      price: 79.90,
      category: 'Moda',
      imageAsset: 'images/categorias/camisa.png',
      isFeatured: true,
    ),
    Product(
      id: 'bermuda-praia',
      name: 'Bermuda de Praia Secagem Rápida',
      description:
          'Tecido leve de secagem rápida, ideal para praia e piscina. '
          'Bolsos com fecho e elástico ajustável.',
      price: 89.90,
      category: 'Praia',
      imageAsset: 'images/categorias/bermuda.png',
      isFeatured: true,
    ),
    Product(
      id: 'calca-jeans',
      name: 'Calça Jeans Conforto',
      description:
          'Jeans com elastano para maior mobilidade. '
          'Clássica, versátil e pronta para qualquer ocasião.',
      price: 129.90,
      category: 'Moda',
      imageAsset: 'images/categorias/calça.png',
    ),
    Product(
      id: 'moletom-leve',
      name: 'Moletom Leve Meia-Estação',
      description:
          'Moletom fino, perfeito para as noites mais frescas de Santos. '
          'Toque de algodão e modelagem despojada.',
      price: 149.90,
      category: 'Moda',
      imageAsset: 'images/categorias/moleton.png',
      isFeatured: true,
    ),
    Product(
      id: 'tenis-casual',
      name: 'Tênis Casual All Day',
      description:
          'Conforto do início ao fim do dia. Solado antiderrapante '
          'e cabedal respirável para o clima litorâneo.',
      price: 199.90,
      category: 'Calçados',
      imageAsset: 'images/categorias/tenis.png',
      isFeatured: true,
    ),
    Product(
      id: 'meias-pack',
      name: 'Meias Esportivas (3 pares)',
      description:
          'Pack com três pares de meias cano médio, algodão com elastano. '
          'Respiração reforçada para o dia a dia.',
      price: 29.90,
      category: 'Acessórios',
      imageAsset: 'images/categorias/meias.png',
    ),
    Product(
      id: 'gravata-slim',
      name: 'Gravata Slim Elegante',
      description:
          'Gravata slim de poliéster acetinado. '
          'O toque de elegância para eventos e ocasiões especiais.',
      price: 69.90,
      category: 'Moda',
      imageAsset: 'images/categorias/gravatas.png',
    ),
    Product(
      id: 'cuecas-pack',
      name: 'Cuecas Confort (pack c/ 3)',
      description:
          'Pack com três cuecas de algodão, elasticidade duradoura '
          'e costuras planas para máximo conforto.',
      price: 49.90,
      category: 'Moda',
      imageAsset: 'images/categorias/cuecas.png',
    ),
    Product(
      id: 'agasalho-urbano',
      name: 'Agasalho Urbano Versátil',
      description:
          'Casaco leve com capuz, ideal para a brisa do mar. '
          'Bolso canguru e toque aveludado.',
      price: 169.90,
      category: 'Moda',
      imageAsset: 'images/categorias/agasalho.png',
    ),
  ];
}
