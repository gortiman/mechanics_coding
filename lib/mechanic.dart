import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex=0;
  List<dynamic>? data; // Explicitly define as List<dynamic>?
  Map<String, dynamic>? selectedCategory; // Explicitly define as Map<String, dynamic>?

  @override
  void initState() {
    super.initState();
    getUserApi();
  }

  Future<void> getUserApi() async {
    final response = await http.get(Uri.parse('https://api.mechanicnow.in/api/show-service'));

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body.toString());
      });
    } else {
      print("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: innerBoxIsScrolled
                      ? Colors.black.withOpacity(0.7)
                      : Colors.grey.withOpacity(0.5),
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2FyfGVufDB8fDB8fHww',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 10,
                            child: Text(
                              "Services",
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Image.network("https://mechanicnow.in/_next/static/media/Location2.632f52b9.webp"),
                      Text("Lucknow", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 5),
                      Image.network("https://mechanicnow.in/_next/static/media/logo.d51f7ef4.webp", width: 30, height: 30),
                      Text("Your cars", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, right: 20),
                      child: InkWell(
                        onTap: () {},
                        child: Image.network("https://mechanicnow.in/_next/static/media/Mask%20group%20(14).57fb1fcc.webp"),
                      ),
                    ),
                  ],
                ),
              ];
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data == null ? 0 : data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button tap
                            setState(() {
                              selectedCategory = data![index];
                            });
                          },
                          child: Text(data![index]['name'] ?? 'Unknown'), // Provide default value
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: data != null,
                    child: selectedCategory == null
                        ? ListView(
                      children: buildCategoryList(data ?? []),
                    )
                        : ListView(
                      children: [
                        ListTile(
                          title: Text(selectedCategory!['name'] ?? 'Unknown'), // Provide default value
                          onTap: () {
                            setState(() {
                              selectedCategory = null;
                            });
                          },
                        ),
                        if (selectedCategory!['children'] != null)
                          ...buildChildList(selectedCategory!['children']),
                        if (selectedCategory!['services'] != null)
                          ...buildServiceList(selectedCategory!['services']),
                      ],
                    ),
                    replacement: Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> buildCategoryList(List<dynamic> categories) {
  List<Widget> categoryWidgets = [];
  for (var category in categories) {
    categoryWidgets.add(
      ListTile(
        title: Text(category['name'] ?? 'Unknown'), // Provide default value
        onTap: () {},
      ),
    );
    if (category['children'] != null) {
      categoryWidgets.addAll(buildChildList(category['children']));
    }
  }
  return categoryWidgets;
}

List<Widget> buildChildList(List<dynamic>? children) { // Add null check for children
  List<Widget> childWidgets = [];
  if (children != null) {
    for (var child in children) {
      childWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ListTile(
            title: Text(child['name'] ?? 'Unknown'), // Provide default value
            onTap: () {},
          ),
        ),
      );
      if (child['services'] != null) {
        childWidgets.addAll(buildServiceList(child['services']));
      }
    }
  }
  return childWidgets;
}

List<Widget> buildServiceList(List<dynamic>? services) { // Add null check for services
  List<Widget> serviceWidgets = [];
  if (services != null) {
    for (var service in services) {
      serviceWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title'] ?? 'Unknown', // Provide default value
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "https://api.mechanicnow.in/storage/serviceImages/5f44vHaOurkMunl9.png",
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 20,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.blueAccent),
                            child: Text(
                              "TAKES FEW HOURS",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.green),
                            child: Text(
                              "NEW",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  service['description'] ?? 'No description available', // Provide default value
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                    "3 Hrs Taken | 1000 km or 1 Month Warranty | Every 5000 | Km or 3 Month (Recommended ) | Free Pick-up & Drop"),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Engine Oil Replacement"),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Oil Filter Replacement"),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.redAccent)),
                      child: Text(
                        "VIEW ALL",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "SELECT CAR",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
  return serviceWidgets;
}


