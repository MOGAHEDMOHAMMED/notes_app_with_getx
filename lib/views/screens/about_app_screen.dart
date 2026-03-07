// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:notes_app_with_getx/core/l10n/app_localizations.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  final String appName = "دوّن";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.aboutApp,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 80,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
 
          // 2. محتوى الوصف
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // المقدمة
                  Text(
                    "$appName: مساحتك الرقمية لتوثيق الإبداع",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "في عالم متسارع تزدحم فيه الأفكار وتتلاشى اللحظات المهمة، يأتي $appName ليكون أكثر من مجرد أداة للكتابة؛ إنه رفيقك الذكي ومساعدك الشخصي لحفظ كل شاردة وواردة بأمان.",
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),

                  const SizedBox(height: 30),

                  // المميزات (استخدمنا كروتاً أنيقة)
                  _buildSectionTitle(context, "لماذا $appName استثنائي؟"),
                  const SizedBox(height: 15),

                  _buildFeatureCard(
                    context,
                    icon: Icons.sync_rounded,
                    title: "دورة حياة متكاملة",
                    description:
                        "نظام ذكي لإدارة الملاحظات: نشطة، مؤرشفة، وسلة مهملات لاستعادة ما حُذف بالخطأ.",
                    color: Colors.blueAccent,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.category_rounded,
                    title: "تنظيم بلا حدود",
                    description:
                        "نظام تصنيفات (Categories) مرن مع تمييز بالألوان لسهولة الوصول.",
                    color: Colors.orangeAccent,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.cloud_done_rounded,
                    title: "أمان ومزامنة سحابية",
                    description:
                        "حفظ لحظي لكل حرف تكتبه عبر سحابة آمنة، لتكمل عملك من أي جهاز وفي أي وقت.",
                    color: Colors.green,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.dark_mode_rounded,
                    title: "تجربة مستخدم مُلهمة",
                    description:
                        "واجهة عصرية تدعم الوضع الليلي واللغتين العربية والإنجليزية.",
                    color: Colors.purpleAccent,
                  ),

                  const SizedBox(height: 30),

                  // الخاتمة
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "$appName.. ليس مجرد تطبيق ملاحظات، بل هو الذاكرة الإضافية التي يمكنك الاعتماد عليها دائماً.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "الإصدار 1.0.0",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ودجت فرعي لعنوان القسم
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          height: 25,
          width: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ودجت فرعي لكرت الميزة
  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
