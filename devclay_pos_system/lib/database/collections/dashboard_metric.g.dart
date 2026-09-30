// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_metric.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDashboardMetricCollection on Isar {
  IsarCollection<DashboardMetric> get dashboardMetrics => this.collection();
}

const DashboardMetricSchema = CollectionSchema(
  name: r'DashboardMetric',
  id: -9114503125527386948,
  properties: {
    r'key': PropertySchema(id: 0, name: r'key', type: IsarType.string),
    r'monthlyProfit': PropertySchema(
      id: 1,
      name: r'monthlyProfit',
      type: IsarType.double,
    ),
    r'monthlyProfitChange': PropertySchema(
      id: 2,
      name: r'monthlyProfitChange',
      type: IsarType.double,
    ),
    r'monthlySales': PropertySchema(
      id: 3,
      name: r'monthlySales',
      type: IsarType.double,
    ),
    r'monthlySalesChange': PropertySchema(
      id: 4,
      name: r'monthlySalesChange',
      type: IsarType.double,
    ),
    r'todayProfit': PropertySchema(
      id: 5,
      name: r'todayProfit',
      type: IsarType.double,
    ),
    r'todayProfitChange': PropertySchema(
      id: 6,
      name: r'todayProfitChange',
      type: IsarType.double,
    ),
    r'todaySales': PropertySchema(
      id: 7,
      name: r'todaySales',
      type: IsarType.double,
    ),
    r'todaySalesChange': PropertySchema(
      id: 8,
      name: r'todaySalesChange',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _dashboardMetricEstimateSize,
  serialize: _dashboardMetricSerialize,
  deserialize: _dashboardMetricDeserialize,
  deserializeProp: _dashboardMetricDeserializeProp,
  idName: r'id',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _dashboardMetricGetId,
  getLinks: _dashboardMetricGetLinks,
  attach: _dashboardMetricAttach,
  version: '3.3.2',
);

int _dashboardMetricEstimateSize(
  DashboardMetric object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _dashboardMetricSerialize(
  DashboardMetric object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeDouble(offsets[1], object.monthlyProfit);
  writer.writeDouble(offsets[2], object.monthlyProfitChange);
  writer.writeDouble(offsets[3], object.monthlySales);
  writer.writeDouble(offsets[4], object.monthlySalesChange);
  writer.writeDouble(offsets[5], object.todayProfit);
  writer.writeDouble(offsets[6], object.todayProfitChange);
  writer.writeDouble(offsets[7], object.todaySales);
  writer.writeDouble(offsets[8], object.todaySalesChange);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

DashboardMetric _dashboardMetricDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DashboardMetric();
  object.id = id;
  object.key = reader.readString(offsets[0]);
  object.monthlyProfit = reader.readDouble(offsets[1]);
  object.monthlyProfitChange = reader.readDouble(offsets[2]);
  object.monthlySales = reader.readDouble(offsets[3]);
  object.monthlySalesChange = reader.readDouble(offsets[4]);
  object.todayProfit = reader.readDouble(offsets[5]);
  object.todayProfitChange = reader.readDouble(offsets[6]);
  object.todaySales = reader.readDouble(offsets[7]);
  object.todaySalesChange = reader.readDouble(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  return object;
}

P _dashboardMetricDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dashboardMetricGetId(DashboardMetric object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dashboardMetricGetLinks(DashboardMetric object) {
  return [];
}

void _dashboardMetricAttach(
  IsarCollection<dynamic> col,
  Id id,
  DashboardMetric object,
) {
  object.id = id;
}

extension DashboardMetricByIndex on IsarCollection<DashboardMetric> {
  Future<DashboardMetric?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  DashboardMetric? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<DashboardMetric?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<DashboardMetric?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(DashboardMetric object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(DashboardMetric object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<DashboardMetric> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(
    List<DashboardMetric> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension DashboardMetricQueryWhereSort
    on QueryBuilder<DashboardMetric, DashboardMetric, QWhere> {
  QueryBuilder<DashboardMetric, DashboardMetric, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DashboardMetricQueryWhere
    on QueryBuilder<DashboardMetric, DashboardMetric, QWhereClause> {
  QueryBuilder<DashboardMetric, DashboardMetric, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterWhereClause> keyEqualTo(
    String key,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'key', value: [key]),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterWhereClause>
  keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [],
                upper: [key],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [key],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [key],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [],
                upper: [key],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DashboardMetricQueryFilter
    on QueryBuilder<DashboardMetric, DashboardMetric, QFilterCondition> {
  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlyProfitEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthlyProfit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlyProfitGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthlyProfit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlyProfitLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthlyProfit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlyProfitBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthlyProfit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlyProfitChangeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthlyProfitChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlyProfitChangeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthlyProfitChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlyProfitChangeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthlyProfitChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlyProfitChangeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthlyProfitChange',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlySalesEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthlySales',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlySalesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthlySales',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlySalesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthlySales',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlySalesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthlySales',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlySalesChangeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthlySalesChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlySalesChangeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthlySalesChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlySalesChangeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthlySalesChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  monthlySalesChangeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthlySalesChange',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todayProfitEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'todayProfit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todayProfitGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'todayProfit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todayProfitLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'todayProfit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todayProfitBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'todayProfit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todayProfitChangeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'todayProfitChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todayProfitChangeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'todayProfitChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todayProfitChangeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'todayProfitChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todayProfitChangeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'todayProfitChange',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todaySalesEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'todaySales',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todaySalesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'todaySales',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todaySalesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'todaySales',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todaySalesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'todaySales',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todaySalesChangeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'todaySalesChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todaySalesChangeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'todaySalesChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todaySalesChangeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'todaySalesChange',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  todaySalesChangeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'todaySalesChange',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DashboardMetricQueryObject
    on QueryBuilder<DashboardMetric, DashboardMetric, QFilterCondition> {}

extension DashboardMetricQueryLinks
    on QueryBuilder<DashboardMetric, DashboardMetric, QFilterCondition> {}

extension DashboardMetricQuerySortBy
    on QueryBuilder<DashboardMetric, DashboardMetric, QSortBy> {
  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByMonthlyProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyProfit', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByMonthlyProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyProfit', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByMonthlyProfitChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyProfitChange', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByMonthlyProfitChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyProfitChange', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByMonthlySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySales', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByMonthlySalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySales', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByMonthlySalesChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySalesChange', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByMonthlySalesChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySalesChange', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByTodayProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayProfit', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByTodayProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayProfit', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByTodayProfitChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayProfitChange', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByTodayProfitChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayProfitChange', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByTodaySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todaySales', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByTodaySalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todaySales', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByTodaySalesChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todaySalesChange', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByTodaySalesChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todaySalesChange', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DashboardMetricQuerySortThenBy
    on QueryBuilder<DashboardMetric, DashboardMetric, QSortThenBy> {
  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByMonthlyProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyProfit', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByMonthlyProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyProfit', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByMonthlyProfitChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyProfitChange', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByMonthlyProfitChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyProfitChange', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByMonthlySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySales', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByMonthlySalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySales', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByMonthlySalesChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySalesChange', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByMonthlySalesChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySalesChange', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByTodayProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayProfit', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByTodayProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayProfit', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByTodayProfitChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayProfitChange', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByTodayProfitChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayProfitChange', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByTodaySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todaySales', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByTodaySalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todaySales', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByTodaySalesChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todaySalesChange', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByTodaySalesChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todaySalesChange', Sort.desc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DashboardMetricQueryWhereDistinct
    on QueryBuilder<DashboardMetric, DashboardMetric, QDistinct> {
  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct> distinctByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByMonthlyProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyProfit');
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByMonthlyProfitChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyProfitChange');
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByMonthlySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlySales');
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByMonthlySalesChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlySalesChange');
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByTodayProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'todayProfit');
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByTodayProfitChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'todayProfitChange');
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByTodaySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'todaySales');
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByTodaySalesChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'todaySalesChange');
    });
  }

  QueryBuilder<DashboardMetric, DashboardMetric, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DashboardMetricQueryProperty
    on QueryBuilder<DashboardMetric, DashboardMetric, QQueryProperty> {
  QueryBuilder<DashboardMetric, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DashboardMetric, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<DashboardMetric, double, QQueryOperations>
  monthlyProfitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyProfit');
    });
  }

  QueryBuilder<DashboardMetric, double, QQueryOperations>
  monthlyProfitChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyProfitChange');
    });
  }

  QueryBuilder<DashboardMetric, double, QQueryOperations>
  monthlySalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlySales');
    });
  }

  QueryBuilder<DashboardMetric, double, QQueryOperations>
  monthlySalesChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlySalesChange');
    });
  }

  QueryBuilder<DashboardMetric, double, QQueryOperations>
  todayProfitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'todayProfit');
    });
  }

  QueryBuilder<DashboardMetric, double, QQueryOperations>
  todayProfitChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'todayProfitChange');
    });
  }

  QueryBuilder<DashboardMetric, double, QQueryOperations> todaySalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'todaySales');
    });
  }

  QueryBuilder<DashboardMetric, double, QQueryOperations>
  todaySalesChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'todaySalesChange');
    });
  }

  QueryBuilder<DashboardMetric, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
