// flutter & dart imports
import "package:flutter/material.dart";

// component imports
import "package:lfti_app/components/routine_card.dart";
import "package:lfti_app/components/bottom_navigation_button.dart";
import "package:lfti_app/components/menu.dart";

// class imports
import "package:lfti_app/classes/Workout.dart";
import "package:lfti_app/classes/User.dart";
import "package:lfti_app/classes/Session.dart";
import "package:lfti_app/classes/Constants.dart";

class ViewRoutinesPage extends StatelessWidget {
  User _currentUser;
  Workout _workout;

  ViewRoutinesPage(Map args) {
    this._currentUser = args["user"];
    this._workout = args["workout"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_workout.name, style: kSmallTextStyle),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Widget item;
                  if (index < _workout.routines.length) {
                    item = RoutineCard(
                      routine: _workout.routines[index],
                      cardAction: null,
                    );
                  }
                  return item;
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationButton(
          label: "START",
          action: () {
            _currentUser.setSession(Session(_workout));
            Navigator.pushNamed(context, '/startSession',
                arguments: _currentUser);
          },
          color: kGreenButtonColor,
        ));
  }
}