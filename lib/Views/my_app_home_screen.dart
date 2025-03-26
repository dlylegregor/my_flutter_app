// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_flutter_app/Utils/constants.dart';
import 'package:my_flutter_app/Widget/banner.dart';
import 'package:my_flutter_app/Widget/food_items_display.dart';
import 'package:my_flutter_app/Widget/my_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  // For category
  String category = "All";
  final CollectionReference categoriesItems = FirebaseFirestore.instance
      .collection("App-Category");
  // For all items display
  Query get filteredRecipes => FirebaseFirestore.instance
      .collection("Complete-Flutter-App")
      .where('category', isEqualTo: category);
  Query get allRecipes =>
      FirebaseFirestore.instance.collection("Complete-Flutter-App");
  Query get selectRecipes => category == "All" ? allRecipes : filteredRecipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerParts(),
                    mySearchBar(),
                    // for banner
                    const BannerToExplore(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // for category
                    selectedCategory(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quick & Easy",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // We will make it a function later
                          },
                          child: Text(
                            "View all",
                            style: TextStyle(
                              color: kBannerColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Place StreamBuilder here <<<<<<<<<<<<
              StreamBuilder(
                stream: selectRecipes.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> recipes =
                        snapshot.data?.docs ?? [];
                    return Padding(
                      padding: const EdgeInsets.only(top: 5, left: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              recipes
                                  .map(
                                    (e) =>
                                        FoodItemsDisplay(documentSnapshot: e),
                                  )
                                  .toList(),
                        ),
                      ),
                    );
                  }
                  // it means if snapshot has date then show the date otherwise show the progress bar
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          category == streamSnapshot.data!.docs[index]["name"]
                              ? kprimaryColor
                              : Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]["name"],
                      style: TextStyle(
                        color:
                            category == streamSnapshot.data!.docs[index]["name"]
                                ? Colors.white
                                : Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        // it means if snapshot has date then show the date otherwise show the progress bar
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Padding mySearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(Iconsax.search_normal),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: "Search any recipes",
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Row headerParts() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 25,
          ), // Adds 25 units of space to the top
          child: const Text(
            "What are you \ncooking today?",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
        const Spacer(),
        MyIconButton(icon: Iconsax.notification, pressed: () {}),
      ],
    );
  }

  // Row headerParts() {
  //   return Row(
  //     children: [
  //       const Text(
  //         "What are you \ncooking today?",
  //         style: TextStyle(
  //           fontSize: 32,
  //           fontWeight: FontWeight.bold,
  //           height: 1,
  //         ),
  //       ),
  //       const Spacer(),
  //       MyIconButton(icon: Iconsax.notification, pressed: () {}),
  //     ],
  //   );
  // }
}
