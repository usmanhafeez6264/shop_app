import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final title;
  final image;
  final id;

  UserProductItem(this.title, this.image, this.id);

  @override
  Widget build(BuildContext context) {
    final delItem = Provider.of<Products>(context, listen: false);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(image),
          ),
          title: Text(title),
          //subtitle: Text(""),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    )),
                IconButton(
                    onPressed: () async {
                      try {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: new Text('Are you sure?'),
                                  content: new Text(
                                      'Do you really want to delete this item?'),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("Continue"),
                                      onPressed: () {
                                        delItem.deleteProduct(id);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    new FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));
                      } catch (error) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Cannot delete item! Refresh to get back")));
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
