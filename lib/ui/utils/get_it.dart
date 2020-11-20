import 'package:chateko_purse_admin/services/ads_api/ads_api.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/bank_detail_api/bank_details_api.dart';
import 'package:chateko_purse_admin/services/bonus_api.dart/bonus_api.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:get_it/get_it.dart';

void setup() {
  GetIt.I.registerSingleton<AuthApi>(AuthApi());
  GetIt.I.registerSingleton<InvestApi>(InvestApi());
  GetIt.I.registerSingleton<UserApi>(UserApi());
  GetIt.I.registerSingleton<BonusApi>(BonusApi());
  GetIt.I.registerSingleton<AdsApi>(AdsApi());
  GetIt.I.registerSingleton<BankDetailsApi>(BankDetailsApi());
}
