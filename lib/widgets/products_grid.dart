import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavs ? productData.favItems : productData.items;
    return GridView.builder(
        padding: EdgeInsets.all(02),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 2),
        itemCount: products.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              // create: (context) => products[index],
              child: ProductItem(
                  // products[index].id,
                  // products[index].title,
                  // products[index].imageUrl,
                  ),
            ));
  }
}
