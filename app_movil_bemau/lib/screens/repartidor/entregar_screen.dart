import 'dart:io';

import 'package:app_bemau/providers/repartidor.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:app_bemau/utils/fecha.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EntregarRepartidorScreen extends StatefulWidget {
  static String nombre = "/repartidor/entrega";
  const EntregarRepartidorScreen({ Key? key }) : super(key: key);

  @override
  _EntregarRepartidorScreenState createState() => _EntregarRepartidorScreenState();
}

class _EntregarRepartidorScreenState extends State<EntregarRepartidorScreen> {
  
  @override
  Widget build(BuildContext context) {
    final _repartidorProvider = context.watch<RepartidorProvider>();
    final responsive = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text('Detalle del envío'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.5),
        child: ListView(
          children: [
            crearFila(context, 'Código: ', _repartidorProvider.envio!.id),
            SizedBox(height: responsive.heightPercentage(1)),
            crearFila(context, 'Fecha Registro: ', formaterarFechaUTC(_repartidorProvider.envio!.fecha)),
            SizedBox(height: responsive.heightPercentage(1)),
            crearFila(context, 'Tipo: ', _repartidorProvider.envio!.tipo,),
            SizedBox(height: responsive.heightPercentage(1)),
            crearFila(context, 'Peso: ', '${_repartidorProvider.envio!.pesoKg} kg',),
            SizedBox(height: responsive.heightPercentage(1)),
            crearFila(context, 'Cliente: ', '${_repartidorProvider.envio!.cliente.nombres} ${_repartidorProvider.envio!.cliente.apellidos}'),
            SizedBox(height: responsive.heightPercentage(1)),
            crearFila(context, 'Destinatario: ', _repartidorProvider.envio!.destinatario.nombre),
            SizedBox(height: responsive.heightPercentage(1)),
            crearFila(context, 'Celular: ', _repartidorProvider.envio!.destinatario.celular),
            SizedBox(height: responsive.heightPercentage(1)),
            crearFila(context, 'Dirección: ', _repartidorProvider.envio!.destinatario.direccion),
            SizedBox(height: responsive.heightPercentage(1)),
            TextField(
              controller: _repartidorProvider.observacionController,
              decoration: InputDecoration(
                label: Text('Observación')
              ),
            ),
            _ImageUpload(),
            SizedBox(height: responsive.heightPercentage(2.5)),
            Container(
              width: responsive.widthPercentage(100),
              child: ElevatedButton(
                onPressed: _repartidorProvider.cargando ? null : ()=> _repartidorProvider.entregarPaquete(context), 
                child: _repartidorProvider.cargando ? 
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ) : 
                  Text('Entregar paquete',style: TextStyle(fontSize: 20),)
              ),
            ),
          ],
        ),
      ),
    );
  }

  crearFila(BuildContext context,String titulo, String valor){
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          titulo,
          style: textTheme.titleMedium,
        ),
        Expanded(
          child: Text(
            valor,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}

class _ImageUpload extends StatelessWidget {
  const _ImageUpload();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    final provider = context.watch<RepartidorProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.heightPercentage(2)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                )
              ),
              child: SizedBox(
                height: responsive.heightPercentage(20),
                child: Center(
                  child: provider.imagenURL == null ? 
                    Text('Subir imagen', style: texts.bodyLarge) :
                    Image.network(provider.imagenURL!)
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.widthPercentage(5)),
          ElevatedButton(
            onPressed: ()=> uploadImage(context),
            child: const Icon(Icons.upload)
          ),
        ],
      ),
    );
  }

  Future<void> uploadImage(BuildContext context) async {
    try {
      final provider = context.read<RepartidorProvider>();
      // Seleccionar imagen desde la galería
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile == null) return;

      // Obtener referencia al bucket de Firebase Storage
      final firebaseStorageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

      // Subir la imagen al bucket
      await firebaseStorageRef.putFile(File(pickedFile.path));

      // Obtener la URL de descarga
      provider.imagenURL = await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      
    }

  }
}