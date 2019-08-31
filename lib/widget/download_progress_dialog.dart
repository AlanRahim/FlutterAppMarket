import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:install_apk_plugin/install_apk_plugin.dart';

String _taskId;
String _dialogMessage = "下载";
enum ProgressDialogType { Normal, Download }

ProgressDialogType progressDialogType = ProgressDialogType.Normal;
double _progress = 0.0;
bool isShow = false;
String _localPath;
String _downloadUrl;
enum DownloadStatus { DOWNLOADING, FAIL, COMPLETE }

class DownloadProgressDialog {
  MyDialog _dialog;

  BuildContext _context;
  DownloadStatus downloadStatus;

  DownloadProgressDialog(
      BuildContext buildContext, ProgressDialogType progressDialogtype) {
    progressDialogType = progressDialogtype;
    _progress = 0.0;
    _dialog = new MyDialog();
  }

  void setMessage(String mess) {
    _dialogMessage = mess;
    debugPrint("ProgressDialog message changed: $mess");
  }

  ///更新进度
  void update(
      {String taskId,
      double progress,
      String message,
      String path,
      String url}) {
    debugPrint("ProgressDialog message changed: ");
    if (progressDialogType == ProgressDialogType.Download) {
      debugPrint("Old Progress: $progress, New Progress: $progress");
      _progress = progress;
    }
    if (progress == 100.0) {
      debugPrint("download complete");
      downloadStatus = DownloadStatus.COMPLETE;
    } else if (progress == -1.0) {
      downloadStatus = DownloadStatus.FAIL;
    } else {
      downloadStatus = DownloadStatus.DOWNLOADING;
    }
    debugPrint("Old message: $_dialogMessage, New Message: $message");
    _dialogMessage = message;
    _taskId = taskId;
    _localPath = path;
    _downloadUrl = url;
    _dialog.update(downloadStatus);
  }

  bool isShowing() {
    return isShow;
  }

  void hide() {
    if (isShow) {
      isShow = false;
      Navigator.of(_context).pop();
      debugPrint('ProgressDialog dismissed');
    }
  }

  MyDialog getDialog() {
    return _dialog;
  }

  double getProgress() {
    return _progress;
  }
}

// ignore: must_be_immutable
class MyDialog extends StatefulWidget {
  var _dialog = new MyDialogState(_downloadStatus);
  static DownloadStatus _downloadStatus;

  update(DownloadStatus downloadStatus) {
    _downloadStatus = downloadStatus;
    _dialog.changeState();
  }

  @override
  // ignore: must_be_immutable
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class MyDialogState extends State<MyDialog> {
  DownloadStatus _downloadStatus;

  MyDialogState(this._downloadStatus);

  changeState() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    isShow = false;
    debugPrint('ProgressDialog dismissed by back button');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SizedBox(
        //限制进度条的高度
        height: 45.0,
        //限制进度条的宽度
        width: 250.0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          child: new LinearProgressIndicator(
              //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
              value: _progress / 100,
              //背景颜色
              backgroundColor: Colors.lightBlueAccent[100],
              //进度颜色
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
        ),
      ),
      Container(
        height: 45.0,
        width: 250.0,
        alignment: Alignment.center,
        child: Text(
          _dialogMessage,
          style: new TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w100,
            // 字体粗细程度
            fontStyle: FontStyle.normal,
            color: Color(0xFFffffff),
          ),
        ),
      ),
    ]);
  }

  double getDialogHeightByDesc(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.2;
  }
}

openDownloadFile(BuildContext context) {
  // 打开文件:android手机调用原生方法安装apk，其他平台直接调用openFile
  if (_downloadUrl.contains(".apk")) {
    installApk(_taskId);
  } else {
    _openDownloadedFile(_taskId).then((success) {
      if (!success) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Cannot open this file')));
      }
    });
  }
}

void installApk(String taskId) {
  //根据localpath和url构造出下载文件路径
  int index = _downloadUrl.lastIndexOf("/");
  String apkName = _downloadUrl.substring(index + 1);
  String filePath = _localPath + "/" + apkName;
  print("installApk apkName:" + apkName + "--filePath:" + filePath);
  InstallApkPlugin.installApk(filePath);
}

// 根据taskId打开下载文件
Future<bool> _openDownloadedFile(taskId) {
  return FlutterDownloader.open(taskId: taskId);
}
