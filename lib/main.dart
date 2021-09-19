import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pay_cam/pay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const MyHomePage(),
        '/pay': (context) => PayPage(),
      },
      initialRoute: '/',
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double scrollPrecent = 0;
  late Future<void> initializeControllerFuture;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  Barcode? result;

  @override
  void initState() {
    super.initState();
  }

  void stopCamera() {
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    stopCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      await Navigator.pushNamed(context, '/pay');
      await controller.resumeCamera();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SnappingSheet(
        snappingPositions: const [
          SnappingPosition.factor(
              positionFactor: 0,
              grabbingContentOffset: GrabbingContentOffset.top),
          SnappingPosition.factor(
              positionFactor: 1,
              grabbingContentOffset: GrabbingContentOffset.bottom)
        ],
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),
        onSheetMoved: (positionData) => {
          setState(() {
            scrollPrecent = positionData.relativeToSnappingPositions;
          })
        },
        grabbingHeight: 70,
        grabbing: Container(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular((1 - scrollPrecent) * 24),
                  topRight: Radius.circular((1 - scrollPrecent) * 24))),
          child: const Text(
            "TESTPAY",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ),
        sheetBelow: SnappingSheetContent(
            draggable: true,
            child: Container(
              color: Colors.white,
              child: const Text("내부 내용이 들어감"),
            )),
      ),
    );
  }
}
