class SaveSaleRequest {
  final String invoiceDate;
  final String invoiceTime;
  final int ledgerId;
  final double subTotal;
  final double discountAmount;
  final double vatAmount;
  final double grandTotal;
  final int cashLedgerId;
  final double cashAmount;
  final int cardLedgerId;
  final double cardAmount;
  final double creditAmount;
  final int tableId;
  final int? supplierId;
  final int cashierId;
  final int orderMasterId;
  final String billStatus;
  final String salesType;
  final int billTokenNo;
  final int createdUser;
  final int branchId;
  final double totalTax;
  final List<SaleDetail> salesDetails;

  SaveSaleRequest({
    required this.invoiceDate,
    required this.invoiceTime,
    required this.ledgerId,
    required this.subTotal,
    required this.discountAmount,
    required this.vatAmount,
    required this.grandTotal,
    required this.cashLedgerId,
    required this.cashAmount,
    required this.cardLedgerId,
    required this.cardAmount,
    required this.creditAmount,
    required this.tableId,
    this.supplierId,
    required this.cashierId,
    required this.orderMasterId,
    required this.billStatus,
    required this.salesType,
    required this.billTokenNo,
    required this.createdUser,
    required this.branchId,
    required this.totalTax,
    required this.salesDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "InvoiceDate": invoiceDate,
      "InvoiceTime": invoiceTime,
      "LedgerId": ledgerId,
      "SubTotal": subTotal,
      "DiscountAmount": discountAmount,
      "VatAmount": vatAmount,
      "GrandTotal": grandTotal,
      "CashLedgerId": cashLedgerId,
      "CashAmount": cashAmount,
      "CardLedgerID": cardLedgerId,
      "CardAmount": cardAmount,
      "creditAmount": creditAmount,
      "table_id": tableId,
      "supplierId": supplierId,
      "cashierId": cashierId,
      "orderMasterId": orderMasterId,
      "BillStatus": billStatus,
      "salesType": salesType,
      "billTokenNo": billTokenNo,
      "CreatedUser": createdUser,
      "branchId": branchId,
      "totalTax": totalTax,
      "SalesDetails": salesDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class SaleDetail {
  final String productCode;
  final String productName;
  final int qty;
  final int unitId;
  final double purchaseCost;
  final double salesRate;
  final double excludeRate;
  final double subtotal;
  final int vatId;
  final double vatAmount;
  final double totalAmount;
  final double conversionRate;

  SaleDetail({
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.unitId,
    required this.purchaseCost,
    required this.salesRate,
    required this.excludeRate,
    required this.subtotal,
    required this.vatId,
    required this.vatAmount,
    required this.totalAmount,
    required this.conversionRate,
  });

  Map<String, dynamic> toJson() {
    return {
      "ProductCode": productCode,
      "ProductName": productName,
      "Qty": qty,
      "UnitId": unitId,
      "PurchaseCost": purchaseCost,
      "SalesRate": salesRate,
      "ExcludeRate": excludeRate,
      "Subtotal": subtotal,
      "VatId": vatId,
      "VatAmount": vatAmount,
      "TotalAmount": totalAmount,
      "conversion_rate": conversionRate,
    };
  }
}
