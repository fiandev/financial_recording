import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_recording/core.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());
    final double appBarHeight = AppBar().preferredSize.height;
    final profileController = Get.put(ProfileController());

    return Obx(() {
      return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: Text(
            "Dompet",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const ProfileView());
              },
              icon: Icon(
                Icons.settings,
                color: profileController.isDarkMode.value
                    ? Colors.black54
                    : Colors.white,
                size: 32.0,
              ),
            ),
          ],
          backgroundColor: primaryColor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - appBarHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(44.0),
              topRight: Radius.circular(44.0),
            ),
            color: profileController.isDarkMode.value
                ? Colors.black87
                : Colors.white,
          ),
          child: _buildWalletList(controller, profileController),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn_add_wallet",
          onPressed: () {
            Get.to(() => const FormWalletView());
          },
          backgroundColor: primaryColor,
          child: Icon(
            Icons.add,
            color: profileController.isDarkMode.value
                ? Colors.black54
                : Colors.white,
          ),
        ),
      );
    });
  }

  Widget _buildWalletList(
    WalletController controller,
    ProfileController profileController,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: controller.wallets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final wallet = controller.wallets[index];
        final List<Color> colors = wallet.gradientColors;
        return _buildWalletCard(
          wallet: wallet,
          name: wallet.name,
          balance: wallet.balance,
          todayExpense: wallet.todayExpense ?? 0,
          gradient: colors,
          index: index,
          controller: controller,
          profileController: profileController,
        );
      },
    );
  }

  Widget _buildWalletCard({
    required WalletModel wallet,
    required String name,
    required int balance,
    required int todayExpense,
    required List<Color> gradient,
    required int index,
    required WalletController controller,
    required ProfileController profileController,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              // View Wallet Detail
              Get.to(() => WalletDetailView(wallet: wallet));
            },
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: profileController.isDarkMode.value
                          ? Colors.black26
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: profileController.isDarkMode.value
                          ? Colors.black12
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: profileController.isDarkMode.value
                                  ? Colors.black54
                                  : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Active",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rp ${_formatCurrency(balance)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  todayExpense < 0
                                      ? Icons.trending_down
                                      : Icons.trending_up,
                                  color: todayExpense < 0
                                      ? Colors.red
                                      : Colors.green,
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Hari ini: Rp ${_formatCurrency(todayExpense)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
