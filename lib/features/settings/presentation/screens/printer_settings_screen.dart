import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterSettingsContent extends StatefulWidget {
  final String companyName;
  const PrinterSettingsContent({super.key, required this.companyName});

  @override
  State<PrinterSettingsContent> createState() => _PrinterSettingsContentState();
}

class _PrinterSettingsContentState extends State<PrinterSettingsContent> {
  String printerType = 'Wifi';
  String? paperSize = '2 inch';

  String companyNameFontSize = '';
  bool st_companyAdressStatus = false;
  bool st_companyPhoneStatus = false;
  bool deviceListStatus = false;

  final TextEditingController ipController = TextEditingController(
    text: '192.168.1.40:5000',
  );

  final TextEditingController connectedDeviceController = TextEditingController(
    text: 'Not connected',
  );

  final List<String> printerTypesList = ['Wifi', 'Bluetooth'];
  final List<String> blPrinterTypes = ['2 inch', '3 inch', 'No print'];

  //print settings

  final _companyNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  //final _phoneController = TextEditingController();
  final _companyFontSizeController = TextEditingController(text: "18");
  bool isPhoneEnabled = false;
  bool isAddressEnabled = false;

  double logoWidth = 80;
  double logoHeight = 80;

  List<BluetoothInfo> bluetoothDevices = [];
  String connectedMac = '';
  bool bluetoothDeviceChanged = false;

  // Dummy WiFi printer lists
  final List<String> printersList = [
    'MainPrinter_1',
    'MainPrinter_2',
    'MainPrinter_3',
  ];
  final List<String> printersKitchenList = [
    'KitchenPrinter_1',
    'KitchenPrinter_2',
    'KitchenPrinter_3',
  ];
  String? selectedMainPrinter;
  String? selectedKitchenPrinter;

  @override
  void initState() {
    super.initState();
    selectedMainPrinter = printersList.first;
    selectedKitchenPrinter = printersKitchenList.first;
    _companyNameController.text = widget.companyName;

    fetchPrinterSettings();

    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDevice = prefs.getString('bt_device_name') ?? '';

    if (savedDevice.isNotEmpty) {
      connectedDeviceController.text = savedDevice;
    }

    final devices = await PrintBluetoothThermal.pairedBluetooths;
    setState(() {
      bluetoothDevices = devices;
    });
  }

  Future<void> _connectAndPrint(String mac, String name) async {
    await SharedPreferenceHelper().saveSelectedPrinter(mac);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connecting... Please wait')));

    await PrintBluetoothThermal.disconnect;

    final connected = await PrintBluetoothThermal.connect(
      macPrinterAddress: mac,
    );

    if (!connected) {
      _onBluetoothFailed();
      return;
    }

    final bytes = await _generateTicket();
    final result = await PrintBluetoothThermal.writeBytes(bytes);

    if (result) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('bt_device_name', name);
      await prefs.setString('bt_device_mac', mac);

      bluetoothDeviceChanged = true;
      connectedMac = mac;

      setState(() {
        connectedDeviceController.text = name;
        deviceListStatus = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Printer connected successfully')),
      );
    } else {
      _onBluetoothFailed();
    }
  }

  void _onBluetoothFailed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bt_device_name');
    await prefs.remove('bt_device_mac');

    bluetoothDeviceChanged = false;
    connectedMac = '';

    setState(() {
      connectedDeviceController.text = 'Not connected';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Printer connection failed')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CommonAppBar(title: "Print Settings"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _printSettingsCard(),
              _printerTypeCard(),
              printerType == 'Bluetooth' ? _bluetoothUi() : _wifiUi(),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _printerTypeCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Printer Type',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: printerTypesList.map((t) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: t,
                        groupValue: printerType,
                        onChanged: (v) => setState(() => printerType = v!),
                      ),
                      Text(t),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _printSettingsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 Row 1 — Company Name + Font Size
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _companyNameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Company Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _companyFontSizeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Font Size",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔹 Row 2 — Company Address + Checkbox
            Row(
              children: [
                Expanded(child: Text('Company Address')),
                const SizedBox(width: 10),

                Checkbox(
                  value: isAddressEnabled,
                  onChanged: (value) {
                    setState(() {
                      isAddressEnabled = value ?? false;
                    });
                  },
                ),
              ],
            ),

            // const SizedBox(height: 8),

            /// 🔹 Row 3 — Company Phone + Checkbox
            Row(
              children: [
                Expanded(child: Text('Company Phone No')),
                const SizedBox(width: 10),
                Checkbox(
                  value: isPhoneEnabled,
                  onChanged: (value) {
                    setState(() {
                      isPhoneEnabled = value ?? false;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔹 Row 4 — Logo Preview + Size Controls
            /// 🔹 Row 4 — Logo Preview + Size Controls (Column Layout)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: logoWidth,
                    height: logoHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "LOGO",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Width Slider
                Row(
                  children: [
                    const Text("Width"),
                    Expanded(
                      child: Slider(
                        value: logoWidth,
                        min: 40,
                        max: 200,
                        onChanged: (value) {
                          setState(() => logoWidth = value);
                        },
                      ),
                    ),
                  ],
                ),

                /// Height Slider
                Row(
                  children: [
                    const Text("Height"),
                    Expanded(
                      child: Slider(
                        value: logoHeight,
                        min: 40,
                        max: 200,
                        onChanged: (value) {
                          setState(() => logoHeight = value);
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text("Description"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: _descriptionController,
                        // readOnly: true,
                        decoration: const InputDecoration(
                          // labelText: "Company Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// --------- BLUETOOTH SECTION ----------
  Widget _bluetoothUi() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: blPrinterTypes.map((t) {
                return RadioListTile(
                  value: t,
                  groupValue: paperSize,
                  onChanged: (v) => setState(() => paperSize = v!),
                  title: Text(t),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Change Printer',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Switch(
                        value: deviceListStatus,
                        onChanged: (v) => setState(() => deviceListStatus = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _connectedDeviceBox(),
                  if (deviceListStatus) _deviceList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectedDeviceBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.print, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Connected Device',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  connectedDeviceController.text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceList() {
    return Column(
      children: [
        const SizedBox(height: 14),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Available Printers',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: bluetoothDevices.isEmpty
              ? const Center(child: Text('No printers found'))
              : ListView.builder(
                  itemCount: bluetoothDevices.length,
                  itemBuilder: (context, i) {
                    final d = bluetoothDevices[i];
                    return ListTile(
                      leading: const Icon(Icons.bluetooth, color: Colors.blue),
                      title: Text(d.name),
                      subtitle: Text(d.macAdress),
                      trailing: IconButton(
                        icon: const Icon(Icons.link, color: Color(0xFFFF8A00)),
                        onPressed: () => _connectAndPrint(d.macAdress, d.name),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// --------- WIFI SECTION (UNCHANGED) ----------
  Widget _wifiUi() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Text(
                  'Printer settings',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: ipController,
              decoration: InputDecoration(
                hintText: "e.g. 192.168.1.40:5000",
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMainPrinter,
              decoration: const InputDecoration(
                labelText: "Select Main Printer",
                border: OutlineInputBorder(),
              ),
              items: printersList
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => selectedMainPrinter = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedKitchenPrinter,
              decoration: const InputDecoration(
                labelText: "Select Kitchen Printer",
                border: OutlineInputBorder(),
              ),
              items: printersKitchenList
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => selectedKitchenPrinter = v),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Add Group Printer",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.add, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: () async {
          print('logoWidth $logoWidth');
          print('logoHeight $logoHeight');
          Navigator.pop(context);

          print('paperSize $paperSize');
          await SharedPreferenceHelper().saveSelectedPrinterSize(paperSize!);
          await SharedPreferenceHelper().saveCompanyNameFontSize(
            _companyFontSizeController.text.toString(),
          );
          await SharedPreferenceHelper().saveCompanyAddressInPrintStatus(
            isAddressEnabled,
          );
          await SharedPreferenceHelper().saveCompanyPhoneInPrintStatus(
            isPhoneEnabled,
          );

          await SharedPreferenceHelper().saveLogoHeight(logoHeight);
          await SharedPreferenceHelper().saveLogoWidth(logoWidth);
          await SharedPreferenceHelper().saveDescriptionPrint(
            _descriptionController.text.toString(),
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Settings saved')));
        },
        child: const Text('Save'),
      ),
    );
  }

  Future<void> fetchPrinterSettings() async {
    paperSize = await (SharedPreferenceHelper().loadSelectedPrinterSize());
    companyNameFontSize = (await (SharedPreferenceHelper()
        .fetchCompanyNameFontSize()))!;
    st_companyAdressStatus = (await SharedPreferenceHelper()
        .fetchCompanyAddressInPrintStatus())!;
    st_companyPhoneStatus = (await SharedPreferenceHelper()
        .fetchCompanyPhoneInPrintStatus())!;
    if (st_companyPhoneStatus) {
      isPhoneEnabled = true;
    }
    if (st_companyAdressStatus) {
      isAddressEnabled = true;
    }
    if (companyNameFontSize.isNotEmpty) {
      _companyFontSizeController.text = companyNameFontSize;
    }
    logoHeight = (await SharedPreferenceHelper().fetchLogoHeight())!;
    logoWidth = (await SharedPreferenceHelper().fetchLogoWidth())!;
  }
}

Future<List<int>> _generateTicket() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  return generator.text(
        'Test Print',
        styles: const PosStyles(align: PosAlign.center),
      ) +
      generator.cut();
}
