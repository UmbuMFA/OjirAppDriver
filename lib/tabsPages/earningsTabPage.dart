import 'package:driver_app/AllScreens/historyScreen.dart';
import 'package:driver_app/DataHandler/appData.dart';
import 'package:driver_app/Models/history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningsTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<History> items =
        Provider.of<AppData>(context, listen: false).tripHistoryDataList;

    return Column(
      children: [
        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                const Text(
                  'Total Earnings',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "${items.isNotEmpty ? items.map((e) => int.parse(e.berat!)).reduce((a, b) => a + b) : 0} kg",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: 'Brand Bold'),
                )
              ],
            ),
          ),
        ),
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset(
                  'images/logo.png',
                  width: 50,
                ),
                const SizedBox(
                  width: 16,
                ),
                const Text(
                  'Total Trips',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                    child: Text(
                  items.length.toString(),
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 18),
                )),
              ],
            ),
          ),
        ),
        const Divider(
          height: 2.0,
          thickness: 2.0,
        ),
      ],
    );
  }
}
