import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/local_data_service.dart';
import 'repositories/jadwal_repository.dart';
import 'repositories/cucian_repository.dart';
import 'repositories/info_repository.dart';
import 'repositories/pengaturan_repository.dart';
import 'viewmodels/beranda_vm.dart';
import 'viewmodels/jadwal_vm.dart';
import 'viewmodels/checklist_vm.dart';
import 'viewmodels/info_vm.dart';
import 'viewmodels/pengaturan_vm.dart';
import 'views/pages/main_navigation_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LaundryKilatApp());
}

/// Root Widget aplikasi Laundry Kilat.
/// Mengonfigurasi arsitektur berlapis:
/// MultiProvider (Service -> Repository -> ViewModel) -> View.
class LaundryKilatApp extends StatelessWidget {
  const LaundryKilatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Lapisan Service (Sumber data lokal/API)
        ChangeNotifierProvider<LocalDataService>(
          create: (_) => LocalDataService(),
        ),

        // 2. Lapisan Repository (Satu pintu akses data)
        ChangeNotifierProxyProvider<LocalDataService, JadwalRepository>(
          create: (ctx) => JadwalRepository(ctx.read<LocalDataService>()),
          update: (ctx, service, prev) => prev ?? JadwalRepository(service),
        ),
        ChangeNotifierProxyProvider<LocalDataService, CucianRepository>(
          create: (ctx) => CucianRepository(ctx.read<LocalDataService>()),
          update: (ctx, service, prev) => prev ?? CucianRepository(service),
        ),
        ChangeNotifierProxyProvider<LocalDataService, InfoRepository>(
          create: (ctx) => InfoRepository(ctx.read<LocalDataService>()),
          update: (ctx, service, prev) => prev ?? InfoRepository(service),
        ),
        ChangeNotifierProxyProvider<LocalDataService, PengaturanRepository>(
          create: (ctx) => PengaturanRepository(ctx.read<LocalDataService>()),
          update: (ctx, service, prev) => prev ?? PengaturanRepository(service),
        ),

        // 3. Lapisan ViewModel (State layar & logika tampilan)
        ChangeNotifierProxyProvider2<JadwalRepository, CucianRepository, BerandaViewModel>(
          create: (ctx) => BerandaViewModel(
            jadwalRepo: ctx.read<JadwalRepository>(),
            cucianRepo: ctx.read<CucianRepository>(),
          ),
          update: (ctx, jadwalRepo, cucianRepo, prev) =>
              prev ??
              BerandaViewModel(
                jadwalRepo: jadwalRepo,
                cucianRepo: cucianRepo,
              ),
        ),
        ChangeNotifierProxyProvider<JadwalRepository, JadwalViewModel>(
          create: (ctx) => JadwalViewModel(
            repository: ctx.read<JadwalRepository>(),
          ),
          update: (ctx, repo, prev) =>
              prev ?? JadwalViewModel(repository: repo),
        ),
        ChangeNotifierProxyProvider<CucianRepository, ChecklistViewModel>(
          create: (ctx) => ChecklistViewModel(
            repository: ctx.read<CucianRepository>(),
          ),
          update: (ctx, repo, prev) =>
              prev ?? ChecklistViewModel(repository: repo),
        ),
        ChangeNotifierProxyProvider<InfoRepository, InfoViewModel>(
          create: (ctx) => InfoViewModel(
            repository: ctx.read<InfoRepository>(),
          ),
          update: (ctx, repo, prev) =>
              prev ?? InfoViewModel(repository: repo),
        ),
        ChangeNotifierProxyProvider<PengaturanRepository, PengaturanViewModel>(
          create: (ctx) => PengaturanViewModel(
            repository: ctx.read<PengaturanRepository>(),
          ),
          update: (ctx, repo, prev) =>
              prev ?? PengaturanViewModel(repository: repo),
        ),
      ],
      child: MaterialApp(
        title: 'Laundry Kilat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00668B), // Biru laut segar khas laundry
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F9FC),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 2,
            backgroundColor: Color(0xFFF7F9FC),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const MainNavigationPage(),
      ),
    );
  }
}
