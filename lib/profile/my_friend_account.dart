import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';

class MyFriendAccount extends StatefulWidget {
  static String routeName = '/my_friend_account';
  const MyFriendAccount({Key? key}) : super(key: key);

  @override
  State<MyFriendAccount> createState() => _MyFriendAccountState();
}

class _MyFriendAccountState extends State<MyFriendAccount> {
  MyFriendAccount? args;
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as MyFriendAccount?;
      
    });
    
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          'Kontak Teman',
          style: TextStyle(
            fontFamily: "Gilroy Bold",
            color: notifire.getdarkscolor,
            fontSize: height / 40,
          ),
        ),
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: serarchtextField(
              Colors.black,
              notifire.getdarkgreycolor,
              notifire.getbluecolor,
              "Cari Data",
            ),
          ),
        ),
      ),
    );
  }

  Widget serarchtextField(
    textclr,
    hintclr,
    borderclr,
    hinttext,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 40),
      child: Container(
        color: Colors.transparent,
        height: height / 17,
        child: TextField(
          controller: _searchController,
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifire.getdarkwhitecolor,
            hintText: hinttext,
            prefixIcon: Icon(
              Icons.search,
              color: notifire.getdarkgreycolor,
            ),
            hintStyle: TextStyle(color: hintclr, fontSize: height / 60),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderclr),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}