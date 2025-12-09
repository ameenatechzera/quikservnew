class RegisterResponseResult {
  final int status;
  final bool error;
  final String messages;
  final List<CompanyModel> companyDetails;

  RegisterResponseResult({
    required this.status,
    required this.error,
    required this.messages,
    required this.companyDetails,
  });

  factory RegisterResponseResult.fromJson(Map<String, dynamic> json) {
    return RegisterResponseResult(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: json['messages'] ?? '',
      companyDetails:
          (json['company_details'] as List<dynamic>? ?? [])
              .map((e) => CompanyModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class CompanyModel {
  final int companyId;
  final String companyName;
  final String companyNameFL;
  final String address1;
  final String address2;
  final String address3;
  final String phone;
  final String email;
  final String? web;
  final String? currency;
  final String? currencySymbol;
  final String serialNumber;
  final String? databaseName;
  final String? vatNumber;
  final int vatEnable;
  final String? vatType;
  final int isVatIncluded;
  final String? expiryDate;
  final String? companyLogo;
  final int sale;
  final int receipt;
  final int payment;

  CompanyModel({
    required this.companyId,
    required this.companyName,
    required this.companyNameFL,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.phone,
    required this.email,
    required this.web,
    required this.currency,
    required this.currencySymbol,
    required this.serialNumber,
    required this.databaseName,
    required this.vatNumber,
    required this.vatEnable,
    required this.vatType,
    required this.isVatIncluded,
    required this.expiryDate,
    required this.companyLogo,
    required this.sale,
    required this.receipt,
    required this.payment,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      // NOTE: API has "CompanyId " (with space). Use exact key.
      companyId:
          json['CompanyId '] is int
              ? json['CompanyId ']
              : int.tryParse((json['CompanyId '] ?? '0').toString()) ?? 0,
      companyName: json['CompanyName'] ?? '',
      companyNameFL: json['CompanyNameFL'] ?? '',
      address1: json['Address1'] ?? '',
      address2: json['Address2'] ?? '',
      address3: json['Address3'] ?? '',
      phone: json['Phone'] ?? '',
      email: json['email'] ?? '',
      web: json['Web'],
      currency: json['Currency'],
      currencySymbol: json['CurrencySymbol'],
      // NOTE: API has "SerialNumber " (with space).
      serialNumber: json['SerialNumber '] ?? '',
      databaseName: json['DatabaseName'],
      vatNumber: json['VATNumber'],
      vatEnable: json['VatEnable'] ?? 0,
      vatType: json['VATType'],
      isVatIncluded: json['isVatIncluded'] ?? 0,
      expiryDate: json['ExpiryDate'],
      companyLogo: json['company_logo'],
      sale: json['sale'] ?? 0,
      receipt: json['receipt'] ?? 0,
      payment: json['payment'] ?? 0,
    );
  }
}
