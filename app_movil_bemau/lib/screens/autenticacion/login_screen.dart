
import 'package:app_bemau/providers/autenticacion.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String nombre = '/login';
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final autenticacionProvider = context.watch<AutenticacionProvider>();
    
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.all(responsive.widthPercentage(5)),
          surfaceTintColor: colorScheme.onPrimary,
          child: Padding(
            padding: EdgeInsets.all(responsive.widthPercentage(5)),
            child: Form(
              key: autenticacionProvider.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.jpg', width: responsive.widthPercentage(60),),
                  SizedBox(height: responsive.heightPercentage(2),),
                  Text('Bienvenido a Bemau Express! 👋🏻',
                    style: textTheme.titleMedium,),
                  SizedBox(height: responsive.heightPercentage(1),),
                  TextFormField(
                    controller: autenticacionProvider.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value == null || value.isEmpty)
                        return 'Campo obligatorio';
                      return null;
                    },
                  ),
                  SizedBox(height: responsive.heightPercentage(2),),
                  TextFormField(
                    controller: autenticacionProvider.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value){
                      if(value == null || value.isEmpty)
                        return 'Campo obligatorio';
                      return null;
                    },
                  ),
                  SizedBox(height: responsive.heightPercentage(2.5),),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: autenticacionProvider.cargando ? 
                        null : ()=> autenticacionProvider.iniciarSesion(context), 
                      child: autenticacionProvider.cargando ? 
                        CircularProgressIndicator(color: colorScheme.onPrimary,) : 
                        Text('INGRESAR')
                    ),
                  ),                  
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}