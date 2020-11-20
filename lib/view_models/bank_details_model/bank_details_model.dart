import 'package:chateko_purse_admin/models/bank_details/bank_details.dart';
import 'package:chateko_purse_admin/services/bank_detail_api/bank_details_api.dart';
import 'package:chateko_purse_admin/ui/views/widget/snacks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class BankDetailModel with ChangeNotifier {
  TextEditingController bankNameController = TextEditingController();
  TextEditingController acctNameController = TextEditingController();
  TextEditingController acctNumberController = TextEditingController();

  final bankApi = GetIt.I.get<BankDetailsApi>();

  setBankToField(BankDetial bankDetail) {
    bankNameController.text = bankDetail.bankName;
    acctNameController.text = bankDetail.accountName;
    acctNumberController.text = bankDetail.accountNumber;
  }

  createBankDetails(context) async {
    var bankDetial = BankDetial();
    bankDetial.accountName = acctNameController.text;
    bankDetial.accountNumber = acctNumberController.text;
    bankDetial.bankName = bankNameController.text;
    notifyListeners();
    await bankApi.createBankDetails(bankDetial);
    showSnackbarSuccess(context, msg: 'Successfully Create Bank Detail');
  }

  updateBankDetails(BuildContext context, BankDetial bankDetail) async {
    if (bankDetail.bankName != bankNameController.text) {
      await bankApi.updateBankDetails(
          bankDetail.id, {'bank_name': bankNameController.text});
      showSnackbarSuccess(context, msg: 'Successfully Updated Bank Name');
    }
    if (bankDetail.accountNumber != acctNumberController.text) {
      await bankApi.updateBankDetails(
          bankDetail.id, {'account_number': acctNumberController.text});
      showSnackbarSuccess(context, msg: 'Successfully Updated Account Number');
    }
    if (bankDetail.accountName != acctNameController.text) {
      await bankApi.updateBankDetails(
          bankDetail.id, {'account_name': acctNameController.text});
      showSnackbarSuccess(context, msg: 'Successfully Updated Account Name');
    }
  }

  deleteBank(context, String id) async {
    await bankApi.deleteBankDetails(id);
    showSnackbarSuccess(context, msg: 'Successfully deleted Bank detail');
  }
}
