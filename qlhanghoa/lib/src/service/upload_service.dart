import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/hinh_anh_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class UpLoadService {
  static const String baseUrl = "${AppConfig.urlApi}/hinh_anh";

  // Hàm uploadSingle
  static Future<http.Response> uploadSingle(XFile fil) async {
    try {
      var file = File(fil.path);
      String fileName = file.path.split('/').last;
      print('Uploading file: $fileName');

      // Xác định loại MIME dựa trên phần mở rộng của tệp
      String? mimeType = lookupMimeType(file.path);
      print('MIME Type: $mimeType');

      // Tạo MultipartFile từ bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        await file.readAsBytes(),
        filename: fileName,
        contentType: MediaType.parse(mimeType ?? 'application/octet-stream'),
      );

      // Tạo request
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_single'))
            ..files.add(multipartFile);

      // Thêm header Authorization nếu có token
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Gửi request và nhận response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print(response);
      return response;
    } catch (e) {
      print("Error: $e");
      return http.Response(
        '{"message": "Server Error"}',
        500,
      );
    }
  }

  static Future<http.Response> uploadMultiple(List<dynamic> files) async {
    try {
      // Tạo request multipart
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_multiple'));

      // Thêm các file vào request
      for (var fil in files) {
        if (fil is XFile) {
          var file = File(fil.path);
          String fileName = file.path.split('/').last;
          String? mimeType = lookupMimeType(file.path);

          var multipartFile = http.MultipartFile.fromBytes(
            'image', // Tên field trên server
            await file.readAsBytes(),
            filename: fileName,
            contentType:
                MediaType.parse(mimeType ?? 'application/octet-stream'),
          );

          request.files.add(multipartFile);
        }
      }

      // Thêm header Authorization nếu có token
      String? token = AuthUtil
          .getAccessToken(); // Thay bằng cách lấy token từ AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Gửi request và nhận response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      print("Error: $e");
      return http.Response(
        '{"message": "Server Error"}',
        500,
      );
    }
  }

  static Future<http.Response> delete(HinhAnhModel hinhanh) async {
    try {
      var fileName = hinhanh.tenAnh;
      print('gọi delete service ${fileName}');
      String? token = AuthUtil.getAccessToken();
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Authorization': 'Bearer $token'
      };
      var response = await http.delete(Uri.parse('$baseUrl/delete/$fileName'),
          headers: headers);

      return response;
    } catch (e) {
      print("Error: $e");
      return http.Response(
        '{"message": "Server Error"}',
        500,
      );
    }
  }
}
