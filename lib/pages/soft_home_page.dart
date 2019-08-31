import 'package:flutter/material.dart';
import 'package:flutter_mmnes/blocs/bloc_provider.dart';
import 'package:flutter_mmnes/blocs/main_bloc.dart';
import 'package:flutter_mmnes/models/cardlist.dart';
import 'package:flutter_mmnes/pages/select_game_page.dart';
import 'package:flutter_mmnes/pages/soft_grid_view.dart';
import 'package:flutter_mmnes/ui/banner_view.dart';
import 'package:flutter_mmnes/ui/home_section_view.dart';
import 'package:flutter_mmnes/utils/loading_util.dart';
import 'package:flutter_mmnes/utils/route_util.dart';
import 'package:rxdart/rxdart.dart';

import 'app_hot.dart';

bool isHomeInit = true;

class SoftHomePage extends StatelessWidget {
  List<CardNes> cardList;
  List<CardUnit> totalList;
  List<CardUnit> advList;
  List<CardUnit> appList;
  List<CardUnit> selectList;

  CardUnit bannerCard;
  CardUnit selectCard;
  CardUnit appCard;
  @override
  Widget build(BuildContext context) {
    totalList = List();
    advList = List();
    appList = List();
    selectList = List();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);

    ///初始化数据
    if (isHomeInit) {
      isHomeInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.getCardList();
      });
    }

    return new StreamBuilder(
        stream: bloc.cardListDataStream,
        builder: (BuildContext context, AsyncSnapshot<CardListData> snapshot) {
          CardListData model = snapshot.data;
          if (model == null) {
            return getLoadingWidget();
          }
          generateCardListData(model);
          return new Scaffold(
            body: ListView(children: <Widget>[
              ///广告banner
              BannerView(banner: bannerCard.advs),

              ///精选游戏
              HomeSectionView(selectCard.title,
                  onPressed: () => pushNewPage(
                      context,
                      AppHotPage(new CardProperty(
                          selectCard.title, selectCard.more)))),

              ///人气精选-横拨
              Container(
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
            ]),
          );
        });
  }

  void generateCardListData(CardListData softCardList) {
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
    bannerCard = advList.isNotEmpty ? advList[0] : null;
    selectCard = selectList.isNotEmpty ? selectList[0] : null;
    appCard = appList.isNotEmpty ? appList[0] : null;
    totalList.addAll(appList);
    totalList.addAll(selectList);
    totalList.addAll(advList);
  }
}
