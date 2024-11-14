import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PpobPostpaidA extends StatefulWidget {
  const PpobPostpaidA({Key? key}) : super(key: key);
  @override
  State<PpobPostpaidA> createState() => _PpobPostpaidAState();
}

class _PpobPostpaidAState extends State<PpobPostpaidA> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Internet & TV Kabel"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Provider
            Row(
              children: [
                Image.asset(
                  'images/indovision_logo.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 10),
                Text(
                  "Indovision",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Form untuk Nomor Pelanggan
            FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nomor Pelanggan",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'nomor_pelanggan',
                    decoration: InputDecoration(
                      hintText: "Contoh 1234567890",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Promo Section
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dapat 1 Token Main Catchback",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    "Berlaku s.d. 31 Desember 2024",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Min. penggunaan Saldo OVO Rp10.000",
                    style: TextStyle(fontSize: 14, color: Colors.orange[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Nomor Terakhir Section
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt, color: Colors.purple),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nomor Terakhir",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        "Belum ada nomor terakhir",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        "Transaksi dulu biar ada nomor kamu di sini",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),

            // Button Lanjut ke Pembayaran
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    // Action ketika form valid
                  }
                },
                style: ElevatedButton.styleFrom(
                  // primary: Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Lanjut Ke Pembayaran",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
