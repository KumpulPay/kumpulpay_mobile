import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RegionalSearch extends StatefulWidget {
  static String routeName = '/regional_search';
  final String? code;
  const RegionalSearch({Key? key, this.code}) : super(key: key);

  @override
  State<RegionalSearch> createState() => _RegionalSearchState();
}

class _RegionalSearchState extends State<RegionalSearch> {
  RegionalSearch? args;
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final TextEditingController _searchController = TextEditingController();
  String? _code = '';
  List<dynamic> _allRegional = [];
  List<dynamic> _filteredRegional =  List.filled(10, {
    "code": "code",
    "name": "name",
  });
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as RegionalSearch?;
      _code = args!.code;
      if (args != null) {
        
        _fetchData();

      } else {
        print('Error: args is null');
        _fetchData();
      }
      _searchController.addListener(_onSearchChanged);
    });
    
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          'Regional',
          style: TextStyle(
            fontFamily: "Gilroy Bold",
            color: notifire.getdarkscolor,
            fontSize: height / 40,
          ),
        ),
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: serarchtextField(
              Colors.black,
              notifire.getdarkgreycolor,
              notifire.getbluecolor,
              "Cari Regional",
            ),
          ),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Skeletonizer(
          enabled: _isLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 20),
            child: ListView.separated(
              itemCount: _filteredRegional.length,
              separatorBuilder: (context, index) => Divider(
                color: notifire.getdarkgreycolor.withOpacity(0.1),
                thickness: 1,
                height: 0,
              ), // Divider antara item
              itemBuilder: (context, index) {
                final regional = _filteredRegional[index];
                return Padding(
                  padding: EdgeInsets.zero,
                  child:  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      regional['name'] ?? 'Unknown',
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontSize: height / 50,
                      ),
                    ),
                    onTap: () {
                      // Aksi saat item diklik
                      print("Selected: ${regional['name']}");
                      Navigator.pop(context, regional);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget serarchtextField(
    textclr,
    hintclr,
    borderclr,
    hinttext,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 40),
      child: Container(
        color: Colors.transparent,
        height: height / 17,
        child: TextField(
          controller: _searchController,
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifire.getdarkwhitecolor,
            hintText: hinttext,
            prefixIcon: Icon(
              Icons.search,
              color: notifire.getdarkgreycolor,
            ),
            hintStyle: TextStyle(color: hintclr, fontSize: height / 60),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderclr),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
   
    try {
     
      final queryParameters = {'code': _code};
      final response = await ApiClient(AppConfig().configDio(context: context))
          .getRegional(authorization: 'Bearer ${SharedPrefs().token}', queries: queryParameters);

      if (response.success) {
        setState(() {
          _allRegional = response.data; // Langsung gunakan response.data
          _filteredRegional = response.data; // Awalnya semua data ditampilkan
          _isLoading = false;
        });
      } else {
        _showError("Gagal mengambil data.");
      }
    } catch (e) {
      // print('errorX ${e.toString()}');
      _showError("Terjadi kesalahan.");
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredRegional = _allRegional.where((regional) {
        return (regional['name'] ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showError(String message) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
