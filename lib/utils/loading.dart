import 'package:flutter/material.dart';

class Loading {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(), // Loading indicator
                SizedBox(width: 20.0),
                Text('Loading...'), // Text indicating loading
              ],
            ),
          ),
        );
      },
    );
  }
}
