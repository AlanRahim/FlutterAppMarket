import 'package:flutter/material.dart';
import 'package:flutter_mmnes/log/log.dart';
import 'package:flutter_mmnes/models/cardlist.dart';
import 'package:flutter_mmnes/ui/image_load_view.dart';
import 'package:flutter_mmnes/ui/web_view.dart';
import 'package:flutter_mmnes/utils/route_util.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BannerView extends StatefulWidget {
  final List<AdvData> banner;
  var log = LogHelper();
  BannerView({Key key, this.banner}) : super(key: key);

  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {

  double radius = 5.0;
  double height = 120.0;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      height: height,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          AdvData curBanner = widget.banner[index];
          return ClipRRect(
            /// 圆角
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
              children: <Widget>[
                ImageLoadView(curBanner.picurl, height: height),
                Opacity(
                  opacity: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                        BorderRadius.all(Radius.circular(radius))),
                  ),
                ),
//                Padding(
//                  padding: const EdgeInsets.all(10.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    crossAxisAlignment: CrossAxisAlignment.end,
//                    children: <Widget>[
//                      Text(
//                        "title",
//                        style: TextStyle(color: Colors.white, fontSize: 20.0),
//                      ),
//                      Text(
//                        "title1",
//                        maxLines: 2,
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ],
//                  ),
//                ),
              ],
            ),
          );
        },
        itemCount: widget.banner.length,
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
        onTap: (index) {
          pushNewPage(
            context,
            WebViewPage(
              url: widget.banner[index].clickrpturl,
              title:"广告详情",
            ),
          );
        },
      ),
    );
  }
}
