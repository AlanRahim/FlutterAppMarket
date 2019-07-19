import 'package:flutter/material.dart';
import 'package:flutter_mmnes/log/log.dart';
import 'package:flutter_mmnes/models/hotapp_bean.dart';
import 'package:flutter_mmnes/ui/image_load_view.dart';

class ItemList extends StatelessWidget {
  var log = LogHelper();
  final VoidCallback onTap;
  final SearchItem searchItem;

  ItemList({Key key, this.searchItem, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///空布局
    var sizeBox = SizedBox(width: 16);

    /// icon
    var movieImage = ImageLoadView(searchItem.iconUrl,
        borderRadius: BorderRadius.circular(4.0), height: 50.0, width: 50.0);

    var movieMsg = Container(
      //高度
      height: 80.0,
      margin: EdgeInsets.only(left: 8.0),
      padding: EdgeInsets.only(left: 8.0, top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            searchItem.name,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13.0,
                color: Colors.black87),
          ),

          /// 应用大小
          Text(searchItem.appSize.toString() + "KB"),

          ///下载量
          Text(searchItem.interested),
        ],
      ),
    );

    return GestureDetector(
      //点击事件
      onTap: onTap,

      child: Card(
        child: Row(
          children: <Widget>[
            sizeBox,
            movieImage,
            // Expanded 均分
            Expanded(
              child: movieMsg,
            ),
          ],
        ),
      ),
    );
  }
}
