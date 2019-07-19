import 'package:flutter/material.dart';
import 'package:flutter_mmnes/log/log.dart';

import 'package:flutter_mmnes/models/hotapp_bean.dart';
import 'package:flutter_mmnes/pages/app_detail.dart';
import 'package:flutter_mmnes/ui/image_load_view.dart';
import 'package:flutter_mmnes/utils/route_util.dart';
import 'package:flutter_mmnes/utils/utils.dart';
import 'package:flutter_mmnes/custom_widgets/smooth_star_rating.dart';


class HotAppGridView extends StatelessWidget {
  var log = LogHelper();
  final SearchItem item;
  final Color textColor;

  HotAppGridView(this.item, {Key key, this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = (Utils.width - 6 * 3 - 5 * 3) / 4;
    double height = width * 383 / 270;
    return GestureDetector(
      onTap: () => pushNewPage(context, AppDetail(item.contentId)),
      child: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageLoadView(item.iconUrl.toString(),
                fit: BoxFit.cover, height: 40, width: 40,),
            SizedBox(height: 5),
            Text(
              item.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.normal, color: textColor),
              maxLines: 1,
            ),
            SizedBox(height: 3),
            SmoothStarRating(
              rating: 4.0,
              size: 12,
              allowHalfRating: false,
              color: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }
}
