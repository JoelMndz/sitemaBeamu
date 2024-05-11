import 'package:app_bemau/providers/autenticacion.dart';
import 'package:app_bemau/providers/repartidor.dart';
import 'package:app_bemau/screens/repartidor/scanear_qr_screen.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeRepartidorScreen extends StatefulWidget {
  static String nombre = "/repartidor/home";
  const HomeRepartidorScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeRepartidorScreen> {
  late Responsive responsive;
  late TextTheme textTheme;
  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();
    Provider.of<RepartidorProvider>(context, listen: false).obtenerEnvios(context);
  }

  @override
  Widget build(BuildContext context){
    responsive = Responsive(context);
    colorScheme = Theme.of(context).colorScheme;
    textTheme =  Theme.of(context).textTheme;
    final autenticacionProvider = context.read<AutenticacionProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text('Paquetes por entregar'),
        actions: [
          IconButton(
            onPressed: () => autenticacionProvider.cerrarSesion(context),             
            icon: Icon(Icons.logout)
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: _cardsEnvios(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.pushNamed(context, ScanearQrRepartidorScreen.nombre),
        child: Icon(Icons.qr_code_scanner_outlined, size: responsive.widthPercentage(9),)
      ),
    );
  }

  _cardsEnvios(BuildContext context){
    final repartidorProvider = context.watch<RepartidorProvider>();
    final envios = repartidorProvider.envios;
    return envios
      .map((x) => Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Card(
          elevation: 3,
          child: ListTile(
            onTap: ()=> repartidorProvider.navegarHaciaEntrega(context, x),
            title: Text(x.destinatario.nombre),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dirección: ${x.destinatario.direccion}"),
                Text("Celular: ${x.destinatario.celular}")
              ]
            ),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
        ),
      ))
      .toList();
  }
}