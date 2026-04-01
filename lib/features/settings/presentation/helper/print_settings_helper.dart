import 'dart:convert';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:quikservnew/features/settings/domain/parameters/save_printersettings_request.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PrintSettingsHelper {
  Future<void> initBluetooth({
    required ValueNotifier<String> selectedPrinterType,
    required ValueNotifier<bool> enableKotPrint,
    required TextEditingController kotStatusController,
    required TextEditingController connectedDeviceController,
    required TextEditingController connectedKOTDeviceController,
    required Function(List<BluetoothInfo>, int, String, String) onLoaded,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedDevice = prefs.getString('bt_device_name') ?? '';
    final savedSecondDevice =
        prefs.getString('selectedSecondPrinterName') ?? '';
    String kotStatus = prefs.getString('KOT_status') ?? '';
    String printerType = prefs.getString('printerType') ?? '';

    if (printerType.isEmpty) {
      printerType = 'Wifi';
    }

    if (printerType.toLowerCase() == 'wifi') {
      selectedPrinterType.value = 'wifi';
    } else {
      selectedPrinterType.value = 'bluetooth';
    }

    if (kotStatus == '1') {
      enableKotPrint.value = true;
    } else {
      enableKotPrint.value = false;
    }

    kotStatusController.text = kotStatus;

    if (savedDevice.isNotEmpty) {
      connectedDeviceController.text = savedDevice;
    }

    if (savedSecondDevice.isNotEmpty) {
      connectedKOTDeviceController.text = savedSecondDevice;
    }

    final devices = await PrintBluetoothThermal.pairedBluetooths;
    final selectedSeconds = prefs.getInt('print_gap') ?? 2;

    onLoaded(devices, selectedSeconds, kotStatus, printerType);
  }

  Future<void> fetchPrinterSettings({
    required ValueNotifier<String> selectedPrinterType,
    required ValueNotifier<String> selectedPaperSize,
    required ValueNotifier<bool> showAddress,
    required ValueNotifier<bool> showPhone,
    required ValueNotifier<int> fontSizeNotifier,
    required ValueNotifier<double> widthValue,
    required ValueNotifier<double> heightValue,
    required TextEditingController companyFontSizeController,
    required Function(
      String? paperSize,
      String companyNameFontSize,
      String printerType,
      bool stCompanyAddressStatus,
      bool stCompanyPhoneStatus,
    )
    onLoaded,
  }) async {
    String? paperSize = await SharedPreferenceHelper()
        .loadSelectedPrinterSize();
    String companyNameFontSize =
        (await SharedPreferenceHelper().fetchCompanyNameFontSize()) ?? '';
    String printerType = '';
    final loadedPrinterType = await SharedPreferenceHelper().fetchPrinterType();
    if (loadedPrinterType.isNotEmpty) {
      printerType = loadedPrinterType;
      selectedPrinterType.value = loadedPrinterType.toLowerCase() == 'wifi'
          ? 'wifi'
          : 'bluetooth';
    }

    if (paperSize != null && paperSize.isNotEmpty) {
      selectedPaperSize.value = paperSize;
    }

    bool stCompanyAddressStatus =
        (await SharedPreferenceHelper().fetchCompanyAddressInPrintStatus()) ??
        false;
    bool stCompanyPhoneStatus =
        (await SharedPreferenceHelper().fetchCompanyPhoneInPrintStatus()) ??
        false;

    showAddress.value = stCompanyAddressStatus;
    showPhone.value = stCompanyPhoneStatus;

    if (companyNameFontSize.isNotEmpty) {
      companyFontSizeController.text = companyNameFontSize;
      fontSizeNotifier.value = int.tryParse(companyNameFontSize) ?? 18;
    }

    final fetchedLogoHeight = await SharedPreferenceHelper().fetchLogoHeight();
    final fetchedLogoWidth = await SharedPreferenceHelper().fetchLogoWidth();

    widthValue.value = fetchedLogoWidth ?? 80;
    heightValue.value = fetchedLogoHeight ?? 80;

    onLoaded(
      paperSize,
      companyNameFontSize,
      printerType,
      stCompanyAddressStatus,
      stCompanyPhoneStatus,
    );
  }

  Future<List<String>> fetchPrinters({
    required TextEditingController ipController,
  }) async {
    final stIpAddress = 'http://${ipController.text.trim()}/printers';
    final response = await http.get(Uri.parse(stIpAddress));

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load printers');
    }
  }

  Future<void> printToTwoPrinters({
    required String macAddress,
    required String name,
    required String printerName,
    required TextEditingController connectedDeviceController,
    required TextEditingController connectedKOTDeviceController,
    required ValueNotifier<bool> changeMainPrinter,
    required ValueNotifier<bool> changeKitchenPrinter,
    required Function({
      required bool deviceListStatus,
      required bool deviceListKOTStatus,
    })
    onStateUpdate,
  }) async {
    final bytes = await generateTicket();

    if (printerName == 'Main') {
      await PrintBluetoothThermal.disconnect;
      final connected = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );

      if (connected) {
        await PrintBluetoothThermal.writeBytes(bytes);
        await Future.delayed(const Duration(milliseconds: 500));
        await PrintBluetoothThermal.disconnect;
      }

      connectedDeviceController.text = name;
      changeMainPrinter.value = false;

      onStateUpdate(deviceListStatus: false, deviceListKOTStatus: false);

      await SharedPreferenceHelper().saveSelectedPrinter(macAddress);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('bt_device_name', name);
      await prefs.setString('bt_device_mac', macAddress);
    }

    if (printerName == 'Kitchen') {
      final connected = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );

      if (connected) {
        await PrintBluetoothThermal.writeBytes(bytes);
        await PrintBluetoothThermal.disconnect;
      }

      connectedKOTDeviceController.text = name;
      changeKitchenPrinter.value = false;

      onStateUpdate(deviceListStatus: false, deviceListKOTStatus: false);

      await SharedPreferenceHelper().saveSelectedSecondPrinter(macAddress);
      await SharedPreferenceHelper().saveSelectedSecondPrinterName(name);
    }
  }

  Future<void> saveSettings({
    required BuildContext context,
    required ValueNotifier<bool> enableKotPrint,
    required ValueNotifier<String> selectedPrinterType,
    required ValueNotifier<String> selectedPaperSize,
    required ValueNotifier<int> fontSizeNotifier,
    required ValueNotifier<bool> showAddress,
    required ValueNotifier<bool> showPhone,
    required ValueNotifier<double> heightValue,
    required ValueNotifier<double> widthValue,
    required TextEditingController kotStatusController,
    required TextEditingController companyFontSizeController,
    required TextEditingController footerController,
    required TextEditingController ipController,
    required int selectedSeconds,
    required String? selectedMainPrinter,
    required String? selectedKitchenPrinter,
    required Function(String kotStatus, String printerType, String? paperSize)
    onLoaded,
  }) async {
    String kotStatus = enableKotPrint.value ? '1' : '0';
    kotStatusController.text = kotStatus;

    String printerType = selectedPrinterType.value == 'wifi'
        ? 'Wifi'
        : 'Bluetooth';
    String? paperSize = selectedPaperSize.value;
    companyFontSizeController.text = fontSizeNotifier.value.toString();

    await SharedPreferenceHelper().savePrinterType(printerType);
    await SharedPreferenceHelper().saveSelectedPrinterSize(paperSize);
    await SharedPreferenceHelper().saveCompanyNameFontSize(
      companyFontSizeController.text,
    );
    await SharedPreferenceHelper().setKOTStatus(kotStatusController.text);
    await SharedPreferenceHelper().setPrintDelayForKot(selectedSeconds);
    await SharedPreferenceHelper().saveCompanyAddressInPrintStatus(
      showAddress.value,
    );
    await SharedPreferenceHelper().saveCompanyPhoneInPrintStatus(
      showPhone.value,
    );
    await SharedPreferenceHelper().saveLogoHeight(heightValue.value);
    await SharedPreferenceHelper().saveLogoWidth(widthValue.value);
    await SharedPreferenceHelper().saveDescriptionPrint(footerController.text);

    context.read<SettingsCubit>().savePrinterSettingsToServer(
      SavePrinterSettingsRequest(
        printType: printerType,
        mainPrinter: selectedMainPrinter ?? '',
        kitchenPrinter: selectedKitchenPrinter ?? '',
        paperSize: paperSize,
        kitchenPrintStatus: kotStatusController.text,
        printFooterText: "",
        ipAddressWithPort: "",
        branchId: 1,
        createdUser: 1,
        mainBluettothPrinterId: 0,
        kitchenBluetoothPrinterId: 0,
        mainBluetoothPrinterName: '',
        kitchenBluetoothPrinterName: '',
        companyDescription: '',
        printInvoiceKotDelay: '',
        logoheight: '',
        logowidth: '',
        companyAddressVisible: '',
        companyPhonenoVisible: '',
        companyNameFontSize: '',
        kotPrintStatus: '',
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings saved')));
    onLoaded(kotStatus, printerType, paperSize);
  }

  Future<List<int>> generateTicket() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    return generator.text(
          'Test Print',
          styles: const PosStyles(align: PosAlign.center),
        ) +
        generator.cut();
  }
}

class AboutUsHelper {
  /// EMAIL
  Future<void> openEmail() async {
    final Uri email = Uri(scheme: 'mailto', path: 'support@quikserv.app');

    await launchUrl(email, mode: LaunchMode.externalApplication);
  }

  /// WHATSAPP
  Future<void> openWhatsApp() async {
    final Uri whatsapp = Uri.parse("https://wa.me/917592909990");

    await launchUrl(whatsapp, mode: LaunchMode.externalApplication);
  }

  /// CALL
  Future<void> makeCall() async {
    final Uri phone = Uri.parse("tel:+917592909990");

    await launchUrl(phone, mode: LaunchMode.externalApplication);
  }

  /// WEBSITE
  Future<void> openWebsite() async {
    final Uri website = Uri.parse("https://www.quikserv.app");

    await launchUrl(website, mode: LaunchMode.externalApplication);
  }
}
