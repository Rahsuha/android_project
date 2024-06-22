import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tabpages/auth_service.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? userProfile;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (user != null) {
      var profileData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        userProfile = profileData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xFFB8E2F2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: userProfile == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(userProfile!['photoUrl'] ?? 'path_to_some_default_image'),
          ),
          SizedBox(height: 20),
          buildDetailItem("User ID", user!.uid),
          buildDetailItem("Name", userProfile!['name']),
          buildDetailItem("Email", user!.email!),
          buildDetailItem("Phone Number", userProfile!['phone']),
          logoutButton(context),
        ],
      ),
    );
  }

  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
  Widget logoutButton(BuildContext context)
  {
    return ElevatedButton(
      onPressed: () async{
        await AuthService.logout();
        Navigator.of(context).pushNamed('/login');
      },
      child: Text('Logout'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.black,
      ),
    );
  }
}
