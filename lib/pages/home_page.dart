import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mmnes/api/api_service.dart';
import 'package:flutter_mmnes/log/log.dart';
import 'package:flutter_mmnes/models/cardlist.dart';
import 'package:flutter_mmnes/pages/app_hot.dart';
import 'package:flutter_mmnes/pages/select_game_page.dart';
import 'package:flutter_mmnes/pages/soft_grid_view.dart';
import 'package:flutter_mmnes/ui/banner_view.dart';
import 'package:flutter_mmnes/ui/home_section_view.dart';
import 'package:flutter_mmnes/utils/loading_util.dart';
import 'package:flutter_mmnes/utils/route_util.dart';

class NesHomePage extends StatefulWidget {
  final String title;

  NesHomePage({Key key, this.title}) : super(key: key);

  @override
  NesHomePageState createState() => NesHomePageState(title);
}

class NesHomePageState extends State<NesHomePage> {
  String title;

  NesHomePageState(this.title);

  var log = LogHelper();

  ///软件数据
  CardListData softCardList;
  List<CardNes> cardList;
  List<CardUnit> totalList;
  List<CardUnit> advList;
  List<CardUnit> appList;
  List<CardUnit> selectList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: bodyView(),
        ),
      ],
    ));

//    return Scaffold(
//      appBar: AppBar(
//        automaticallyImplyLeading: false,
//        title: Text('必备应用'),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.search, color: Colors.white),
//            onPressed: () {},
//          )
//        ],
//      ),
//      body: bodyView(),
//      backgroundColor: Colors.white,
//    );
  }

  ///获取主页数据
  Future<void> getHomeData(String title) async {
    totalList = List();
    advList = List();
    appList = List();
    selectList = List();
    log.info("NesHomePage, getHomeData start:" + title);
    softCardList = title == "软件"
        ? await ApiService.getCardList()
        : await ApiService.getGameList();
    this.title = title;
    log.info("NesHomePage, getHomeData:" + softCardList.toString());
    if (softCardList != null) {
      cardList = softCardList.cards;
      if (cardList != null && cardList.isNotEmpty) {
        for (int i = 0; i < cardList.length; i++) {
          CardNes cardNes = cardList[i];
          List<CardUnit> blocks = cardNes.blocks;
          if (blocks != null && blocks.isNotEmpty) {
            for (int j = 0; j < blocks.length; j++) {
              CardUnit unit = blocks[j];
              if (unit != null) {
                switch (unit.type) {
                  case CardListData.TYPE_APP_LIST:

                    ///软件列表
                    appList.add(unit);
                    break;
                  case CardListData.TYPE_HOT_GAME:

                    ///精选
                    selectList.add(unit);
                    break;
                  case CardListData.TYPE_SLIDE_ADV:

                    ///广告
                    advList.add(unit);
                    break;
                }
              }
            }
          }
        }
      }
    }
    totalList.addAll(appList);
    totalList.addAll(selectList);
    totalList.addAll(advList);
    setState(() {
      totalList;
    });
  }

  bodyView() {
    if (totalList == null || totalList.isEmpty) {
      return getLoadingWidget();
    } else {
      CardUnit bannerCard = advList.isNotEmpty ? advList[0] : null;
      CardUnit selectCard = selectList.isNotEmpty ? selectList[0] : null;
      CardUnit appCard = appList.isNotEmpty ? appList[0] : null;
      CardUnit appCard1 = appList.isNotEmpty ? appList[1] : null;
      CardUnit appCard2 = appList.isNotEmpty ? appList[2] : null;
      return title == "软件" ?ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          ///广告banner
          BannerView(banner: bannerCard.advs),

          ///精选游戏
          HomeSectionView(selectCard.title,
              onPressed: () => pushNewPage(
                  context,
                  AppHotPage(
                      new CardProperty(selectCard.title, selectCard.more)))),
          ///人气精选-横拨
          Container(
//            padding: EdgeInsets.all(6.0),
            child: SelectGames(selectCard),
          ),

          ///装机必备
          HomeSectionView(appCard.prop.title,
              onPressed: () => pushNewPage(context, AppHotPage(appCard.prop))),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300], width: 0.5),
                )),
            padding: EdgeInsets.all(6.0),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children:
                  appCard.items.map((item) => SoftGridView(item)).toList(),
            ),
          ),
          HomeSectionView(appCard1.prop.title,
              onPressed: () => pushNewPage(context, AppHotPage(appCard1.prop))),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300], width: 0.5),
                )),
            padding: EdgeInsets.all(6.0),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children:
                  appCard1.items.map((item) => SoftGridView(item)).toList(),
            ),
          ),
        ],
      ):
      ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          ///精选游戏
          HomeSectionView(appCard.prop.title,
              onPressed: () => pushNewPage(context, AppHotPage(appCard.prop))),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300], width: 0.5),
                )),
            padding: EdgeInsets.all(6.0),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children:
              appCard.items.map((item) => SoftGridView(item)).toList(),
            ),
          ),
          HomeSectionView(appCard1.prop.title,
              onPressed: () => pushNewPage(context, AppHotPage(appCard1.prop))),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300], width: 0.5),
                )),
            padding: EdgeInsets.all(6.0),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children:
              appCard1.items.map((item) => SoftGridView(item)).toList(),
            ),
          ),
        ],
      );
    }
  }
}
