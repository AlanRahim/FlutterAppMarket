import 'package:flutter/material.dart';
import 'package:auto_size/auto_size.dart';
import 'package:flutter_mmnes/pages/main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluintl/src/custom_localizations.dart';
import 'package:flutter_mmnes/res/colors.dart';
import 'package:flutter_mmnes/res/strings.dart';
import 'package:flutter_mmnes/utils/sp_util.dart';
import 'blocs/application_bloc.dart';
import 'blocs/bloc_provider.dart';
import 'blocs/main_bloc.dart';
import 'common/common.dart';
import 'common/sp_helper.dart';
import 'models/language_model.dart';

void main() => runAutoSizeApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(child: MyApp(), bloc: MainBloc()),
    ));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp> {
  Locale _locale;
  Color _themeColor = Color(0xFF666666);
  @override
  void initState() {
    super.initState();
    setLocalizedValues(localizedValues);
    _initAsync();
    _initListener();
  }

  void _initAsync() async {
    await SpUtil.getInstance();
    if (!mounted) return;
//    _init();
    _loadLocale();
  }

  void _initListener() {
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    bloc.appEventStream.listen((value) {
      _loadLocale();
    });
  }

  void _loadLocale() {
    setState(() {
      LanguageModel model =
      SpHelper.getObject<LanguageModel>(Constant.keyLanguage);
      if (model != null) {
        _locale = new Locale(model.languageCode, model.countryCode);
      } else {
        _locale = null;
      }

      String _colorKey = SpHelper.getThemeColor();
      if (themeColorMap[_colorKey] != null)
        _themeColor = themeColorMap[_colorKey];
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// 任务管理器显示的标题
      title: "Flutter Demo",

      /// 右上角显示一个debug的图标
      debugShowCheckedModeBanner: false,

      /// 主页
      home: MainPage(),//MarketHomePage()
      theme: ThemeData.light().copyWith(
        primaryColor: _themeColor,
        accentColor: _themeColor,
        indicatorColor: Colors.white,
      ),
      locale: _locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocalizations.delegate
      ],
      supportedLocales: CustomLocalizations.supportedLocales,
    );
  }
}