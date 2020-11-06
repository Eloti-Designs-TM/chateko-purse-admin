import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:get_it/get_it.dart';

void setup() {
  GetIt.I.registerSingleton<AuthApi>(AuthApi());
  GetIt.I.registerSingleton<InvestApi>(InvestApi());
  GetIt.I.registerSingleton<UserApi>(UserApi());
}
