import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmnes/api/api_service.dart';
import 'package:flutter_mmnes/custom_widgets/bottom_drag_widget.dart';
import 'package:flutter_mmnes/log/log.dart';
import 'package:flutter_mmnes/models/app_detail_bean.dart';
import 'package:flutter_mmnes/models/detail_recommend_bean.dart';
import 'package:flutter_mmnes/models/hotapp_bean.dart';
import 'package:flutter_mmnes/ui/app_detail_header.dart';
import 'package:flutter_mmnes/ui/expandable_text.dart';
import 'package:flutter_mmnes/ui/home_section_view.dart';
import 'package:flutter_mmnes/ui/image_load_view.dart';
import 'package:flutter_mmnes/ui/item_list.dart';
import 'package:flutter_mmnes/utils/download_utils.dart';
import 'package:flutter_mmnes/utils/loading_util.dart';
import 'package:flutter_mmnes/utils/route_util.dart';
import 'package:flutter_mmnes/utils/toast.dart';
import 'package:flutter_mmnes/utils/utils.dart';
import 'package:flutter_mmnes/widget/download_progress_dialog.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

class AppDetail extends StatefulWidget {
  final String id;

  AppDetail(this.id, {Key key}) : super(key: key);

  @override
  AppDetailState createState() => AppDetailState();
}

class AppDetailState extends State<AppDetail> {
  var log = LogHelper();
  AppDetailData detailData;
  DetailRecommendData recommendData;
  List<SearchItem> recommendItems;
  bool loadError = false;
  bool isSummaryUnfold = false;

  double width = (Utils.width - 10 * 3) / 3;
  double height;
  DownloadProgressDialog mProgressDialog;

  @override
  void initState() {
    super.initState();
    height = width * 405 / 720 + 10;
    mProgressDialog = new DownloadProgressDialog(context, ProgressDialogType.Download);
    getMovieDetail(widget.id);
  }

  ///加载数据
  void getMovieDetail(String id) async {
    detailData = await ApiService.getAppDetailData(id);
    recommendData = await ApiService.getDetailRecommendData(
        id, detailData.appName, detailData.appUid);
    recommendItems = new List<SearchItem>();
    if (recommendData != null) {
      for (int i = 0; i < recommendData.items.length && i < 3; i++) {
        recommendItems.add(recommendData.items[i]);
      }
    }
    loadError = detailData == null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (detailData == null) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.blueGrey),
          body: Center(
            child: Stack(children: <Widget>[
              Offstage(
                  offstage: !loadError,
                  child: RaisedButton(
                      onPressed: () => getMovieDetail(widget.id),
                      child: Text("加载失败，重新加载"))),
              Offstage(offstage: loadError, child: getLoadingWidget())
            ]),
          ));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: BottomDragWidget(
            body: CustomScrollView(slivers: <Widget>[
              AppDetailHeader(detailData, pageColor: Colors.blueGrey),
              buildThumbnail(),
              buildContent(),
            ]),
            dragContainer: DragContainer(
                drawer: Container(
                    child: OverscrollNotificationWidget(
                      child: SizedBox(height: 1),
                    ),
                    //BottomDragView()
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 243, 244, 248),
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0)))),
                defaultShowHeight: Utils.height * 0.1,
                height: Utils.height * 0.6)));
  }

  ///构建广告和推荐应用
  Widget buildContent() {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        HomeSectionView("简介",
            hiddenMore: true,
            backgroundColor: Colors.white,
            textColor: Colors.black87),
        Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
            child: ExpandableText(detailData.description,
                textColor: Colors.black87,
                iconColor: Colors.black87,
                iconTextColor: Colors.black87,
                alignment: MainAxisAlignment.center,
                fontSize: 12.0,
                isShow: isSummaryUnfold,
                onPressed: () => changeSummaryMaxLines())),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "版本: " + detailData.versionName,
                style: TextStyle(color: Colors.black87, fontSize: 13.0),
              ),
              Text(
                "更新时间: " + getUpdateTime(),
                style: TextStyle(color: Colors.black87, fontSize: 13.0),
              ),
              Text(
                "提供者: " + detailData.provider,
                style: TextStyle(color: Colors.black87, fontSize: 13.0),
              ),
            ],
          ),
        ),
        detailData.marketingActivity != null
            ? Column(children: <Widget>[
                HomeSectionView("详情页广告",
                    hiddenMore: true,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87),
                ImageLoadView(
                  detailData.marketingActivity.picurl,
                  fit: BoxFit.cover,
                  height: width * 1.8,
                  width: width,
                  borderRadius: BorderRadius.circular(6.0),
                  placeholder: kTransparentImage,
                ),
              ])
            : SizedBox(height: 1),
        HomeSectionView("安装" + detailData.appName + "的人还下载了",
            hiddenMore: true,
            backgroundColor: Colors.white,
            textColor: Colors.black87),
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
            children: recommendItems.map((item) {
              return ItemList(
                searchItem: item,
                onTap: () => pushNewPage(context, AppDetail(item.contentId)),
              );
            }).toList(),
          ),
        ),
        const Padding(padding: EdgeInsets.all(12.0)),
        Container(
            child: CupertinoButton(
                child: mProgressDialog.getDialog(),
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 72.0),
                onPressed: () => downloadAction()),
        ),
        const Padding(padding: EdgeInsets.all(18.0)),
      ]),
    );
  }

  ///时间戳
  String getUpdateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatStr = formatter.format(now);
    return formatStr;
  }

  /// 展开 or 收起
  changeSummaryMaxLines() => setState(() => isSummaryUnfold = !isSummaryUnfold);

  ///缩略图
  Widget buildThumbnail() {
    return SliverToBoxAdapter(
      child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
            Offstage(
                offstage: detailData.thumbnails.isEmpty,
                child: Column(children: <Widget>[
                  HomeSectionView(
                    "缩略图",
                    hiddenMore: detailData.thumbnails.length < 10,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                  ),
                  SizedBox.fromSize(
                    size: Size.fromHeight(width * 1.8),
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: detailData.previews.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Hero(
                              tag: detailData.previews[index],
                              child: ImageLoadView(
                                detailData.previews[index],
                                fit: BoxFit.cover,
                                height: width * 1.8,
                                width: width,
                                borderRadius: BorderRadius.circular(6.0),
                                placeholder: kTransparentImage,
                              ),
                            ),
                          );
                        }),
                  )
                ])),
          ])),
    );
  }

  downloadAction() async{
    ///测试数据,部分下载链接不可用
    detailData.orderUrl = "http://apk.fr18.mmarket.com/cdn/rs/publish10/prepublish2/21/2019/08/26/a851/460/52460851/huoshanliteban_beijingyiying.apk?cid=300011883090&gid=000x11980390106100011560534300011883090&MD5=ae6039baf6c6e179f2723bc056964f70&ts=201908311836&tk=16B1&v=1";
    debugPrint("downloadAction detailData.orderUrl:"  + detailData.orderUrl);
//    String realUrl = await ApiService.getRealDownloadUrl(detailData.orderUrl);
    doDownloadOperation(context, detailData.orderUrl, mProgressDialog);
  }
}
