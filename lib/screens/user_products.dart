import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/add_new_product.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProducts extends StatelessWidget {
  const UserProducts({Key? key}) : super(key: key);
  Future<void> pullToRefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  static const routeName = '/user-product';
  @override
  Widget build(BuildContext context) {
    final manageProducts = Provider.of<Products>(context);
    return RefreshIndicator(
      onRefresh: () => pullToRefresh(context),
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Your Products"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddNewProduct.routeName);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: ListView.builder(
          itemCount: manageProducts.items.length,
          itemBuilder: (ctx, index) => UserProductItem(
            manageProducts.items[index].title,
            manageProducts.items[index].imageUrl,
            manageProducts.items[index].id,
          ),
        ),
      ),
    );
  }
}
