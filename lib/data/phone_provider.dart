class PhoneProvider {
  static List<Map<String, dynamic>> providerData = [
    {
      "provider": "telkomsel",
      "icon": "",
      "prefix": ["0811", "0812", "0813", "0852", "0853", "0821", "0822", "0823"]
    },
    {
      "provider": "byu",
      "icon": "",
      "prefix": ["0851"]
    },
    {
      "provider": "indosat",
      "icon": "",
      "prefix": ["0815", "0816", "0858", "0847", "0855", "0856", "0857", "0814"]
    },
    {
      "provider": "xl",
      "icon": "",
      "prefix": ["0817", "0818", "0819", "0878", "0877"]
    },
    {
      "provider": "axis",
      "icon": "",
      "prefix": ["0838", "0831", "0832", "0833", "0837", "0839", "0859"]
    },
    {
      "provider": "tri",
      "icon": "",
      "prefix": [
        "0890",
        "0891",
        "0892",
        "0893",
        "0894",
        "0895",
        "0896",
        "0897",
        "0898",
        "0899"
      ]
    },
    {
      "provider": "smartfren",
      "icon": "",
      "prefix": [
        "0881",
        "0882",
        "0883",
        "0884",
        "0885",
        "0886",
        "0887",
        "0888",
        "0889"
      ]
    }
  ];

  static Map<String, dynamic> getProvide(String value) {
    // print("getProvide: ${value}");
    Map<String, dynamic> data = {};
    try {
      for (var provider in providerData) {
        print(provider);
        for (var prefix in provider["prefix"]) {
          // print("prefix: ${prefix}");
          // print("contains: ${value.contains(prefix)}");
          
          if (value.contains(prefix)) {
            data.addAll(provider);
            break;
          }
        }
      }
      return data;
    } catch (e) {
      // print("getProvideError: ${e}");
      rethrow;
    }
  }
}
