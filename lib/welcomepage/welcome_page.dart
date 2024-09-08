import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipe_page_new/Detect_Object_Page.dart';
import 'package:recipe_page_new/HomeScreen.dart';
import 'package:recipe_page_new/providers/alleres_provider.dart';
import 'package:recipe_page_new/ui/screens/favorite_recipes_screen.dart';
import 'package:recipe_page_new/ui/screens/main_recipe_screen.dart';
import 'package:recipe_page_new/ui/screens/new_recipe_screen.dart';
import 'package:recipe_page_new/ui/screens/shopping_list_screen.dart';
import 'package:recipe_page_new/welcomepage/page_one_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class welcomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {       
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
      routes: {
        '/detect_screen':(context) => const detect_object_page(),
        '/favorite_recipes_screen': (context) => const FavoriteRecipesScreen(),
        '/new_recipe_screen': (context) => const NewRecipeScreen(),
        '/main_recipe_screen': (context) => const MainRecipeScreen(),
        '/shopping_list_screen': (context) => const ShoppingListScreen(),
        '/homescreen'  :(context) => const HomeScreen()
      },
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final controller = OnboardingItems();
  int _currentPage = 0;

  final List<String> _allergenchoices = [
    'Peanut',
    'Cashew Nuts',
    'Milk',
    'Eggs',
    'Wheat',
    'Soy',
    'Fish',
    'Shellfish',
    'Sesame Seeds',
    'Mustard',
    'Corn',
    'Meat',
    'Fruits',
    'Soy Sauce',
    'Lemon',
    'Garlic',
    'Black Pepper',
    'Onions',
    'Chili Flakes',
    'Mushrooms'
  ];

  final List<String> restrictionsChoices = [
    'Vegetarian',
    'Vegan',
    'Gluten-free',
    'Lactose-free',
    'Keto',
    'Sugar-free'
  ];

  late List<bool> _selectedAllergenChoices;
  late List<bool> _selectedRestrictionsChoices;

  @override
  void initState() {
    super.initState();
    _selectedAllergenChoices = List<bool>.filled(_allergenchoices.length, false);
    _selectedRestrictionsChoices = List<bool>.filled(restrictionsChoices.length, false);
    
  }

  String getSelectedAllergens() {
    List<String> selectedAllergenChoices = [];

    for (int i = 0; i < _allergenchoices.length; i++) {
      if (_selectedAllergenChoices[i]) {
        selectedAllergenChoices.add(_allergenchoices[i]);
      }
    }
    return selectedAllergenChoices.join(', ');
  }

  String getSelectedRestrictions(){
    List<String> selectedRestrictionsChoices = [];

    for (int i = 0; i < restrictionsChoices.length; i++){
      if (_selectedRestrictionsChoices[i]){
        selectedRestrictionsChoices.add(restrictionsChoices[i]);
      }
    }
    return selectedRestrictionsChoices.join(',');
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      String allergens = getSelectedAllergens();
      String restrictions = getSelectedRestrictions();
      
      
      
      AlleresProvider().updateRestrictions(restrictions);
      AlleresProvider().updateAllergens(allergens);
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      
    }
  } 

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: <Widget>[
          _buildPage1(),
          _buildPage2(),
          _buildPage3(),
          _buildPage4(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             TextButton(
                onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text("Skip"),
                
              ),
              SmoothPageIndicator(controller: _pageController, count: 4,
              effect:  const WormEffect(
                activeDotColor: Colors.green
              ),),
                
               TextButton(
                onPressed: _nextPage,
                child: Text(_currentPage == 3 ? 'Finish' : 'Next'),    
              ),
            ],
          ),
        ),
      ),
    );
     
  }

  Widget _buildPage1() {
    return Scaffold(
      body: Container(
        child: Column(
          children: [Image.asset(controller.items[0].image),
          SizedBox(height: 15),
          Text(controller.items[0].title, 
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          SizedBox(height: 15,),
          Text(controller.items[0].descriptions)
          ],
          
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select Options:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(
                _allergenchoices.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(_allergenchoices[index]),
                    selected: _selectedAllergenChoices[index],
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedAllergenChoices[index] = selected;
                      });
                    },
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage3(){
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Dietary Restrictions:'),
          SizedBox(height: 20,),
          Wrap(
            spacing: 8.0,
            children: List<Widget>.generate(
              restrictionsChoices.length, 
              (int index) {
                return ChoiceChip(label: Text(restrictionsChoices[index]),
                 selected: _selectedRestrictionsChoices[index],
                 onSelected: (bool selected){
                  setState(() {
                    _selectedRestrictionsChoices[index] = selected;
                  });
                 },
                );
              }),
          )
        ]
        
      ),),
      
    );
  }
}

  Widget _buildPage4() {
    return Center(
      child: Text(
        'Thank you for using our app!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
