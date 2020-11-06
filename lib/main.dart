import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:chateko_purse_admin/ui/page/start_page/start_page.dart';
import 'package:chateko_purse_admin/view_models/theme_view_model/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  runApp(MyApp());
}

void setup() {
  GetIt.I.registerSingleton<AuthApi>(AuthApi());
  GetIt.I.registerSingleton<InvestApi>(InvestApi());
  GetIt.I.registerSingleton<UserApi>(UserApi());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeModel()),
      ],
      child: Builder(builder: (context) {
        return Consumer<ThemeModel>(builder: (context, model, chi) {
          return MaterialApp(
            title: ' Admin Chateko Purse',
            theme: model.theme,
            debugShowCheckedModeBanner: false,
            home: StartPage(),
          );
        });
      }),
    );
  }
}
