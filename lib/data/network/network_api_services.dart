

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mechanic/data/network/base_api_services.dart';
import 'package:http/http.dart' as http;

import '../app_exception.dart';

class NetworkApiSevice implements BaseApiSevices{
  @override
  Future getGetApiResponse(String url) async{
   if(kDebugMode){
     print(url);
   }
   dynamic responseJson;

   try{
     final response = await http.get(Uri.parse(url));
     responseJson = returnResponse(response);
   }
   catch(e){
     print("Exception $e");
   }
   return responseJson;
  }

  @override
  Future getPostApiReponse(String url, data) async{
   if(kDebugMode){
     print(url);
     print(data);
   }

   dynamic responseJson;
   try{
     Response response = await http.post(Uri.parse(url),
     body: data
     );
     responseJson = returnResponse(response);
   }catch(e){
     print("Error is $e");
   }

   if(kDebugMode){
     print(responseJson);
   }
   return responseJson;
  }


  dynamic returnResponse (http.Response response){
    if(kDebugMode){
      print(response.statusCode);
    }
    switch(response.statusCode){
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException("Error occurred while communication");
    }
  }


}