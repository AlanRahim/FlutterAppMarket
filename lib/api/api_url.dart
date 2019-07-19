class ApiUrl {
  static const String MMNES_BASE_URL = "http://odp.mmarket.com/t.do";
  static const String REQUEST_ID = "requestid=";
  static const String REQUESTID_GET_CARD_LIST = "terminal_TMMHelper_index";

  static String getCardListUrl(int type, int pagesize) {
    return MMNES_BASE_URL +
        REQUEST_ID +
        REQUESTID_GET_CARD_LIST +
        "&type=" +
        type.toString() +
        "&pageSize=" +
        pagesize.toString();
  }

}
