import 'package:app_bemau/providers/repartidor.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:app_bemau/utils/fecha.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CargarPaquete extends StatefulWidget {
  const CargarPaquete({ Key? key }) : super(key: key);

  @override
  _CargarPaqueteState createState() => _CargarPaqueteState();
}

class _CargarPaqueteState extends State<CargarPaquete> {
    
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final textTheme = Theme.of(context).textTheme;
    final _repartidorProvider = context.watch<RepartidorProvider>();

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Datos del paquete', style: textTheme.titleLarge,),
                  ),              
                  IconButton(
                    onPressed: () => _repartidorProvider.cerrarModal(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: responsive.heightPercentage(2)),
              crearFila(context, 'Guía: ', _repartidorProvider.envio!.guia),
              SizedBox(height: responsive.heightPercentage(1)),
              crearFila(context, 'Fecha Registro: ', formaterarFechaUTC(_repartidorProvider.envio!.fecha)),
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
              SizedBox(height: responsive.heightPercentage(2.5)),
              Container(
                width: responsive.widthPercentage(100),
                child: ElevatedButton(
                  onPressed: _repartidorProvider.cargando ? null : ()=> _repartidorProvider.cargarPaquete(context), 
                  child: _repartidorProvider.cargando ? 
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ) : 
                    Text('Cargar paquete',style: TextStyle(fontSize: 20),)
                ),
              ),
              SizedBox(height: responsive.heightPercentage(1)),
            ],
          ),
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
}