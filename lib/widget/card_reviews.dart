
import 'package:flutter/cupertino.dart';

enum TabContentType {
  reviews,
  comments,
}

class TabSwitchNotification extends Notification {
  final TabContentType tabContentType;

  TabSwitchNotification({this.tabContentType});
}