import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/screens/edit_product_screen.dart';
import 'package:shopy/widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/drawer.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: const SideDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Products>(
                        builder: (context, productsData, _) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: ((context, i) => Column(
                                  children: [
                                    UserProductItem(
                                        id: productsData.items[i].id,
                                        title: productsData.items[i].title,
                                        imageUrl: productsData.items[i].imgUrl),
                                    const Divider(),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
