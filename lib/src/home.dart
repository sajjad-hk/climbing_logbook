import 'package:flutter/material.dart';
import 'package:hundred_climbs/src/climbingRouteWizard/state/wizardState.dart';
import 'package:hundred_climbs/src/dashboard/dashboard.dart';
import 'package:hundred_climbs/src/dashboard/state/dashboardState.dart';
import 'package:hundred_climbs/src/editeRouteWizard/editRouteWizard.dart';
import 'package:hundred_climbs/src/models/values.dart';
import 'package:provider/provider.dart';

import 'commons/tags/tags.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    final state = Provider.of<DashboardState>(context);

    if (user != null) {
      return SafeArea(
        child: ChangeNotifierProvider(
          builder: (context) => WizardState(user?.lastClimb),
          child: IndexedStack(
            index: state.mode,
            children: <Widget>[
              user.totalNumOfClimbs != 0 ? Dashboard() : FirstDashboard(),
              EditRouteWizard(),
              TagsL(),
            ],
          ),
        ),
      );
    } else {
      // Todo add on user loading some how
      return Container();
    }
  }
}

class FirstDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
