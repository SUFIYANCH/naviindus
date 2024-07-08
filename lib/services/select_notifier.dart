import 'package:flutter/foundation.dart';
import 'package:naviindus/models/branch_model.dart' as branch_model;
import 'package:naviindus/models/treatment_model.dart';

class SelectedNotifier extends ChangeNotifier {
  branch_model.Branch? _selectedBranch;
  Treatment? _selectedTreatment;

  branch_model.Branch? get selectedBranch => _selectedBranch;
  Treatment? get selectedTreatment => _selectedTreatment;

  void selectBranch(branch_model.Branch? branch) {
    _selectedBranch = branch;
    notifyListeners();
  }

  void selectTreatment(Treatment? treatment) {
    _selectedTreatment = treatment;
    notifyListeners();
  }
}
