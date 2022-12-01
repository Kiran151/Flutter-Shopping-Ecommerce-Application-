import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/auth.dart';
import 'package:shopy/providers/orders.dart';
import 'package:shopy/widgets/drawer.dart';
import 'package:shopy/widgets/order_items.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //this widget can convert to stateless because this widget not holding any state

  // var _isLoading = false;
  // @override
  // void initState() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final auth=Provider.of<Auth>(context);
  //   Provider.of<Orders>(context, listen: false).fetchOrders(auth.token!,auth.userId!).then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const SideDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context)
              .fetchOrders(authData.token!, authData.userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                //error handling
                return const Center(
                  child: Text('AN ERROR OCCURED'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index) =>
                        OrderItems(order: orderData.orders[index]),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
