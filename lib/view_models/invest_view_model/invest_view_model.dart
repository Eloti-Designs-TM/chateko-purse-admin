import 'dart:math';
import 'package:chateko_purse_admin/models/bank_details/bank_details.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:chateko_purse_admin/ui/page/widget/button.dart';
import 'package:chateko_purse_admin/ui/page/widget/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class InvestViewModel with ChangeNotifier {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  var authApi = GetIt.I.get<AuthApi>();
  var investApi = GetIt.I.get<InvestApi>();
  TextEditingController unitController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController acctNameController = TextEditingController();
  TextEditingController acctNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  var investIdGenerator = Random();
  String investId;

  int unit = 0;

  int calculaateUnitToNaira() {
    return unit * 10000;
  }

  void clearFields() {
    unitController.clear();
    bankNameController.clear();
    totalAmountController.clear();
    acctNameController.clear();
    acctNumberController.clear();
    addressController.clear();
  }

  onInputChanged(String v) {
    if (v.isNotEmpty) {
      int value = int.parse(v);
      unit = value;
      notifyListeners();
    } else {
      unit = 0;
      notifyListeners();
    }
  }

  investID() {
    var id = investIdGenerator.nextInt(92143543) + 09451234356;
    var randomId = "ch-${id.toString().substring(0, 8)}";
    investId = randomId;
    notifyListeners();
  }

  getAllInvestment() {
    try {
      investApi.getInvests(authApi.users.userID);
    } catch (e) {
      print(e);
    }
  }

//   Future showSuccessBankDetail(
//     BuildContext context,
//   ) {
//     return showDialog(
//         context: context,
//         builder: (_) => CustomDialog(
//               title: 'Bank Details',
//               children: [
//                 Consumer<InvestViewModel>(builder: (context, investapi, child) {
//                   return FutureBuilder<QuerySnapshot>(
//                       future: investapi.investApi.getBankDetial(),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return Center(child: CircularProgressIndicator());
//                         }

//                         final docList = snapshot.data.docs;

//                         BankDetials bank = BankDetials();
//                         List<BankDetials> listBank = List();

//                         docList.map((e) {
//                           bank = BankDetials.fromDoc(e);
//                           listBank.add(bank);
//                         }).toList();

//                         return Column(
//                             children: List.generate(
//                                 listBank.length,
//                                 (i) => Column(
//                                       children: [
//                                         LineTexts(
//                                           leadingText: 'Bank Name',
//                                           trailingText:
//                                               '${listBank[i].bankName}',
//                                         ),
//                                         LineTexts(
//                                           leadingText: 'Account Name',
//                                           trailingText:
//                                               '${listBank[i].accountName}',
//                                         ),
//                                         LineTexts(
//                                           leadingText: 'Account Number',
//                                           trailingText:
//                                               '${listBank[i].accountNumber}',
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16.0),
//                                           child: FlatButton(
//                                             color: Colors.pink,
//                                             shape: StadiumBorder(),
//                                             textColor: Colors.white,
//                                             onPressed: () => copyToClipBoard(
//                                                 clipBoardText:
//                                                     '${listBank[i].accountNumber}'),
//                                             child: Text('Copy Account Number'),
//                                           ),
//                                         ),
//                                       ],
//                                     )));
//                       });
//                 }),
//                 Text('Screab shot every transactions you make'),
//                 circleButton(
//                     icon: Icons.close,
//                     text: 'Close',
//                     onPressed: () => Navigator.of(context).pop()),
//               ],
//             ));
//   }
// }
}
