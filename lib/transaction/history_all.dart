import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helper_data_json.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:skeletonizer/skeletonizer.dart';

class HistoryAll extends StatefulWidget {
  static String routeName = '/ppob/transaction/history';
  const HistoryAll({Key? key}) : super(key: key);

  @override
  State<HistoryAll> createState() => _HistoryAllState();
}

class _HistoryAllState extends State<HistoryAll> {
  late ColorNotifire notifire;
  final TextEditingController _searchController = TextEditingController(); 
  final ScrollController _scrollController = ScrollController();
  List<dynamic> transactionList = [];
  
  bool _isLoading = false;
  int _page = 1;
  final int _perPage = 10;
  List<dynamic> filteredTransactionList = [
    {
      "title": "Kirim Uang",
      "amount": -10000,
      "date": DateTime(2024, 11, 16, 8, 9),
      // "icon": Icons.send,
    },
    {
      "title": "Isi Saldo dari LOKET",
      "amount": 19500,
      "updated_at": DateTime(2024, 11, 16, 8, 7),
      // "icon": Icons.account_balance_wallet,
    },
    {
      "title": "Kirim Uang",
      "amount": -99500,
      "date": DateTime(2024, 11, 15, 8, 15),
      // "icon": Icons.send,
    },
    {
      "title": "Isi Saldo",
      "amount": 99500,
      "date": DateTime(2024, 11, 15, 8, 5),
      // "icon": Icons.add_circle,
    },
    {
      "title": "Kirim Uang",
      "amount": -89500,
      "date": DateTime(2024, 10, 25, 23, 19),
      // "icon": Icons.send,
    },
    {
      "title": "Isi Saldo",
      "amount": 89500,
      "date": DateTime(2024, 10, 25, 23, 19),
      // "icon": Icons.add_circle,
    },
  ];

  Map<String, List<dynamic>> groupedTransactions = {};
  String selectedFilter = "Semua"; // Default filter

  @override
  void initState() {
    super.initState();
    _loadData();
    // Tambahkan listener untuk pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadData(); // Muat data baru saat mencapai akhir daftar
      }
    });
  }

  void _groupTransactionsByMonth() {
    groupedTransactions.clear(); // Kosongkan grup sebelum memperbarui

    for (var transaction in filteredTransactionList) {
      DateTime updatedAt = DateTime.parse(transaction['updated_at']);
      String month = DateFormat.yMMMM().format(updatedAt);

      if (!groupedTransactions.containsKey(month)) {
        groupedTransactions[month] = [];
      }
      groupedTransactions[month]!.add(transaction);
    }
  }


  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          "Riwayat Transaksi",
          style: TextStyle(
              fontFamily: "Gilroy Bold",
              color: notifire.getdarkscolor,
              fontSize: height / 40),
        ),
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: serarchtextField(
                      Colors.black,
                      notifire.getdarkgreycolor,
                      notifire.getPrimaryPurpleColor,
                      CustomStrings.search,
                    )
                  ),
                  // SizedBox(width: width / width),
                  IconButton(
                    icon: Icon(Icons.tune_outlined, color: notifire.getdarkscolor),
                    onPressed: _showFilterBottomSheet,
                  ),
                ],
              )
            )),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(
              "images/background.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading && _page == 1
            ? Center(child: CircularProgressIndicator()) // Loading awal
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: groupedTransactions.keys.length + 1,
                itemBuilder: (context, index) {
                  if (index == groupedTransactions.keys.length) {
                    return _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink();
                  }

                  String month = groupedTransactions.keys.elementAt(index);
                  List<dynamic> monthTransactions = groupedTransactions[month]!;
                  return _buildMonthSection(month, monthTransactions);
                },
              ),
        
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        String selectedStatus = "Semua";
        String selectedPeriod = "90 Hari Terakhir";
        DateTime? selectedDate;
        List<String> selectedCategories = ["Semua"];
        final List<String> categories = [
          "Semua",
          "Deposit",
          "Withdraw",
          "Transfer",
          "Pembelian",
          "Pembayaran",
          "Refund",
          "Cashback",
        ];

        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Tinggi awal BottomSheet
          minChildSize: 0.4, // Tinggi minimal BottomSheet
          maxChildSize: 0.9, // Tinggi maksimal BottomSheet
          expand: false,
          builder: (context, scrollController) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bagian Konten yang Bisa di-Scroll
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul
                          const Text(
                            "Filter Transaksi",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          // Status Transaksi
                          const Text("Status Transaksi",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            children: ["Semua", "Selesai", "Diproses", "Gagal"]
                                .map((status) {
                              return ChoiceChip(
                                label: Text(status),
                                selected: selectedStatus == status,
                                onSelected: (selected) {
                                  selectedStatus = status;
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Tanggal
                          const Text("Tanggal",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );

                              if (pickedDate != null) {
                                selectedDate = pickedDate;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedDate == null
                                        ? "Pilih tanggal yang mau ditampilkan"
                                        : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                                    style: TextStyle(
                                        color: selectedDate == null
                                            ? Colors.grey
                                            : Colors.black),
                                  ),
                                  const Icon(Icons.calendar_today,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Periode Tanggal
                          const Text("Pilih periode yang mau ditampilkan",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              "7 Hari Terakhir",
                              "30 Hari Terakhir",
                              "90 Hari Terakhir"
                            ].map((period) {
                              return RadioListTile<String>(
                                value: period,
                                groupValue: selectedPeriod,
                                onChanged: (value) {
                                  selectedPeriod = value!;
                                },
                                title: Text(period),
                                contentPadding:
                                      EdgeInsets.zero
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Kategori
                          const Text("Kategori",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: categories.map((category) {
                              return ChoiceChip(
                                label: Text(category),
                                selected: selectedCategories.contains(category),
                                onSelected: (selected) {
                                  if (selected) {
                                    selectedCategories.add(category);
                                  } else {
                                    selectedCategories.remove(category);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tombol Tetap
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 40),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pop(ctxBsc);
                          },
                          child: Custombutton.button2(notifire.getbackcolor,
                              "Ubah", notifire.getPrimaryPurpleColor),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width / 50)),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            // fetchDataAndNavigate(ctxBsc, listDetail[index]);
                          },
                          child: Custombutton.button2(
                              notifire.getPrimaryPurpleColor,
                              "Konfirmasi",
                              Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _loadData() async {
    if (_isLoading) return; // Hindari pemuatan ulang saat sedang memuat
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> queries = {"page": _page, "per_page": _perPage};

      final response = await ApiClient(AppConfig().configDio(context: context )).getHistoryTransaction(
          authorization: 'Bearer ${SharedPrefs().token}', queries: queries);
      
      if (response.success) {
        setState(() {
          // Tambahkan data baru ke daftar transaksi
          transactionList.addAll(response.data);
          filteredTransactionList = transactionList;

          // Kelompokkan ulang transaksi berdasarkan bulan
          _groupTransactionsByMonth();

          _isLoading = false;
          _page++; // Tambah nomor halaman
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMonthSection(
      String month, List<dynamic> transactions) {
    int total = transactions.fold(
        0, (sum, transaction) => sum + transaction['price_fixed_view'] as int);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: width / 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                month,
                style: TextStyle(
                    fontFamily: "Gilroy Bold",
                    color: notifire.getdarkscolor,
                    fontSize: height / 50),
              ),
              Text(
                Helpers.currencyFormatter(total.toDouble()),
                style: TextStyle(
                  fontFamily: "Gilroy Bold",
                  fontSize: height / 55,
                  color: total < 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
        ...transactions
            .map((transaction) => _buildTransactionItem(transaction))
            .toList(),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    String title = transaction['transaction_type'] == 'deposit' ? 'Deposit' : HelpersDataJson.product(transaction["product_meta"], "product_name");
    Widget image = Image.asset(
                          "images/logo_app/disabled_kumpulpay_logo.png",
                          height: height / 20,
                        );
    if (transaction["product_meta"] != null && transaction["product_meta"]['provider_images'] != null) {
        image = Helpers.setCachedNetworkImage(transaction["product_meta"]['provider_images']['image'],height_: height / 26);
    }                    
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: width / 20,
        vertical: height / 100,
      ),
      child: Container(
        height: height / 11,
        width: width,
        decoration: BoxDecoration(
          color: notifire.getdarkwhitecolor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 30),
          child: Row(
            children: [
              Container(
                height: height / 15,
                width: width / 7,
                decoration: BoxDecoration(
                  color: notifire.gettabwhitecolor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: image,
                ),
              ),
              SizedBox(width: width / 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Gilroy Bold",
                      color: notifire.getdarkscolor,
                      fontSize: height / 52,
                    ),
                  ),
                  // const SizedBox(height: 5),
                  Text(
                    Helpers.dateTimeToFormat(
                      transaction["updated_at"],
                      format: "d MMM y",
                    ),
                    style: TextStyle(
                      fontFamily: "Gilroy Medium",
                      color: notifire.getdarkgreycolor.withOpacity(0.6),
                      fontSize: height / 60,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Helpers.currencyFormatter(
                      transaction["price_fixed_view"].toDouble(),
                    ),
                    style: TextStyle(
                      fontFamily: "Gilroy Bold",
                      color: transaction['price_fixed_view'] > 0
                          ? Colors.green
                          : Colors.red,
                      fontSize: height / 52,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    transaction["status"]??'On Process',
                    style: TextStyle(
                      fontFamily: "Gilroy Medium",
                      color: notifire.getdarkgreycolor.withOpacity(0.6),
                      fontSize: height / 60,
                    ),
                  ),
                ],
              ),
            ],
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
}