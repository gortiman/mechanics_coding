// views/home_page.dart
import 'package:flutter/material.dart';

import '../model/machenic_model.dart';
import '../view_model/mechanic_view_model.dart';
import 'package:provider/provider.dart';

class mechanicView extends StatefulWidget {
  const mechanicView({Key? key}) : super(key: key);

  @override
  State<mechanicView> createState() => _mechanicViewState();
}

class _mechanicViewState extends State<mechanicView> {
  ScrollController _scrollController = ScrollController();
  Category? _selectedChildCategory;
  bool _isChildCategoryVisible = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..fetchData(),
      child: Scaffold(
        bottomNavigationBar: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return BottomNavigationBar(
              currentIndex: viewModel.currentIndex,
              onTap: (index) {
                viewModel.setCurrentIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            );
          },
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            print("body");
            print("============${viewModel.data}");
            switch (viewModel.currentIndex) {
              case 1:
                return _buildSearchPage();
              case 2:
                return _buildProfilePage();
              case 0:
              default:
                return _buildHomePage(viewModel);
            }
          },
        ),
      ),
    );
  }

  Widget _buildHomePage(HomeViewModel viewModel) {
    final allServices = _collectAllServices(viewModel.data ?? []);

    return Stack(
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
                        const Positioned(
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
                // color: Colors.red,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.data == null ? 0 : viewModel.data!.length,
                  itemBuilder: (context, index) {
                    print("============${viewModel.data}");
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: (){
                            viewModel.selectCategory(viewModel.data![index]);
                            print("+++++++++++++++++++++++++${viewModel.data![index]}");
                          },
                          child: Text(viewModel.data![index].name)),
                    );
                  },
                ),
              ),

              // Text("dfgshgd==========="),

              // if (viewModel.selectedCategory?.children != null &&
              //     viewModel.selectedCategory!.children!.isNotEmpty)
                Container(
                  height: 50,
                  color: Colors.pink,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.selectedCategory!.children!.length,
                    itemBuilder: (context, index) {
                      final childCategory = viewModel.selectedCategory!.children![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            viewModel.selectSubCategory(childCategory);
                            // Scroll to the part of the screen
                            _scrollToCategory(childCategory.name);
                          },
                          child: Text(
                            childCategory.name,
                            style: TextStyle(
                              fontWeight: viewModel.selectedSubCategory == childCategory
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              Expanded(
                child: Visibility(
                  visible: viewModel.data != null,
                  child: viewModel.selectedCategory == null
                      ? ListView(
                    children: _buildServiceList(allServices),
                  )
                      : Column(
                    children: [

                      Expanded(
                        child: ListView(
                          controller: _scrollController,
                          children: [

                            // Text("Helooooooooo"),
                            // if (viewModel.selectedCategory!.children != null)
                            //   ..._buildChildList(viewModel.selectedCategory!.children!),
                            if (viewModel.selectedSubCategory!.services != null)
                               // ..._buildServiceList(viewModel.selectedCategory!.services!),
                              ..._buildCategoryAndServiceList(viewModel.selectedSubCategory!),
                          ],
                        ),
                      ),
                    ],
                  ),
                  replacement: Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _scrollToCategory(String categoryName) {
    // Implement the scroll-to-category logic here
    // Example:
    final position = _findCategoryPosition(categoryName);
    if (position != null) {
      _scrollController.animateTo(position,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }
  double? _findCategoryPosition(String categoryName) {
    // This method should determine the position of the category
    // in the scrollable view. You need to implement this based on your UI structure.
    // For example, you can use GlobalKey to mark positions in the ListView.
    return null;
  }


  List<Widget> _buildCategoryAndServiceList(Category category) {
    List<Widget> widgets = [];

    if (category.children != null) {
      for (var child in category.children!) {
        widgets.addAll(_buildCategoryAndServiceList(child));
      }
    }

    if (category.services != null) {
      widgets.addAll(_buildServiceList(category.services!));
    }

    return widgets;
  }

  List<Service> _collectAllServices(List<Category> categories) {
    List<Service> allServices = [];
    for (var category in categories) {
      if (category.services != null) {
        allServices.addAll(category.services!);
      }
      if (category.children != null) {
        allServices.addAll(_collectAllServices(category.children!));
      }
    }
    return allServices;
  }

  Widget _buildSearchPage() {
    return Center(
      child: Text('Search Page', style: TextStyle(fontSize: 24)),
    );
  }

  Widget _buildProfilePage() {
    return Center(
      child: Text('Profile Page', style: TextStyle(fontSize: 24)),
    );
  }

  List<Widget> _buildCategoryList(List<Category> categories) {
    return categories
        .map((category) => ListTile(
      title: Text(category.name), // Provide default value
      onTap: () {},
    ))
        .toList();
  }

  List<Widget> _buildChildList(List<Category> children) {
    return children
        .map((child) => Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ListTile(
        title: Text(child.name), // Provide default value
        trailing: Text("childreeeeeeen"),
        onTap: () {
          print("children");
        },
      ),
    ))
        .toList();
  }

  List<Widget> _buildServiceList(List<Service> services) {
    return services
        .map((service) => Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.title,
              style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.w500),
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
              service.description,
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            Text("3 Hrs Taken | 1000 km or 1 Month Warranty | Every 5000 | Km or 3 Month (Recommended ) | Free Pick-up & Drop"),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(50)),
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
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(50)),
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
                  decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
                  child: Text(
                    "VIEW ALL",
                    style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "SELECT CAR",
                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ))
        .toList();
  }
}
