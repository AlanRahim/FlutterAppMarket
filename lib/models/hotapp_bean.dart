import 'package:flutter_mmnes/log/log.dart';

class PageInfo {
  ///Must 当前页码，从1开始
  int curPage;

  ///Option 总页数，从第二页开始可不传该变量
  int totalPage;

  ///Option 总页数，从第二页开始可不传该变量
  int totalRows;

  PageInfo({this.curPage, this.totalPage, this.totalRows});

  PageInfo.fromJSON(Map json) {
    this.curPage = json['curPage'];
    this.totalPage = json['totalPage'];
    this.totalRows = json['totalRows'];
  }
}

class SearchItem {
  String versionName;

  /**
   * 包名
   */
  String appUid;
  String category;
  String contentId;
  String iconUrl;
  String name;
  String description;

  /**
   * 下载地址
   */
  String orderUrl;

  /**
   * 详情页地址
   */
  String detailUrl;
  int appSize;

  /**
   * 星级
   */
  int grade;
  String slogan;

  /**
   * 搜索结果后台木有返回interested字段
   */
  String interested;
  String version;

  /**
   * 内容卡片小图标
   */
  String icon2Url;

  /**
   * 内容外显文字链接内容页面
   */
  String contentUrl;
  String contentColor;

  /**
   * 自定义类型
   */
  int itemType = 0;

  /**
   * 搜索结果数量
   */
  int totalCount;

  /**
   * 角标文字
   */
  String yourwords;

  /**
   * 文字颜色
   */
  String yourtextcolor;

  /**
   * 背景颜色
   */
  String yourbackgroundcolor;

  SearchItem.fromJSON(Map<String, dynamic> json) {
    this.versionName = json['versionName'];
    this.version = json['version'];
    this.appUid = json['appUid'];
    this.category = json['category'];
    this.contentId = json['contentId'];
    this.iconUrl = json['iconUrl'];
    this.name = json['name'];
    this.description = json['description'];
    this.orderUrl = json['orderUrl'];
    this.interested = json['interested'];
    this.appSize = json['appSize'];
    this.grade = json['grade'];
    this.detailUrl = json['detailUrl'];
    this.yourwords = json['yourwords'];
    this.yourtextcolor = json['yourtextcolor'];
    this.yourbackgroundcolor = json['yourbackgroundcolor'];
  }
}

class HotResultBean {
  ///PageInfo	Must	标记当前页信息
  PageInfo pageInfo;

  ///Option 列表数组
  List<SearchItem> items;

  HotResultBean.fromJSON(Map data) {
    var log = LogHelper();
    this.pageInfo = PageInfo.fromJSON(data['pageInfo']);

    List<SearchItem> items = [];
    if (data['items'] != null) {
      (data['items'] as List).forEach((item) {
        SearchItem itemData = SearchItem.fromJSON(item);
        items.add(itemData);
      });
    }
    this.items = items;
  }
}
