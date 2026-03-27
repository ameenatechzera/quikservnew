import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/settings/presentation/helper/print_settings_helper.dart';
import 'package:quikservnew/features/settings/presentation/screens/bill_preview_screen.dart';
import 'package:quikservnew/features/settings/presentation/widgets/print_settings_widget.dart';

import '../widgets/print_settings_ui_widgets.dart';

class PrintSettingsScreen extends StatefulWidget {
  final String companyName;
  const PrintSettingsScreen({super.key, required this.companyName});

  @override
  State<PrintSettingsScreen> createState() => _PrintSettingsScreenState();
}

class _PrintSettingsScreenState extends State<PrintSettingsScreen> {
  final ValueNotifier<bool> showAddress = ValueNotifier(false);
  final ValueNotifier<bool> showPhone = ValueNotifier(false);
  final ValueNotifier<double> widthValue = ValueNotifier(80);
  final ValueNotifier<double> heightValue = ValueNotifier(80);
  final ValueNotifier<String> selectedPrinterType = ValueNotifier('wifi');
  final ValueNotifier<bool> enableKotPrint = ValueNotifier(false);
  final ValueNotifier<String> selectedPaperSize = ValueNotifier('2 inch');
  final ValueNotifier<bool> changeMainPrinter = ValueNotifier(false);
  final ValueNotifier<bool> changeKitchenPrinter = ValueNotifier(false);
  final ValueNotifier<int> fontSizeNotifier = ValueNotifier(18);
  int selectedSeconds = 2;
  final List<int> delayOptions = [1, 2, 3, 4, 5, 6, 7, 8];
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController footerController = TextEditingController();
  final TextEditingController ipController = TextEditingController(
    text: '192.168.1.40:5000',
  );
  final TextEditingController connectedDeviceController = TextEditingController(
    text: 'Not connected',
  );
  final TextEditingController connectedKOTDeviceController =
      TextEditingController(text: 'Not connected');

  final TextEditingController kotStatusController = TextEditingController();
  final TextEditingController companyFontSizeController = TextEditingController(
    text: '18',
  );
  List<BluetoothInfo> bluetoothDevices = [];
  List<String> printersList = [];
  String? selectedMainPrinter;
  String? selectedKitchenPrinter;
  String printerType = 'Wifi';
  String? paperSize = '2 inch';
  String kotStatus = '0';
  bool deviceListStatus = false;
  bool deviceListKOTStatus = false;
  String companyNameFontSize = '';
  bool stCompanyAddressStatus = false;
  bool stCompanyPhoneStatus = false;
  @override
  void initState() {
    super.initState();
    companyNameController.text = widget.companyName;
    PrintSettingsHelper().fetchPrinterSettings(
      selectedPrinterType: selectedPrinterType,
      selectedPaperSize: selectedPaperSize,
      showAddress: showAddress,
      showPhone: showPhone,
      fontSizeNotifier: fontSizeNotifier,
      widthValue: widthValue,
      heightValue: heightValue,
      companyFontSizeController: companyFontSizeController,
      onLoaded:
          (
            fetchedPaperSize,
            fetchedCompanyNameFontSize,
            fetchedPrinterType,
            fetchedCompanyAddressStatus,
            fetchedCompanyPhoneStatus,
          ) {
            setState(() {
              paperSize = fetchedPaperSize;
              companyNameFontSize = fetchedCompanyNameFontSize;
              if (fetchedPrinterType.isNotEmpty) {
                printerType = fetchedPrinterType;
              }
              stCompanyAddressStatus = fetchedCompanyAddressStatus;
              stCompanyPhoneStatus = fetchedCompanyPhoneStatus;
            });
          },
    );

    PrintSettingsHelper().initBluetooth(
      selectedPrinterType: selectedPrinterType,
      enableKotPrint: enableKotPrint,
      kotStatusController: kotStatusController,
      connectedDeviceController: connectedDeviceController,
      connectedKOTDeviceController: connectedKOTDeviceController,
      onLoaded: (devices, seconds, kot, type) {
        setState(() {
          bluetoothDevices = devices;
          selectedSeconds = seconds;
          kotStatus = kot;
          printerType = type;
        });
      },
    );
  }

  @override
  void dispose() {
    showAddress.dispose();
    showPhone.dispose();
    widthValue.dispose();
    heightValue.dispose();
    selectedPrinterType.dispose();
    enableKotPrint.dispose();
    selectedPaperSize.dispose();
    changeMainPrinter.dispose();
    changeKitchenPrinter.dispose();
    fontSizeNotifier.dispose();
    companyNameController.dispose();
    footerController.dispose();
    ipController.dispose();
    connectedDeviceController.dispose();
    connectedKOTDeviceController.dispose();
    kotStatusController.dispose();
    companyFontSizeController.dispose();
    super.dispose();
  }

  Future<void> _refreshWifiPrinters() async {
    try {
      final list = await PrintSettingsHelper().fetchPrinters(
        ipController: ipController,
      );
      setState(() {
        printersList = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to fetch printers: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: AppColors.theme,
        title: const Text('Print Settings'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BillPreviewScreen();
                    },
                  ),
                );
              },
              icon: Icon(Icons.play_arrow, color: Colors.black),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bill Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            /// Company Name
            const Text("Company Name"),
            const SizedBox(height: 6),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: TextField(
                controller: companyNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  //hintText: "Nema Solution",
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// Font Size
            const Text("Font Size"),
            const SizedBox(height: 8),
            FontSize(fontSizeNotifier: fontSizeNotifier),

            /// Switches
            switchRow("Show Company Address", showAddress),
            switchRow("Show Company PhoneNo", showPhone),

            /// Logo + Sliders
            LogoSliders(widthValue: widthValue, heightValue: heightValue),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Print Delay", style: TextStyle(fontSize: 15)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: DropdownButton<int>(
                    value: selectedSeconds,
                    underline: const SizedBox(),
                    items: delayOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text("$value sec"),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedSeconds = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
            const Text("Footer Description"),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: TextField(
                controller: footerController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      "Ex.Thank You For Choosing Restaurant\nWe Truly Appreciate Your Visit.\nHave A Great Day!",
                ),
              ),
            ),
            const Text(
              "Printer Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ValueListenableBuilder<String>(
                valueListenable: selectedPrinterType,
                builder: (context, printerTypeValue, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Printer Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          radioOption(
                            title: "WiFi",
                            value: "wifi",
                            groupValue: printerTypeValue,
                            onTap: () {
                              selectedPrinterType.value = "wifi";
                              printerType = 'Wifi';
                            },
                          ),
                          const SizedBox(width: 28),
                          radioOption(
                            title: "Bluetooth",
                            value: "bluetooth",
                            groupValue: printerTypeValue,
                            onTap: () {
                              selectedPrinterType.value = "bluetooth";
                              printerType = 'Bluetooth';
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      ValueListenableBuilder<bool>(
                        valueListenable: enableKotPrint,
                        builder: (context, value, _) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 80.0),
                            child: printerSwitchRow("Enable KOT Print", value, (
                              newValue,
                            ) {
                              enableKotPrint.value = newValue;
                              kotStatus = newValue ? '1' : '0';
                              kotStatusController.text = kotStatus;
                            }),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      if (printerTypeValue == 'wifi') ...[
                        const Text(
                          "Printer Settings",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),

                        textFieldBox(
                          controller: ipController,
                          hint: "192.929.1.20.838383",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _refreshWifiPrinters,
                          ),
                        ),
                        const SizedBox(height: 10),

                        dropdownBox(
                          topLabel: "Select Main Printer",
                          value: selectedMainPrinter ?? "Main Printer",
                          items: printersList,
                          onChanged: (v) {
                            setState(() {
                              selectedMainPrinter = v;
                            });
                          },
                        ),
                        const SizedBox(height: 12),

                        dropdownBox(
                          topLabel: "Select Kitchen Printer",
                          value: selectedKitchenPrinter ?? "Kitchen Printer",
                          items: printersList,
                          onChanged: (v) {
                            setState(() {
                              selectedKitchenPrinter = v;
                            });
                          },
                        ),
                      ],

                      if (printerTypeValue == 'bluetooth') ...[
                        const Text(
                          "Paper Size",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),

                        ValueListenableBuilder<String>(
                          valueListenable: selectedPaperSize,
                          builder: (context, paperSizeValue, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                radioOption(
                                  title: "2 Inch",
                                  value: "2inch",
                                  groupValue: paperSizeValue,
                                  onTap: () {
                                    selectedPaperSize.value = "2inch";
                                    paperSize = "2 inch";
                                  },
                                ),
                                const SizedBox(height: 14),
                                radioOption(
                                  title: "3 Inch",
                                  value: "3inch",
                                  groupValue: paperSizeValue,
                                  onTap: () {
                                    selectedPaperSize.value = "3inch";
                                    paperSize = "3 inch";
                                  },
                                ),

                                const SizedBox(height: 14),
                                radioOption(
                                  title: "No Print",
                                  value: "noprint",
                                  groupValue: paperSizeValue,
                                  onTap: () {
                                    selectedPaperSize.value = "noprint";
                                    paperSize = "No print";
                                  },
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Select Main Printer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<bool>(
                          valueListenable: changeMainPrinter,
                          builder: (context, value, _) {
                            return Column(
                              children: [
                                printerSwitchRow("Change Printer", value, (
                                  newValue,
                                ) {
                                  changeMainPrinter.value = newValue;
                                  setState(() {
                                    deviceListStatus = newValue;
                                  });
                                }),
                                const SizedBox(height: 18),
                                connectedDeviceBox(
                                  connectedDeviceController.text,
                                ),
                                if (deviceListStatus) ...[
                                  const SizedBox(height: 12),
                                  deviceListWidget(
                                    bluetoothDevices: bluetoothDevices,
                                    printerName: 'Main',
                                    onConnect: (mac, name) async {
                                      await PrintSettingsHelper()
                                          .printToTwoPrinters(
                                            macAddress: mac,
                                            name: name,
                                            printerName: 'Main',
                                            connectedDeviceController:
                                                connectedDeviceController,
                                            connectedKOTDeviceController:
                                                connectedKOTDeviceController,
                                            changeMainPrinter:
                                                changeMainPrinter,
                                            changeKitchenPrinter:
                                                changeKitchenPrinter,
                                            onStateUpdate:
                                                ({
                                                  required bool
                                                  deviceListStatus,
                                                  required bool
                                                  deviceListKOTStatus,
                                                }) {
                                                  setState(() {
                                                    this.deviceListStatus =
                                                        deviceListStatus;
                                                    this.deviceListKOTStatus =
                                                        deviceListKOTStatus;
                                                  });
                                                },
                                          );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Printer connected successfully',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'Select Kitchen Printer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<bool>(
                          valueListenable: changeKitchenPrinter,
                          builder: (context, value, _) {
                            return Column(
                              children: [
                                printerSwitchRow("Change Printer", value, (
                                  newValue,
                                ) {
                                  changeKitchenPrinter.value = newValue;
                                  setState(() {
                                    deviceListKOTStatus = newValue;
                                  });
                                }),
                                const SizedBox(height: 18),
                                connectedDeviceBox(
                                  connectedKOTDeviceController.text,
                                ),
                                if (deviceListKOTStatus) ...[
                                  const SizedBox(height: 12),
                                  deviceListWidget(
                                    bluetoothDevices: bluetoothDevices,
                                    printerName: 'Kitchen',
                                    onConnect: (mac, name) async {
                                      await PrintSettingsHelper()
                                          .printToTwoPrinters(
                                            macAddress: mac,
                                            name: name,
                                            printerName: 'Kitchen',
                                            connectedDeviceController:
                                                connectedDeviceController,
                                            connectedKOTDeviceController:
                                                connectedKOTDeviceController,
                                            changeMainPrinter:
                                                changeMainPrinter,
                                            changeKitchenPrinter:
                                                changeKitchenPrinter,
                                            onStateUpdate:
                                                ({
                                                  required bool
                                                  deviceListStatus,
                                                  required bool
                                                  deviceListKOTStatus,
                                                }) {
                                                  setState(() {
                                                    this.deviceListStatus =
                                                        deviceListStatus;
                                                    this.deviceListKOTStatus =
                                                        deviceListKOTStatus;
                                                  });
                                                },
                                          );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Printer connected successfully',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4AD00),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await PrintSettingsHelper().saveSettings(
                    context: context,
                    enableKotPrint: enableKotPrint,
                    selectedPrinterType: selectedPrinterType,
                    selectedPaperSize: selectedPaperSize,
                    fontSizeNotifier: fontSizeNotifier,
                    showAddress: showAddress,
                    showPhone: showPhone,
                    heightValue: heightValue,
                    widthValue: widthValue,
                    kotStatusController: kotStatusController,
                    companyFontSizeController: companyFontSizeController,
                    footerController: footerController,
                    ipController: ipController,
                    selectedSeconds: selectedSeconds,
                    selectedMainPrinter: selectedMainPrinter,
                    selectedKitchenPrinter: selectedKitchenPrinter,
                    onLoaded: (kot, type, size) {
                      kotStatus = kot;
                      printerType = type;
                      paperSize = size;
                    },
                  );
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
