import 'package:dio/dio.dart';
import 'sqlite_util.dart';

const root = 'http://47.96.84.101:8080';
//const root = 'http://47.96.84.101:8081';

class Api {

  String formatUrl([String url,Map<String,Object> param]){
    String ret = url;
    if(param!=null){
      bool start = true;
      param.forEach((String key, Object value){
        ret += (start?'?':'&');
        if(start) start = false;
        ret += (key+'='+value.toString());
      });
    }
    print(ret);
    return ret;
  }

  dynamic get(String url,var param) async {
//    var httpClient = new HttpClient();
//    var uri = new Uri.https(root, url, param);
//    var request = await httpClient.getUrl(uri);
//    var response = await request.close();
//    var responseBody = await response.transform(utf8.decoder).join();
    var dio = new Dio();
    try {
      //    dio.options.baseUrl = root;
//    dio.options.connectTimeout = 5000; //5s
//    dio.options.receiveTimeout=5000;
      Response response=await dio.get(root+url,data:param);
//      Response response=await dio.get(formatUrl(root + url,param));
//      print(response.data.toString());
      print(response.data);
      return response.data;
    } on DioError catch(e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if(e.response!=null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else{
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
    }
  }


  dynamic post(String url,var param) async {
//    var httpClient = new HttpClient();
//    var uri = new Uri.https(root, url, param);
//    var request = await httpClient.getUrl(uri);
//    var response = await request.close();
//    var responseBody = await response.transform(utf8.decoder).join();
    var dio = new Dio();
    try {
      //    dio.options.baseUrl = root;
//    dio.options.connectTimeout = 5000; //5s
//    dio.options.receiveTimeout=5000;
      Response response=await dio.post(root+url,data:param);
//      Response response=await dio.get(formatUrl(root + url,param));
//      print(response.data.toString());
      print(response.data);
      return response.data;
    } on DioError catch(e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if(e.response!=null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else{
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
    }
  }

  dynamic getHanziList({int page:1, int pagesize:10, bool needAll:false, String name:''}) async {
    Map<String,Object> param = {
      'page': page,
      'pagesize': pagesize,
      'full': needAll?'y':'n',
      'keyword': name
    };
    print(param);
    String url = '/hanzi/page';
    String request = await sqliteUtil.getCache(url, param);
    if (request!=null) {
      return request;
    } else {
      dynamic response = await get(url,param);
      sqliteUtil.saveCache(url, param, response);
      return response;
    }
  }

  dynamic findHanzi(String name) async {
    Map<String,Object> param = {
      'name': name
    };
    print(param);
    String url = '/hanzi/findByName';
    String request = await sqliteUtil.getCache(url, param);
    if (request!=null) {
      return request;
    } else {
      //    return await get('/hanzi/find',param);
      dynamic response = await get(url,param);
      sqliteUtil.saveCache(url, param, response);
      return response;
    }
  }

}