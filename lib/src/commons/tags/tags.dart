import 'package:hundred_climbs/src/assets-content/colors/AppColors.dart';
import 'package:hundred_climbs/src/climbingRouteWizard/state/wizardState.dart';
import 'package:hundred_climbs/src/commons/tags/tagsHistory.dart';
import 'package:hundred_climbs/src/commons/appBar.dart';
import 'package:hundred_climbs/src/commons/appBar.dart' as prefix0;
import 'package:hundred_climbs/src/dashboard/state/DashboardMode.dart';
import 'package:hundred_climbs/src/dashboard/state/dashboardState.dart';
import 'package:hundred_climbs/src/models/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagsL extends StatefulWidget {
  TagsL();
  @override
  State createState() => _State();
}

class _State extends State<TagsL> {
  final TextEditingController _tagTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<TagModel> stringTags;

  @override
  void initState() {
    _tagTextController.text = '';
    stringTags = List();
    super.initState();
  }

  @override
  build(BuildContext context) {
    DashboardState ds = Provider.of<DashboardState>(context);
    WizardState ws = Provider.of<WizardState>(context);
    AppUser user = Provider.of<AppUser>(context);
    _tagTextController.addListener(() {
      List<String> sts = user.tags
          .where((i) => i.startsWith(_tagTextController.text))
          .take(4)
          .toList()
            ..add(_tagTextController.text);
      List<TagModel> tagModels = List();
      sts.toSet().toList()
        ..reversed.forEach((i) =>
            tagModels.add(TagModel(i, ws.selectedTags.contains(i.trim()))));
      setState(() {
        stringTags = tagModels;
      });
    });
    if (ds.mode == DashboardMode.tagEditor)
      FocusScope.of(context).requestFocus(_focusNode);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredAppBar.tag(),
        backgroundColor:
            ds.previousMode == DashboardMode.editClimbingRoutePageOpen
                ? AppColors.getGradeColor(ds.selectedClimbingRoute?.grade)
                : AppColors.getGradeColor(ws.selectedClimbingGrade),
        body: ListView(
          children: [
            Container(
              height: 30,
              width: 120,
              margin: const EdgeInsets.only(top: 30.0, left: 15),
              padding: const EdgeInsets.all(3.0),
              child: TextField(
                focusNode: _focusNode,
                autofocus: true,
                textAlign: TextAlign.left,
                controller: _tagTextController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Click to add...',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Color(0xff4c000000),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff4c000000),
                ),
              ),
            ),
            Visibility(
              visible: _tagTextController.text != '',
              child: TagsHistory(
                tags: stringTags ?? [],
                onAdd: (tag) {
                  if (ds.previousMode ==
                      DashboardMode.editClimbingRoutePageOpen)
                    ds.pickClimbingRoute(ds.selectedClimbingRoute
                        .rebuild((r) => r..tags.add(tag.value)));
                  else
                    ws.addTag(tag.value);
                  ds.closeTagEdit();
                  _tagTextController.text = '';
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagModel {
  String value;
  bool alreadyAdded;
  TagModel(this.value, this.alreadyAdded);
}
