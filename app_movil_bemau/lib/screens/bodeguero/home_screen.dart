import 'package:app_bemau/constants/accionQr.dart';
import 'package:app_bemau/providers/autenticacion.dart';
import 'package:app_bemau/providers/bodeguero.dart';
import 'package:app_bemau/screens/bodeguero/paquetes_screen.dart';
import 'package:app_bemau/screens/bodeguero/scanear_qr_screen.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBodegeroScreenn extends StatelessWidget {
  static String nombre = "/bodeguero/home";
  late Responsive responsive;
  late TextTheme textTheme;
  late ColorScheme colorScheme;

  HomeBodegeroScreenn({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    responsive = Responsive(context);
    colorScheme = Theme.of(context).colorScheme;
    textTheme =  Theme.of(context).textTheme;
    final bodegueroProvider = context.read<BodegueroProvider>();
    final autenticacionProvider = context.read<AutenticacionProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text('Bemau'),
        actions: [
          IconButton(
            onPressed: () => autenticacionProvider.cerrarSesion(context),             
            icon: Icon(Icons.logout)
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            crearItem(context, 'Enviar paquete', ()=> bodegueroProvider.navegarHaciaScanQR(context, AccionesQR.enviar_paquete.name),Icons.qr_code_scanner),
            SizedBox(height: responsive.heightPercentage(2),),
            crearItem(context, 'Recibir paquete', ()=> bodegueroProvider.navegarHaciaScanQR(context, AccionesQR.recibir_paquete.name),Icons.qr_code_scanner),
            SizedBox(height: responsive.heightPercentage(2),),
            crearItem(context, 'Paquetes en la oficina', ()=> Navigator.pushNamed(context, PaquetesBodegueroScreen.nombre),Icons.local_post_office_outlined),
          ],
        ),
      )
    );
  }

  crearItem(BuildContext context, String titulo, Function() onTap, IconData icono){
    return Container(
      width: responsive.widthPercentage(50),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(titulo,
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.heightPercentage(1),),
                Icon(icono, size: responsive.heightPercentage(10),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}