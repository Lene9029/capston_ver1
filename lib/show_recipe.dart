import 'package:flutter/material.dart';
import 'package:recipe_page_new/data_repository/dbHelper.dart';
import 'package:recipe_page_new/models/recipe_model.dart';
import 'package:recipe_page_new/ui/widgets/recipe_widget.dart';

// ignore: must_be_immutable
class ShowRecipeWithIngredients extends StatefulWidget {
  final List<RecipeModel> recipes;
  List<RecipeModel> filteredRecipes = [];
  final List<String> resultData;

  ShowRecipeWithIngredients({super.key, required this.recipes, required this.resultData}) {
    filteredRecipes = recipes;
  }

  @override
  State<ShowRecipeWithIngredients> createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<ShowRecipeWithIngredients> {

  void filterRecipe(String value) {
    setState(() {
      widget.filteredRecipes = widget.recipes
          .where((recipe) =>
              recipe.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _filterRecipes(String concatenatedIngredients) {
    setState(() {
      widget.filteredRecipes = widget.recipes.where((recipe) {
        return recipe.ingredients.toLowerCase().contains(concatenatedIngredients.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // Remove duplicate words
    Set<String> uniqueIngredients = widget.resultData.toSet();
    // Concatenate unique words
    String concatenatedIngredients = uniqueIngredients.join(' ');
    _filterRecipes(concatenatedIngredients);
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
        child: widget.filteredRecipes.isNotEmpty
            ? ListView.builder(
                itemCount: widget.filteredRecipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeWidget(widget.filteredRecipes[index]);
                },
              )
            : const Center(
                child: Text('Recipe not found...'),
              ),
      ),
    );
  }
}
