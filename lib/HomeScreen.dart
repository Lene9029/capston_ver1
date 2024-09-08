import 'package:flutter/material.dart';
import 'package:recipe_page_new/Detect_Object_Page.dart';
import 'package:recipe_page_new/providers/alleres_provider.dart';
import 'package:recipe_page_new/ui/screens/main_recipe_screen.dart';
import 'package:recipe_page_new/ui/screens/new_recipe_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SMART PALATE"),
      centerTitle: true,
      backgroundColor: Colors.pink,),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipeScreen()));
                }, child: const Text('Add Recipe')),
          SizedBox(height: 80,),

          ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => detect_object_page()));
                }, child: const Text('Scan Ingredients')),
          SizedBox(height: 80,),

          ElevatedButton(child: Text('Main Recipe Screen'),
          onPressed:  (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => MainRecipeScreen()));
             
          }),
           
        ],
      )),
      
    );
  }
}