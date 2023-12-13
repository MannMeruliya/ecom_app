import 'package:ecom_app/model/ecom_model.dart';
import 'package:ecom_app/provider/ecom_provider.dart';
import 'package:ecom_app/screen/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EcomProvider>(context, listen: false).getallProduct();
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  List<ProductElement> _list = [];

  final List<ProductElement> _searchList = [];

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name",
                  contentPadding: EdgeInsets.all(20),
                ),
                style: const TextStyle(fontSize: 18),
                cursorColor: Colors.indigo,
                autofocus: true,
                onChanged: (value) {
                  _searchList.clear();

                  for (var i in _list) {
                    if (i.brand!.toLowerCase().contains(value.toLowerCase())) {
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
              )
            : const Text("CartCraft"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              accountName: Text(
                "Mann Meruliya",
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text("mannmeruliya@gmail.com"),
              currentAccountPictureSize: Size.square(70),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Text(
                  "M",
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
                signOut();
              },
            ),
          ],
        ),
      ),
      body: Consumer<EcomProvider>(
        builder: (context, provider, child) => FutureBuilder(
          future: provider.getallProduct(),
          builder: (context, snapshot) {
            Product product = snapshot.data!;
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('');
              },
              child: GridView.builder(
                itemCount: product.products!.length,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.63),
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  color: Colors.grey.shade300,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 160,
                        width: 150,
                        // color: Colors.grey.shade300,
                        color: Colors.grey.shade300,
                        child: Image.network(
                            "${product.products![index].thumbnail}"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 14, top: 14)),
                          Container(
                            width: 163,
                            child: Text(
                              product.products![index].brand!,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border)),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 14, top: 14)),
                          Text(
                            "\$ ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            product.products![index].price.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// IconButton(
// onPressed: () {
// Navigator.of(context).pushNamed(
// 'favscreen',
// arguments: product
//     .products![index].title);
// },
// icon: Icon(Icons.favorite),
// ),

//     Column(
//   children: [
//     Container(
//       padding: EdgeInsets.all(10),
//       height: 230,
//       width: 200,
//       decoration: BoxDecoration(
//           color: Colors.blueAccent,
//           borderRadius: BorderRadius.circular(10)),
//       child: Column(
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         // mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 height: 70,
//                 width: 70,
//                 // child: Image.network('${product.products![index].images}'),
//                 decoration: BoxDecoration(
//                   borderRadius:
//                       BorderRadius.circular(10),
//                   color: Colors.amber,
//                 ),
//               ),
//             ],
//           ),
//           Spacer(),
//           SizedBox(
//             height: 20,
//           ),
//           Column(
//             children: [
//               Text(product.products![index].brand!,softWrap: true,style: TextStyle(fontSize: 20),),
//             ],
//           ),
//           Row(
//             children: [
//               Text("Rs:-",style: TextStyle(fontSize: 18),),
//               Text(product.products![index].price
//                   .toString(),style: TextStyle(fontSize: 18),),
//             ],
//           )
//         ],
//       ),
//     ),
//   ],
// ),

// FloatingActionButton(
// onPressed: () {
// signOut();
// },
// child: Icon(
// Icons.logout,
// color: Colors.white,
// ),
// backgroundColor: Colors.red),
