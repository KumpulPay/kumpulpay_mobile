import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyBankAccount extends StatefulWidget {
  static String routeName = '/my_bank_account';
  const MyBankAccount({Key? key}) : super(key: key);


  @override
  State<MyBankAccount> createState() => _MyBankAccountState();
}

class _MyBankAccountState extends State<MyBankAccount> {
  MyBankAccount? args;
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true; 
  List<dynamic> _allData = [];
  List<dynamic> _filteredData = List.filled(10, {
    "code": "code",
    "name": "name",
  });

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as MyBankAccount?;
    });

    _fetchData();
    _searchController.addListener(_onSearchChanged);

  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          'Rekening Saya',
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
              "Cari Data",
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
              itemCount: _filteredData.length,
              separatorBuilder: (context, index) => Divider(
                color: notifire.getdarkgreycolor.withOpacity(0.1),
                thickness: 1,
                height: 0,
              ), // Divider antara item
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                return Padding(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item['name'] ?? 'Unknown',
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontSize: height / 50,
                      ),
                    ),
                    onTap: () {
                      // Aksi saat item diklik
                      print("Selected: ${item['name']}");
                      Navigator.pop(context, item);
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

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiClient(AppConfig().configDio(context: context))
          .getRegional(
              authorization: 'Bearer ${SharedPrefs().token}');

      if (response.success) {
        setState(() {
          _allData = response.data; // Langsung gunakan response.data
          _filteredData = response.data; // Awalnya semua data ditampilkan
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
      _filteredData = _allData.where((regional) {
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
}