import 'dart:convert';
import 'package:http/http.dart' as http;


class CallApi{

  final String _url='https://finaltestapi.acadmin.in/api/InstituteMasterData/';
  final String _url2='https://finaltestapi.acadmin.in/api/StudentData/';
  final String _url3='https://finaltestapi.acadmin.in/api/MasterData/';

  // final String _url1='https://homexp.in/AgentApi/';


  postData(data,apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }


  postData2(data,apiUrl) async {
    var fullUrl = _url2 + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }
  postData3(data,apiUrl) async {
    var fullUrl = _url3 + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }


  getData(apiUrl) async {
    var fullUrl =_url + apiUrl ;// await _getToken();
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }

  _setHeaders()=>{
    // 'Authorization' : '4ccda7514adc0f13595a585205fb9761',
    'Content-type' : 'application/json',
    'Accept' : 'application/json',

  };
  _setHeaders2()=>{
    // 'Authorization' : '4ccda7514adc0f13595a585205fb9761',
    'Content-type' : 'application/x-www-form-urlencoded; charset=UTF-8',
    'Accept' : 'application/json',

  };

/*  razorPaypostData(data,apiUrl) async {
    String username = 'rzp_live_Kdj8EMnC5zB0F3';
    String password = 'FNwLydK0lgfqa8TTfyxpBj6U';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    print(basicAuth);

    var fullUrl = _Razorpay_url + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'authorization':basicAuth,
        }
    );
  }*/

}