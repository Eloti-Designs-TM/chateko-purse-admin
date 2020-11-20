import 'package:chateko_purse_admin/ui/views/others/bank_details/bank_details.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:flutter/material.dart';

class Others extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GradiantButton(
              title: 'Bank Details',
              isOutline: false,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => BankDetails()));
              },
            ),
          )
        ],
      ),
    );
  }
}
