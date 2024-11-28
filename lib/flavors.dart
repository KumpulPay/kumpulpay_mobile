enum Flavor {
  prod,
  dev,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.prod:
        return 'KumpulPay';
      case Flavor.dev:
        return 'KumpulPay Dev';
      default:
        return 'title';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.prod:
        return 'https://api.kumpulpay.com';
      case Flavor.dev:
        return 'https://dev-api.kumpulpay.com';
      default:
        return 'https://dev-api.kumpulpay.com';
    }
  }

}
