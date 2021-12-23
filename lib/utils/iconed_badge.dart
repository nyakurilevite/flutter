import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IconedBadge extends StatelessWidget {
  IconedBadge({required Key key, this.icon, required this.items }) : super(key: key);
  var icon;
  final int items;


  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Icon(icon,size:27),
        Positioned(
          right: 0,
          child: Visibility(
                    visible:items==0?false:true,
             child:Container(
               padding: EdgeInsets.all(1),
               decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
               ),
              constraints: const BoxConstraints(
              minWidth: 15,
              minHeight: 15,
              ),
                     child: Text(
                       items.toString(),
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 10,
                       ),
                       textAlign: TextAlign.center,
                     ),
               ),
          ),
        ),
      ],
    );
  }
}


