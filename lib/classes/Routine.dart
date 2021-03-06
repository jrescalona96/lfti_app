import "Exercise.dart";
import "package:intl/intl.dart";
import "Constants.dart";
import "package:flutter/material.dart";

class Routine {
  String id;
  Exercise exercise;
  int sets;
  int reps;
  double weight;

  Routine(
      {@required this.exercise, this.reps = 1, this.sets = 1, this.weight}) {
    this.id = "R" + DateFormat(kFormatDateId).format(DateTime.now());
  }
}
