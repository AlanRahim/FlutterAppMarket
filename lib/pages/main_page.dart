import 'package:flutter/material.dart';
import 'package:flutter_mmnes/pages/soft_home_page.dart';
import 'package:flutter_mmnes/res/strings.dart';
import 'package:flutter_mmnes/utils/intl_utils.dart';
import 'package:flutter_mmnes/utils/toast.dart';
import 'package:flutter_mmnes/utils/utils.dart';

import 'game_home_page.dart';

class _Page {
  final String labelId;

  _Page(this.labelId);
}

final List<_Page> _allPages = <_Page>[
  new _Page(Ids.titleSoft),
  new _Page(Ids.titleGame),
];

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: _allPages.length,
        child: new Scaffold(
          appBar: new AppBar(
//            leading: new Container(
//              decoration: BoxDecoration(
//                shape: BoxShape.circle,
//                image: DecorationImage(
//                  image: AssetImage(
//                    Utils.getImgPath('flutter_logo'),
//                  ),
//                ),
//              ),
//            ),
            centerTitle: true,
            title: new TabLayout(),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () => Toast.show('搜索测试', context))
            ],
          ),
          body: new TabBarViewLayout(),
//          drawer: new Drawer(
//            child: new Text("MainLeftPage"),
//          ),
          )
    );
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      isScrollable: true,
      labelPadding: EdgeInsets.all(12.0),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: _allPages
          .map((_Page page) =>
      new Tab(text: IntlUtil.getString(context, page.labelId)))
          .toList(),
    );
  }
}

class TabBarViewLayout extends StatelessWidget {
  Widget buildTabView(BuildContext context, _Page page) {
    String labelId = page.labelId;
    switch (labelId) {
      case Ids.titleSoft:
        return SoftHomePage();
        break;
      case Ids.titleGame:
        return GameHomePage();
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new TabBarView(
        children: _allPages.map((_Page page) {
          return buildTabView(context, page);
        }).toList());
  }
}
