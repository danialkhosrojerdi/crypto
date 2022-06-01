class Crypto {
  final String id;
  final String rank;
  final String symbol;
  final String name;
  final String marketCapUsd;
  final double priceUsd;
  final double changePercent;

  Crypto(this.id, this.rank, this.symbol, this.name, this.marketCapUsd,
      this.priceUsd, this.changePercent);

  factory Crypto.fromMapJason(Map<String, dynamic> jasonMapObject) {
    return Crypto(
      jasonMapObject['id'],
      jasonMapObject['rank'],
      jasonMapObject['symbol'],
      jasonMapObject['name'],
      jasonMapObject['marketCapUsd'],
      double.parse(jasonMapObject['priceUsd']),
      double.parse(jasonMapObject['changePercent24Hr']),
    );
  }
}
