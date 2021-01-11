import "package:flutter/material.dart";

class MerchantCalendarPage extends StatefulWidget {
  final Map<dynamic, dynamic> profile;
  MerchantCalendarPage({Key key, @required this.profile}) : super(key: key);

  @override
  _MerchantCalendarPageState createState() => _MerchantCalendarPageState();
}

class _MerchantCalendarPageState extends State<MerchantCalendarPage> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        print(newTime);
        _time = newTime;
        print(_time.hour);
        print(_time.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafe Express"),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('SELECT TIME'),
            ),
            SizedBox(height: 8),
            Text(
              'Selected time: ${_time.format(context)}',
            ),
            Text('${widget.profile}')
          ],
        ),
      ),
    );
  }
}
