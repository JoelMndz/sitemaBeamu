
import 'package:app_bemau/model/cliente.dart';
import 'package:app_bemau/model/sucursal.dart';

class Envio{
  String id;
  String guia;
  String fecha;
  double pesoKg;
  bool entregaDomicilio;
  double total;
  Cliente cliente;
  Sucursal sucursalSalida;
  Sucursal sucursalLlegada;
  Destinatario destinatario;
  List<Estado> estados;

  Envio({
    required this.id,
    required this.guia,
    required this.fecha,
    required this.cliente,
    required this.pesoKg,
    required this.entregaDomicilio,
    required this.estados,
    required this.destinatario,
    required this.sucursalSalida,
    required this.sucursalLlegada,
    required this.total,
  });
}

class Destinatario{
  String nombre;
  String celular;
  String direccion;

  Destinatario({
    required this.nombre,
    required this.celular,
    required this.direccion
  });
}

class Estado{
  String fecha;
  String estado;
  String observacion;
  String idEmpleado;
  String? imagenURL;

  Estado({
    required this.fecha,
    required this.estado,
    required this.observacion,
    required this.idEmpleado,
    this.imagenURL
  });
}