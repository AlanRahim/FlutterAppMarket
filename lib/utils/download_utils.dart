import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_mmnes/widget/download_progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_mmnes/utils/toast.dart';
import 'package:permission_handler/permission_handler.dart';

String mLocalPath;
String mDownloadUrl;
DownloadProgressDialog mProgressDialog;
double mProgress = 0.0;

initDownload(BuildContext context) {
  mProgressDialog.setMessage('下载');
  // 设置下载回调
  FlutterDownloader.registerCallback((id, status, progress) {
    mProgress = progress.toDouble();
    // 打印输出下载信息
    print('Download task ($id) is in status ($status) and process ($progress)');
    if (status == DownloadTaskStatus.running) {
      mProgressDialog.update(
          taskId: id,
          progress: progress.toDouble(),
          message: "下载中",
          path: mLocalPath,
          url: mDownloadUrl);
    }
    if (status == DownloadTaskStatus.failed) {
      Toast.show("下载异常", context);
      mProgressDialog.update(taskId: id, progress: -1.0, message: "下载失败");
    }

    if (status == DownloadTaskStatus.complete) {
      print(mProgressDialog.isShowing());
      mProgressDialog.update(
          taskId: id,
          progress: progress.toDouble(),
          message: "完成",
          path: mLocalPath,
          url: mDownloadUrl);
    }
  });
}

/// 执行下载文件的操作
doDownloadOperation(
    BuildContext context, String downloadUrl, DownloadProgressDialog pr) async {
  /**
   * 下载文件的步骤：
   * 1. 获取权限：网络权限、存储权限
   * 2. 获取下载路径
   * 3. 设置下载回调
   */
  mProgressDialog = pr;
  if (mProgressDialog.getProgress() == 100.0) {
    openDownloadFile(context);
    return;
  }
  // 获取权限
  var isPermissionReady = await checkPermission(context);
  if (isPermissionReady) {
    // 获取存储路径
    var _localPath = (await findLocalPath()) + '/Download';
    mLocalPath = _localPath;
    mDownloadUrl = downloadUrl;
    final savedDir = Directory(_localPath);
    // 判断下载路径是否存在
    bool hasExisted = await savedDir.exists();
    // 不存在就新建路径
    if (!hasExisted) {
      savedDir.create();
    }
    print("downloadFetionAction initDownload");
    initDownload(context);
    // 下载
    downloadFile(downloadUrl, _localPath);
  } else {
    Toast.show("您还没有获取权限", context);
  }
}

// 申请权限
Future<bool> checkPermission(BuildContext context) async {
  // 先对所在平台进行判断
  if (Platform.isAndroid) {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
  return false;
}

// 获取存储路径
Future<String> findLocalPath() async {
  // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
  // 如果是android，使用getExternalStorageDirectory
  // 如果是iOS，使用getApplicationSupportDirectory
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  return directory.path;
}

// 根据 downloadUrl 和 savePath 下载文件
downloadFile(downloadUrl, savePath) async {
  print("downloadFetionAction downloadFile");
  await FlutterDownloader.enqueue(
    url: downloadUrl,
    savedDir: savePath,
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
  );
}
