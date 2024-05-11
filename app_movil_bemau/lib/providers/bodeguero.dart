
import 'package:app_bemau/constants/accionQr.dart';
import 'package:app_bemau/constants/estados.dart';
import 'package:app_bemau/model/cliente.dart';
import 'package:app_bemau/model/envio.dart';
import 'package:app_bemau/model/sucursal.dart';
import 'package:app_bemau/providers/autenticacion.dart';
import 'package:app_bemau/screens/bodeguero/scanear_qr_screen.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:app_bemau/utils/error.dart';
import 'package:app_bemau/utils/fecha.dart';
import 'package:app_bemau/widgets/EnviarPaquete.dart';
import 'package:app_bemau/widgets/RecibirPaquete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BodegueroProvider with ChangeNotifier{
  final _coleccionEnvios = FirebaseFirestore.instance.collection('envios');
  final _coleccionTipoEnvio = FirebaseFirestore.instance.collection('tipo_envio');
  final _coleccionSucursal = FirebaseFirestore.instance.collection('sucursales');
  final _coleccionCliente = FirebaseFirestore.instance.collection('clientes');
  String? accionQR;
  Envio? _envio;
  Envio? get envio => _envio;
  set envio(Envio? valor){_envio = valor; notifyListeners();}
  QRViewController? controllerQR;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? _resultadoQR;
  Barcode? get resultadoQR => _resultadoQR;
  set resultadoQR(Barcode? qr){_resultadoQR = qr; notifyListeners();}

  bool _cargando = false;
  bool get cargando => _cargando;
  set cargando(bool valor){_cargando = valor; notifyListeners();}
  final observacionController = TextEditingController();

  navegarHaciaScanQR(BuildContext context, String accion){
    accionQR = accion;
    Navigator.pushNamed(context, ScanearQrBodegueroScreen.nombre);
  }

  void onQRViewCreated(BuildContext context, QRViewController controller) {
    controllerQR = controller;
    controllerQR!.scannedDataStream.listen((qr) async{
      try {
        controllerQR!.pauseCamera();
        resultadoQR = qr;
        this.envio = await _obtenerInformacionEnvio(resultadoQR!.code!);
        validarEstados(this.envio!);
        resultadoQR = null;
        _mostrarInformacionModal(context);
      } catch (e) {
        resultadoQR = null;
        manejarError(context, e);
        controllerQR!.resumeCamera();
      }
    });
  }
  
  validarEstados(Envio envio){
    // Validar cuando se envía el paquete
    if(accionQR! == AccionesQR.enviar_paquete.name){
      if(envio.estados.last.estado == Estados.pendiente.name) return;
      if(envio.estados.last.estado == Estados.viajando.name){
        throw new Exception('Este paquete no se puede volver a enviar!');
      }
      throw new Exception('El paquete tiene un estado de ${envio.estados.last.estado} no se puede envíar');
    }else{ //Validar cuando se recibe el paquete
      if(envio.estados.last.estado == Estados.viajando.name) return;
      if(envio.estados.last.estado == Estados.sucursal.name){
        throw new Exception('Este paquete no se puede volver a recibir!');
      }
      throw new Exception('El paquete tiene un estado de ${envio.estados.last.estado} no se puede envíar');
    }
  }

  Future<Envio> _obtenerInformacionEnvio(String idEnvio) async {
    final docEnvio = await _coleccionEnvios.doc(idEnvio).get();
    if(docEnvio.data() == null){
      throw Exception('El QR no esta registrado!');
    }
    final jsonEnvio = docEnvio.data()!;
    final docTipoEnvio = await _coleccionTipoEnvio.doc(jsonEnvio['idTipoEnvio']).get();
    final docCliente = await _coleccionCliente.doc(jsonEnvio['idCliente']).get();
    final docSucursalSalida = await _coleccionSucursal.doc(jsonEnvio['idSucursalSalida']).get();
    final docSucursalLlegada = await _coleccionSucursal.doc(jsonEnvio['idSucursalLlegada']).get();
    return Envio(
      id: docEnvio.id, 
      fecha: jsonEnvio['fechaRegistro'], 
      cliente: Cliente(
        id: jsonEnvio['idCliente'],
        nombres: docCliente.data()!['nombres'],
        apellidos: docCliente.data()!['apellidos'],
        cedula: docCliente.data()!['cedula'],
        email: docCliente.data()!['email']
      ), 
      tipo: docTipoEnvio.data()!['nombre'], 
      pesoKg: double.parse(jsonEnvio['pesoKg'].toString()), 
      entregaDomicilio: jsonEnvio['entregaDomicilio'], 
      estados: (jsonEnvio['estados'] as List<dynamic>)
        .map((x) => Estado(
          fecha: x['fecha'], 
          estado: x['estado'], 
          observacion: x['observacion'] ?? '',
          idEmpleado: x['idEmpleado']  
        )
        ).toList(), 
      destinatario: Destinatario(
        nombre: jsonEnvio['destinatario']['nombre'],
        celular: jsonEnvio['destinatario']['celular'],
        direccion: jsonEnvio['destinatario']['direccion'],
      ), 
      sucursalSalida: Sucursal(
        id: jsonEnvio['idSucursalSalida'],
        nombre: docSucursalSalida.data()!['nombre'],
        provincia: docSucursalSalida.data()!['provincia']['nombre'],
        canton: docSucursalSalida.data()!['canton']['nombre'],
        direccion: docSucursalSalida.data()!['direccion'],
      ), 
      sucursalLlegada: Sucursal(
        id: jsonEnvio['idSucursalLlegada'],
        nombre: docSucursalLlegada.data()!['nombre'],
        provincia: docSucursalLlegada.data()!['provincia']['nombre'],
        canton: docSucursalLlegada.data()!['canton']['nombre'],
        direccion: docSucursalLlegada.data()!['direccion'],
      ),
      total: double.parse(jsonEnvio['total'].toString())
    );
  }

  _mostrarInformacionModal(BuildContext context){
    showModalBottomSheet(
      context: context, 
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => accionQR! == AccionesQR.enviar_paquete.name ?  EnviarPaquete() : RecibirPaquete()
    );
  }

  cerrarModal(BuildContext context){
    Navigator.pop(context);
    observacionController.clear();
    controllerQR!.resumeCamera();
    cargando = false;
  }

  enviarPaquete(BuildContext context)async{
    try {
      cargando = true;
      final idEmpleado = context.read<AutenticacionProvider>().usuarioActual!.id;
      envio!.estados.add(
        Estado(
          fecha: obtenerFechaActualUTC(),
          estado: Estados.viajando.name,
          observacion: observacionController.text, 
          idEmpleado: idEmpleado
        )
      );
      await _coleccionEnvios.doc(envio!.id).update({
        "estados": envio!.estados
          .map((x) => {
            "fecha": x.fecha,
            "estado": x.estado,
            "observacion": x.observacion,
            "idEmpleado": x.idEmpleado
          })
          .toList()
      });
      cerrarModal(context);
    } catch (e) {
      manejarError(context, e);
    }finally{
      cargando = false;
    }
  }

  recibirPaquete(BuildContext context)async{
    try {
      cargando = true;
      final idEmpleado = context.read<AutenticacionProvider>().usuarioActual!.id;
      envio!.estados.add(
        Estado(
          fecha: obtenerFechaActualUTC(), 
          estado: Estados.sucursal.name, 
          observacion: observacionController.text, 
          idEmpleado: idEmpleado
        )
      );
      await _coleccionEnvios.doc(envio!.id).update({
        "estados": envio!.estados
          .map((x) => {
            "fecha": x.fecha,
            "estado": x.estado,
            "observacion": x.observacion,
            "idEmpleado": x.idEmpleado
          })
          .toList()
      });
      cerrarModal(context);
    } catch (e) {
      manejarError(context, e);
    }finally{
      cargando = false;
    }
  }
}