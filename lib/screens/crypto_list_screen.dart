import 'package:crypto_chand/data/constants/constants.dart';
import 'package:crypto_chand/data/model/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/constants/constants.dart';
import '../data/model/crypto.dart';

class CryptoListScreen extends StatefulWidget {
  CryptoListScreen({Key? key, this.cryptoList}) : super(key: key);
  List<Crypto>? cryptoList;

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  List<Crypto>? cryptoList;

  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'کریپتو چند ؟',
          style: TextStyle(fontFamily: 'mor'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.black38,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none),
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: greenColor,
                  hintText: 'نام ارز مورد نظرت رو بنویس ...',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      TextStyle(color: greyColor, fontWeight: FontWeight.bold)),
              cursorColor: greenColor,
              cursorHeight: 25,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: greenColor,
              color: blackColor,
              onRefresh: () async {
                List<Crypto> freshData = await _getData();
                setState(() {
                  cryptoList = freshData;
                });
              },
              child: ListView.builder(
                itemCount: cryptoList!.length,
                itemBuilder: (context, index) {
                  return _getListTileItem(cryptoList![index]);
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: const TextStyle(color: greenColor),
      ),
      subtitle: Text(crypto.symbol, style: const TextStyle(color: greyColor)),
      leading: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            crypto.rank,
            style: const TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$ ${crypto.priceUsd.toStringAsFixed(2)}',
                  style: const TextStyle(color: greyColor),
                ),
                Text(
                  crypto.changePercent.toStringAsFixed(2),
                  style: TextStyle(
                      color: _getColorChangeText(crypto.changePercent)),
                )
              ],
            ),
            const SizedBox(width: 20),
            _getIconChangePercent(crypto.changePercent)
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange < 0
        ? const Icon(
            Icons.trending_down,
            color: redColor,
          )
        : const Icon(
            Icons.trending_up,
            color: greenColor,
          );
  }

  Color _getColorChangeText(double percentChange) {
    return percentChange < 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJason(jsonMapObject))
        .toList();
    return cryptoList;
  }
}
