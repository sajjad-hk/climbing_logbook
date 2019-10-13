import 'dart:async';

import 'package:built_value/standard_json_plugin.dart';
import 'package:climbing_logbook/src/models/serializers.dart';
import 'package:climbing_logbook/src/models/values.dart';
import 'package:climbing_logbook/src/plugin/TimestapmsSerializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class ClimbingCountChartService {
  final Firestore _db = Firestore.instance;

  static final standardSerializers = (serializers.toBuilder()
        ..addPlugin(StandardJsonPlugin())
        ..addPlugin(TimestampSerializerPlugin()))
      .build();

  StreamTransformer<QuerySnapshot, List<ClimbingRoute>>
      _jsonToClimbingRoutesTransformer = StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      return sink.add(data.documents.map(
        (document) {
          return standardSerializers
              .deserializeWith(ClimbingRoute.serializer, document.data)
              .rebuild((it) => it..documentId = document.documentID);
        },
      ).toList());
    },
  );

  StreamTransformer<List<ClimbingRoute>,
          Map<String, Map<DateTime, List<ClimbingRoute>>>>
      _climbingRoutesToChartTransformer =
      StreamTransformer.fromHandlers(handleData: (data, sink) {
    Map groupByMonth = groupBy(
      data,
      (it) => it.grade,
    );
    Map<String, Map<DateTime, List<ClimbingRoute>>> groupByGrade =
        groupByMonth.map(
      (key, values) => MapEntry(
        key,
        groupBy(
          values,
          (value) => DateTime(value.loggedDate.year, value.loggedDate.month),
        ),
      ),
    );
    return sink.add(
      groupByGrade,
    );
  });

  Stream<Map<String, Map<DateTime, List<ClimbingRoute>>>>
      getClimbingCountChartData(String uid) {
    return _getClimbingRoutes(uid).transform(_climbingRoutesToChartTransformer);
  }

  Stream<List<ClimbingRoute>> _getClimbingRoutes(String uid) {
    var ref = _db.collection('routes').where('uid', isEqualTo: uid);
    return ref.snapshots().transform(_jsonToClimbingRoutesTransformer);
  }
}

final ClimbingCountChartService climbingCountChartService =
    ClimbingCountChartService();