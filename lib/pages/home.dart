import 'package:flutter/material.dart';
import 'package:flutter_mmnes/delegate/sliver_appbar_delegate.dart';
import 'package:flutter_mmnes/pages/bottom_gridview.dart';
import 'package:flutter_mmnes/pages/home_page.dart';
import 'package:flutter_mmnes/ui/custom_icon.dart';
import 'package:flutter_mmnes/ui/image_load_view.dart';
import 'package:flutter_mmnes/utils/utils.dart';

class XianyuHomePage extends StatefulWidget {
  XianyuHomePage({Key key}) : super(key: key);

  @override
  createState() => _XianyuHomePageState();
}

class _XianyuHomePageState extends State<XianyuHomePage>
    with TickerProviderStateMixin {
  var backgroundImage = 'http://pic1.16pic.com/00/31/72/16pic_3172062_b.jpg';
  List<String> titleTabs = [
    '软件',
    "游戏",
  ];

  List<Tab> tabs = [];
  TabController controller;
  int currentIndex = 1;

  ScrollController scrollController = ScrollController();

  /// 透明度 取值范围[0,1]
  double navAlpha = 0;
  double headerHeight;

  GlobalKey<NesHomePageState> bottomKey = GlobalKey<NesHomePageState>();

  @override
  void initState() {
    super.initState();

    /// 当tab滑动到标题栏下时切换appBar为渐变的，此处的高度应根据实际项目中tab上面的控件总高度，应根据实际项目中tab上面的控件动态计算高度（即此处的400）
    headerHeight = 400 + Utils.navigationBarHeight - Utils.topSafeHeight;

    scrollController.addListener(() {
      var offset = scrollController.offset;
      if (offset < 0) {
        if (navAlpha != 0) {
          setState(() {
            navAlpha = 0;
          });
        }
      } else if (offset < headerHeight) {
        setState(() {
          navAlpha = 1 - (headerHeight - offset) / headerHeight;
        });
      } else if (navAlpha != 1) {
        setState(() {
          navAlpha = 1;
        });
      }
    });

    tabs = titleTabs.map((title) {
      return Tab(text: "$title");
    }).toList();

    controller = TabController(
        length: titleTabs.length, vsync: this, initialIndex: currentIndex)
      ..addListener(() {
        // 监听滑动/点选位置
        if (controller.index.toDouble() == controller.animation.value) {
          setState(() => currentIndex = controller.index);
          bottomKey.currentState.getHomeData(titleTabs[currentIndex]);
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          /// 搜索框
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          centerTitle: true,
          title: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(children: <Widget>[
                Icon(Icons.search, color: Colors.grey[300]),
                Text('搜索关键字',
                    style: TextStyle(fontSize: 14, color: Colors.grey[300]))
              ]),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(
                          255,
                          (255 - 255 * navAlpha).toInt(),
                          (255 - 255 * navAlpha).toInt(),
                          (255 - 255 * navAlpha).toInt())),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
          automaticallyImplyLeading: false,
          leading: Container(
              child:
              IconButton(
                  icon: Icon(Icons.list, color: Colors.white), onPressed: () {}),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20)),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search, color: Colors.white), onPressed: () {})
          ]),
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        /// TabBar部分
        CustomScrollView(controller: scrollController, slivers: <Widget>[
          SliverPersistentHeader(
              delegate: SliverAppBarDelegate(TabBar(
                  tabs: tabs,
                  indicatorWeight: 1.0,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  controller: controller,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 18.0),
                  indicatorSize: TabBarIndicatorSize.label)),
              // 悬停到顶部
              pinned: true),

          /// 瀑布流部分
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              child: NesHomePage(key: bottomKey, title: titleTabs[currentIndex]),
              height: 1600,
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _bildTopView() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      floating: false,
      pinned: true,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
            child: ImageLoadView(backgroundImage,
                fit: BoxFit.cover, height: 200, width: Utils.width)),
      ),
    );
  }
}
