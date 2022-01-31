import 'package:flutter/material.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/order';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Placed Order"),
      ),
      drawer: AppDrawer(),
      body: orderData.orders.isEmpty
          ? Center(child: Text("No Orders Placed yet!"))
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, index) => OrderItem(orderData.orders[index]),
            ),
    );
  }
}
