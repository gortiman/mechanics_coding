

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechanic/config/routes/routes_name.dart';

import '../../mechanic.dart';
import '../../view/login_page.dart';

class Routes{
   static Route<dynamic> generateRoutes(RouteSettings settings){
     switch(settings.name){
       case AppRoutesName.login:
         return MaterialPageRoute(builder: (BuildContext context)=> LoginPage());

       case AppRoutesName.home:
         return MaterialPageRoute(builder: (BuildContext context)=>HomePage());

       default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
            body: Text("No Page Found"),
          );
        });
     }
   }
}