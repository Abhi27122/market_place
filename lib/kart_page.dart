import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Kart extends StatelessWidget {
   final User? user = FirebaseAuth.instance.currentUser;

  Kart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("Your cart"),
    backgroundColor: Colors.black,
    ), 
    backgroundColor: Colors.black12,
    
    body:StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user_kart')
          .doc(user!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          
          return Text('No data available');
        }

        // Accessing the 'kart' array field
        final List<dynamic> kart = snapshot.data!.get('kart');

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where(FieldPath.documentId, whereIn: kart)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container(child: CircularProgressIndicator());
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(child: CircularProgressIndicator());
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot document = snapshot.data!.docs[index];
                final Map<String, dynamic> productData = document.data() as Map<String, dynamic>;

                // Access the product data as needed
                final String productName = productData['name'];
                return buildNFTCard(productData);
              },
            );
          },
        );
      },
    ));
  }
  
}

class ProductListTile extends StatelessWidget {
  final String name;
  final String artist;
  final String price;

  ProductListTile({
    required this.name,
    required this.artist,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 39, 14, 14),
      child: ListTile(
        leading: Icon(
          Icons.videogame_asset,
          color: Colors.deepPurple,
        ),
        title: Text(
          name,
          style: TextStyle(
            color: Color.fromARGB(255, 233, 154, 154),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Artist: $artist',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              'Price: \$'+price,
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class buildNFTCard extends StatelessWidget {
  final Map<String,dynamic> doc;
  const buildNFTCard(this.doc);
  @override
  Widget build(BuildContext context) {
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
            
          ],
        ),
      ),
    );
  }}