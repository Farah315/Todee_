import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todee_/core/AppLocalizations.dart';
import 'package:provider/provider.dart';
import 'package:todee_/presentation/provider/locale_provider.dart';
import 'package:todee_/presentation/provider/task_provider.dart';
import 'package:todee_/presentation/provider/theme_provider.dart';
import 'package:todee_/presentation/screen/HomeScreen.dart';
import 'data/datasource/local.dart';
import 'data/repository/task_repository_impl.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(
            repository: TaskRepositoryImpl(
              database: LocalDatabase.instance,
            ),
          ),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            title: 'To-Do App',
            debugShowCheckedModeBanner: false,

            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}