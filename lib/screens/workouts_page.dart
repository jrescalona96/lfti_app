import "package:flutter/material.dart";

// class imports
import "package:lfti_app/classes/Constants.dart";
import "package:lfti_app/classes/User.dart";
import "package:lfti_app/classes/Workout.dart";
import "package:lfti_app/classes/Routine.dart";
import "package:lfti_app/classes/Crud.dart";

// component imports
import "package:lfti_app/components/workout_card.dart";
import "package:lfti_app/components/bottom_navigation_button.dart";
import "package:lfti_app/components/menu.dart";
import "package:lfti_app/components/empty_state_notification.dart";
import "package:lfti_app/components/custom_dialog_button.dart";
import "package:lfti_app/components/custom_floating_action_button.dart";

class WorkoutsPage extends StatefulWidget {
  final User _currentUser;
  WorkoutsPage(this._currentUser);

  @override
  _WorkoutsPageState createState() => _WorkoutsPageState(_currentUser);
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  User _currentUser;
  List<Workout> _workoutList;
  Crud crudController;

  _WorkoutsPageState(this._currentUser) {
    if (_currentUser.getWorkoutList().isEmpty) {
      this._currentUser.setWorkoutList(List<Workout>());
    }
    this._workoutList = _currentUser.getWorkoutList();
    crudController = Crud(_currentUser);
  }

  void _showDeleteConfirmationDialog(int index) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Workout"),
          content: Text("Are you sure you want to delete Workout?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: kCardBackground.withOpacity(0.9),
          actions: <Widget>[
            CustomDialogButton(
              label: "CANCEL",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CustomDialogButton(
              label: "DELETE",
              onPressed: () {
                setState(() {
                  this._currentUser.deleteWorkoutAt(index);
                  crudController.updateWorkoutList();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCreateNewWorkoutDialog() async {
    final _nameTextController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Workout Name"),
          content: TextFormField(
              controller: _nameTextController,
              keyboardType: TextInputType.text),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          backgroundColor: kCardBackground.withOpacity(0.9),
          actions: <Widget>[
            CustomDialogButton(
              label: "CREATE",
              color: kGreenButtonColor.withOpacity(0.5),
              onPressed: () {
                if (_nameTextController.text != null) {
                  this._currentUser.addWorkout(
                        Workout(
                          name: _nameTextController.text,
                          routines: List<Routine>(),
                        ),
                      );
                  Navigator.pushNamed(context, "/updateWorkout", arguments: {
                    "user": _currentUser,
                    "index": _currentUser.getWorkoutList().length - 1
                  });
                } else {
                  print("Empty Name Field!");
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          "WORKOUTS",
          style: kSmallTextStyle,
        ),
      ),
      drawer: Menu(_currentUser),
      body: _workoutList.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    Widget item;
                    if (index < _workoutList.length) {
                      item = WorkoutCard(
                          onOptionsTap: () =>
                              _showDeleteConfirmationDialog(index),
                          optionsIcon: Icons.delete,
                          user: this._currentUser,
                          index: index,
                          onTap: () {
                            Navigator.of(context).pushNamed('/updateWorkout',
                                arguments: {
                                  "user": this._currentUser,
                                  "index": index
                                });
                          });
                    }
                    return item;
                  }),
                ),
              ],
            )
          : EmptyStateNotification(sub: "Create workout routines first."),
      floatingActionButton: CustomFloatingActionButton(
        icon: Icons.add,
        onPressed: () => _showCreateNewWorkoutDialog(),
      ),
      bottomNavigationBar: BottomNavigationButton(
        label: "START WORKOUT",
        action: () => Navigator.pushNamed(context, "/viewWorkouts",
            arguments: this._currentUser),
        color: kBlueButtonColor,
      ),
    );
  }
}
