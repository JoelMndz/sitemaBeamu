import 'package:app_bemau/providers/repartidor.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanearQrRepartidorScreen extends StatefulWidget {
  static String nombre = "/repartidor/scanear-qr";
  
  const ScanearQrRepartidorScreen({ Key? key }) : super(key: key);

  @override
  _ScanearQrRepartidorScreenState createState() => _ScanearQrRepartidorScreenState();
}

class _ScanearQrRepartidorScreenState extends State<ScanearQrRepartidorScreen> {
  late RepartidorProvider _repartidorProvider;

  @override
  void reassemble() {
    super.reassemble();
    _repartidorProvider.controllerQR!.pauseCamera();
    _repartidorProvider.controllerQR!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _repartidorProvider = context.watch<RepartidorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cargar paquete'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      resizeToAvoidBottomInset: true,
      body: _scanearQR(context)
    );
  }

  Widget _scanearQR(BuildContext context){
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: QRView(
            key: _repartidorProvider.qrKey,
            onQRViewCreated: (controller) =>  _repartidorProvider.onQRViewCreated(context,controller),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: (_repartidorProvider.resultadoQR != null)
              ? CircularProgressIndicator()
              : Text('Scanea un QR',
                style: textTheme.headlineMedium,
              )
          ),
        ),
      ],
    );
  }
}