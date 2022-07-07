import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/Models/history.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final History history;

  HistoryItem({required this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'images/pickicon.png',
                      height: 16,
                      width: 16,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                        child: Container(
                            child: Text(
                      history.client!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18),
                    ))),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${history.berat} kg',
                      style: TextStyle(
                          fontFamily: 'Brand Bold',
                          fontSize: 16,
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                AssistantMethods.formatTripDate(history.date!),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
