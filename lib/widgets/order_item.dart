import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.Order order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('PKR ${widget.order.price}'),
            subtitle: Text(DateTime.now().toString()),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Container(
              height: min(widget.order.products.length * 15.0 + 10, 180),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: widget.order.products
                    .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Item: ${prod.title}',
                              ),
                              Text('Price: ${prod.price}'.toString()),
                              Text('Qty: ${prod.quantity}'.toString()),
                            ]))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
