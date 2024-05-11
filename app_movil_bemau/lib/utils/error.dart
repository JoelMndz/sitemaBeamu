import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

manejarError(BuildContext context, Object error){
  String? mensajeError = null;
  if(error is FirebaseAuthException){
    switch (error.code) {
      case 'network-request-failed':
        mensajeError = 'Revise su conexión a internet!';
        break;
      case 'invalid-credential':
        mensajeError = 'Credenciales incorrectas!';
        break;
      case 'invalid-credential':
        mensajeError = 'Credenciales incorrectas!';
        break;
      default:
        mensajeError = error.message;
    }
  }else if(error is FirebaseException){
    switch(error.code){
      case "unavailable":
        mensajeError = 'Revise su conexión a internet!';
        break;
    }
  }

  //Contemplar el uso de microtareas
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensajeError ?? error.toString().replaceFirst('Exception: ', '')),
      backgroundColor: Colors.red[800],
      
    )
  );
}