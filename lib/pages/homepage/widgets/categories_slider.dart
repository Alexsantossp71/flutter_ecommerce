// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/model/slidercategorias_model.dart';

class SliderCategorias extends StatelessWidget {
  SliderCategorias({super.key});

  List<SliderCategoriaModel> titulos = [
    SliderCategoriaModel(
        title: 'AGASALHOS', icon: 'images/categorias/agasalho.png'),
    SliderCategoriaModel(
        title: 'CAMISAS', icon: 'images/categorias/camisa2.png'),
    SliderCategoriaModel(title: 'CALÇAS', icon: 'images/categorias/calça.png'),
    SliderCategoriaModel(
        title: 'BERMUDAS', icon: 'images/categorias/bermuda.png'),
    SliderCategoriaModel(title: 'TENIS', icon: 'images/categorias/tenis.png'),
    SliderCategoriaModel(title: 'MEIAS', icon: 'images/categorias/meias.png'),
    SliderCategoriaModel(
        title: 'GRAVATAS', icon: 'images/categorias/gravatas.png'),
    SliderCategoriaModel(
        title: 'MOLETONS', icon: 'images/categorias/moleton.png'),
    SliderCategoriaModel(title: 'CUECAS', icon: 'images/categorias/cuecas.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 80,
        child: ListView(
          // This next line does the trick.
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            for (var item in titulos)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Category(imageIcon: item.icon, imageCaption: item.title),
              ),
          ],
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  Category({super.key, required this.imageIcon, required this.imageCaption});
  String imageIcon;
  String imageCaption;
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      // height: 80,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Image.asset(imageIcon, height: 60),
            /*  Icon(
              imageIcon,
              size: 60,
            ),*/
            Text(imageCaption)
          ],
        ),
      ),
    );
  }
}
