import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save article to Firestore
  Future<void> saveArticle(String userId, Map<String, dynamic> articleData) async {
    await _db.collection('users').doc(userId).collection('saved_articles').add(articleData);
  }

  // Retrieve saved articles from Firestore
  Future<List<Map<String, dynamic>>> getSavedArticles(String userId) async {
    QuerySnapshot snapshot = await _db.collection('users').doc(userId).collection('saved_articles').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}