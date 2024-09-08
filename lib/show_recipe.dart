import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_page_new/models/recipe_model.dart';
import 'package:recipe_page_new/providers/alleres_provider.dart';
import 'package:recipe_page_new/ui/widgets/recipe_widget.dart';

// ignore: must_be_immutable
class ShowRecipeWithIngredients extends StatefulWidget {
   
  ShowRecipeWithIngredients({super.key, required this.recipes, required this.resultData,});
  final List<RecipeModel> recipes;
  List<RecipeModel> filteredRecipes = [];
  final List<String> resultData;
  List<RecipeModel> filteredRecipe = [];

  State<ShowRecipeWithIngredients> createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<ShowRecipeWithIngredients> {
  late List<RecipeModel> _filteredRecipes;
  List<RecipeModel> _filteredRecipe = [];
  
  void filterRecipe(String value) {
    setState(() {
      _filteredRecipes = widget.recipes
          .where((recipe) =>
              recipe.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
 _filterRecipes(List<String> resultData) {
    setState(() {
      for (var ingredient in resultData){
        

       _filteredRecipes = widget.recipes
          .where((recipe) =>
              recipe.ingredients.toLowerCase().contains(ingredient))
          .toList();
          print(ingredient);
        
       
         _filteredRecipe.addAll(_filteredRecipes);
        
      }
    });
      
    
  }

  @override
  void initState() {
    _filterRecipes(widget.resultData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            filterRecipe(value);
          },
          decoration: const InputDecoration(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: "Search Recipe",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: _filteredRecipe.isNotEmpty
            ? ListView.builder(
                itemCount: _filteredRecipe.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeWidget(_filteredRecipe[index]);
                },
              )
            : const Center(
                child: Text('Recipe not found...'),
              ),
      ),
    );
  }
}