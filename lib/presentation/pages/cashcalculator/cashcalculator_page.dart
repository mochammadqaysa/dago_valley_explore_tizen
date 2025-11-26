import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:dago_valley_explore/presentation/controllers/cashcalculator/cashcalculator_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class CashcalculatorPage extends StatefulWidget {
  const CashcalculatorPage({Key? key}) : super(key: key);

  @override
  State<CashcalculatorPage> createState() => _CashcalculatorPageState();
}

class _CashcalculatorPageState extends State<CashcalculatorPage> {
  HouseModel? selectedModel;
  PaymentMethod paymentMethod = PaymentMethod.kprSyariah;
  final TextEditingController _diskonRpController = TextEditingController();
  final TextEditingController _diskonPersenController = TextEditingController();
  bool tanpaDp = false;
  double? diskonNominal;
  double? diskonPersen;
  int tenor = 5;
  double marginPersen = 11.0; // Default untuk KPR Syariah
  double marginSyariah = 0.0;
  double marginDeveloper = 0.0;

  final controller = CashcalculatorController();

  final rupiahFormat = NumberFormat("#,###", "id_ID");

  final LocalStorageService _storage = Get.find<LocalStorageService>();

  List<int> get tenorOptions {
    if (paymentMethod == PaymentMethod.kprSyariah) {
      return [5, 10, 15, 20];
    } else {
      return [1, 2, 3, 4];
    }
  }

  @override
  void initState() {
    super.initState();
    final cachedKpr = _storage.kprCalculators;

    marginSyariah = cachedKpr?.first.marginBankSyariahValue ?? 11.0;
    marginDeveloper = cachedKpr?.first.marginDeveloperValue ?? 5.25;

    // Set default margin berdasarkan metode pembayaran
    marginPersen = paymentMethod == PaymentMethod.kprSyariah
        ? marginSyariah
        : marginDeveloper;
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    final result = selectedModel != null
        ? controller.compute(
            model: selectedModel!,
            method: paymentMethod,
            tanpaDp: tanpaDp,
            diskonNominal: diskonNominal,
            diskonPersen: diskonPersen,
            tenorYears: tenor,
            marginPersen: marginPersen,
          )
        : null;

    print(
      '💾 Cached KPR Calculators for margins: Syariah: $marginSyariah, Developer: $marginDeveloper',
    );

    return Obx(() {
      final cardColor = themeController.isDarkMode
          ? Colors.grey[900]
          : AppColors.white;

      final textColor = themeController.isDarkMode
          ? Colors.white
          : Colors.black;
      return Scaffold(
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Kalkulator - 60%
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 17.0,
                    horizontal: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Card(
                          elevation: 0,
                          color: cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ListView(
                              children: [
                                Text(
                                  'mortgage_simulation'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'mortgage_simulation_desc'.tr,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'model_and_type'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                // const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButton<HouseModel>(
                                    isExpanded: true,
                                    value: selectedModel,
                                    hint: Text(
                                      'choose_house_model'.tr,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    dropdownColor: cardColor,
                                    focusColor: cardColor,
                                    underline: const SizedBox(),
                                    items: houseModels.map((m) {
                                      return DropdownMenuItem(
                                        value: m,
                                        child: Text(
                                          '${m.displayName} - Rp. ${_formatCurrency(m.hargaCash.round())}',
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (v) =>
                                        setState(() => selectedModel = v),
                                  ),
                                ),
                                const SizedBox(height: 5),

                                Text(
                                  'payment_method'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<PaymentMethod>(
                                        title: Text(
                                          'sharia_bank_mortgage'.tr,
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        value: PaymentMethod.kprSyariah,
                                        groupValue: paymentMethod,
                                        onChanged: (v) {
                                          setState(() {
                                            paymentMethod = v!;
                                            tanpaDp = false;
                                            tenor = 5;
                                            marginPersen = marginSyariah;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<PaymentMethod>(
                                        title: Text(
                                          'developer_mortgage'.tr,
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        value: PaymentMethod.developer,
                                        groupValue: paymentMethod,
                                        onChanged: (v) {
                                          setState(() {
                                            paymentMethod = v!;
                                            tenor = 4;
                                            marginPersen = marginDeveloper;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'tenor'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 5),

                                Slider(
                                  value: tenor.toDouble(),
                                  divisions: tenorOptions.length - 1,
                                  min: tenorOptions.first.toDouble(),
                                  max: tenorOptions.last.toDouble(),
                                  label: '$tenor ${'years'.tr}',
                                  onChanged: (v) =>
                                      setState(() => tenor = v.round()),
                                ),
                                Center(
                                  child: Text(
                                    '$tenor ${'years'.tr}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),

                                // const SizedBox(height: 5),
                                if (paymentMethod == PaymentMethod.developer)
                                  Row(
                                    children: [
                                      Text(
                                        'no_down_payment'.tr,
                                        style: TextStyle(color: textColor),
                                      ),
                                      const SizedBox(width: 10),
                                      Switch(
                                        value: tanpaDp,
                                        onChanged: (v) =>
                                            setState(() => tanpaDp = v),
                                      ),
                                    ],
                                  ),

                                // const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // === Kolom DP ===
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'DP',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                          Container(
                                            width: double
                                                .infinity, // <-- biar ikut lebar Expanded
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: themeController.isDarkMode
                                                  ? Colors.grey[800]
                                                  : Colors.grey[200],
                                            ),
                                            child: Text(
                                              selectedModel == null
                                                  ? 'choose_house_model_first'
                                                        .tr
                                                  : 'Rp ${_formatCurrency(controller.calculateDp(harga: selectedModel!.hargaCash.toDouble(), method: paymentMethod, tanpaDp: tanpaDp).round())}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // const SizedBox(width: 12),

                                    // === Kolom Margin (%) ===
                                    Expanded(
                                      flex: 1,
                                      child: Offstage(
                                        offstage: true,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Margin (%)',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                                fontSize: 9,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width: double.infinity,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Margin %',
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12,
                                                      ),
                                                ),
                                                keyboardType:
                                                    TextInputType.numberWithOptions(
                                                      decimal: true,
                                                    ),
                                                style: TextStyle(
                                                  color: textColor,
                                                ),
                                                controller:
                                                    TextEditingController(
                                                      text: marginPersen
                                                          .toString(),
                                                    ),
                                                onChanged: (v) {
                                                  double? val = double.tryParse(
                                                    v,
                                                  );
                                                  if (val != null) {
                                                    setState(
                                                      () => marginPersen = val,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // === Kolom Margin KPR  ===
                                    Expanded(
                                      flex: 1,
                                      child: Offstage(
                                        offstage: true,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'mortgage_margin'.tr,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color:
                                                    themeController.isDarkMode
                                                    ? Colors.grey[800]
                                                    : Colors.grey[200],
                                              ),
                                              child: Text(
                                                selectedModel == null ||
                                                        result == null
                                                    ? 'choose_house_model_first'
                                                          .tr
                                                    : 'Rp ${_formatCurrency(result.marginKpr.round())}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                Text(
                                  'discount'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          Container(
                                            height: 35,
                                            child: TextField(
                                              controller: _diskonRpController,
                                              enabled: diskonPersen == null,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8,
                                                    ),
                                                labelText:
                                                    '${'discount'.tr} (Rp)',
                                                border:
                                                    const OutlineInputBorder(),
                                                suffixIcon:
                                                    diskonNominal != null
                                                    ? IconButton(
                                                        icon: const Icon(
                                                          Icons.close,
                                                        ),
                                                        onPressed: () {
                                                          _diskonRpController
                                                              .clear();
                                                          setState(() {
                                                            diskonNominal =
                                                                null;
                                                          });
                                                        },
                                                      )
                                                    : null,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                color:
                                                    themeController.isDarkMode
                                                    ? Colors.grey
                                                    : Colors.black,
                                              ),
                                              onChanged: (v) {
                                                String cleaned = v.replaceAll(
                                                  '.',
                                                  '',
                                                );
                                                double? val = double.tryParse(
                                                  cleaned,
                                                );
                                                if (val != null) {
                                                  setState(() {
                                                    diskonNominal = val;
                                                    diskonPersen = null;
                                                  });
                                                  _diskonRpController
                                                      .value = TextEditingValue(
                                                    text: rupiahFormat.format(
                                                      val,
                                                    ),
                                                    selection:
                                                        TextSelection.collapsed(
                                                          offset: rupiahFormat
                                                              .format(val)
                                                              .length,
                                                        ),
                                                  );
                                                } else if (v.isEmpty) {
                                                  setState(
                                                    () => diskonNominal = null,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          Container(
                                            height: 35,
                                            child: TextField(
                                              controller:
                                                  _diskonPersenController,
                                              enabled: diskonNominal == null,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8,
                                                    ),
                                                labelText:
                                                    '${'discount'.tr} (%)',
                                                border:
                                                    const OutlineInputBorder(),
                                                suffixIcon: diskonPersen != null
                                                    ? IconButton(
                                                        icon: const Icon(
                                                          Icons.close,
                                                        ),
                                                        onPressed: () {
                                                          _diskonPersenController
                                                              .clear();
                                                          setState(() {
                                                            diskonPersen = null;
                                                          });
                                                        },
                                                      )
                                                    : null,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                color:
                                                    themeController.isDarkMode
                                                    ? Colors.grey
                                                    : Colors.black,
                                              ),
                                              onChanged: (v) => setState(() {
                                                diskonPersen =
                                                    (v.trim().isEmpty)
                                                    ? null
                                                    : double.tryParse(v.trim());
                                                if (diskonPersen != null)
                                                  diskonNominal = null;
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // const SizedBox(height: 8),
                      if (selectedModel != null && result != null)
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              color: cardColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Angsuran / Bulan',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        'Rp ${(diskonNominal != null || diskonPersen != null) ? _formatCurrency(result.cicilanBulananSetelahDiskon.round()) : _formatCurrency(result.cicilanBulanan.round())}',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      if (diskonNominal != null ||
                                          diskonPersen != null)
                                        Column(
                                          children: [
                                            Text(
                                              'Rp ${_formatCurrency(result.totalPembayaran.round())}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.red,
                                                decorationThickness: 2,
                                                color: textColor,
                                              ),
                                            ),
                                            Text(
                                              'Rp ${_formatCurrency(result.hargaSetelahDiskon.round())}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        Text(
                                          'Rp ${_formatCurrency(result.totalPembayaran.round())}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Panel Kanan - Tabel Angsuran
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 8.0,
                  ),
                  child: Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: DefaultTabController(
                      length: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          children: [
                            Material(
                              color: cardColor,
                              child: TabBar(
                                labelColor: textColor,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: Colors.green.shade700,
                                tabs: [
                                  Tab(text: 'summary'.tr),
                                  Tab(text: 'installment_table'.tr),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  SingleChildScrollView(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${'terms_n_conditions'.tr}:',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...List.generate(
                                          _ringkasanList.length,
                                          (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 4,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${index + 1}. ',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          themeController
                                                              .isDarkMode
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      _ringkasanList[index].tr,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            themeController
                                                                .isDarkMode
                                                            ? Colors.grey
                                                            : Colors.black,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        selectedModel == null || result == null
                                        ? Center(
                                            child: Text(
                                              'Pilih model & hitung terlebih dahulu',
                                              style: TextStyle(
                                                color:
                                                    themeController.isDarkMode
                                                    ? Colors.grey
                                                    : Colors.black,
                                              ),
                                            ),
                                          )
                                        : _buildScheduleTable(
                                            result,
                                            themeController,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatCurrency(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    int cnt = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]);
      cnt++;
      if (cnt == 3 && i != 0) {
        buf.write('.');
        cnt = 0;
      }
    }
    final rev = buf.toString().split('').reversed.join();
    return rev;
  }

  Widget _buildScheduleTable(
    CalculatorResult result,
    ThemeController themeController,
  ) {
    final schedule = result.scheduleTable;
    final startLabel = schedule.first['label'];
    final endLabel = schedule.last['label'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Periode: $startLabel - $endLabel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: DataTable(
                border: TableBorder.all(color: Colors.grey, width: 1),
                columnSpacing: 16,
                columns: const [
                  DataColumn(
                    label: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Angsuran',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sisa Hutang',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: schedule
                    .map(
                      (r) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              '${r['no']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Rp ${_formatCurrency((r['angsuran'] as num).toDouble().round())}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Rp ${_formatCurrency((r['sisaHutang'] as num).toDouble().round())}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final List<String> _ringkasanList = [
  'terms_one',
  'terms_two',
  'terms_three',
  'terms_four',
  'terms_five',
  'terms_six',
  'terms_seven',
  'terms_eight',
  'terms_nine',
  'terms_ten',
  'terms_eleven',
  'terms_twelve',
];
