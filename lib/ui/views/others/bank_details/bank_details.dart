import 'package:chateko_purse_admin/models/bank_details/bank_details.dart';
import 'package:chateko_purse_admin/services/bank_detail_api/bank_details_api.dart';
import 'package:chateko_purse_admin/ui/views/widget/alert_dialog.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/ui/views/widget/custom_dialog.dart';
import 'package:chateko_purse_admin/ui/views/widget/text_field_wid.dart';
import 'package:chateko_purse_admin/view_models/bank_details_model/bank_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankDetails extends StatelessWidget {
  const BankDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BankInjector(
      child: Consumer2<BankDetailsApi, BankDetailModel>(
          builder: (context, bankApi, model, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Bank Details'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) =>
                        CreateEditBankDetail(title: 'Create Bank Detail'));
              },
              child: Icon(Icons.add),
            ),
            body: SingleChildScrollView(
                child: FutureBuilder<QuerySnapshot>(
                    future: bankApi.getBankDetial(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Getting Bank Details, wait....'),
                        ));
                      }

                      final docList = snapshot.data.docs;

                      BankDetial bank = BankDetial();
                      List<BankDetial> listBank = List();

                      docList.map((e) {
                        bank = BankDetial.fromDoc(e);
                        listBank.add(bank);
                      }).toList();

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[400],
                          ),
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                            children: List.generate(
                                listBank.length,
                                (i) => Material(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(''),
                                            LineTexts(
                                              leadingText: 'Bank Name',
                                              trailingText:
                                                  '${listBank[i].bankName}',
                                            ),
                                            LineTexts(
                                              leadingText: 'Account Name',
                                              trailingText:
                                                  '${listBank[i].accountName}',
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: LineTexts(
                                                    leadingText:
                                                        'Account Number',
                                                    trailingText:
                                                        '${listBank[i].accountNumber}',
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Container(
                                                    width: 100,
                                                    child: Row(
                                                      children: [
                                                        circleButton(
                                                          icon: Icons.edit,
                                                          onPressed: () =>
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      CreateEditBankDetail(
                                                                        bankDetial:
                                                                            listBank[i],
                                                                        title:
                                                                            'Update Bank Detail',
                                                                      )),
                                                          color: Colors.black,
                                                          text: 'Edit',
                                                        ),
                                                        circleButton(
                                                          icon: Icons.delete,
                                                          onPressed: () =>
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      CustomAlertDialog(
                                                                        title:
                                                                            'Delete Bank Details',
                                                                        content:
                                                                            'Do you want to delete this bank details?',
                                                                        onTapYes:
                                                                            () async {
                                                                          await model.deleteBank(
                                                                              context,
                                                                              listBank[i].id);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )),
                                                          color: Colors.black,
                                                          text: 'Delete',
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))),
                      );
                    })));
      }),
    );
  }
}

class CreateEditBankDetail extends StatelessWidget {
  const CreateEditBankDetail({
    Key key,
    this.bankDetial,
    this.title,
  }) : super(key: key);
  final BankDetial bankDetial;
  final String title;
  @override
  Widget build(BuildContext context) {
    return BankInjector(
      child: Consumer<BankDetailModel>(
        builder: (_, model, ch) => Builder(builder: (context) {
          bankDetial == null ? null : model.setBankToField(bankDetial);
          return CustomDialog(
            title: '$title',
            children: [
              Column(
                children: [
                  TextFieldWidRounded(
                    title: 'Bank Name',
                    controller: model.bankNameController,
                  ),
                  TextFieldWidRounded(
                      title: 'Account Name',
                      controller: model.acctNameController),
                  TextFieldWidRounded(
                      title: 'Account Number',
                      controller: model.acctNumberController),
                ],
              ),
              SizedBox(height: 10),
              GradiantButton(
                isOutline: false,
                onPressed: () async {
                  bankDetial == null
                      ? await model.createBankDetails(context)
                      : await model.updateBankDetails(context, bankDetial);
                  Navigator.of(context).pop();
                },
                title: 'Done',
              )
            ],
          );
        }),
      ),
    );
  }
}

class LineTexts extends StatelessWidget {
  final String leadingText;
  final String trailingText;

  const LineTexts({
    Key key,
    this.leadingText,
    this.trailingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('$leadingText:  ', style: TextStyle(fontSize: 14)),
            Expanded(
              child: Text('$trailingText',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

class BankInjector extends StatelessWidget {
  final Widget child;

  const BankInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BankDetailsApi(),
        ),
        ChangeNotifierProvider(
          create: (_) => BankDetailModel(),
        ),
      ],
      child: child,
    );
  }
}
