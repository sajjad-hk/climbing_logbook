import 'package:hundred_climbs/src/models/values.dart';
import 'package:hundred_climbs/src/screens/layout-utils/layout-utils.dart';
import 'package:hundred_climbs/src/screens/screens.dart';
import 'package:hundred_climbs/src/services/chartService.dart';
import 'package:hundred_climbs/src/services/climbService.dart';
import 'package:provider/provider.dart';

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: MultiProvider(
                        providers: [
                          StreamProvider<
                              Map<String, Map<DateTime, List<Climb>>>>.value(
                            value: chartService
                                .getClimbingCountChartData(user?.uid),
                          ),
                          StreamProvider<List<DateTime>>.value(
                              value: climbService.climbingSessions(user?.uid)),
                        ],
                        child: StackedBarChart(),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.lightNavy, AppColors.dark],
                ),
              ),
            ),
          ),
          expandedHeight: screens['DASHBOARD']['CHART_HEIGHT']
              [LayoutUtils(context).screenSize],
        ),
        StreamProvider<Map<DateTime, List<Climb>>>.value(
          value: climbService.climbsGroupByDate(user?.uid),
          child: ClimbingRoutes(),
        ),
      ],
    );
  }
}
