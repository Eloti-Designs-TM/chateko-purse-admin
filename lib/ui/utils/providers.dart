import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:chateko_purse_admin/view_models/home_view_model/home_view_model.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/view_models/invest_view_model/invest_view_model.dart';
import 'package:chateko_purse_admin/view_models/profile_view_model/profile_view_model.dart';
import 'package:chateko_purse_admin/view_models/theme_view_model/theme_model.dart';
import '../../././view_models/start_view_model/auth_view_model/login_view_model.dart';
import '../../././view_models/start_view_model/landing_view_model/slider_view_model.dart';
import '../../././view_models/start_view_model/landing_view_model/start_view_model.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider.value(value: AuthApi()),
  ChangeNotifierProvider.value(value: UserApi()),
  ChangeNotifierProvider.value(value: InvestApi()),
  ChangeNotifierProvider.value(value: StartPageViewModel()),
  ChangeNotifierProvider.value(value: SliderViewModel()),
  ChangeNotifierProvider.value(value: LoginViewModel()),
  ChangeNotifierProvider.value(value: ThemeModel()),
  ChangeNotifierProvider.value(value: ProfileViewModel()),
  ChangeNotifierProvider.value(value: InvestViewModel()),
  ChangeNotifierProvider.value(value: HomeViewModel()),
];
