import 'package:app_bemau/providers/bodeguero.dart';
import 'package:app_bemau/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanearQrBodegueroScreen extends StatefulWidget {
  static String nombre = "/bodeguero/scanear-qr";
  const ScanearQrBodegueroScreen({ Key? key }) : super(key: key);

  @override
  _ScanearQrBodegueroScreenState createState() => _ScanearQrBodegueroScreenState();
}

class _ScanearQrBodegueroScreenState extends State<ScanearQrBodegueroScreen> {
  late BodegueroProvider _bodegueroProvider;

  @override
  void reassemble() {
    super.reassemble();
    _bodegueroProvider.controllerQR!.pauseCamera();
    _bodegueroProvider.controllerQR!.resumeCamera();
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _bodegueroProvider = context.watch<BodegueroProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Scanear QR'),
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
            key: _bodegueroProvider.qrKey,
            onQRViewCreated: (controller) =>  _bodegueroProvider.onQRViewCreated(context,controller),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: (_bodegueroProvider.resultadoQR != null)
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