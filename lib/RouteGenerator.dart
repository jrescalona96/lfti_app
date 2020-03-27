import "package:flutter/material.dart";

// class imports
import "package:lfti_app/classes/Constants.dart";
import "package:lfti_app/classes/User.dart";

// screen imports
import "package:lfti_app/screens/home_page.dart";
import "package:lfti_app/screens/dashboard_page.dart";
import "package:lfti_app/screens/login_page.dart";
import "package:lfti_app/screens/workouts_page.dart";
import "package:lfti_app/screens/session_page.dart";
import "package:lfti_app/screens/signup_page.dart";
import "package:lfti_app/screens/view_routines_page.dart";
import "package:lfti_app/screens/session_summary_page.dart";
import "package:lfti_app/screens/update_workout_page.dart";
import "package:lfti_app/screens/update_checklist_page.dart";

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args =
        settings.arguments; // Hold arguments passed from previous screen
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => HomePage());
        break;
      case "/login":
        if (args is Map<String, String>) {
          return MaterialPageRoute(builder: (_) => LoginPage(args));
        } else {
          return _errorRoute();
        }
        break;
      case "/signup":
        return MaterialPageRoute(builder: (_) => SignUpPage());
        break;
      case "/dashboard":
        print("dashboard args: $args");
        if (args is User) {
          return MaterialPageRoute(builder: (_) => DashboardPage(args));
        } else {
          return _errorRoute();
        }
        break;
      case "/workouts":
        print("workouts args: $args ");
        if (args is User) {
          return MaterialPageRoute(builder: (_) => WorkoutsPage(args));
        } else {
          return _errorRoute();
        }
        break;
      case "/updateWorkout":
        print("updateWorkout args: $args");
        if (args is Map) {
          return MaterialPageRoute(builder: (_) => UpdateWorkoutPage(args));
        } else {
          return _errorRoute();
        }
        break;
      case "/updateChecklist":
        print("updateChecklist args: $args");
        if (args is User) {
          return MaterialPageRoute(builder: (_) => UpdateChecklistPage(args));
        } else {
          return _errorRoute();
        }
        break;
      case "/viewWorkout":
        print("viewWorkout args: $args");
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => ViewRoutinesPage(args),
          );
        } else {
          return _errorRoute();
        }
        break;
      case "/startSession":
        print("startSession args: $args");
        if (args is User) {
          return MaterialPageRoute(
            builder: (_) => SessionPage(args),
          );
        } else {
          return _errorRoute();
        }
        break;
      case "/endSession":
        print("endSession args: $args");
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => SessionSummaryPage(args),
          );
        } else {
          return _errorRoute();
        }
        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Error!",
          ),
        ),
        body: Center(
          child: Text(
            "Something went wrong!",
            style: kMediumBoldTextStyle,
          ),
        ),
      );
    });
  }
}