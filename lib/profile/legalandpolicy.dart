import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';

class LegalPolicy extends StatefulWidget {
  final String title;

  const LegalPolicy(this.title, {Key? key}) : super(key: key);

  @override
  State<LegalPolicy> createState() => _LegalPolicyState();
}

class _LegalPolicyState extends State<LegalPolicy> {
  late ColorNotifire notifire;
  final privacyPolicy = PrivacyPolicy(); // Tambahkan PrivacyPolicy instance

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
          iconTheme: IconThemeData(color: notifire.getdarkscolor),
          elevation: 0,
          backgroundColor: notifire.getprimerycolor,
          title: Text(
            widget.title,
            style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: MediaQuery.of(context).size.height / 40,
              fontFamily: 'Gilroy Bold',
            ),
          ),
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
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            privacyPolicy.title,
                            style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            privacyPolicy.welcomeMessage,
                            style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...privacyPolicy.sections.map((section) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    section.title,
                                    style: TextStyle(
                                      color: notifire.getdarkscolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...section.content.map((content) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        content,
                                        style: TextStyle(
                                          color: notifire.getdarkscolor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}

class PrivacyPolicy {
  final String title = "Kebijakan Privasi";
  final String lastUpdated = "Terakhir diperbarui: [Tanggal]";
  final String welcomeMessage =
      "Selamat datang di KumpulPay. Kami menghargai privasi dan keamanan informasi Anda. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, mengungkapkan, dan melindungi informasi pribadi Anda saat Anda menggunakan aplikasi KumpulPay. Dengan menggunakan layanan kami, Anda menyetujui pengumpulan dan penggunaan informasi sesuai dengan Kebijakan Privasi ini.";

  final List<Section> sections = [
    Section(
      title: "1. Informasi yang Kami Kumpulkan",
      content: [
        "1.1 Informasi Pribadi",
        "Kami dapat mengumpulkan informasi pribadi yang dapat mengidentifikasi Anda, seperti:",
        "Nama lengkap",
        "Alamat email",
        "Nomor telepon",
        "Alamat fisik",
        "Informasi pembayaran (jika diperlukan)",
        "1.2 Informasi Non-Pribadi",
        "Kami juga dapat mengumpulkan informasi non-pribadi yang tidak mengidentifikasi Anda secara spesifik, seperti:",
        "Jenis perangkat yang Anda gunakan",
        "Alamat IP",
        "Sistem operasi perangkat",
        "Data geolokasi (jika Anda memberikan izin)",
        "Informasi penggunaan aplikasi (seperti fitur yang sering digunakan)",
      ],
    ),
    Section(
      title: "2. Cara Kami Menggunakan Informasi Anda",
      content: [
        "Informasi yang kami kumpulkan digunakan untuk tujuan berikut:",
        "Menyediakan layanan aplikasi yang Anda gunakan, seperti pengelolaan pembayaran dan transaksi.",
        "Memproses transaksi dan pembayaran dengan aman.",
        "Meningkatkan layanan kami berdasarkan masukan pengguna.",
        "Mengirimkan pemberitahuan terkait layanan, pembaruan sistem, dan informasi penting lainnya.",
        "Menyediakan dukungan pelanggan.",
        "Mengelola promosi, penawaran khusus, atau layanan lainnya yang relevan.",
      ],
    ),
    Section(
      title: "3. Pembagian Informasi",
      content: [
        "Kami tidak akan menjual, menyewakan, atau membagikan informasi pribadi Anda kepada pihak ketiga kecuali dalam kondisi berikut:",
        "Dengan persetujuan Anda.",
        "Kepada penyedia layanan pihak ketiga yang bekerja sama dengan kami untuk memproses transaksi dan menyediakan layanan yang Anda minta.",
        "Jika diwajibkan oleh hukum atau peraturan, kami dapat membagikan informasi pribadi Anda kepada otoritas yang berwenang.",
      ],
    ),
    Section(
      title: "4. Keamanan Informasi",
      content: [
        "Kami menggunakan langkah-langkah keamanan teknis dan organisasi yang wajar untuk melindungi informasi pribadi Anda dari akses yang tidak sah, penggunaan, atau pengungkapan. Namun, perlu diingat bahwa tidak ada metode transmisi data melalui internet atau metode penyimpanan elektronik yang 100% aman, dan kami tidak dapat menjamin keamanan mutlak informasi Anda.",
      ],
    ),
    Section(
      title: "5. Hak Anda",
      content: [
        "Sebagai pengguna, Anda memiliki hak berikut terkait informasi pribadi Anda:",
        "Akses: Anda dapat meminta salinan informasi pribadi yang kami miliki tentang Anda.",
        "Perbaikan: Anda dapat meminta kami untuk memperbaiki informasi pribadi yang tidak akurat atau tidak lengkap.",
        "Penghapusan: Anda dapat meminta kami untuk menghapus informasi pribadi yang kami miliki tentang Anda, kecuali jika ada kewajiban hukum untuk menyimpannya.",
        "Penarikan Persetujuan: Anda dapat menarik persetujuan Anda kapan saja untuk penggunaan informasi pribadi Anda.",
      ],
    ),
    Section(
      title: "6. Cookie dan Teknologi Pelacakan",
      content: [
        "Kami dapat menggunakan cookie atau teknologi pelacakan lainnya untuk meningkatkan pengalaman Anda dalam menggunakan aplikasi kami. Cookie membantu kami mengingat preferensi Anda, melacak penggunaan, dan menganalisis bagaimana layanan kami digunakan. Anda dapat menonaktifkan cookie melalui pengaturan browser Anda, tetapi beberapa fitur aplikasi mungkin tidak berfungsi dengan baik tanpa cookie.",
      ],
    ),
    Section(
      title: "7. Pembaruan Kebijakan Privasi",
      content: [
        "Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu untuk mencerminkan perubahan dalam praktik kami atau peraturan yang berlaku. Kami akan memberi tahu Anda tentang perubahan signifikan melalui aplikasi atau email. Kami mendorong Anda untuk meninjau kebijakan ini secara berkala.",
      ],
    ),
    Section(
      title: "8. Hubungi Kami",
      content: [
        "Jika Anda memiliki pertanyaan tentang Kebijakan Privasi ini atau ingin menggunakan hak Anda terkait informasi pribadi, silakan hubungi kami melalui:",
        "Email: info@kumpulpay.com",
        "Alamat: Jl. Sarikaya 1 No.223, Depok Jaya, Kec. Pancoran Mas Kota Depok, Jawa Barat 16432",
      ],
    ),
  ];
}

class Section {
  final String title;
  final List<String> content;

  Section({required this.title, required this.content});
}

