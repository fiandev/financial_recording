import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core.dart';

class CardWallet extends StatelessWidget {
  const CardWallet({super.key, required this.controller});
  final DashboardController controller;

  // Helper untuk format compact (K, M, B, T)
  // String _formatCompact(int value) {
  //   if (value >= 1000000000000) {
  //     return "${NumberFormat("#,##0.##", "id").format(value / 1000000000000)}T";
  //   } else if (value >= 1000000000) {
  //     return "${NumberFormat("#,##0.##", "id").format(value / 1000000000)}M";
  //   } else if (value >= 1000000) {
  //     return "${NumberFormat("#,##0.##", "id").format(value / 1000000)}Jt";
  //   }

  //   return NumberFormat.decimalPattern('id').format(value);
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Back card - Lowest opacity + Border for contrast
        Transform.translate(
          offset: const Offset(0, 20),
          child: Container(
            width: MediaQuery.of(context).size.width - 120,
            height: 180,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
        ),

        // Middle card - Medium opacity
        Transform.translate(
          offset: const Offset(0, 10),
          child: Container(
            width: MediaQuery.of(context).size.width - 90,
            height: 180,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
        ),

        // Front card - Main Gradient & Glow
        Container(
          width: MediaQuery.of(context).size.width,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                primaryColor,
                Color.lerp(primaryColor, Colors.black, 0.2) ?? primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circle 1 (Big)
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),

              // Decorative circle 2 (Small)
              Positioned(
                right: -10,
                top: 80,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
              ),

              // Decorative circle 3 (Bottom Left)
              Positioned(
                left: -30,
                bottom: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              // Content
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Total Balance",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Obx(
                                  () => IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      controller.isObscured.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        controller.isObscured.toggle(),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            controller.isObscured.value
                                ? "Rp ••••••••"
                                : "Rp ${NumberFormat.decimalPattern('id').format(controller.balance.value)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
