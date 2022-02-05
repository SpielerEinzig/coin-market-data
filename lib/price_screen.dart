import 'dart:convert';
import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final String apiKey = "6139F869-0AB7-49B2-BB23-15ECFD5FFD9F";
  String selectedCurrency = "USD";
  double bitcoinRate = 0;
  double ethereumRate = 0;
  double liteCoinRate = 0;

  getBitcoinData() async {
    http.Response response = await http.get(
      Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apikey=$apiKey'),
    );
    if (response.statusCode == 200) {
      double rate = jsonDecode(response.body)['rate'];
      bitcoinRate = rate;
      print("The bitcoin rate is $rate");
    } else {
      print(response.statusCode);
    }
  }

  getEthereumData() async {
    http.Response response = await http.get(
      Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/ETH/$selectedCurrency?apikey=$apiKey'),
    );
    if (response.statusCode == 200) {
      double rate = jsonDecode(response.body)['rate'];
      ethereumRate = rate;
      print("The ethereum rate is $rate");
    } else {
      print(response.statusCode);
    }
  }

  getLiteCoinData() async {
    http.Response response = await http.get(
      Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/LTC/$selectedCurrency?apikey=$apiKey'),
    );
    if (response.statusCode == 200) {
      double rate = jsonDecode(response.body)['rate'];
      liteCoinRate = rate;
      print("The litecoin rate is $rate");
    } else {
      print(response.statusCode);
    }
  }

  androidDropDown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
      },
      value: selectedCurrency,
      items: dropdownItems,
    );
  }

  iOSPicker() {
    List<Widget> pickerItems = [];
    for (String item in currenciesList) {
      var newItem = Text(item);
      pickerItems.add(newItem);
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (currentSelected) {
        print(currentSelected);
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    getBitcoinData();
    getEthereumData();
    getLiteCoinData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = $ethereumRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 LTC = $liteCoinRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: !kIsWeb && Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
