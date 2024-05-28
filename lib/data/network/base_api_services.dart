abstract class BaseApiSevices{
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getPostApiReponse(String url, dynamic data);
}