import 'package:flutter_mmnes/api/api_service.dart';
import 'package:flutter_mmnes/models/cardlist.dart';
import 'package:flutter_mmnes/utils/log_util.dart';
import 'package:flutter_mmnes/utils/object_util.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class MainBloc implements BlocBase {
  ///首页--软件
  BehaviorSubject<CardListData> _cardListData = BehaviorSubject<CardListData>();

  Sink<CardListData> get _cardListDataSink => _cardListData.sink;

  Stream<CardListData> get cardListDataStream =>
      _cardListData.stream.asBroadcastStream();

  CardListData _cardLisModel;

  ///首页--游戏
  BehaviorSubject<CardListData> _gameListData = BehaviorSubject<CardListData>();

  Sink<CardListData> get _gameListDataSink => _gameListData.sink;

  Stream<CardListData> get gameListDataStream =>
      _gameListData.stream.asBroadcastStream();

  CardListData _gameLisModel;

  MainBloc() {
    LogUtil.e("MainBloc......");
  }

  @override
  Future getData({String labelId, int page}) {}

  @override
  Future onLoadMore({String labelId}) {}

  @override
  Future onRefresh({String labelId, bool isReload}) {}

  ///获取软件数据
  Future getCardList() async {
    return ApiService.getCardList().then((model) {
      _cardLisModel = model;
      _cardListDataSink.add(_cardLisModel);
    }).catchError((_) {
      if (ObjectUtil.isEmpty(_cardLisModel)) {
        _cardListData.sink.addError("error");
      }
    });
  }

  ///获取游戏数据
  Future getGameList() async {
    return ApiService.getGameList().then((model) {
      _gameLisModel = model;
      _gameListDataSink.add(_gameLisModel);
    }).catchError((_) {
      if (ObjectUtil.isEmpty(_gameLisModel)) {
        _gameListData.sink.addError("error");
      }
    });
  }

  @override
  void dispose() {
    _cardListData.close();
    _gameListData.close();
  }
}
