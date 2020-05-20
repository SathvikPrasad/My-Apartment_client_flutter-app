import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/dataBase.dart';

//
final _firestore = Firestore.instance;
int flatNumber;
bool spin = false;

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: spin,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Text(
                    'My Apartment',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2),
                  )),
                ),
                SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Flat No',
                          labelStyle: TextStyle(color: kMainColor),
                          fillColor: Colors.white),
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          flatNumber = int.parse(value);
                        });
                      },
                    )),
                SizedBox(
                  height: 40,
                ),
                ApartmentList(onPress: (s) {
                  setState(() {
                    spin = !spin;
                  });
                }),
              ],
            ),
          ),
        ));
  }
}

class ApartmentList extends StatefulWidget {
  ApartmentList({this.onPress});

  final Function onPress;

  @override
  _ApartmentListState createState() => _ApartmentListState();
}

class _ApartmentListState extends State<ApartmentList> {
  final List<Map> entries = [];
  DataBase dataBase = DataBase();
  @override
  void initState() {
    super.initState();
    fireBase();
  }

  void fireBase() async {
    await for (var snapshot
        in _firestore.collection("apartments").snapshots()) {
      for (var apartment in snapshot.documents) {
        print(apartment.metadata.isFromCache
            ? "NOT FROM NETWORK"
            : "FROM NETWORK");
        setState(() {
          entries.add(apartment.data);
        });
      }
    }
  }

  void onClick(context, flatnumber, nameofapartment, email) async {
    setState(() {
      spin = true;
    });
    bool status = await dataBase.statusData('${email}DataBase', flatNumber);
    Map moneydata = await dataBase.moneyData('${email}Details');
    List expenses = await dataBase.expensesData('${email}expenses');
    setState(() {
      spin = false;
    });
    Navigator.pushNamed(context, MyHomePage.id, arguments: {
      'flatNumber': flatnumber,
      'apartmentname': nameofapartment,
      'status': status,
      'moneydata': moneydata,
      'expenses': expenses,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return FlatButton(
              onPressed: () {
                onClick(context, flatNumber, entries[index]['nameOfApartment'],
                    entries[index]['email']);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff3A50BE),
                ),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${entries[index]['nameOfApartment']} ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
