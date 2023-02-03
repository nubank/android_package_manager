// ignore_for_file: avoid_print

import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    "Feature tests",
    () {
      final pm = AndroidPackageManager();
      test(
        "getInstalledApplications",
        () async {
          final applications = await pm.getInstalledApplications(
            flags: ApplicationInfoFlags(
              {PMFlag.getMetaData,},
            ),
          );
          print("BEGIN: getInstalledApplications",);
          print(
            applications?.map((e) => "App Name: ${e.name} | Package: ${e.packageName}",).join("\n"),
          );
          print("END: getInstalledApplications",);
          expect(applications?.isNotEmpty, true,);
        },
      );

      test(
        "getAllPermissionGroups",
        () async {
          final permissionGroups = await pm.getAllPermissionGroups(
            flags: PermissionGroupInfoFlags(provideMetaData: true,),
          );
          print("BEGIN: getAllPermissionGroups",);
          print(
            permissionGroups?.map(
              (e) => "${e.priority}: ${e.name} | ${e.packageName}",).join("\n",
            ),
          );
          print("END: getAllPermissionGroups",);
          expect(permissionGroups != null, true,);
        },
      );

      test(
        "getInstalledPackages",
        () async {
          final packages = await pm.getInstalledPackages(
            flags: PackageInfoFlags(
              {
                PMFlag.getMetaData,
                PMFlag.getPermissions,
                PMFlag.getReceivers,
                PMFlag.getServices,
                PMFlag.getProviders,
              },
            ),
          );
          print("BEGIN: getInstalledPackages",);
          print(
            packages?.map(
              (e) => "${e.packageName} | (${e.applicationInfo != null})\n\tAppInfo.name: ${e.applicationInfo?.name}\n\tRequested Permissions: ${e.requestedPermissions}",
            ).join("\n",),
          );
          print("END: getInstalledPackages",);
          expect(packages != null, true,);
        },
      );

      test(
        "getInstallerPackageName",
            () async {
          final installerPackageName = await pm.getInstallerPackageName(
            "com.google.android.youtube",
          );
          print(installerPackageName);
          expect(installerPackageName == null, true,);
        },
      );

      test(
        "getSystemAvailableFeatures",
        () async {
          final features = await pm.getSystemAvailableFeatures();
          print("BEGIN: getSystemAvailableFeatures",);
          print(
            features?.map(
              (e) => "${e.name} (${e.flags})",
            ).join("\n",),
          );
          print("END: getSystemAvailableFeatures",);
          expect(features != null, true,);
        },
      );

      test(
        "getSystemSharedLibraryNames",
        () async {
          final names = await pm.getSystemSharedLibraryNames();
          print("BEGIN: getSystemSharedLibraryNames",);
          print(names,);
          print("END: getSystemSharedLibraryNames",);
          expect(names != null, true,);
        },
      );

      test(
        "isSafeMode",
        () async {
          final isSafeMode = await pm.isSafeMode();
          print("BEGIN: isSafeMode",);
          print(isSafeMode,);
          print("END: isSafeMode",);
          expect(isSafeMode, false,);
        },
      );

      test(
        "openApp",
        () async {
          final applications = await pm.getInstalledApplications();
          assert(applications != null,);
          ApplicationInfo? cApp;
          for (var app in applications!) {
            // Modify search query here
            if (app.packageName?.contains("recorder",) == true) {
              cApp = app;
              break;
            }
          }
          expect(cApp != null, true,);
          expect(cApp?.packageName != null, true,);
          final packageName = cApp!.packageName!;
          print("Launching $packageName",);
          pm.openApp(packageName,);
        }
      );
    },
  );
}