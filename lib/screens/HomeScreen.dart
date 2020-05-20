import 'package:flash_chat/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flash_chat/constants.dart';

bool argss;

class MyHomePage extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool status = false;
  var expensedata;
  var expensetotal;
  var corpusFund;
  var monthlyMaintenance;
  var nameOfApartment;
  var flatNumber;
  expenseTotal(List data) {
    int total = 0;
    for (var obj in data) {
      total = total + int.parse(obj['amount']);
    }
    setState(() {
      expensetotal = total;
    });
  }

  void getData(context) {
    Map args = ModalRoute.of(context).settings.arguments;
    // print(args);
    expenseTotal(args['expenses']);
    setState(() {
      status = args['status'];
      expensedata = args['expenses'];
      corpusFund = args['moneydata']['corpusFund'];
      monthlyMaintenance = args['moneydata']['monthlyMaintenance'];
      nameOfApartment = args['apartmentname'];
      flatNumber = args['flatNumber'];
    });
  }

  @override
  Widget build(BuildContext context) {
    getData(context);
    argss = status;
    return Scaffold(
      backgroundColor: status == true ? kMainColor : kNotPaidColor,
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        parallaxEnabled: true,
        parallaxOffset: .3,
        maxHeight: 590,
        panel: Panel(
          entries: expensedata,
          expensetotal: expensetotal,
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              '$nameOfApartment',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Text(
                '$flatNumber',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Maintenance',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Text(
                status == true ? 'Paid' : 'Not Paid',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Details(
              name: "Maintenance",
              amount: monthlyMaintenance,
            ),
            SizedBox(
              height: 20,
            ),
            Details(
              name: "Corpus Fund",
              amount: corpusFund,
            ),
          ],
        )),
      ),
    );
  }
}

class Panel extends StatelessWidget {
  Panel({this.entries, this.expensetotal});
  var entries;
  final int expensetotal;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Text(
            'Expenses',
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${entries[index]['expense']} :',
                          style: kExpensesStyle,
                        ),
                        Text(
                          '${entries[index]['amount']}',
                          style: kExpensesStyle,
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: argss == true ? kMainColor : kNotPaidColor,
                  ),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$expensetotal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Details extends StatelessWidget {
  Details({this.name, this.amount});

  final String name;
  var amount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$name :',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
                letterSpacing: 2),
          ),
          Text(
            '$amount',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }
}
