import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

enum PaymentMethod { kprSyariah, developer }

class CalculatorResult {
  final double dp;
  final double plafon;
  final double hargaSetelahDiskon;
  final double cicilanBulanan;
  final double cicilanBulananSetelahDiskon;
  final double totalPembayaran;
  final double totalPembayaranSetelahDiskon;
  final double marginKpr;
  final int months;
  final List<Map<String, dynamic>> scheduleTable;

  CalculatorResult({
    required this.dp,
    required this.plafon,
    required this.hargaSetelahDiskon,
    required this.cicilanBulanan,
    required this.cicilanBulananSetelahDiskon,
    required this.totalPembayaran,
    required this.totalPembayaranSetelahDiskon,
    required this.marginKpr,
    required this.months,
    required this.scheduleTable,
  });
}

class CashcalculatorController {
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  /// Hitung DP
  double calculateDp({
    required double harga,
    required PaymentMethod method,
    required bool tanpaDp,
  }) {
    final cacheKpr = _storage.kprCalculators;
    print(
      '💾 Cached KPR Calculators: ${cacheKpr!.first.dpDeveloperValue}, ${cacheKpr!.first.dpSyariahValue}',
    );
    if (method == PaymentMethod.developer) {
      if (tanpaDp) return 0.0;
      return harga * cacheKpr!.first.dpDeveloperValue;
    } else {
      return harga * cacheKpr!.first.dpSyariahValue;
    }
  }

  /// Fungsi PPMT - menghitung pembayaran pokok per periode
  double ppmt(double rate, int period, int nper, double pv) {
    if (rate == 0) return -pv / nper;

    double pmt = _pmt(rate, nper, pv);
    double ipmt = _ipmt(rate, period, nper, pv);

    return pmt - ipmt;
  }

  /// Fungsi IPMT - menghitung pembayaran bunga per periode
  double ipmt(double rate, int period, int nper, double pv) {
    return _ipmt(rate, period, nper, pv);
  }

  /// Helper: Hitung IPMT
  double _ipmt(double rate, int period, int nper, double pv) {
    if (rate == 0) return 0;

    double pmt = _pmt(rate, nper, pv);

    // Hitung saldo setelah periode sebelumnya
    double balance = pv;
    for (int i = 1; i < period; i++) {
      double interest = balance * rate;
      double principal = pmt - interest;
      balance = balance - principal;
    }

    // Bunga untuk periode ini
    return balance * rate;
  }

  /// Helper: Hitung PMT (angsuran tetap)
  double _pmt(double rate, int nper, double pv) {
    if (rate == 0) return -pv / nper;

    double pvif = math.pow(1 + rate, nper).toDouble();
    double pmt = rate * pv * pvif / (pvif - 1);

    return pmt;
  }

  /// Generate tabel cicilan untuk KPR Syariah
  List<Map<String, dynamic>> _generateKprSyariahSchedule({
    required double plafon,
    required int months,
    required double marginRate,
    DateTime? startDate,
  }) {
    final List<Map<String, dynamic>> rows = [];
    DateTime date = startDate ?? DateTime.now();
    date = DateTime(date.year, date.month, 1);

    double sisaHutang = plafon;
    double monthlyRate = marginRate / 12;

    for (int i = 1; i <= months; i++) {
      double pokok = ppmt(monthlyRate, i, months, plafon);
      double margin = ipmt(monthlyRate, i, months, plafon);
      double angsuran = pokok + margin;
      sisaHutang = sisaHutang - pokok;

      final row = {
        'no': i,
        'month': date.month,
        'year': date.year,
        'label': "${_monthName(date.month)} ${date.year}",
        'angsuran': angsuran,
        'pokok': pokok,
        'margin': margin,
        'sisaHutang': sisaHutang.clamp(0, double.infinity),
      };
      rows.add(row);
      date = DateTime(date.year, date.month + 1, 1);
    }
    return rows;
  }

  /// Generate tabel cicilan untuk KPR Developer
  List<Map<String, dynamic>> _generateKprDeveloperSchedule({
    required double plafon,
    required int months,
    required int tenorYears,
    required double marginRate,
    DateTime? startDate,
  }) {
    final List<Map<String, dynamic>> rows = [];
    DateTime date = startDate ?? DateTime.now();
    date = DateTime(date.year, date.month, 1);

    double pokok = plafon / months;
    double marginPerBulan = ((plafon * tenorYears) * marginRate) / months;
    double angsuran = pokok + marginPerBulan;
    double sisaHutang = plafon;

    for (int i = 1; i <= months; i++) {
      sisaHutang = sisaHutang - pokok;

      final row = {
        'no': i,
        'month': date.month,
        'year': date.year,
        'label': "${_monthName(date.month)} ${date.year}",
        'angsuran': angsuran,
        'pokok': pokok,
        'margin': marginPerBulan,
        'sisaHutang': sisaHutang.clamp(0, double.infinity),
      };
      rows.add(row);
      date = DateTime(date.year, date.month + 1, 1);
    }
    return rows;
  }

  /// Fungsi utama compute()
  CalculatorResult compute({
    required HouseModel model,
    required PaymentMethod method,
    required bool tanpaDp,
    double? diskonNominal,
    double? diskonPersen,
    required int tenorYears,
    required double marginPersen,
  }) {
    final harga = model.hargaCash.toDouble();
    final dp = calculateDp(harga: harga, method: method, tanpaDp: tanpaDp);
    print('💰 Calculating with harga: $harga, dp: $dp');
    final plafon = harga - dp;
    final months = tenorYears * 12;
    final marginRate = marginPersen / 100;

    // Generate tabel cicilan berdasarkan metode
    List<Map<String, dynamic>> scheduleTable;
    if (method == PaymentMethod.kprSyariah) {
      scheduleTable = _generateKprSyariahSchedule(
        plafon: plafon,
        months: months,
        marginRate: marginRate,
      );
    } else {
      scheduleTable = _generateKprDeveloperSchedule(
        plafon: plafon,
        months: months,
        tenorYears: tenorYears,
        marginRate: marginRate,
      );
    }

    // Ambil angsuran bulanan dari baris pertama tabel
    final cicilan = scheduleTable.first['angsuran'] as double;

    // Hitung Margin KPR
    double marginKpr = 0.0;
    if (method == PaymentMethod.kprSyariah) {
      // Margin KPR = (angsuran * tenor + DP) - harga_jual
      double hargaJualKpr = (cicilan * months) + dp;
      marginKpr = hargaJualKpr - harga;
    } else {
      // Margin KPR = ((plafon * tenor) * margin %) / tenor (bulan)
      marginKpr = ((plafon * tenorYears) * marginRate);
    }

    // Total pembayaran = (cicilan * months) + DP
    final total = (cicilan * months) + dp;

    // Jika ada diskon manual
    double totalAfterDiskon = total;
    double diskon = 0.0;

    if (diskonNominal != null && diskonNominal > 0) {
      diskon = diskonNominal;
      totalAfterDiskon = (total - diskonNominal).clamp(0, double.infinity);
    } else if (diskonPersen != null && diskonPersen > 0) {
      diskon = (total * diskonPersen / 100).clamp(0, double.infinity);
      totalAfterDiskon = (total * (1 - diskonPersen / 100)).clamp(
        0,
        double.infinity,
      );
    }

    final diskonCicilan = diskon > 0 ? diskon / months : 0;
    final cicilanAfterDiskon = (diskonCicilan > 0)
        ? cicilan - diskonCicilan
        : cicilan;

    return CalculatorResult(
      dp: dp,
      plafon: plafon,
      hargaSetelahDiskon: totalAfterDiskon,
      cicilanBulanan: cicilan,
      cicilanBulananSetelahDiskon: cicilanAfterDiskon,
      totalPembayaran: total,
      totalPembayaranSetelahDiskon: totalAfterDiskon,
      marginKpr: marginKpr,
      months: months,
      scheduleTable: scheduleTable,
    );
  }

  String _monthName(int m) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    if (m < 1 || m > 12) return '';
    return names[m];
  }
}
