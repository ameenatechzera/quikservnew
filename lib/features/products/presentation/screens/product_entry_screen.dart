import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/domain/parameters/save_product_parameter.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/products/presentation/widgets/category_bottomsheet.dart';
import 'package:quikservnew/features/products/presentation/widgets/group_bottomsheet.dart';
import 'package:quikservnew/features/products/presentation/widgets/unit_bottomsheet.dart';
import 'package:quikservnew/features/products/presentation/widgets/vat_bottomsheet.dart';

class ProductEntryUiOnlyScreen extends StatefulWidget {
  final String pageFrom; // keep for your navigation later
  final FetchProductDetails? product; // or ProductEntity
  // if not empty -> Update button text
  const ProductEntryUiOnlyScreen({
    super.key,
    required this.pageFrom,
    required this.product,
  });
  bool get isEdit => product != null;
  @override
  State<ProductEntryUiOnlyScreen> createState() =>
      _ProductEntryUiOnlyScreenState();
}

class _ProductEntryUiOnlyScreenState extends State<ProductEntryUiOnlyScreen> {
  // ---------- CONTROLLERS ----------
  final _productNameController = TextEditingController();
  final _productNameSecondController = TextEditingController();
  final _categoryController = TextEditingController(text: "Select Category");
  final _groupController = TextEditingController(text: "Select Group");
  final _unitController = TextEditingController(text: "Select Unit");
  final _barcodeController = TextEditingController();
  final _purchaseRateController = TextEditingController();
  final _conversionRateController = TextEditingController(text: "1");
  final _salesRateController = TextEditingController();
  final _mrpController = TextEditingController();
  final _taxController = TextEditingController(text: "Select Tax %");
  // ✅ SELECTED IDS (from bottomsheet)
  int? categoryId;
  int? groupId;
  int? baseUnitId;
  int? vatId;
  // ---------- UI STATES ----------
  bool isVegSelected = false;
  bool isNonVegSelected = true;

  bool taxEnabled = true; // "Tax" option in your UI
  bool inclusiveSelected = true; // Tax type
  bool exclusiveSelected = false;

  bool showMultiBarcode = false;
  File? pickedImage; // UI only (no crop/upload)
  // ✅ active must be bool (as your model)
  bool isActive = true;

  final Map<String, FocusNode> _focusNodes = {
    'productName': FocusNode(),
    'productSecondName': FocusNode(),
    'categoryName': FocusNode(),
    'groupName': FocusNode(),
    'unitName': FocusNode(),
    'productBarcode': FocusNode(),
    'purchaseRate': FocusNode(),
    'conversionRate': FocusNode(),
    'salesRate': FocusNode(),
    'mrp': FocusNode(),
    'taxRate': FocusNode(),
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.product != null) {
      final p = widget.product!;

      // ---- TEXT FIELDS ----
      _productNameController.text = p.productName ?? "";
      _productNameSecondController.text = p.productNameFL ?? "";
      _barcodeController.text = p.barcode ?? "";
      _purchaseRateController.text = p.purchaseRate?.toString() ?? "";
      _salesRateController.text = p.salesPrice?.toString() ?? "";
      _mrpController.text = p.mrp?.toString() ?? "";

      // ---- SELECTED IDS ----
      categoryId = p.categoryId;
      groupId = p.groupId;
      baseUnitId = p.unitId;
      vatId = p.vatId;

      // ---- DISPLAY NAMES ----
      _categoryController.text = p.categoryName ?? "Select Category";
      _groupController.text = p.groupName;
      _unitController.text = p.unitName ?? "Select Unit";
      _taxController.text = p.vatName ?? "Select Tax %";

      // ---- FLAGS ----
      taxEnabled = (p.vatId ?? 0) != 0;
      isActive = (p.isActive ?? 1) == 1;
    }
  }

  @override
  void dispose() {
    for (final n in _focusNodes.values) {
      n.dispose();
    }
    _productNameController.dispose();
    _productNameSecondController.dispose();
    _categoryController.dispose();
    _groupController.dispose();
    _unitController.dispose();
    _barcodeController.dispose();
    _purchaseRateController.dispose();
    _conversionRateController.dispose();
    _salesRateController.dispose();
    _mrpController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  Widget get height10 => const SizedBox(height: 10);
  // void _snack(String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  // }

  bool _validate() {
    final productName = _productNameController.text.trim();
    if (productName.isEmpty) {
      showAnimatedToast(
        context,
        message: "Product Name is required",
        isSuccess: false,
      );
      return false;
    }

    if (categoryId == null) {
      showAnimatedToast(
        context,
        message: "Category is required",
        isSuccess: false,
      );
      return false;
    }

    if (groupId == null) {
      showAnimatedToast(
        context,
        message: "Geoup is required",
        isSuccess: false,
      );
      return false;
    }

    if (baseUnitId == null) {
      showAnimatedToast(context, message: "Unit is required", isSuccess: false);
      return false;
    }

    if (taxEnabled && (vatId == null)) {
      showAnimatedToast(context, message: "Vat is required", isSuccess: false);
      return false;
    }

    return true;
  }

  Future<void> _onSavePressed() async {
    if (!_validate()) return;

    final productName = _productNameController.text.trim();
    final productSecondName = _productNameSecondController.text.trim();

    final purchaseRate =
        double.tryParse(_purchaseRateController.text.trim()) ?? 0;

    final conversionRate =
        double.tryParse(_conversionRateController.text.trim()) ?? 1;

    final salesRate = double.tryParse(_salesRateController.text.trim()) ?? 0;
    final mrp = double.tryParse(_mrpController.text.trim()) ?? 0;

    final List<ConversionDetail> conversionDetails = [
      ConversionDetail(
        unitId: baseUnitId!,
        barcode: _barcodeController.text.trim(),
        conversionRate: conversionRate,
        mrp: mrp,
        salesPrice: salesRate,
        branchId: 1,
      ),
    ];

    final request = ProductSaveRequest(
      productName: productName,
      productNameFL: productSecondName,
      baseUnitId: baseUnitId!,
      groupId: groupId!,
      categoryId: categoryId!,
      vatId: taxEnabled ? (vatId ?? 0) : 0,
      purchaseRate: purchaseRate,
      isActive: isActive,
      branchId: 1,
      descriptionStatus: 0,
      createdUser: 0,
      conversionDetails: conversionDetails,
    );
    final cubit = context.read<ProductCubit>();

    if (widget.isEdit) {
      cubit.updateProduct(int.parse(widget.product!.productCode!), request);
    } else {
      cubit.saveProduct(request);
    }
    // context.read<ProductCubit>().saveProduct(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductsState>(
      listener: (context, state) {
        if (state is SaveProductFailure) {
          showAnimatedToast(context, message: state.message, isSuccess: false);
        }

        if (state is SaveProductSuccess) {
          showAnimatedToast(
            context,
            message: 'Saved Successfully',
            isSuccess: true,
          );
          Navigator.pop(context, true); // ✅ go back after success
        }
        if (state is UpdateProductFailure) {
          showAnimatedToast(context, message: state.message, isSuccess: false);
        }
        if (state is UpdateProductSuccess) {
          showAnimatedToast(
            context,
            message: 'Updated Successfully',
            isSuccess: true,
          );
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        final isLoading =
            state is SaveProductLoading || state is UpdateProductLoading;
        return Scaffold(
          backgroundColor: AppColors.white,

          appBar: CommonAppBar(
            title: widget.isEdit ? "Update Product" : "Add Product",
          ),

          body: SingleChildScrollView(
            child: Container(
              color: AppColors.white,
              child: Column(
                children: [
                  // ------------------ CARD 1 : PRODUCT NAME ------------------
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _productNameController,
                              focusNode: _focusNodes['productName'],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                isCollapsed:
                                    !_focusNodes['productName']!.hasFocus &&
                                    _productNameController.text.isEmpty,
                                label: RichText(
                                  text: const TextSpan(
                                    text: "Product Name",
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: " *",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    controller: _productNameSecondController,
                                    focusNode: _focusNodes['productSecondName'],
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      isCollapsed:
                                          !_focusNodes['productSecondName']!
                                              .hasFocus &&
                                          _productNameSecondController
                                              .text
                                              .isEmpty,
                                      labelText: "Product Second Name",
                                      labelStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      // UI ONLY: no translate logic here
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 30,
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.text_fields,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          height10,
                        ],
                      ),
                    ),
                  ),

                  // ------------------ CARD 2 : CATEGORY + GROUP + FOOD TYPE ------------------
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        children: [
                          height10,

                          // Category with + icon
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showCategoryBottomSheet(
                                      context: context,
                                      categoryController: _categoryController,
                                      onSelected: (id, name) {
                                        setState(() {
                                          categoryId = id;
                                          _categoryController.text = name;
                                        });
                                      },
                                    );
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _categoryController,
                                      focusNode: _focusNodes['categoryName'],
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        isCollapsed:
                                            !_focusNodes['categoryName']!
                                                .hasFocus &&
                                            _categoryController.text.isEmpty,
                                        label: RichText(
                                          text: const TextSpan(
                                            text: "Category",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: " *",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        showCategoryBottomSheet(
                                          context: context,
                                          categoryController:
                                              _categoryController,
                                          onSelected: (id, name) {
                                            setState(() {
                                              categoryId = id;
                                              _categoryController.text = name;
                                            });
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.add, size: 20),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          height10,

                          // Group with + icon
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await showGroupBottomSheet(
                                      context: context,
                                      groupController: _groupController,
                                      onSelected: (id, name) {
                                        setState(() {
                                          groupId = id;
                                          _groupController.text = name;
                                        });
                                      },
                                    );
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _groupController,
                                      focusNode: _focusNodes['groupName'],
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        isCollapsed:
                                            !_focusNodes['groupName']!
                                                .hasFocus &&
                                            _groupController.text.isEmpty,
                                        label: RichText(
                                          text: const TextSpan(
                                            text: "Group",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: " *",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () async {
                                        await showGroupBottomSheet(
                                          context: context,
                                          groupController: _groupController,
                                          onSelected: (id, name) {
                                            setState(() {
                                              groupId = id;
                                              _groupController.text = name;
                                            });
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.add, size: 20),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Food Type row
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text("Food Type   "),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isVegSelected = true;
                                        isNonVegSelected = false;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.circle_fill,
                                          size: 14,
                                          color: isVegSelected
                                              ? AppColors.primary
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Veg.",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isNonVegSelected = true;
                                        isVegSelected = false;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.circle_fill,
                                          size: 14,
                                          color: isNonVegSelected
                                              ? AppColors.primary
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Non Veg.",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ------------------ CARD 3 : UNIT DETAILS ------------------
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        children: [
                          height10,
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Unit Details",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (showMultiBarcode)
                                  const Text(
                                    "1 Additional Barcodes",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await showUnitBottomSheet(
                                            context: context,
                                            unitController: _unitController,
                                            onSelected: (id, name) {
                                              setState(() {
                                                baseUnitId = id;
                                                _unitController.text = name;
                                              });
                                            },
                                          );
                                        },
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: _unitController,
                                            focusNode: _focusNodes['unitName'],
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              isCollapsed:
                                                  !_focusNodes['unitName']!
                                                      .hasFocus &&
                                                  _unitController.text.isEmpty,
                                              label: RichText(
                                                text: const TextSpan(
                                                  text: "Unit",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: " *",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.add,
                                              size: 20,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () async {
                                              await showUnitBottomSheet(
                                                context: context,
                                                unitController: _unitController,
                                                onSelected: (id, name) {
                                                  setState(() {
                                                    baseUnitId = id;
                                                    _unitController.text = name;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _barcodeController,
                                    focusNode: _focusNodes['productBarcode'],
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      isCollapsed:
                                          !_focusNodes['productBarcode']!
                                              .hasFocus &&
                                          _barcodeController.text.isEmpty,
                                      label: RichText(
                                        text: const TextSpan(
                                          text: "Barcode",
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: " *",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          height10,

                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _purchaseRateController,
                                    focusNode: _focusNodes['purchaseRate'],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      isCollapsed:
                                          !_focusNodes['purchaseRate']!
                                              .hasFocus &&
                                          _purchaseRateController.text.isEmpty,
                                      labelText: "Purchase Rate",
                                      labelStyle: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _conversionRateController,
                                    focusNode: _focusNodes['conversionRate'],
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      labelText: "Conversion Rate",
                                      labelStyle: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          height10,

                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _salesRateController,
                                    focusNode: _focusNodes['salesRate'],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      isCollapsed:
                                          !_focusNodes['salesRate']!.hasFocus &&
                                          _salesRateController.text.isEmpty,
                                      label: RichText(
                                        text: const TextSpan(
                                          text: "Sales Rate",
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: " *",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _mrpController,
                                    focusNode: _focusNodes['mrp'],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      labelText: "MRP",
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Multi barcodes (UI only)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Multi Barcodes"),
                                const SizedBox(width: 50),
                                InkWell(
                                  onTap: () {
                                    setState(
                                      () =>
                                          showMultiBarcode = !showMultiBarcode,
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ------------------ CARD 4 : TAX ------------------
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("Tax Status"),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => taxEnabled = false);
                                      vatId = null;
                                      _taxController.text = "Select Tax %";
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.circle_fill,
                                          size: 14,
                                          color: !taxEnabled
                                              ? AppColors.primary
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "No Tax",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => taxEnabled = true);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.circle_fill,
                                          size: 14,
                                          color: taxEnabled
                                              ? AppColors.primary
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Tax",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (taxEnabled) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  showVatBottomSheet(
                                    context: context,
                                    vatController: _taxController,
                                    onSelected: (id, name) {
                                      setState(() {
                                        vatId = id;
                                        _taxController.text = name;
                                      });
                                    },
                                  );
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _taxController,
                                    focusNode: _focusNodes['taxRate'],
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: "Tax Percentage",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Tax Type   "),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          inclusiveSelected = true;
                                          exclusiveSelected = false;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.circle_fill,
                                            size: 14,
                                            color: inclusiveSelected
                                                ? AppColors.primary
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Inclusive",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          exclusiveSelected = true;
                                          inclusiveSelected = false;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.circle_fill,
                                            size: 14,
                                            color: exclusiveSelected
                                                ? AppColors.primary
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Exclusive",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // ------------------ CARD 5 : IMAGE UPLOAD ------------------
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _uploaderCard(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ------------------ ADD / UPDATE BUTTON ------------------
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: _onSavePressed,
                        child: Text(
                          widget.isEdit ? "Update" : "Add",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: kIsWeb ? 380 : 180,
              height: 190,
              child: Center(
                child: pickedImage == null
                    ? Icon(
                        Icons.image,
                        size: 80,
                        color: Theme.of(context).highlightColor,
                      )
                    : Image.file(pickedImage!, fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -5,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: IconButton(
                onPressed: () async {
                  // UI only: fake pick (no image_picker)
                  // you can connect real image picker later
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
