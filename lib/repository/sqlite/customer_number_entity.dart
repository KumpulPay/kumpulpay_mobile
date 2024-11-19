import 'package:floor/floor.dart';

@Entity(tableName: 'customer_number')
class CustomerNumberEntity {
  // @PrimaryKey(autoGenerate: true)
  // final int? id; // Primary key, auto-increment
  @PrimaryKey() // Primary key, dapat menggunakan kombinasi unik di sini
  final String category; // Kategori customer

  @PrimaryKey() // Ini akan membuat kombinasi category + customerNumber menjadi unik
  final String customerNumber; // Nomor pelanggan

  final String customerName; // Nama pelanggan

  CustomerNumberEntity({
    // this.id,
    required this.category,
    required this.customerNumber,
    required this.customerName,
  });

  /// Factory constructor untuk membuat instance dengan nilai default
  factory CustomerNumberEntity.optional({
    // int? id,
    String? category,
    String? customerNumber,
    String? customerName,
  }) =>
      CustomerNumberEntity(
        // id: id,
        category: category ?? '',
        customerNumber: customerNumber ?? '',
        customerName: customerName ?? '',
      );

  /// Konversi objek ke JSON (untuk kebutuhan serialisasi/deserialisasi)
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'category': category,
      'customerNumber': customerNumber,
      'customerName': customerName,
    };
  }

  /// Factory method untuk membuat objek dari JSON
  factory CustomerNumberEntity.fromJson(Map<String, dynamic> json) {
    return CustomerNumberEntity(
      // id: json['id'],
      category: json['category'],
      customerNumber: json['customerNumber'],
      customerName: json['customerName'],
    );
  }

  /// Override toString untuk debugging
  @override
  String toString() {
    return 'CustomerNumberEntity{category: $category, customerNumber: $customerNumber, customerName: $customerName}';
  }
}
