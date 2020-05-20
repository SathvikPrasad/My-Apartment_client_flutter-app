import 'package:cloud_firestore/cloud_firestore.dart';

//
final _firestore = Firestore.instance;

class DataBase {
  List expensesDetails;
  Map moneydata;
  bool status;
  String apartmentName;

  Future<dynamic> statusData(database, flatNumber) async {
    await for (var snapshot in _firestore.collection(database).snapshots()) {
      for (var doc in snapshot.documents) {
        if (doc.data['name'] == flatNumber) {
          if (doc.data['maintenance'] == true) {
            status = true;
            return true;
          } else {
            status = false;
            return false;
          }
        }
      }
    }
  }

  Future<Map> moneyData(database) async {
    Map data;
    await for (var snapshot in _firestore.collection(database).snapshots()) {
      for (var doc in snapshot.documents) {
        data = doc.data;
      }
      moneydata = data;
      apartmentName = data['nameOfApartment'];

      return data;
    }
  }

  Future<List> expensesData(database) async {
    List data = [];
    await for (var snapshot in _firestore.collection(database).snapshots()) {
      for (var doc in snapshot.documents) {
        Map dat = {
          'expense': doc.data['expense'],
          'amount': doc.data['amount']
        };
        data.add(dat);
      }
      expensesDetails = data;
      return data;
    }
  }
}
