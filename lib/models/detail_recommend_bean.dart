import 'package:flutter_mmnes/models/hotapp_bean.dart';

class DetailRecommendData {
  List<SearchItem> items;

  DetailRecommendData.fromJSON(Map<String, dynamic> data) {
    if (data['items'] != null) {
      List<SearchItem> items = [];
      (data['items'] as List).forEach((item) {
        SearchItem searchItem = SearchItem.fromJSON(item);
        items.add(searchItem);
      });
      this.items = items;
    } else {
      this.items = null;
    }
  }
}
