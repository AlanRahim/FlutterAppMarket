import 'package:flutter/material.dart';
import 'package:flutter_mmnes/models/cardlist.dart';

class BottomGridView extends StatefulWidget {

  BottomGridView({Key key}) : super(key: key);

  @override
  createState() => BottomGridViewState();
}

class BottomGridViewState extends State<BottomGridView> {
  List<Item> images = [];

  @override
  void initState() {
    super.initState();
    getListData();
  }

  @override
  Widget build(BuildContext context) {
//    return Center();
    return Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text("test"),
              ),
            ),

            ///分割符自定义，可以放任何widget
            Text('/', style: TextStyle(color: Color(0xffd0d0d0), fontSize: 23))
          ],
        ));

  }

  void getListData() async {
    images = [];
    setState(() {});
  }
}
