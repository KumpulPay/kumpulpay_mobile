import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryAll extends StatefulWidget {
  static String routeName = '/ppob/transaction/history';
  const HistoryAll({Key? key}) : super(key: key);

  @override
  State<HistoryAll> createState() => _HistoryAllState();
}

class _HistoryAllState extends State<HistoryAll> {
  late ColorNotifire notifire;
  final TextEditingController _searchController = TextEditingController(); 
  final List<Map<String, dynamic>> transactions = [
    {
      "title": "Kirim Uang",
      "amount": -10000,
      "date": DateTime(2024, 11, 16, 8, 9),
      "icon": Icons.send,
    },
    {
      "title": "Isi Saldo dari LOKET",
      "amount": 19500,
      "date": DateTime(2024, 11, 16, 8, 7),
      "icon": Icons.account_balance_wallet,
    },
    {
      "title": "Kirim Uang",
      "amount": -99500,
      "date": DateTime(2024, 11, 15, 8, 15),
      "icon": Icons.send,
    },
    {
      "title": "Isi Saldo",
      "amount": 99500,
      "date": DateTime(2024, 11, 15, 8, 5),
      "icon": Icons.add_circle,
    },
    {
      "title": "Kirim Uang",
      "amount": -89500,
      "date": DateTime(2024, 10, 25, 23, 19),
      "icon": Icons.send,
    },
    {
      "title": "Isi Saldo",
      "amount": 89500,
      "date": DateTime(2024, 10, 25, 23, 19),
      "icon": Icons.add_circle,
    },
  ];

  Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
  String selectedFilter = "Semua"; // Default filter

  @override
  void initState() {
    super.initState();
    _groupTransactionsByMonth();
  }

  void _groupTransactionsByMonth() {
    for (var transaction in transactions) {
      String month = DateFormat.yMMMM().format(transaction['date']);
      if (groupedTransactions[month] == null) {
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: groupedTransactions.keys.length,
          itemBuilder: (context, index) {
            String month = groupedTransactions.keys.elementAt(index);
            List<Map<String, dynamic>> monthTransactions =
                groupedTransactions[month]!;
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
          "Pembayaran",
          "Refund",
          "Isi Saldo",
          "Cashback",
          "Kirim Uang"
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

  Widget _buildMonthSection(
      String month, List<Map<String, dynamic>> transactions) {
    int total = transactions.fold(
        0, (sum, transaction) => sum + transaction['amount'] as int);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                "Rp${total.abs()}",
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
    return Card(
      elevation: 0,
      shadowColor: Colors.transparent,
      color: notifire.gettabwhitecolor,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Icon(
            transaction['icon'],
            color: Colors.blue,
          ),
        ),
        title: Text(
          transaction['title'],
          style: TextStyle(
                fontFamily: "Gilroy Bold",
                color: notifire.getdarkscolor,
                fontSize: height / 50)
        ),
        subtitle:
            Text(
              DateFormat('dd MMM yyyy • HH:mm').format(transaction['date']),
              style: TextStyle(
                fontFamily: "Gilroy Medium",
                color: notifire.getdarkgreycolor.withOpacity(0.6),
                fontSize: height / 65)
            ),
            
        trailing: Text(
          transaction['amount'] > 0
              ? "+Rp${transaction['amount'].abs()}"
              : "-Rp${transaction['amount'].abs()}",
          style: TextStyle(
            fontFamily: "Gilroy Bold",
            fontSize: height / 55,
            color: transaction['amount'] > 0 ?
             Colors.green : 
             Colors.red,
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