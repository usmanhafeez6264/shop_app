import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/order_screen.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = './cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Builder(
        builder: (context) => Card(
            child: cart.items.isEmpty
                ? Center(
                    child: Text("No items in cart to show"),
                  )

                // Center(child: Text("No Items in cart"))

                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Grand Total",
                              style: TextStyle(fontSize: 20),
                            ),
                            Spacer(),
                            Chip(
                              label: Text(
                                ' PKR ${cart.totalAmount}'.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            TextButton(
                                onPressed: () {
                                  Provider.of<Orders>(context, listen: false)
                                      .addOrder(cart.items.values.toList(),
                                          cart.totalAmount);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Your Order Has been Placed!"),
                                      action: SnackBarAction(
                                        label: ("Track Order"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed(OrderScreen.routeName);
                                        },
                                      ),
                                    ),
                                  );
                                  cart.clear();
                                },
                                child: Text("ORDER NOW"))
                          ],
                        ),
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, index) => ci.CartItem(
                            cart.items.values.toList()[index].id,
                            cart.items.keys.toList()[index],
                            cart.items.values.toList()[index].title,
                            cart.items.values.toList()[index].price,
                            cart.items.values.toList()[index].quantity),
                      )
                    ],
                  )),
      ),
    );
  }
}
