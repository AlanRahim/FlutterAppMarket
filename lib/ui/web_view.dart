import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmnes/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum WebType {
  net,        //网络链接
  local,      //本地html文件
}


class WebViewPage extends StatefulWidget {

  const WebViewPage({
    Key key,
    this.webType = WebType.net,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  final WebType webType;
  final String title;
  final String url;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  String realUrl = "";

  void _initData() async {
    if (widget.webType == WebType.net) {
      //网页链接
      realUrl = widget.url;
    } else {
      //本地网页，
      //（1）加载方式String url = await rootBundle.loadString('assets/test.html');
      //（2）加载类型webType是WebType.local
      realUrl = Uri.dataFromString(widget.url, mimeType: 'text/html', encoding: Encoding.getByName("utf-8")).toString();
    }

//    print("----  初始化_initData 连接是 ${realUrl} ---");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initData();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: _controller.future,
        builder: (context, snapshot) {
          return WillPopScope(
            child: Scaffold(
              appBar: PreferredSize(
                  child: Offstage(
                    offstage: widget.title.isEmpty ? true : false,
                    child: Utils.loadAppBar(widget.title, context),
                  ),
                  preferredSize: Size.fromHeight(48)),
              body: Column(
                children: <Widget>[
                  _WebViewWidget(),
                ],
              ),
            ),
            onWillPop: () async {
              if (snapshot.hasData) {
                bool canGoBack = await snapshot.data.canGoBack;
                if (canGoBack) {
                  // 网页可以返回时，优先返回上一页
                  snapshot.data.goBack();
                  return Future.value(false);
                }
                return Future.value(true);
              }
              return Future.value(true);
            },
          );
        });
  }

  //网页视图
  Widget _WebViewWidget() {
    if (realUrl != null && realUrl.length > 0) {
      return Expanded(
        child: WebView(
          initialUrl: realUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _closeJavascriptChannel(context),
          ].toSet(),
          onPageFinished: (String val) {
            // WebView 页面加载调用
            print("-------WebView 页面加载调用 ${val} ------");
          },
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  /************************** JS监听回调 **************************************/

  //JS调起Flutter的关闭回调
  JavascriptChannel _closeJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: "close",
        onMessageReceived: (JavascriptMessage message) {
          print("----收到回调消息---");
        });
  }
}
