import 'package:app_bemau/providers/autenticacion.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  static String nombre = '/';
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final autenticacionProvider = context.read<AutenticacionProvider>();
    autenticacionProvider.iniciarSesionAutomaticamente(context);
    final responsive = Responsive(context);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.jpg', width: responsive.widthPercentage(60)),
            SizedBox(height: responsive.heightPercentage(2),),
            CircularProgressIndicator()  
          ],
        )
      ),
    );
  }
}