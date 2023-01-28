import 'dart:async';

import 'package:flutter/material.dart';

errorPopUpAlert(BuildContext context, String text) {
  Timer timer = Timer(const Duration(milliseconds: 3000), () {
    Navigator.of(context, rootNavigator: true).pop();
  });
  showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) {
        return FractionallySizedBox(
          widthFactor: 0.9,
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width:
                      MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                          .size
                          .width,
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(text,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).then((value) {
    timer.cancel();
  });
}
