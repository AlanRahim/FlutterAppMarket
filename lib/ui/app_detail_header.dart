import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mmnes/models/app_detail_bean.dart';
import 'package:flutter_mmnes/ui/image_load_view.dart';
import 'package:transparent_image/transparent_image.dart';

class AppDetailHeader extends StatelessWidget {
  final AppDetailData detailData;
  final Color pageColor;

  AppDetailHeader(this.detailData, {Key key, this.pageColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String defaultImage =
        'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3271389503,231131796&fm=26&gp=0.jpg';

    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      expandedHeight: 160,
      backgroundColor: pageColor,
      actions: <Widget>[IconButton(icon: Icon(Icons.search), onPressed: () {})],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          '${detailData.appName}',
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 11,
              color: Colors.white70),
        ),
        background: Stack(
          children: <Widget>[
            ///背景大图
            ImageLoadView(
                detailData.iconUrl != null ? detailData.iconUrl : defaultImage,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                placeholder: kTransparentImage),

            /// 加上一层毛玻璃效果
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 6.0,
              ),
              child: Opacity(
                opacity: 0.4,
                child: Container(
                  decoration: BoxDecoration(
                    color: pageColor,
                  ),
                ),
              ),
            ),
            ///icon小图
            Center(
                child: ImageLoadView(detailData.iconUrl.toString(),
                    height: 60, width: 60)),
          ],
        ),
      ),
    );
  }
}
