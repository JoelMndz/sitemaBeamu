
import 'package:intl/intl.dart';

formaterarFechaUTC(String fechaUTC){
  DateTime fecha = DateFormat('E, dd MMM yyyy HH:mm:ss').parseUtc(fechaUTC);
  String fechaFormateada = DateFormat('dd-MM-yyyy HH:mm:ss').format(fecha);
  return fechaFormateada;
}

obtenerFechaActualUTC(){
  DateTime fechaUTC = DateTime.now().toUtc();
  DateFormat formateadorFecha = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US');
  String fechaFormateada = formateadorFecha.format(fechaUTC);
  return '$fechaFormateada GMT';
}