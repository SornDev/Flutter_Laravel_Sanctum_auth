import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanctum_flutter_app_03/login_screen.dart';
import 'package:sanctum_flutter_app_03/service/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:sanctum_flutter_app_03/service/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = new FlutterSecureStorage();
  String User_data = 'ໜ້າຫຼັກ Home Screen A';

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tyToken(token: token.toString());
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ໜ້າຫຼັກ"),
        ),
        body: Center(
          child: Text(
            User_data,
            style: TextStyle(fontSize: 30),
          ),
        ),
        drawer: Drawer(
          child: Consumer<Auth>(
            builder: (context, auth, child) {
              if (!auth.authenticated) {
                return ListView(
                  children: [
                    ListTile(
                      title: Text('ເຂົ້າສູ່ລະບົບ'),
                      leading: Icon(Icons.login),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                    ),
                  ],
                );
              } else {
                return ListView(
                  children: [
                    DrawerHeader(
                      child: Column(
                        children: [
                          CircleAvatar(
                            // backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                'https://thegritandgraceproject.org/wp-content/uploads/2017/01/Anatomy-of-a-Strong-Woman.jpg'),
                            radius: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            auth.user.name,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            auth.user.email,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                    ListTile(
                      title: Text('ຂໍ້ມູນຜູ້ໃຊ້'),
                      leading: Icon(Icons.account_circle),
                      onTap: () {
                        getUserData();
                      },
                    ),
                    ListTile(
                      title: Text('ອອກຈາກລະບົບ'),
                      leading: Icon(Icons.logout),
                      onTap: () {
                        Provider.of<Auth>(context, listen: false).logout();
                        setState(() {
                          User_data = 'ໜ້າຫຼັກ Home Screen A';
                        });
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }

  void getUserData() async {
    String? token = await storage.read(key: 'token');
    var response = await dio().get(
      '/user',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    setState(() {
      User_data = response.data.toString();
    });
    //print(response.data);
  }
}
