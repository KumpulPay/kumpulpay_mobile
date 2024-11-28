import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'colornotifire.dart';
import 'media.dart';

late ColorNotifire notifire;

class NormalCustomtextfilds {
  /// Membuat widget text field menggunakan FormBuilderTextField dengan dekorasi standar.
  static Widget textField({
    required String name, // Nama field (wajib untuk FormBuilder)
    required Color textclr, // Warna teks input
    required Color hintclr, // Warna teks placeholder
    required Color borderclr, // Warna border saat fokus
    required String hinttext, // Placeholder teks
    required double w, // Padding horizontal
    required Color fillcolor, // Warna latar belakang field
    required BuildContext context, // Konteks untuk ColorNotifire
    TextEditingController? controller, // Kontroller untuk teks (opsional)
    String? initialValue, // Nilai awal teks
    String? Function(String?)? validator, // Fungsi validasi (opsional)
    bool readOnly = false, // Apakah input hanya bisa dibaca
    VoidCallback? onTap, // Fungsi yang dipanggil saat widget diklik
    Widget? suffixIcon, // Ikon di sisi kanan
    keyboardType,
  }) {
    // Mendapatkan instance ColorNotifire
    final notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w),
      child: Container(
        color: Colors.transparent,
        child: FormBuilderTextField(
          name: name,
          controller: controller, // Menggunakan controller
          initialValue: initialValue,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          autofocus: false,
          onTap: onTap,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifire.getwhite,
            hintText: hinttext,
            hintStyle: TextStyle(color: hintclr, fontSize: height / 60),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderclr),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
