
import 'package:app_bemau/constants/rol.dart';
import 'package:app_bemau/model/usuario.dart';
import 'package:app_bemau/screens/autenticacion/login_screen.dart';
import 'package:app_bemau/screens/bodeguero/home_screen.dart';
import 'package:app_bemau/screens/repartidor/home_screen.dart';
import 'package:app_bemau/utils/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutenticacionProvider with ChangeNotifier{
  final _auth = FirebaseAuth.instance;
  final _collection = FirebaseFirestore.instance.collection('empleados');

  Usuario? _usuarioActual;
  Usuario? get usuarioActual => _usuarioActual;
  set usuarioActual(Usuario? valor){_usuarioActual = valor; notifyListeners();}
  bool _cargando = false;
  bool get cargando => _cargando;
  set cargando(bool valor){_cargando = valor; notifyListeners();}

  //Form
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: false ? 'boot.asistente.sistema@gmail.com':'asistente.sistema.escolar@gmail.com');
  final passwordController = TextEditingController(text: '12345678');

  iniciarSesion(BuildContext context) async{
    try {
      cargando = true;
      if(formKey.currentState!.validate()){
        await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
        );
        final usuario = await buscarUsuarioPorEmail(emailController.text.toLowerCase());
        if(usuario == null || Rol.bodeguero.name != usuario.rol && Rol.repartidor.name != usuario.rol){
          throw Exception('No está autorizado!');
        }
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', usuario.email);
        this.usuarioActual = usuario;
        Navigator.pushReplacementNamed(context, usuario.rol == Rol.bodeguero.name ? HomeBodegeroScreenn.nombre : HomeRepartidorScreen.nombre);
      }
    } on Exception catch (e) {
      manejarError(context, e);
    }finally{
      cargando = false;
    }
  }

  iniciarSesionAutomaticamente(BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if(email != null){
      final usuario = await buscarUsuarioPorEmail(emailController.text.toLowerCase());
      this.usuarioActual = usuario;
      Navigator.pushReplacementNamed(context, usuario!.rol == Rol.bodeguero.name ? HomeBodegeroScreenn.nombre : HomeRepartidorScreen.nombre);
      return;
    }
    Navigator.pushReplacementNamed(context, LoginScreen.nombre);
  }

  cerrarSesion(BuildContext context)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.nombre,
      (route) => false
    );
  }

  Future<Usuario?> buscarUsuarioPorEmail(String email)async{
    final data = await _collection
      .where('email',isEqualTo: email)
      .where('eliminado', isEqualTo: false)
      .where('rol', whereIn: [Rol.bodeguero.name, Rol.repartidor.name])
      .get();
    if(data.docs.first != null){
      final campos = data.docs.first.data();
      return Usuario(
        id: data.docs.first.id, 
        nombres: campos['nombres'], 
        apellidos: campos['apellidos'], 
        rol: campos['rol'], 
        idSucursal: campos.containsKey('idSucursal') ? campos['idSucursal'] : '', 
        email: email
      );
    } 
    return null;
  }
}