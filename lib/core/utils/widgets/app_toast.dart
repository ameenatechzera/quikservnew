// ✅ Right → Left Animated Curved Toast
import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

void showAnimatedToast(
  BuildContext context, {
  required String message,
  required bool isSuccess,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _ToastWidget(
      message: message,
      isSuccess: isSuccess,
      onEnd: () {
        entry.remove(); // remove after animation completes
      },
    ),
  );

  overlay.insert(entry);
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback onEnd;

  const _ToastWidget({
    required this.message,
    required this.isSuccess,
    required this.onEnd,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideIn;
  late final Animation<Offset> _slideOut;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      await _controller.reverse(); // trigger reverse animation
      widget.onEnd(); // remove overlay after slide out
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _controller.status == AnimationStatus.reverse
            ? _slideOut
            : _slideIn,
        child: Center(
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // Container(
                //   width: 34,
                //   height: 34,
                //   padding: const EdgeInsets.all(6),
                //   decoration: BoxDecoration(
                //     color: AppColors.theme.withOpacity(0.15),
                //     shape: BoxShape.circle,
                //   ),
                //   child: Image.asset(
                //     'assets/icons/quikserv_icon.png',
                //     fit: BoxFit.contain,
                //   ),
                // ),
                // const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: widget.isSuccess ? AppColors.green : AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  widget.isSuccess
                      ? Icons.check_circle_rounded
                      : Icons.error_rounded,
                  color: widget.isSuccess ? Colors.green : Colors.red,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
