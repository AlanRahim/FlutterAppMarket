import 'package:flutter/material.dart';
import 'package:flutter_mmnes/models/cardlist.dart';
import 'package:flutter_mmnes/utils/route_util.dart';

import 'app_detail.dart';

const _defaulUrl =
    'https://img3.doubanio.com/f/movie/8dd0c794499fe925ae2ae89ee30cd225750457b4/pics/movie/celebrity-default-medium.png';

class _SelectGame extends StatelessWidget {
  final Item item;

  _SelectGame({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => pushNewPage(context, AppDetail(item.contentId)),
      child: Container(
        color: Colors.lightBlue[50],
        margin: EdgeInsets.only(left: 8.0),
        padding: EdgeInsets.all(6.0),
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                child: Image.network(
                  item.iconUrl == null ? _defaulUrl : item.iconUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                item.name,
                overflow: TextOverflow.ellipsis,
              )
            ],
          );
        }),
      ),
    );
  }
}

class SelectGames extends StatelessWidget {
  CardUnit cardUnit;

  SelectGames(this.cardUnit, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300], width: 0.5),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 110,
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    itemExtent: 110,
                    scrollDirection: Axis.horizontal,
                    children: cardUnit.items
                        .map<Widget>((item) => _SelectGame(
                              item: item,
                            ))
                        .toList(),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
