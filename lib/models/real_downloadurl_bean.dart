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