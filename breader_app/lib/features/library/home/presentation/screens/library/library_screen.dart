import 'package:breader_app/style/colors.dart';
import 'package:flutter/material.dart';

class Library_Screen extends StatelessWidget {
  var last_book = 4;


  Library_Screen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:  Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20,top: 20,bottom: 20),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:MaterialStateProperty.all(App_Colors.blue_main),
            ), 
            child: Container(
              
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('data',style: TextStyle(color: Colors.white),),
                  Icon(Icons.add,color: Colors.white,)
                ],
              ),
            ),
            onPressed: (){},
            )
          ),
          const Padding(
            padding:EdgeInsets.all(15),
            child: Text('Последние прочитанные'), 
          ),
          
        ],));

  }
}