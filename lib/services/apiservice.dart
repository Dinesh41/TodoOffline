import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ApiService {
  Dio dio;

  ApiService() {
    dio = new Dio();
    dio.options.baseUrl = "https://us-central1-sdss-india.cloudfunctions.net";
  }

  Future<void> downloadImage({@required url, @required savePath}) async {
    try {
      await dio.download(url, savePath);
    } on DioError catch (e) {
      throw e;
    }
    return null;
  }
}
