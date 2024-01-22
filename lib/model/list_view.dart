
import 'package:dlala_group/model/lift.dart';
import 'package:flutter/foundation.dart';

///Contains the relevant lifts data for our views
class LiftsViewModel extends  ChangeNotifier {
  get offeredLifts => null;

  get lifts => null;

  void offerLift(Lift newLift) {}

  void updateLift(Lift lift, Lift updatedLift) {}

  void createLift({required String departurePlace, required String destination, required String date, required String time, required int seats}) {}

  fetchUserLifts(String uid) {}
  //TODO keep track of loaded Lifts and notify views on changes
}