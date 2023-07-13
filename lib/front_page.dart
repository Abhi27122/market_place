// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:market_place/authentication.dart';

import 'kart_page.dart';
import 'nft.dart';

class NFTBuyingPage extends StatefulWidget {
  @override
  State<NFTBuyingPage> createState() => _NFTBuyingPageState();
}

class _NFTBuyingPageState extends State<NFTBuyingPage> {
List<NFT> products = [];

final CollectionReference _products = FirebaseFirestore.instance.collection('products'); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Market Place'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) => Kart())));
          }, 
          icon: Icon(Icons.card_travel_sharp)),
        ],
      ),
      drawer: DrawerWidget(),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> streamSnapshot) { 
          if(streamSnapshot.hasData){
            return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      ),
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                         final DocumentSnapshot doc = streamSnapshot.data!.docs[index];
                    return _buildNFTCard(doc);
                      });
          }
          else{
            return Center(child:CircularProgressIndicator());
          }
          }
      ),
    );
  }

  Widget _buildNFTCard(DocumentSnapshot doc) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF161616), Color(0xFF252525)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              spreadRadius: 3.0,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                child: Image.network(
                  doc['url'],
                  //fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Column(
                
                children: [
                  Text(
                    doc['name'],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    doc['artist'],
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$' + doc['price'],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 35.0,
              child: TextButton(
                onPressed: () async{
                    final FirebaseAuth authfire = FirebaseAuth.instance;
                    final User? user = authfire.currentUser;
              
                    await FirebaseFirestore.instance.collection('user_kart').doc(user!.uid).update({
                      'kart': FieldValue.arrayUnion([doc.id]),
                    });
                },
                child: Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
               
                if (states.contains(MaterialState.pressed)) {
                  return Color.fromARGB(255, 192, 84, 51);
                }
                return Colors.black;
              })),
              
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DrawerWidget extends StatefulWidget {
  DrawerWidget();

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      backgroundColor: Colors.black,
      child: ListView(children: [
        DrawerHeader(
        
        child: Text("profile info",style: TextStyle(color: Colors.white,fontSize:40)),
        
        ),
        ListTile(
          tileColor: Colors.blueAccent,
          leading:TextButton(onPressed: (){},child: Text("logout",style: TextStyle(color: Colors.white),)),
          trailing: Icon(Icons.logout),
          onTap: () async {
            await FirebaseAuth.instance.signOut();             
            }
        )
      ],)
    );
  }
}