import 'package:app_bemau/firebase/firebase_options.dart';
import 'package:app_bemau/providers/autenticacion.dart';
import 'package:app_bemau/providers/bodeguero.dart';
import 'package:app_bemau/providers/repartidor.dart';
import 'package:app_bemau/screens/autenticacion/login_screen.dart';
import 'package:app_bemau/screens/bodeguero/home_screen.dart';
import 'package:app_bemau/screens/bodeguero/paquetes_screen.dart';
import 'package:app_bemau/screens/bodeguero/scanear_qr_screen.dart';
import 'package:app_bemau/screens/repartidor/entregar_screen.dart';
import 'package:app_bemau/screens/repartidor/home_screen.dart';
import 'package:app_bemau/screens/repartidor/scanear_qr_screen.dart';
import 'package:app_bemau/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AutenticacionProvider()),
        ChangeNotifierProvider(create: (_) => BodegueroProvider()),
        ChangeNotifierProvider(create: (_) => RepartidorProvider())
      ],
      builder: (context, child) => 
        MaterialApp(
          title: 'Bemau',
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color(0xff374FCB),
              background: Color(0xfff4f5fa),
              onPrimary: Colors.white,
            ),
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15)
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff374FCB),
                foregroundColor: Colors.white,
              )
            )
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.nombre,
          routes: {
            SplashScreen.nombre:(context) => SplashScreen(),
            LoginScreen.nombre: (context) => LoginScreen(),
            HomeBodegeroScreenn.nombre: (context) => HomeBodegeroScreenn(),
            ScanearQrBodegueroScreen.nombre: (context) => ScanearQrBodegueroScreen(),
            PaquetesBodegueroScreen.nombre: (context) => PaquetesBodegueroScreen(),
            HomeRepartidorScreen.nombre:(context) => HomeRepartidorScreen(),
            ScanearQrRepartidorScreen.nombre: (context) => ScanearQrRepartidorScreen(),
            EntregarRepartidorScreen.nombre:(context) => EntregarRepartidorScreen()
          },
        )
    );
  }
}
