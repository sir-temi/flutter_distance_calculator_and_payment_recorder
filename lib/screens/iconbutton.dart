import 'package:flutter/material.dart';

class IconB extends StatelessWidget {
  var subMit;
  var level;

  IconB({
    this.subMit,
    this.level
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
                    icon: Icon(
                      Icons.add_circle), 
                    onPressed: (){
                      subMit();
                      final snackBar = SnackBar(
                        content: Text(
                          '$level added successfully.',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16
                          ),
                          ),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 8,
                        duration: Duration(seconds: 7),
                      );

                    // Find the Scaffold in the widget tree and use
                    // it to show a SnackBar.
                    Scaffold.of(context).showSnackBar(snackBar);
                    }, 
                    iconSize: 100,
                    color: Theme.of(context).primaryColor,
                      );
  }
}