import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const baseUrl = 'https://rest.coinapi.io/v1/exchangerate/';
const apiKey = 'CC6317BC-C156-43B0-8449-7601925DA408';
const apiKey2 = 'A8AC5BA1-F078-4E2F-8984-8B28335FB72E';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList){
      String requestURL = '$baseUrl$crypto/$selectedCurrency?apikey=$apiKey2';
      http.Response response = await http.get(Uri.parse(requestURL));
      var decodedData = jsonDecode(response.body);
      double price = decodedData['rate'];
      cryptoPrices[crypto] = price.toStringAsFixed(0);
      print(response.statusCode);
    }
    return cryptoPrices;
  }
}