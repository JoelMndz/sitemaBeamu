import 'package:app_bemau/constants/estados.dart';
import 'package:app_bemau/model/envio.dart';
import 'package:app_bemau/providers/bodeguero.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:app_bemau/utils/fecha.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaquetesBodegueroScreen extends StatefulWidget {
  static String nombre = '/bodeguero/paquetes';
  const PaquetesBodegueroScreen({ Key? key }) : super(key: key);

  @override
  _PaquetesBodegueroScreenState createState() => _PaquetesBodegueroScreenState();
}

class _PaquetesBodegueroScreenState extends State<PaquetesBodegueroScreen> {
  late Responsive responsive;
  late TextTheme textTheme;
  late ColorScheme colorScheme;
  
  @override
  void initState() {
    super.initState();
    Provider.of<BodegueroProvider>(context,listen: false).obtenerEnvios(context);
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive(context);
    colorScheme = Theme.of(context).colorScheme;
    textTheme =  Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text('Paquetes en la Oficina'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: _cardsEnvios(context),
      ),
    );
  }

  _cardsEnvios(BuildContext context){
    final repartidorProvider = context.watch<BodegueroProvider>();
    final envios = repartidorProvider.envios;
    return envios
      .map((x) => Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Card(
          elevation: 3,
          child: ListTile(
            title: Text("Guía ${x.guia}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Estado: ${x.estados.last.estado == Estados.pendiente.name ? 'Pendiente de envíar a su destino' : 'Recibido el ${formaterarFechaUTC(x.estados.last.fecha)}'}"),
                Text("Cliente: ${x.cliente.nombres} ${x.cliente.apellidos}")
              ]
            ),
          ),
        ),
      ))
      .toList();
  }
}