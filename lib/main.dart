import 'package:chateko_purse_admin/ui/utils/get_it.dart';
import 'package:chateko_purse_admin/ui/utils/providers.dart';
import 'package:chateko_purse_admin/ui/views/start_view/start_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chateko_purse_admin/view_models/theme_view_model/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (context) {
        return Consumer<ThemeModel>(builder: (context, model, chi) {
          return MaterialApp(
            title: ' Admin Chateko Purse',
            theme: model.theme,
            debugShowCheckedModeBanner: false,
            home: StartView(),
          );
        });
      }),
    );
  }
}
