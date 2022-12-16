

import 'package:bitcoin_ticker/constants.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter_spinkit/flutter_spinkit.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String item in currenciesList) {
      var newItem = DropdownMenuItem(
        value: item,
        child: Text(item),
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        onChanged: (value) {
          setState(() async {
            selectedCurrency = value!;
            getData();
          });
        },
        items: dropDownItems);
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String item in currenciesList) {
      pickerItems.add(
        Text(
          item,
          style: TextStyle(color: Colors.white),
        ),);
    }
    return CupertinoPicker(
      itemExtent: 20.0,
      onSelectedItemChanged: (value) {
        getData();
      },
      backgroundColor: Colors.lightBlue,
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    var data = await CoinData().getCoinData(selectedCurrency);
    isWaiting = false;
    setState(() {
      coinValues = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardForCoins(bTC: 'BTC',
                  resultBTC: coinValues['BTC'] ?? '',
                  currency: selectedCurrency),
              CardForCoins(bTC: 'ETH',
                  resultBTC: coinValues['ETH'] ?? '',
                  currency: selectedCurrency),
              CardForCoins(bTC: 'LTC',
                  resultBTC: coinValues['LTC'] ?? '',
                  currency: selectedCurrency),
            ],
          ),
          Visibility(
              child:  SpinKitSquareCircle(
                color: Colors.lightBlue.shade900,
                size: 100.0,
              ),
            visible: isWaiting,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdownButton(),
          )
        ],
      ),
    );
  }
}

class CardForCoins extends StatelessWidget {
  const CardForCoins({
    Key? key,
    required this.bTC,
    required this.resultBTC,
    required this.currency,
  }) : super(key: key);

  final String bTC;
  final String resultBTC;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $bTC = $resultBTC $currency',
            textAlign: TextAlign.center,
            style: KTextLableStyle,
          ),
        ),
      ),
    );
  }
}



