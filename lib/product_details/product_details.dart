// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final prod_detail_nome;
  final prod_detail_imagem;
  final prod_detail_preco;
  final prod_detail_precoDesconto;

  const ProductDetails(
      {super.key,
      required this.prod_detail_nome,
      required this.prod_detail_imagem,
      required this.prod_detail_preco,
      required this.prod_detail_precoDesconto});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text('Lojinha'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag)),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 300,
            color: Colors.blueGrey,
            child: GridTile(
              child: Image.asset(widget.prod_detail_imagem),
            ),
          )
        ],
      ),
    );
  }
}
