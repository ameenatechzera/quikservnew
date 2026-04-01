import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/save_paymentvoucher_parameter.dart';
import 'package:quikservnew/features/paymentVoucher/presentation/bloc/payment_cubit.dart';

class PaymentScreenHelper {
  bool validationForSave({
    required TextEditingController dateController,
    required TextEditingController paymentModeController,
    required TextEditingController amountController,
  }) {
    bool validStatus = true;
    String? stDateSelected = dateController.text.toString();
    if (stDateSelected.toString().isEmpty) {
      validStatus = false;
      Fluttertoast.showToast(
        msg: "Pls Select Date..!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (paymentModeController.text.toString().isEmpty) {
      validStatus = false;
      Fluttertoast.showToast(
        msg: "Pls Select Mode of Payment..!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (amountController.text.toString().isEmpty) {
      validStatus = false;
      Fluttertoast.showToast(
        msg: "Pls Add Amount..!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      validStatus = true;
    }

    return validStatus;
  }

  String getDateTime() {
    String formattedDate = "";
    try {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      formattedDate = formatter.format(now);
    } catch (e) {
      e.toString();
    }
    return formattedDate;
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);
    return formattedDate;
  }

  Future<void> selectDate({
    required BuildContext context,
    required DateTime? initialDate,
    required Function(DateTime pickedDate) onDateSelected,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void onSavePressed({
    required BuildContext context,
    required bool isSaving,
    required TextEditingController dateController,
    required TextEditingController paymentModeController,
    required TextEditingController amountController,
    required String selectedOption,
    required String selectedledgerId,
    required String stCashLedgerId,
    required String stBankLedgerId,
    //required Function(String) setStLedgerId,
  }) {
    if (isSaving) return;

    final saveStatus = PaymentScreenHelper().validationForSave(
      dateController: dateController,
      paymentModeController: paymentModeController,
      amountController: amountController,
    );
    if (!saveStatus) return;
    // String stLedgerId = '';
    // if (selectedOption == 'Cash') stLedgerId = stCashLedgerId;
    // if (selectedOption == 'Bank') stLedgerId = stBankLedgerId;

    final receiptDate = dateController.text.toString();

    if (amountController.text.isEmpty ||
        selectedOption.isEmpty ||
        selectedOption.isEmpty ||
        selectedledgerId.isEmpty ||
        receiptDate.isEmpty) {
      Fluttertoast.showToast(
        msg: "Enter All Fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    final request = SavePaymentVoucherParameter(
      branchId: 1,
      voucherType: 'Payment Voucher',
      yearId: 0,
      date: '2026-02-09',
      ledgerId: int.parse(selectedledgerId),
      narration: 'fff',
      totalAmount: double.parse(amountController.text),
      costCentreId: 0,
      referenceNo: '',
      referenceDate: '',
      postedStatus: 0,
      postedBy: '',
      postedDate: '',
      exchangeRate: 0,
      exchangeDate: '',
      createdUser: '',
      paymentDetails: [
        SavePaymentDetail(
          ledgerId: int.parse(selectedledgerId),
          amount: double.parse(amountController.text),
          currencyConversionId: 0,
          chequeNo: '',
          chequeDate: '',
          lineIndex: 0,
          narration: '',
        ),
      ],
      partyDetails: [
        SavePartyDetail(
          date: '2026-02-09',
          againstVoucherType: '',
          againstVoucherNo: '',
          referenceType: '',
          amount: double.parse(amountController.text),
          creditPeriod: 0,
          currencyConversionId: 0,
          referenceNo: '',
          billAmount: double.parse(amountController.text),
        ),
      ],
    );

    context.read<PaymentCubit>().savePaymentVoucher(request);
  }
}
