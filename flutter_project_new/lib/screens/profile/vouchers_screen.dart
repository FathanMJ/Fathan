import 'package:flutter/material.dart';
import '../../models/voucher.dart';

class VouchersScreen extends StatelessWidget {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Voucher> vouchers = [
      Voucher(code: 'DISKON50', description: 'Diskon 50% untuk semua produk', isUsed: true),
      Voucher(code: 'ONGKIRGRATIS', description: 'Gratis ongkir tanpa minimum pembelian', expiryDate: DateTime.now().add(const Duration(days: 7))),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        final voucher = vouchers[index];
        return Card(
          color: voucher.isUsed ? Colors.grey[200] : Colors.white,
          child: ListTile(
            title: Text(voucher.code, style: TextStyle(fontWeight: FontWeight.bold, color: voucher.isUsed ? Colors.grey : Colors.black)),
            subtitle: Text(voucher.description),
            trailing: voucher.isUsed
                ? const Text('Digunakan')
                : Text('Berakhir ${voucher.expiryDate != null ? voucher.expiryDate!.day.toString() : 'N/A'} hari lagi'),
          ),
        );
      },
    );
  }
}
