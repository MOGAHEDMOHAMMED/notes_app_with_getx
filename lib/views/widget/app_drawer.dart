// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:get/get.dart';

import 'package:notes_app_with_getx/views/screens/show_category_notes.dart';
import '../../core/app_routes.dart';
import '../../controllers/notes_controller.dart';
import '../../controllers/auth_controller.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key, required this.currentScreen});
  String currentScreen;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final notesController = Get.find<NotesController>();

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildFancyHeader(context, 'appTitle'.tr),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: [
                //Show List of categories:
                _buildSectionTitle(context, 'category'.tr),
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey[800]!.withOpacity(0.5)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),

                    child: Obx(
                      () => ExpansionTile(
                        leading: _buildIconContainer(
                          Icons.category_rounded,
                          Colors.blue,
                        ),
                        title: Text(
                          'category'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        childrenPadding: EdgeInsets.zero,
                        children: [
                          _buildSubTile(
                            context,
                            title: 'update'.tr,
                            icon: Icons.edit_rounded,
                            onTap: () =>
                                Get.toNamed(AppRoutes.editCategoriesScreen),
                          ),
                          ...notesController.categories.map(
                            (cat) => ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.only(
                                left: 60,
                                right: 20,
                              ),
                              leading: const Icon(
                                Icons.label_outline,
                                size: 12,
                                color: Colors.amberAccent,
                              ),
                              title: Text(
                                cat.name,
                                style: const TextStyle(fontSize: 14),
                              ),
                              onTap: () {
                                // Get.back(); // close drawer
                                Get.to(
                                  () => ShowCategoryNotes(categoryModel: cat),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Show archived and deleted notes only if we are not already in them:
                //archived notes:
                if (currentScreen != AppRoutes.archivedNotesScreen) ...[
                  _buildDrawerItem(
                    context,
                    title: 'archivedNotesAppBar'.tr,
                    icon: Icons.archive_rounded,
                    color: Colors.orange,
                    onTap: () {
                     Get.back();
                      Get.toNamed(AppRoutes.archivedNotesScreen);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                //deleted notes:
                if (currentScreen != AppRoutes.deletedNotesScreen) ...[
                  _buildDrawerItem(
                    context,
                    title: 'deletedNoteAppBar'.tr,
                    icon: Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    onTap: () {
                      // Get.back(); // close drawer
                      Get.toNamed(AppRoutes.deletedNotesScreen);
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                //app  section(settings, about app, about developer):
                _buildSectionTitle(context, 'app'.tr),
                //settings Screen:
                _buildDrawerItem(
                  context,
                  title: 'setting'.tr,
                  icon: Icons.settings_rounded,
                  color: Colors.teal,
                  onTap: () => Get.toNamed(AppRoutes.settingsScreen),
                ),
                const SizedBox(height: 10),

                //about app screen:
                _buildDrawerItem(
                  context,
                  title: 'aboutApp'.tr,
                  icon: Icons.info_outline_rounded,
                  color: Colors.purple,
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                  onTap: () => Get.toNamed(AppRoutes.aboutAppScreen),
                ),
                const SizedBox(height: 10),

                //about developer screen:
                _buildDrawerItem(
                  context,
                  title: 'aboutDeveloper'.tr,
                  icon: Icons.code_rounded,
                  color: Colors.purple,
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                  onTap: () => Get.toNamed(AppRoutes.aboutDeveloperScreen),
                ),
              ],
            ),
          ),

          //logout button and version number at the bottom of the drawer:
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.black12 : Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
            ),
            child: Column(
              children: [
                _buildDrawerItem(
                  context,
                  title: 'logout'.tr,
                  icon: Icons.logout_rounded,
                  color: Colors.red,
                  isLogout: true,
                  onTap: () async {
                    await Get.find<AuthController>().signOut();
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  "v1.0.0",
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFancyHeader(BuildContext context, String appName) {
    final User? user = Get.find<AuthController>().currentUser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            appName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Tahoma",
            ),
          ),
          Text(
            "${'welcomeback'.tr}: ${user != null ? (user.displayName != null && user.displayName!.isNotEmpty ? user.displayName : user.email) : 'مستخدم'}",
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Widget? trailing,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: isLogout ? Colors.red.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              _buildIconContainer(icon, color),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isLogout
                        ? Colors.red
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isCategory = false,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 60, right: 20),
      leading: isCategory
          ? Icon(icon, size: 12, color: Colors.amberAccent)
          : Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
