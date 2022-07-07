import 'package:driver_app/AllWidgets/HistoryItem.dart';
import 'package:driver_app/DataHandler/appData.dart';
import 'package:driver_app/Models/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const HistoryScreen({
    Key? key,
  }) : super(key: key);

  // --------------------------------- METHODS ---------------------------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Month Year Picker Example',
      home: HistoryContent(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}


class HistoryContent extends StatefulWidget {
  @override
  _HistoryContentState createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  String bulan = "Pilih Bulan";
  DateTime? selectedDate;
  List<History> items = [];
  List<History> filteredItems = [];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    items = Provider.of<AppData>(context, listen: false).tripHistoryDataList;
    filteredItems =
        Provider.of<AppData>(context, listen: false).tripHistoryDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History'),
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showMonthYearPicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 1, 5),
                  lastDate: DateTime(DateTime.now().year + 1, 9),
                  locale: const Locale("id"),
                ).then((value) {
                  List<History> tmp = [];
                  for (var element in items) {
                    int month1 = DateTime.parse(element.date!).month;
                    int year1 = DateTime.parse(element.date!).year;
                    int month2 = value!.month;
                    int year2 = value.year;
                    if (month1 == month2 && year1 == year2) {
                      tmp.add(element);
                    }
                  }

                  setState(() {
                    selectedDate = value;
                    bulan = "${selectedDate!.month} / ${selectedDate!.year}";
                    filteredItems = tmp;
                  });
                });
              },
              child: Text(bulan)),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
                "Total ${filteredItems.isNotEmpty ? filteredItems.map((e) => int.parse(e.berat!)).reduce((a, b) => a + b) : 0} kg"),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.separated(
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return HistoryItem(
                history: filteredItems[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              thickness: 3.0,
              height: 3.0,
            ),
            itemCount: filteredItems.length,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
