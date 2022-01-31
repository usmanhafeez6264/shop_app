import 'package:flutter/material.dart';
import 'package:shop_app/screens/user_products.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {
  //const AddNewProduct({Key? key}) : super(key: key);
  static const routeName = 'add-new-product';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final imageController = TextEditingController();
  final priceNode = FocusNode();
  final descriptionNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  bool isLoading = false;

  Future<void> addProduct() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Products>(context, listen: false)
          .addProduct(editedProduct);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Something went wrong"),
          content: Text("An error occured while processing request"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Okay"))
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    imageController.dispose();
    priceNode.dispose();
    descriptionNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Product"),
        actions: [
          IconButton(onPressed: () => addProduct(), icon: Icon(Icons.save))
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Enter Title'),
                      onSaved: (value) => editedProduct = Product(
                          id: editedProduct.id,
                          title: value.toString(),
                          description: editedProduct.description,
                          price: editedProduct.price,
                          imageUrl: editedProduct.imageUrl),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(priceNode),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter title.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Enter Price'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      focusNode: priceNode,
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            price: double.parse(value.toString()),
                            imageUrl: editedProduct.imageUrl);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(descriptionNode);
                      },
                    ),
                    TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Enter Description'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Description';
                          }
                          return null;
                        },
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) => editedProduct = Product(
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: value.toString(),
                            price: editedProduct.price,
                            imageUrl: editedProduct.imageUrl),
                        focusNode: descriptionNode),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                          ),
                          child: imageController.text.isEmpty
                              ? Center(child: Text("No image"))
                              : FittedBox(
                                  child: Image.network(imageController.text,
                                      fit: BoxFit.cover),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                            controller: imageController,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onSaved: (value) => editedProduct = Product(
                                id: editedProduct.id,
                                title: editedProduct.title,
                                description: editedProduct.description,
                                price: editedProduct.price,
                                imageUrl: value.toString()),
                            decoration:
                                InputDecoration(labelText: 'Enter Image Url'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () => addProduct(),
                        child: Text("Add Product"))
                  ],
                ),
              ),
            ),
    );
  }
}
