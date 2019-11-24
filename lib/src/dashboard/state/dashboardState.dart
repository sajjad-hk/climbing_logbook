import 'package:hundred_climbs/src/dashboard/state/DashboardMode.dart';
import 'package:hundred_climbs/src/models/values.dart';
import 'package:flutter/widgets.dart';

class DashboardState extends ChangeNotifier {
  int _mode;
  int _previousMode;
  bool _newRouteOpen = false;
  Climb _selectedClimbingRoute;
  List<Climb> _selectedClimbingRoutes;

  DashboardState()
      : _mode = DashboardMode.defaultDashboard,
        _selectedClimbingRoutes = List<Climb>(),
        super();

  int get mode => _mode;
  bool get isNewModalOpen => _newRouteOpen;
  int get previousMode => _previousMode;
  Climb get selectedClimbingRoute => _selectedClimbingRoute;
  List<Climb> get selectedClimbingRoutes => _selectedClimbingRoutes;

  pickClimbingRoute(Climb route) {
    _selectedClimbingRoute = route;
    notifyListeners();
  }

  selectClimbingRoute(Climb route) {
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

  unSelectClimbingRoute(Climb route) {
    _selectedClimbingRoutes.remove(route);
    notifyListeners();
  }

  bool isSelected(Climb route) {
    return _selectedClimbingRoutes.contains(route);
  }

  closeNewRouteWizard() {
    _newRouteOpen = false;
    notifyListeners();
  }

  close() {
    _mode = DashboardMode.defaultDashboard;
    _newRouteOpen = false;
    notifyListeners();
  }

  openNew() {
    _previousMode = DashboardMode.defaultDashboard;
    _newRouteOpen = true;
    notifyListeners();
  }

  openEdit() {
    _previousMode = _mode;
    _mode = DashboardMode.editClimbingRoutePageOpen;
    notifyListeners();
  }

  openTagsEdit() {
    _previousMode = _mode;
    _mode = DashboardMode.tagEditor;
    notifyListeners();
  }

  closeTagEdit() {
    _mode = _previousMode;
    notifyListeners();
  }
}
