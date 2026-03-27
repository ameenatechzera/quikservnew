import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/settings/presentation/widgets/print_settings_widget.dart';

//fontsize
class FontSize extends StatelessWidget {
  const FontSize({super.key, required this.fontSizeNotifier});

  final ValueNotifier<int> fontSizeNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: fontSizeNotifier,
      builder: (context, value, _) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 225, 223, 223),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              /// LEFT BUTTON
              InkWell(
                onTap: () {
                  if (fontSizeNotifier.value > 1) {
                    fontSizeNotifier.value--;
                  }
                },
                child: Container(
                  width: 50,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFEED677),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "−",
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.w500,
                        //color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              /// VALUE
              Expanded(
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              /// RIGHT BUTTON
              InkWell(
                onTap: () {
                  fontSizeNotifier.value++;
                },
                child: Container(
                  width: 50,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFEED677),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.add, size: 20)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//logosliders
class LogoSliders extends StatelessWidget {
  const LogoSliders({
    super.key,
    required this.widthValue,
    required this.heightValue,
  });

  final ValueNotifier<double> widthValue;
  final ValueNotifier<double> heightValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EFD5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ValueListenableBuilder2<double, double>(
            first: widthValue,
            second: heightValue,
            builder: (context, width, height, _) {
              return Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.theme,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                ),
                child: const Text("Logo"),
              );
            },
          ),
          const SizedBox(height: 16),

          /// Width
          Row(
            children: [
              const SizedBox(width: 50, child: Text("Width")),
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: widthValue,
                  builder: (context, value, _) {
                    return Slider(
                      min: 40,
                      max: 200,
                      value: value,
                      activeColor: AppColors.theme,
                      onChanged: (v) {
                        widthValue.value = v;
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          /// Height
          Row(
            children: [
              const SizedBox(width: 50, child: Text("Height")),
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: heightValue,
                  builder: (context, value, _) {
                    return Slider(
                      min: 40,
                      max: 200,
                      value: value,
                      activeColor: AppColors.theme,
                      onChanged: (v) {
                        heightValue.value = v;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
