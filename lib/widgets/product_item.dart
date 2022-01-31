import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import '/providers/products.dart';
import '/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductItem extends StatefulWidget {
  // final id;
  // final title;
  // final image;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.image,
  // );

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context);
    //final isFav = product.isFavourite;
    // final toggler = Provider.of<Products>(context);
    final cart = Provider.of<Cart>(context);
    return Consumer<Product>(builder: (ctx, product, child) {
      return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (context, cart, child) {
                return IconButton(
                  icon: Icon(product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border_outlined),
                  onPressed: () {
                    product.toggleFavourite();
                  },
                );
              },
            ),
            title: Text(product.title),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(" ${product.title} is added to cart!"),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ));
    });
  }
}
