import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/pages/homepage/slider.dart';
import 'package:flutter_ecommerce/pages/homepage/widgets/categories_slider.dart';
import 'package:flutter_ecommerce/pages/homepage/widgets/novidades_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      drawer: Drawer(
        child: ListView(
          children: [
            //cabeçalho
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              accountName: const Text('Alexandre'),
              accountEmail: const Text('a@a.net'),
              currentAccountPicture: GestureDetector(
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

/////////////////////////FIM HEARDE DRAWER///////////////////////////////////////////
//// CORPO DRAWER

            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Text('Início'),
                leading: Icon(Icons.home),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Text('Minha Conta'),
                leading: Icon(Icons.person),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Text('Pedidos'),
                leading: Icon(Icons.shopping_basket),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Text('Categorias'),
                leading: Icon(Icons.dashboard),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Text('Favoritos'),
                leading: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Text('Configurações'),
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Text('Sobre'),
                leading: Icon(
                  Icons.help,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // slider de apresentação
          MeuSlider(
            title: '',
          ),

          // Categorias
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Categorias",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // SLIDE CATEGORIAS
          SizedBox(height: 90, child: SliderCategorias()),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Novidades",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // GRIDVIEW DAS NOVIDADES

          const SizedBox(
            height: 320,
            child: NovidadesGrid(),
          )
        ],
      ),
    );
  }
}
