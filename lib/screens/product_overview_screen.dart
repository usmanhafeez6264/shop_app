import 'package:flutter/material.dart';
import 'package:shop_app/widgets/21.1%20badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../widgets/drawer.dart';

enum filterOption {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var isInit = true;
  bool isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) => (_) {
    //       Provider.of<Products>(context).fetchProducts();
    //     });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });

      Provider.of<Products>(context).fetchProducts().then((_) => setState(() {
            isLoading = false;
          }));
    }
    isInit = false;

    super.didChangeDependencies();
  }

  var showOnlyFav = false;

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Shop"),
          actions: [
            PopupMenuButton(
                onSelected: (filterOption selectedValue) {
                  setState(() {
                    if (selectedValue == filterOption.Favourites) {
                      showOnlyFav = true;
                    } else {
                      showOnlyFav = false;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (ctx) => [
                      PopupMenuItem(
                        child: Text("Only Favourites"),
                        value: filterOption.Favourites,
                      ),
                      PopupMenuItem(
                        child: Text("Show All"),
                        value: filterOption.All,
                      )
                    ]),
            //IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
            Consumer<Cart>(
              builder: (ctx, cart, child) => Badge(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                  value: cart.itemCount.toString(),
                  color: Colors.red),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(showOnlyFav));
  }
}
