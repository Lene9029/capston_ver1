import 'package:flutter/material.dart';

class AlleresProvider  {
  String allergens = '';
  String restrictions = '';

  

  void updateAllergens(String selectedAllergens) {
    allergens = selectedAllergens;
    
  }

  void updateRestrictions(String selectedRestrictions) {
    restrictions = selectedRestrictions;
    
  }
}
