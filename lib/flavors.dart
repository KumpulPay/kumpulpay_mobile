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

}
