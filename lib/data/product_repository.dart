import '../models/product.dart';

/// Fonte de produtos da loja.
///
/// A UI depende apenas desta abstração: hoje temos a implementação demo
/// (dados locais); no futuro, uma implementação Firebase poderá ser plugada
/// sem tocar em nenhuma tela.
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
