import 'package:flutter_mmnes/log/log.dart';

class AppDetailData {
  String appName;
  String iconUrl;
  int grade;
  var origPrice;
  var price;
  String promotion;
  String category;
  String slogan;
  String editorialReviews;
  var updateTime;
  String appUid;
  String version;
  String versionName;
  int appSize;
  bool isTry;
  String provider;
  String providerId;
  String description;
  List<String> thumbnails;
  List<String> previews;
  int pricetype;
  String orderUrl;
  String contentId;

  /**
   * 感兴趣数量
   */
  String interested;

  /**
   * 方
   */
  bool official;

  /**
   * 类型关联的URL地址，比如游戏分类的具体页面 不传该字段，则不加链接
   */
  String categoryurl;

  /**
   * 预览图中第三方视频信息
   */
  List<VideoLink> videolinks;

  /**
   * 外链地址(h5预览)
   */
  List<ExternalLinks> externalLinks;

  /**
   * 顶部背景图，运营可配。如果不配则客户端取icon模糊化处理
   */
  String bgurl;

  /**
   * 评分（原来是整形，现在换为浮点）
   */
  var score;

  /**
   * 详情页营销卡片
   */
  MarketingEntry marketingActivity;

  /**
   * 所有礼包地址
   */
//    String giftUrl;
  /**
   * 详情页软件福利卡片
   */
  ActivityEntry activityEntry;

  /**
   * 媒体化文章，没有数据则不显示
   */
  RelatedItem mediaBusiness;

  /**
   * 商品id
   */
  String goodsid;

  AppDetailData.fromJSON(Map<String, dynamic> data) {
    var log = LogHelper();
    this.appName = data['appName'];
    this.iconUrl = data['iconUrl'];
    this.grade = data['grade'];
    this.origPrice = data['origPrice'];
    this.price = data['price'];
    this.promotion = data['promotion'];
    this.category = data['category'];
    this.slogan = data['slogan'];
    this.editorialReviews = data['editorialReviews'];
    this.updateTime = data['updateTime'];
    this.appUid = data['appUid'];
    this.version = data['version'];
    this.versionName = data['versionName'];
    this.appSize = data['appSize'];
    this.isTry = data['isTry'];
    this.provider = data['provider'];
    this.providerId = data['providerId'];
    this.description = data['description'];

    List<dynamic> pics = data['thumbnails'] == null ? [] : data['thumbnails'];
    this.thumbnails = List();
    this.thumbnails.addAll(pics.map((o) => o.toString()));


    List<dynamic> prews = data['previews'] == null ? [] : data['previews'];
    this.previews = List();
    this.previews.addAll(prews.map((o) => o.toString()));

    this.pricetype = data['pricetype'];
    this.orderUrl = data['orderUrl'];
    this.contentId = data['contentId'];
    this.interested = data['interested'];
    this.official = data['official'];
    this.categoryurl = data['categoryurl'];

    if (data['videolinks'] != null) {
      List<VideoLink> videolinks = [];
      (data['videolinks'] as List).forEach((item) {
        VideoLink videoLink = VideoLink.fromJSON(item);
        videolinks.add(videoLink);
      });
      this.videolinks = videolinks;
    } else {
      this.videolinks = null;
    }
    if (data['externalLinks'] != null) {
      List<ExternalLinks> externalLinks = [];
      (data['externalLinks'] as List).forEach((item) {
        ExternalLinks externalLink = ExternalLinks.fromJSON(item);
        externalLinks.add(externalLink);
      });
      this.externalLinks = externalLinks;
    } else {
      this.externalLinks = null;
    }
    this.bgurl = data['bgurl'];
    this.score = data['score'];

    if (data['marketingActivity'] != null) {
      this.marketingActivity =
          MarketingEntry.fromJSON(data['marketingActivity']);
    }
    if (data['activityEntry'] != null) {
      this.activityEntry = ActivityEntry.fromJSON(data['activityEntry']);
    }
    if (data['mediaBusiness'] != null) {
      this.mediaBusiness = RelatedItem.fromJSON(data['mediaBusiness']);
    }
    this.goodsid = data['goodsid'];
  }
}

class VideoLink {
  /**
   * 图片对应URL
   */
  String picurl;

  /**
   * 类型
   */
  String videotype;

  /**
   * 视频对应URL
   */
  String videourl;

  VideoLink.fromJSON(Map<String, dynamic> json) {
    this.videotype = json['videotype'];
    this.videourl = json['videourl'];
    this.picurl = json['picurl'];
  }
}

class ExternalLinks {
  /**
   * String	Must	图片名称
   */
  String picurl;

  /**
   * String	Must	跳转URL
   */
  String jumpurl;

  ExternalLinks.fromJSON(Map<String, dynamic> json) {
    this.picurl = json['picurl'];
    this.jumpurl = json['jumpurl'];
  }
}

class MarketingEntry {
  String picurl;
  String url;
  String title;

  MarketingEntry.fromJSON(Map<String, dynamic> json) {
    this.title = json['title'];
    this.url = json['url'];
    this.picurl = json['picurl'];
  }
}

class ActivityEntry {
  /**
   * 角标文字，没有该字段时，不展示角标
   */
  String markText;

  /**
   * 活动标题
   */
  String title;

  /**
   * 详情页地址
   */
  String url;

  /**
   * 广告图片地址
   */
  String picurl;

  ActivityEntry.fromJSON(Map<String, dynamic> json) {
    this.markText = json['markText'];
    this.title = json['title'];
    this.url = json['url'];
    this.picurl = json['picurl'];
  }
}

class RelatedItem {
  /**
   * 唯一id
   */
  String id;

  /**
   * 评测标题
   */
  String title;

  /**
   * 时间
   */
  String time;

  /**
   * 相关链接
   */
  String url;

  /**
   * 相关图片链接
   */
  String picurl;

  RelatedItem.fromJSON(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.time = json['time'];
    this.url = json['url'];
    this.picurl = json['picurl'];
  }
}
