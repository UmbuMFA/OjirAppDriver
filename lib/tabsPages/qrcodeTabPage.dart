import 'package:driver_app/configMaps.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeTabPage extends StatefulWidget {
  @override
  _QrcodeTabPageState createState() => _QrcodeTabPageState();
}

class _QrcodeTabPageState extends State<QrcodeTabPage> {
  TextEditingController bobotController = TextEditingController();

  String id_d = driversInformation.id!;
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 25.0,
              ),
              Center(
                child: QrImage(data: code, size: 200),
              ),
              Text(
                driversInformation.name!,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Brand Bold",
                    color: Colors.black54),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: bobotController,
                  onChanged: (text) {
                    setState(() {
                      code = "${id_d}_$text";
                    });
                  },
                  keyboardType: TextInputType.number,
                  onTap: () {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    labelText: "Bobot (kg)",
                    labelStyle:
                        TextStyle(fontSize: 14.0, color: Color(0xFF050707)),
                  ),
                  style:
                      const TextStyle(fontSize: 18.0, color: Color(0xFF050707)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
