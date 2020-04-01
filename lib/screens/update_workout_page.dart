import "package:flutter/material.dart";
import 'package:lfti_app/components/custom_card.dart';
import "package:numberpicker/numberpicker.dart";

// class imports
import "package:lfti_app/classes/Constants.dart";
import 'package:lfti_app/classes/Exercise.dart';
import "package:lfti_app/classes/User.dart";
import "package:lfti_app/classes/Workout.dart";
import "package:lfti_app/classes/Routine.dart";
import "package:lfti_app/classes/TimedRoutine.dart";
import "package:lfti_app/classes/Crud.dart";

// component imports
import "package:lfti_app/components/bottom_navigation_button.dart";
import 'package:lfti_app/components/custom_button_card.dart';
import "package:lfti_app/components/routine_card.dart";
import "package:lfti_app/components/time_dropdown_menu.dart";
import "package:lfti_app/components/custom_dialog_button.dart";
import "package:lfti_app/components/custom_text_form_field.dart";

class UpdateWorkoutPage extends StatefulWidget {
  final Map _args;
  UpdateWorkoutPage(this._args);

  @override
  _UpdateWorkoutPageState createState() => _UpdateWorkoutPageState(this._args);
}

class _UpdateWorkoutPageState extends State<UpdateWorkoutPage> {
  User _currentUser;
  Workout _workout;
  int _workoutIndex;
  List<Routine> _routineList;
  String _name, _description;
  TextEditingController _nameTextController, _descriptionTextController;
  Crud crudController;

  _UpdateWorkoutPageState(Map args) {
    this._currentUser = args["user"];
    this._workoutIndex = args["index"];
    this._workout = this._currentUser.getWorkoutAt(this._workoutIndex);
    this._routineList = this._workout.routines;
    this._name = this._workout.name;
    this._description = this._workout.description;
    this._nameTextController = TextEditingController(text: _name);
    this._descriptionTextController = TextEditingController(text: _description);
    crudController = Crud(_currentUser);
  }

  void _showUpdateRestTimeDialog(int index) async {
    final _timeDropdownMenu =
        TimeDropdownMenu(_workout.routines[index].timeToPerformInSeconds);
    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Time (seconds)"),
          content: _timeDropdownMenu,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: kCardBackground.withOpacity(0.9),
          actions: <Widget>[
            CustomDialogButton(
              label: "DELETE",
              onPressed: () {
                setState(() {
                  this._currentUser.deleteRoutineAt(this._workoutIndex, index);
                });
                Navigator.of(context).pop();
              },
              color: kRedButtonColor.withOpacity(0.5),
            ),
            CustomDialogButton(
              label: "CONFIRM",
              onPressed: () {
                setState(() {
                  _workout.routines[index].timeToPerformInSeconds =
                      _timeDropdownMenu.getValue();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddRoutineDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Choose Type of Routine",
            style: kMediumLabelTextStyle,
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                FlatButton(
                  color: kGreenButtonColor.withOpacity(0.1),
                  child: Text(
                    "Rest",
                    style:
                        kButtonTextFontStyle.copyWith(color: kGreenButtonColor),
                  ),
                  onPressed: () {
                    _addRestRoutine();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: kSizedBoxHeight),
                FlatButton(
                  color: kRedButtonColor.withOpacity(0.1),
                  child: Text(
                    "Exercise",
                    style:
                        kButtonTextFontStyle.copyWith(color: kRedButtonColor),
                  ),
                  onPressed: () {
                    this._routineList.add(Routine(
                          exercise: Exercise(name: "", focus: "--"),
                          sets: 1,
                          reps: 1,
                        ));
                    Navigator.pop(context);
                    _updateExerciseRoutine(_routineList.length - 1);
                  },
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: kCardBackground,
        );
      },
    );
  }

  void _addRestRoutine() {
    setState(() {
      _routineList.add(TimedRoutine());
    });
  }

  void _updateExerciseRoutine(int index) {
    Navigator.pushNamed(context, "/updateRoutine", arguments: {
      "user": this._currentUser,
      "workoutIndex": this._workoutIndex,
      "routineIndex": index
    });
  }

  List<RoutineCard> _getRoutineCards() {
    final routines = List<RoutineCard>();
    if (this._routineList.isNotEmpty) {
      for (int i = 0; i < this._routineList.length; i++) {
        routines.add(
          RoutineCard(
            onOptionsTap: () => _removeWorkoutAt(i),
            optionsIcon: Icons.delete,
            routine: _routineList[i],
            onTap: _routineList[i] is TimedRoutine
                ? () => _showUpdateRestTimeDialog(i)
                : () => _updateExerciseRoutine(i),
          ),
        );
      }
    }
    return routines;
  }

  void _removeWorkoutAt(int index) {
    setState(() {
      _routineList.removeAt(index);
    });
  }

  void _saveChanges() {
    this._workout.setName(_nameTextController.text.isEmpty
        ? "Unnamed Workout"
        : _nameTextController.text.toString());
    this._workout.setDescription(_descriptionTextController.text.isEmpty
        ? ""
        : _descriptionTextController.text.toString());
    this._workout.setRoutines(this._routineList);
    this._currentUser.setWorkoutAt(this._workoutIndex, _workout);
    crudController.updateWorkoutList();
  }

  @override
  Widget build(BuildContext context) {
    // line divider
    var lineDivider = Divider(
      indent: 40.0,
      endIndent: 40.0,
      color: kIconColor.withOpacity(0.2),
      thickness: 1.0,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Workout",
          style: kSmallTextStyle,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          children: <Widget>[
            // workout name
            CustomTextFormField(
              textController: _nameTextController,
              label: "Name",
            ),
            // workout description
            CustomTextFormField(
              textController: _descriptionTextController,
              label: "Description",
            ),
            Container(
              child: _routineList.isEmpty
                  ? Column(
                      children: <Widget>[
                        lineDivider,
                        Text(
                          "No Routines Yet!",
                          style: kSmallBoldTextStyle.copyWith(
                              fontStyle: FontStyle.italic,
                              color: kGrayTextColor),
                          textAlign: TextAlign.center,
                        ),
                        lineDivider,
                      ],
                    )
                  : null,
            ),
            // routines section
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ..._getRoutineCards(),
              ],
            ),
            SizedBox(height: kSizedBoxHeight),
            CustomButtonCard(onTap: () => _showAddRoutineDialog())
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationButton(
        label: "SAVE CHANGES",
        action: () {
          _saveChanges();
          Navigator.pushNamed(context, "/workouts", arguments: _currentUser);
        },
        color: kBlueButtonColor,
      ),
    );
  }
}
