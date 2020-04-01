import 'package:flutter/material.dart';

// class imports
import 'package:lfti_app/classes/Workout.dart';
import 'package:lfti_app/classes/Constants.dart';
import 'package:lfti_app/classes/User.dart';
import "package:lfti_app/classes/Routine.dart";

// component imports
import 'package:lfti_app/components/custom_card.dart';

class WorkoutCard extends StatelessWidget {
  final int index;
  final User user;
  Workout _workout;
  final Function onTap;
  bool dottedBorder;
  final Function onOptionsTap;
  IconData optionsIcon;
  WorkoutCard({
    this.user,
    this.index,
    this.onTap,
    this.dottedBorder = false,
    this.onOptionsTap,
    this.optionsIcon,
  }) {
    this._workout = this.user.getWorkoutAt(index);
  }

  bool _isIncompleteWorkout() {
    return _workout.name.isNotEmpty || _workout.routines.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var cardColor = _isIncompleteWorkout()
        ? kBlueButtonColor.withOpacity(0.2)
        : kRedButtonColor.withOpacity(0.2);
    var _workoutNameTextStyle = kMediumBoldTextStyle;
    var _descriptionTextStyle = kLabelTextStyle;
    var _routineCountTextStyle = kMediumBoldTextStyle;

    return GestureDetector(
      onTap: this.onTap,
      child: CustomCard(
        color: cardColor,
        dottedBorder: this.dottedBorder,
        cardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    this._workout.name,
                    style: _workoutNameTextStyle,
                  ),
                ),
                this.onOptionsTap == null
                    ? SizedBox(height: 0.0)
                    : Expanded(
                        child: GestureDetector(
                          child: Container(
                              alignment: AlignmentDirectional.topEnd,
                              child: Icon(optionsIcon, size: 20.0)),
                          onTap: this.onOptionsTap,
                        ),
                      )
              ],
            ),
            SizedBox(height: kSmallSizedBoxHeight),
            Text(
              this._workout.description,
              style: _descriptionTextStyle,
            ),
            SizedBox(height: kSizedBoxHeight),
            Text(
              this._workout == null
                  ? "No Routines yet"
                  : _workout.routines.length > 1
                      ? _workout.routines.length.toString() + ' Routines'
                      : _workout.routines.length.toString() + "Routine",
              style: _routineCountTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
