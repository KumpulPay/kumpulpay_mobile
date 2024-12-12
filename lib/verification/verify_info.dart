import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/verification/personal_data.dart';
import 'package:provider/provider.dart';

class VerifyInfo extends StatefulWidget {
  static String routeName = '/verify_info';
  const VerifyInfo({Key? key}) : super(key: key);

  @override
  State<VerifyInfo> createState() => _VerifyInfoState();
}

class _VerifyInfoState extends State<VerifyInfo> {
  late ColorNotifire notifire;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          'Lengkapi Data Diri',
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontFamily: 'Gilroy Bold',
              fontSize: height / 40),
        ),
        centerTitle: true,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gambar header
                Image.asset(
                  'images/illustration.png',
                  height: height / 4,
                ),

                SizedBox(height: 16),

                // Judul dan Deskripsi
                Text(
                  'Lengkapi Data Diri',
                  style: TextStyle(
                    fontSize: height / 30,
                    fontFamily: 'Gilroy Bold',
                    color: notifire.getdarkscolor,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Dapatkan lebih banyak keuntungan dan layanan lebih lengkap dengan melengkapi data diri Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height / 50,
                    fontFamily: 'Gilroy Medium',
                    color: notifire.getdarkscolor.withOpacity(0.7),
                  ),
                ),

                SizedBox(height: 16),

                // Daftar Keuntungan
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nikmati keuntungannya',
                          style: TextStyle(
                            fontSize: height / 45,
                            fontFamily: 'Gilroy SemiBold',
                            color: notifire.getdarkscolor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: [
                            benefitItem('Layanan keuangan lebih lengkap'),
                            benefitItem(
                                'Akses layanan transfer saldo kapanpun'),
                            benefitItem(
                                'Akses lebih lengkap ke produk-produk pilihan'),
                            benefitItem(
                                'Berbagai produk e-money yang lebih lengkap'),
                            benefitItem(
                                'Ajukan permintaan permodalan melalui layanan Kredit Usaha Rakyat (KUR)'),
                            benefitItem(
                                'Akses pengajuan QRIS untuk menerima dan melakukan pembayaran'),
                            benefitItem(
                                'Promo dengan harga terbaik, khusus untuk pengguna terverifikasi'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Tombol
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: notifire.getPrimaryPurpleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, PersonalData.routeName);
                  },
                  child: Text(
                    'Lengkapi Data Diri Saya',
                    style: TextStyle(
                      fontSize: height / 50,
                      fontFamily: 'Gilroy SemiBold',
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget benefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: notifire.getPrimaryPinkColor,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Gilroy Regular',
                color: notifire.getdarkscolor,
              ),
            ),
          )
        ],
      ),
    );
  }

}