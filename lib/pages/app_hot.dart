import 'package:flutter/material.dart';
import 'package:flutter_mmnes/api/api_service.dart';
import 'package:flutter_mmnes/log/log.dart';
import 'package:flutter_mmnes/models/cardlist.dart';
import 'package:flutter_mmnes/models/hotapp_bean.dart';
import 'package:flutter_mmnes/pages/app_detail.dart';
import 'package:flutter_mmnes/ui/hotapp_grid_view.dart';
import 'package:flutter_mmnes/ui/item_list.dart';
import 'package:flutter_mmnes/utils/loading_util.dart';
import 'package:flutter_mmnes/utils/route_util.dart';

class AppHotPage extends StatefulWidget {
  CardProperty prop;

  AppHotPage(this.prop, {Key key}) : super(key: key);

  @override
  _AppHotPageState createState() => _AppHotPageState(prop);
}

class _AppHotPageState extends State<AppHotPage> {
  var log = LogHelper();
  CardProperty prop;
  HotResultBean hotResultBean;
  List<SearchItem> hotItems = [];
  bool loadError = false;
  bool isEmpty = false;
  bool isFirst = true;

  bool isList = true;

  _AppHotPageState(this.prop);

  @override
  void initState() {
    super.initState();
    getAppHotList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(prop == null? "热门应用":prop.title), actions: <Widget>[
        IconButton(
            icon: Icon(isList ? Icons.menu : Icons.apps),
            onPressed: () => setState(() => isList = !isList))
      ]),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: !isFirst,
            child: Center(child: getLoadingWidget()),
          ),
          Offstage(
            offstage: !isEmpty,
            child: Center(
              child: Text("暂无数据"),
            ),
          ),
          Offstage(
            offstage: !loadError,
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  getAppHotList();
                },
                child: Text("加载失败，重新加载"),
              ),
            ),
          ),
          Offstage(
              offstage: loadError && isEmpty,
              child: isList
                  ? ListView(
                      /// 表示列表包含的widget集合，整个滚动视图中的内容设置。
                      children: hotItems.map((hotItem) {
                        return ItemList(
                          searchItem: hotItem,
                          onTap: () => pushNewPage(
                              context, AppDetail(hotItem.contentId)),
                        );
                      }).toList(),

                      /// 表示控件滚动的方向，主要有两个值可设置。Axis.vertical表示垂直滚动视图；Axis.horizontal表示水平滚动视图。
                      scrollDirection: Axis.vertical,

                      /// 可设置值为true|false。true时表示内容不足够填充控件区间时也可以有滚动反馈；false表示只有内容超出控件大小时才可滚动。
                      primary: true,

                      /// 表示读取内容的方向是否颠倒，可设置值为true|false。false表示由左向右或由上向下读取；true表示由右向左或由下向上读取。
                      reverse: false,

                      /// 表示物理反馈，一般设置值为AlwaysScrollableScrollPhysics()|ScrollPhysics()。AlwaysScrollableScrollPhysics表示总是有滚动反馈，无论primary值为true or false；ScrollPhysics表示只有只有内容超出控件大小时才会有滚动反馈，无论primary值为true or false。
                      physics: const BouncingScrollPhysics(),

                      /// 表示控件的内边距。
                      padding: EdgeInsets.all(0.0),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: hotItems
                              .map((hotItem) => HotAppGridView(hotItem))
                              .toList(),
                        ),
                      ),
                    ))
        ],
      ),
    );
  }

  void getAppHotList() async {
    if(prop == null){
      isEmpty = true;
    }else{
      hotResultBean = await ApiService.getHotAppList(prop.more);
      loadError = hotResultBean == null;
      if (hotResultBean == null) {
        isEmpty = true;
      } else if (hotResultBean.items.isEmpty) {
        isEmpty = true;
      }
      isFirst = false;
      if (!isEmpty) {
        hotItems = hotResultBean.items;
      }
    }
    log.info("AppHotPage getAppHotList" + hotItems.length.toString());
    setState(() {
      hotItems;
    });
  }
}
