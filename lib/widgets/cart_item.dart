import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  CartItem(this.id, this.productId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: ValueKey(id),
          background: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          confirmDismiss: (direction) {
            return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text("Are you Sure?"),
                      content:
                          Text("Do you really want to remove item from cart?"),
                      actions: [
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("No")),
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Yes"))
                      ],
                    ));
          },
          onDismissed: (direction) {
            Provider.of<Cart>(context, listen: false).removeItem(
              productId,
            );
          },
          direction: DismissDirection.endToStart,
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                child: FittedBox(
                    child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(price.toString()),
                )),
              ),
              title: Text(title),
              subtitle: Text('Total: ${(price * quantity)}'),
              trailing: Text('$quantity x'),
            ),
          ),
        ),
      ],
    );
  }
}
