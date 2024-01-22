import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Lift {
  final String departurePlace;
  final String destination;
  final String date;
  final String time;
  final int seats;

  Lift({
    required this.departurePlace,
    required this.destination,
    required this.date,
    required this.time,
    required this.seats,
  });
}

class LiftsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Lift> lifts = [];

  Future<void> createLift({
    required String departurePlace,
    required String destination,
    required String date,
    required String time,
    required int seats,
  }) async {
    try {
      // Data validation: Ensure date follows a specific format (you can use a library like intl for this)
      // Example format: 'yyyy-MM-dd'
      DateTime.parse(date);

      // Data validation: Ensure time follows a specific format (you can use a library like intl for this)
      // Example format: 'HH:mm'
      DateFormat('HH:mm').parse(time);

      // Data validation: Ensure seats is within a reasonable range (positive and not too large)
      if (seats <= 0 || seats > 100) {
        throw ArgumentError('Invalid number of seats');
      }

      // Create a new Lift object
      Lift newLift = Lift(
        departurePlace: departurePlace,
        destination: destination,
        date: date,
        time: time,
        seats: seats,
      );

      // Save the new lift to Firebase Firestore
      await _firestore.collection('lifts').add({
        'departurePlace': newLift.departurePlace,
        'destination': newLift.destination,
        'date': newLift.date,
        'time': newLift.time,
        'seats': newLift.seats,
      });

      // Notify listeners that the lift has been created
      notifyListeners();
    } catch (e) {
      print('Error creating lift: $e');
      // Optionally, you can rethrow the exception to propagate it to the caller
      // throw e;
    }
  }

  Future<void> fetchUserLifts(String userId) async {
    try {
      // User authentication: Ensure userId is not null or empty
      if (userId.isEmpty) {
        throw ArgumentError('Invalid userId');
      }

      // Fetch lifts created by the user with the specified userId
      var liftsSnapshot = await _firestore.collection('lifts').where('userId', isEqualTo: userId).get();

      // Clear existing lifts
      lifts.clear();

      // Convert each document to a Lift object and add to the list
      for (var liftDoc in liftsSnapshot.docs) {
        Map<String, dynamic> liftData = liftDoc.data() as Map<String, dynamic>;
        Lift lift = Lift(
          departurePlace: liftData['departurePlace'],
          destination: liftData['destination'],
          date: liftData['date'],
          time: liftData['time'],
          seats: liftData['seats'],
        );
        lifts.add(lift);
      }

      // Notify listeners that lifts have been fetched
      notifyListeners();
    } catch (e) {
      print('Error fetching user lifts: $e');
      // Optionally, you can notify the UI or user about the error
    }
  }
}
