import 'package:floor/floor.dart';
import 'customer_number_entity.dart';

@dao
abstract class CustomerNumberDao {

  /// Ambil semua data customer number
  @Query('SELECT * FROM customer_number ORDER BY customerNumber DESC LIMIT :limit OFFSET :offset')
  Future<List<CustomerNumberEntity>> getAll(int limit, int offset);

  /// Ambil semua data customer number berdasarkan kategori
  @Query('SELECT * FROM customer_number WHERE category = :category ORDER BY customerNumber DESC LIMIT :limit OFFSET :offset')
  Future<List<CustomerNumberEntity>> getAllByCategory(String category, int limit, int offset);

  /// Ambil data berdasarkan ID
  @Query('SELECT * FROM customer_number WHERE category = :category AND customerNumber :customerNumber')
  Future<CustomerNumberEntity?> getById(String category, String customerNumber);

  /// Tambahkan data baru
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertData(CustomerNumberEntity customer);

  /// Tambahkan banyak data sekaligus
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> inserts(List<CustomerNumberEntity> customers);

  /// Update data
  @update
  Future<void> updateData(CustomerNumberEntity customer);

  @delete
  Future<void> deleteData(CustomerNumberEntity customer);

  /// Hapus data berdasarkan ID
  @Query('DELETE FROM customer_number WHERE customerName = :id')
  Future<void> deleteDataById(int id);

  /// Hapus semua data
  @Query('DELETE FROM customer_number')
  Future<void> deleteAllCustomers();
}
