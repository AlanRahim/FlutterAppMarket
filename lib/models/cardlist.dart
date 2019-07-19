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

class Item {
  String versionName;
  String version;

  ///包名
  String appUid;
  String category;
  String contentId;
  String iconUrl;
  String name;
  String description;

  ///下载地址
  String orderUrl;
  String interested;
  int appSize;

  ///星级
  String grade;

  ///详情页地址
  String detailUrl;

  ///是否已经安装
  bool isInstall;

  ///装机必备排序用
  int sort;

  ///DeepLink页面推送
  String uri;

  ///本地图片地址，自定义，用于首页的第一个位置和最后两个位置的图标
  int localIconUrl;

  ///角标文字
  String yourwords;

  ///文字颜色
  String yourtextcolor;

  ///背景颜色
  String yourbackgroundcolor;

  ///是否曝
  bool isExposure;

  ///曝光url
  String advpositionreporturl;

  Item.fromJSON(Map<String, dynamic> json) {
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
    this.isInstall = json['isInstall'];
    this.sort = json['sort'];
    this.uri = json['uri'];
    this.localIconUrl = json['localIconUrl'];
    this.yourwords = json['yourwords'];
    this.yourtextcolor = json['yourtextcolor'];
    this.yourbackgroundcolor = json['yourbackgroundcolor'];
    this.isExposure = json['isExposure'];
    this.advpositionreporturl = json['advpositionreporturl'];
  }
}

class CardProperty {
  CardProperty(String title, String more) {
    this.title = title;
    this.more = more;
  }

  ///卡片标题
  String title;

  ///卡片更多的跳转地址
  String more;

  ///卡片的背景图地址
  String bgpic;

  ///卡片的背景图颜色，可以它可以被bgpic叠加
  String maskcolor;

  ///卡片标题标语
  String slogan;

  ///标签文字
  String marktext;

  CardProperty.fromJSON(Map json) {
    this.title = json['title'];
    this.more = json['more'];
    this.bgpic = json['bgpic'];
    this.maskcolor = json['maskcolor'];
    this.slogan = json['slogan'];
    this.marktext = json['marktext'];
  }
}

class AdvData {
  String exposureurl;

  String clickrpturl;

  String picurl;

  String url;

  String advurl;
  String logourl;
  String title;

  String slogan;

  int type;

  String contentId;

  String slogan2;

  String buttontext;

  var playbegintime;

  var playendtime;

  String marktext;

  Item recommend;

  int opentype = 0;

  String pname;

  AdvData.fromJSON(Map<String, dynamic> json) {
    this.exposureurl = json['exposureurl'];
    this.clickrpturl = json['clickrpturl'];
    this.picurl = json['picurl'];
    this.url = json['url'];
    this.advurl = json['advurl'];
    this.logourl = json['logourl'];
    this.title = json['title'];
    this.slogan = json['slogan'];
    this.type = json['type'];
    this.contentId = json['contentId'];
    this.slogan2 = json['slogan2'];
    this.buttontext = json['buttontext'];
    this.playbegintime = json['playbegintime'];
    this.playendtime = json['playendtime'];
    this.marktext = json['marktext'];
    this.recommend = json['recommend'];
    this.opentype = json['opentype'];
    this.pname = json['pname'];
  }
}

class CardUnit {
  ///Must 卡片类型
  int type;

  ///卡片单元属性
  CardProperty prop;

  ///Option 广告数组
  List<AdvData> advs;

  ///Option 内容分组数  对于items数组需要分组的情况，该字段表示每组商品数量
  int numpergroup;

  ///item之间是否需要分割线;true: 需要\ false: 不需要 自定义的属性
  bool needline = true;

  ///单行右滑卡片
  ///卡片标题
  String title;

  ///卡片更多的跳转地址
  String more;

  ///卡片的背景图地址
  String bgpic;

  ///1：去重；0不去重
  int DuplicateRemova;

  List<Item> items;

  CardUnit.fromJSON(Map data) {
    this.type = data['type'];
    var log = LogHelper();
    if (data['prop'] != null) {
      this.prop = CardProperty.fromJSON(data['prop']);
    }
    this.numpergroup = data['numpergroup'];
    this.needline = data['needline'];
    this.title = data['title'];
    this.more = data['more'];
    this.bgpic = data['bgpic'];
    this.DuplicateRemova = data['DuplicateRemova'];

    if (data['advs'] != null) {
      List<AdvData> advdatas = [];
      (data['advs'] as List).forEach((item) {
        AdvData advData = AdvData.fromJSON(item);
        advdatas.add(advData);
      });
      this.advs = advdatas;
    } else {
      this.advs = null;
    }
    if (data['items'] != null) {
      List<Item> items = [];
      (data['items'] as List).forEach((item) {
        Item itemData = Item.fromJSON(item);
        items.add(itemData);
      });
      this.items = items;
    }
  }
}

class CardNes {
  ///Must 卡片单元数组
  List<CardUnit> blocks;

  ///卡片之间是否需要分割线;true: 不需要 false: 需要
  bool noblockline;

  CardNes.fromJSON(Map data) {
    this.noblockline = data['noblockline'];
    List<CardUnit> blocks = [];
    if (data['blocks'] != null) {
      (data['blocks'] as List).forEach((item) {
        CardUnit cardUnit = CardUnit.fromJSON(item);
        blocks.add(cardUnit);
      });
    }
    this.blocks = blocks;
  }
}

class CardListData {
  ///首页轮播图广告
  static const TYPE_SLIDE_ADV = 24;

  ///首页热门游戏
  static const TYPE_HOT_GAME = 25;

  ///列表应用卡片
  static const TYPE_APP_LIST = 19;

  ///分割线
  static const TYPE_CARD_LINE = 99;

  ///PageInfo	Must	标记当前页信息
  PageInfo pageInfo;

  ///Option 卡片组数组
  List<CardNes> cards;

  ///Option 列表数组
  List<Item> list;

  CardListData.fromJSON(Map data) {
    var log = LogHelper();
    this.pageInfo = PageInfo.fromJSON(data['pageInfo']);
    List<CardNes> cards = [];
    if (data['cards'] != null) {
      (data['cards'] as List).forEach((item) {
        CardNes card = CardNes.fromJSON(item);
        cards.add(card);
      });
    }
    this.cards = cards;
    List<Item> items = [];
    if (data['items'] != null) {
      (data['items'] as List).forEach((item) {
        Item itemData = Item.fromJSON(item);
        items.add(itemData);
      });
    }
    this.list = items;
  }
}
