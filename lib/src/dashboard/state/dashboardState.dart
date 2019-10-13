import 'package:climbing_logbook/src/dashboard/state/DashboardMode.dart';
import 'package:climbing_logbook/src/models/values.dart';
import 'package:flutter/widgets.dart';

class DashboardState extends ChangeNotifier {
  int _mode;
  ClimbingRoute _selectedClimbingRoute;
  List<ClimbingRoute> _selectedClimbingRoutes;

  DashboardState()
      : _mode = DashboardMode.defaultDashboard,
        _selectedClimbingRoutes = List<ClimbingRoute>(),
        super();

  int get mode => _mode;
  ClimbingRoute get selectedClimbingRoute => _selectedClimbingRoute;
  List<ClimbingRoute> get selectedClimbingRoutes => _selectedClimbingRoutes;

  pickClimbingRoute(ClimbingRoute route) {
    _selectedClimbingRoute = route;
    notifyListeners();
  }

  selectClimbingRoute(ClimbingRoute route) {
    if (!_selectedClimbingRoutes.contains(route))
      _selectedClimbingRoutes.add(route);
    else
      _selectedClimbingRoutes.remove(route);
    notifyListeners();
  }

  clearSelections() {
    _selectedClimbingRoutes.clear();
    notifyListeners();
  }

  unSelectClimbingRoute(ClimbingRoute route) {
    _selectedClimbingRoutes.remove(route);
    notifyListeners();
  }

  bool isSelected(ClimbingRoute route) {
    return _selectedClimbingRoutes.contains(route);
  }

  close() {
    _mode = DashboardMode.defaultDashboard;
    notifyListeners();
  }

  openNew() {
    _mode = DashboardMode.newClimbingRouteWizardOpen;
    notifyListeners();
  }

  openEdit() {
    _mode = DashboardMode.editClimbingRoutePageOpen;
    notifyListeners();
  }
}