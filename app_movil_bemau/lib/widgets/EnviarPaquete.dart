import 'package:app_bemau/providers/bodeguero.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:app_bemau/utils/fecha.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnviarPaquete extends StatefulWidget {
  const EnviarPaquete({ Key? key }) : super(key: key);

  @override
  _EnviarPaqueteState createState() => _EnviarPaqueteState();
}

class _EnviarPaqueteState extends State<EnviarPaquete> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final textTheme = Theme.of(context).textTheme;
    final bodegueroProvider = context.watch<BodegueroProvider>();
    
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
                    onPressed: () => bodegueroProvider.cerrarModal(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: responsive.heightPercentage(2)),
              crearFila(context, 'Guía: ', bodegueroProvider.envio!.guia),
              SizedBox(height: responsive.heightPercentage(1)),
              crearFila(context, 'Fecha Registro: ', formaterarFechaUTC(bodegueroProvider.envio!.fecha)),
              SizedBox(height: responsive.heightPercentage(1)),
              crearFila(context, 'Peso: ', '${bodegueroProvider.envio!.pesoKg} kg',),
              SizedBox(height: responsive.heightPercentage(1)),
              crearFila(context, 'Cliente: ', '${bodegueroProvider.envio!.cliente.nombres} ${bodegueroProvider.envio!.cliente.apellidos}'),
              SizedBox(height: responsive.heightPercentage(1)),
              crearFila(context, 'Destinatario: ', bodegueroProvider.envio!.destinatario.nombre),
              SizedBox(height: responsive.heightPercentage(1)),
              crearFila(context, 'Sucursal salida: ', bodegueroProvider.envio!.sucursalSalida.nombre),
              SizedBox(height: responsive.heightPercentage(1)),
              crearFila(context, 'Sucursal llegada: ', bodegueroProvider.envio!.sucursalLlegada.nombre),
              SizedBox(height: responsive.heightPercentage(1)),
              TextField(
                controller: bodegueroProvider.observacionController,
                decoration: InputDecoration(
                  label: Text('Observación')
                ),
              ),
              SizedBox(height: responsive.heightPercentage(2.5)),
              Container(
                width: responsive.widthPercentage(100),
                child: ElevatedButton(
                  onPressed: bodegueroProvider.cargando ? null : ()=> bodegueroProvider.enviarPaquete(context), 
                  child: bodegueroProvider.cargando ? 
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ) : 
                    Text('Enviar paquete',style: TextStyle(fontSize: 20),)
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