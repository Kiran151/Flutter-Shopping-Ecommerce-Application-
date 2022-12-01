import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/cart.dart';
import 'package:shopy/screens/cart_screen.dart';
import 'package:shopy/widgets/badge.dart';
import 'package:shopy/widgets/drawer.dart';
import 'package:shopy/widgets/products_grid.dart';
import '../providers/products.dart';

enum FilterOptions {
  All,
  Favorites,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProduct(); //won't work here.
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchAndSetProduct();
    // }); -- this will work,this is a hack.
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<Products>(context).fetchAndSetProduct().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('AN ERROR OCCURED')));
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<Products>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopy'),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.Favorites) {
                      _showFavoritesOnly = true;
                    } else {
                      _showFavoritesOnly = false;
                    }
                  });
                },
                icon: const Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: FilterOptions.All,
                        child: Text('All'),
                      ),
                      const PopupMenuItem(
                        value: FilterOptions.Favorites,
                        child: Text('Favorites'),
                      ),
                    ]),
            Consumer<Cart>(
              builder: (_, cartData, c) => Badge(
                value: cartData.itemCount.toString(),
                color: Colors.red,
                child: c!,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            )
          ],
        ),
        drawer: const SideDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ProductsGrid(_showFavoritesOnly),
        ),
      ),
    );
  }
}
