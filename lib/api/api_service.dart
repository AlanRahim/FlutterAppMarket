import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mmnes/api/api_url.dart';
import 'package:flutter_mmnes/models/app_detail_bean.dart';
import 'package:flutter_mmnes/models/detail_recommend_bean.dart';
import 'package:flutter_mmnes/models/hotapp_bean.dart';

import 'dart:convert';
import 'package:flutter_mmnes/log/log.dart';
import 'package:flutter_mmnes/models/cardlist.dart';

class ApiService {
  static Future<CardListData> getCardList() async {
    var client = HttpClient();
    var request = await client.getUrl(Uri.parse(
        'http://odp.mmarket.com/t.do?requestid=terminal_TMMHelper_index&type=1&pageSize=10'));
    //添加请求头部
    request.headers.add("appname", "TMMHelper1.6.0.001.01_Android");
    request.headers.add("channel-id", "5410231609");
    request.headers.add("mi", "63835ec5-1cd2-4b0d-8a19-3eade1d3e405");
    request.headers.add("ua", "android-19-1080x1920-SM-G9008V");
    request.headers.add("X-Up-Bearer-Type", "WLAN");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    debugPrint("getCardList:" + responseBody);
    Map data = json.decode(responseBody);
    return CardListData.fromJSON(data);
  }

  static Future<CardListData> getGameList() async {
    var client = HttpClient();
    var request = await client.getUrl(Uri.parse(
        'http://odp.mmarket.com/t.do?requestid=terminal_TMMHelper_index&type=2&pageSize=10'));
    //添加请求头部
    request.headers.add("appname", "TMMHelper1.6.0.001.01_Android");
    request.headers.add("channel-id", "5410231609");
    request.headers.add("mi", "63835ec5-1cd2-4b0d-8a19-3eade1d3e405");
    request.headers.add("ua", "android-19-1080x1920-SM-G9008V");
    request.headers.add("X-Up-Bearer-Type", "WLAN");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    debugPrint("getGameList:" + responseBody);
    Map data = json.decode(responseBody);
    return CardListData.fromJSON(data);
  }

  static Future<HotResultBean> getHotAppList(String url) async {
    var client = HttpClient();
    var request = await client.getUrl(Uri.parse(url));
    //添加请求头部
    request.headers.add("appname", "TMMHelper1.6.0.001.01_Android");
    request.headers.add("channel-id", "5410231609");
    request.headers.add("mi", "63835ec5-1cd2-4b0d-8a19-3eade1d3e405");
    request.headers.add("ua", "android-19-1080x1920-SM-G9008V");
    request.headers.add("X-Up-Bearer-Type", "WLAN");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    debugPrint("getHotAppList:" + responseBody);
    Map data = json.decode(responseBody);
    return HotResultBean.fromJSON(data);
  }

  static Future<AppDetailData> getAppDetailData(String contentId) async {
    var client = HttpClient();
    String url = ApiUrl.MMNES_BASE_URL +
        "?requestid=app_info_forward&contentid=" +
        contentId;
    var request = await client.getUrl(Uri.parse(url));
    //添加请求头部
    request.headers.add("appname", "TMMHelper1.6.0.001.01_Android");
    request.headers.add("channel-id", "5410231609");
    request.headers.add("mi", "63835ec5-1cd2-4b0d-8a19-3eade1d3e405");
    request.headers.add("ua", "android-19-1080x1920-SM-G9008V");
    request.headers.add("X-Up-Bearer-Type", "WLAN");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    debugPrint("getAppDetailData:" + responseBody);
    Map data = json.decode(responseBody);
    return AppDetailData.fromJSON(data);
  }

  static Future<DetailRecommendData> getDetailRecommendData(String contentId,
      String name, String appUid) async {
    var client = HttpClient();
    String url = ApiUrl.MMNES_BASE_URL +
        "?requestid=appinfo_recommend_mm3.6&contentid=" +
        contentId +"&appname=" + name + "&appuid=" + appUid;
    var request = await client.getUrl(Uri.parse(url));
    //添加请求头部
    request.headers.add("appname", "TMMHelper1.6.0.001.01_Android");
    request.headers.add("channel-id", "5410231609");
    request.headers.add("mi", "63835ec5-1cd2-4b0d-8a19-3eade1d3e405");
    request.headers.add("ua", "android-19-1080x1920-SM-G9008V");
    request.headers.add("X-Up-Bearer-Type", "WLAN");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    debugPrint("getDetailRecommendData:" + responseBody);
    Map data = json.decode(responseBody);
    return DetailRecommendData.fromJSON(data);
  }

  static Future<String> getRealDownloadUrl(String orderUrl) async {
    var client = HttpClient();
    String url = orderUrl;
    var request = await client.getUrl(Uri.parse(url));
    //添加请求头部
    request.headers.add("appname", "TMMHelper1.6.0.001.01_Android");
    request.headers.add("channel-id", "5410231609");
    request.headers.add("mi", "63835ec5-1cd2-4b0d-8a19-3eade1d3e405");
    request.headers.add("ua", "android-19-1080x1920-SM-G9008V");
    request.headers.add("X-Up-Bearer-Type", "WLAN");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    debugPrint("getRealDownloadUrl:" + responseBody);
    return orderUrl;
  }
}
