// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/product_details/product_details.dart';

class NovidadesGrid extends StatefulWidget {
  const NovidadesGrid({super.key});

  @override
  State<NovidadesGrid> createState() => _NovidadesGridState();
}

class _NovidadesGridState extends State<NovidadesGrid> {
  var novidadesList = [
    {
      'nome': 'Agasalho',
      'imagem': 'images/categorias/agasalho.png',
      'preco': '120',
      'precoDesconto': '100',
    },
    {
      'nome': 'Camisas',
      'imagem': 'images/categorias/camisa2.png',
      'preco': '121',
      'precoDesconto': '101',
    },
    {
      'nome': 'Tenis',
      'imagem': 'images/categorias/tenis.png',
      'preco': '122',
      'precoDesconto': '102',
    },
    {
      'nome': 'Moleton',
      'imagem': 'images/categorias/moleton.png',
      'preco': '123',
      'precoDesconto': '103',
    },
    {
      'nome': 'Gravatas',
      'imagem': 'images/categorias/gravatas.png',
      'preco': '124',
      'precoDesconto': '104',
    },
    {
      'nome': 'Meias',
      'imagem': 'images/categorias/meias.png',
      'preco': '125',
      'precoDesconto': '105',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: novidadesList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: ((context, index) {
          return Single_Prod(
            prod_nome: novidadesList[index]['nome'],
            prod_imagem: novidadesList[index]['imagem'],
            prod_preco: novidadesList[index]['preco'],
            prod_precoDesconto: novidadesList[index]['precoDesconto'],
          );
        }));
  }
}

class Single_Prod extends StatelessWidget {
  final prod_nome;
  final prod_imagem;
  final prod_preco;
  final prod_precoDesconto;

  const Single_Prod(
      {super.key,
      required this.prod_nome,
      required this.prod_imagem,
      required this.prod_preco,
      required this.prod_precoDesconto});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: prod_nome,
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ProductDetails(),
                ),
              );
            },
            child: GridTile(
              footer: Container(
                color: Colors.white60,
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(36, 0, 9, 0),
                  title: Text(
                    "R\$ $prod_preco,00",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text(
                    "R\$ $prod_precoDesconto,00",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 43, 43, 43),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Text(
                    prod_nome,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              child: Image.asset(
                prod_imagem,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
