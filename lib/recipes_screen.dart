import 'package:flutter/material.dart';
import 'package:recipe_app/recipe_details.dart';
import 'package:recipe_app/recipes_model.dart';
import 'package:recipe_app/services.dart';
// import 'package:food_recipe_app/services.dart';

class RecipesHomeScreen extends StatefulWidget {
  const RecipesHomeScreen({super.key});

  @override
  State<RecipesHomeScreen> createState() => _RecipesHomeScreenState();
}

class _RecipesHomeScreenState extends State<RecipesHomeScreen> {
  List<Recipe> recipesModel = [];
  List<Recipe> filteredRecipes = [];
  bool isLoading = false;
  String searchQuery = "";

  @override
  void initState() {
    myRecipes();
    super.initState();
  }

  void myRecipes() {
    setState(() {
      isLoading = true;
    });
    recipesItems().then((value) {
      setState(() {
        recipesModel = value;
        filteredRecipes = value;
        isLoading = false;
      });
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredRecipes = recipesModel.where((recipe) {
        return recipe.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Center(child: const Text("Recipes App")),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Food',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(
                  Icons.food_bank_sharp,
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (query) => updateSearchQuery(query),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          final recipe = filteredRecipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(recipe: recipe),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    image: DecorationImage(
                      image: NetworkImage(recipe.image),
                      fit: BoxFit.fill,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(-5, 3),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 45,
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(19),
                        bottomRight: Radius.circular(29),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Text(
                              recipe.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 220, 42, 59),
                        ),
                        Text(
                          recipe.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                            color: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          recipe.cookTimeMinutes.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "min",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}