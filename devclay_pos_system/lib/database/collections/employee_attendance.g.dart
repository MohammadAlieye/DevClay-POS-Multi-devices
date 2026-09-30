// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_attendance.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEmployeeAttendanceCollection on Isar {
  IsarCollection<EmployeeAttendance> get employeeAttendances =>
      this.collection();
}

const EmployeeAttendanceSchema = CollectionSchema(
  name: r'EmployeeAttendance',
  id: -3837224694098514647,
  properties: {
    r'clockInAt': PropertySchema(
      id: 0,
      name: r'clockInAt',
      type: IsarType.dateTime,
    ),
    r'clockOutAt': PropertySchema(
      id: 1,
      name: r'clockOutAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'employeeId': PropertySchema(
      id: 3,
      name: r'employeeId',
      type: IsarType.long,
    ),
    r'employeeName': PropertySchema(
      id: 4,
      name: r'employeeName',
      type: IsarType.string,
    ),
    r'note': PropertySchema(id: 5, name: r'note', type: IsarType.string),
  },

  estimateSize: _employeeAttendanceEstimateSize,
  serialize: _employeeAttendanceSerialize,
  deserialize: _employeeAttendanceDeserialize,
  deserializeProp: _employeeAttendanceDeserializeProp,
  idName: r'id',
  indexes: {
    r'employeeId': IndexSchema(
      id: 1283453093523034672,
      name: r'employeeId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'employeeId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'clockInAt': IndexSchema(
      id: -2571132862549712071,
      name: r'clockInAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'clockInAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _employeeAttendanceGetId,
  getLinks: _employeeAttendanceGetLinks,
  attach: _employeeAttendanceAttach,
  version: '3.3.2',
);

int _employeeAttendanceEstimateSize(
  EmployeeAttendance object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.employeeName.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _employeeAttendanceSerialize(
  EmployeeAttendance object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.clockInAt);
  writer.writeDateTime(offsets[1], object.clockOutAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.employeeId);
  writer.writeString(offsets[4], object.employeeName);
  writer.writeString(offsets[5], object.note);
}

EmployeeAttendance _employeeAttendanceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmployeeAttendance();
  object.clockInAt = reader.readDateTime(offsets[0]);
  object.clockOutAt = reader.readDateTimeOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.employeeId = reader.readLong(offsets[3]);
  object.employeeName = reader.readString(offsets[4]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[5]);
  return object;
}

P _employeeAttendanceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _employeeAttendanceGetId(EmployeeAttendance object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _employeeAttendanceGetLinks(
  EmployeeAttendance object,
) {
  return [];
}

void _employeeAttendanceAttach(
  IsarCollection<dynamic> col,
  Id id,
  EmployeeAttendance object,
) {
  object.id = id;
}

extension EmployeeAttendanceQueryWhereSort
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QWhere> {
  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhere>
  anyEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'employeeId'),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhere>
  anyClockInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'clockInAt'),
      );
    });
  }
}

extension EmployeeAttendanceQueryWhere
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QWhereClause> {
  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
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

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  idBetween(
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

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  employeeIdEqualTo(int employeeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'employeeId', value: [employeeId]),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  employeeIdNotEqualTo(int employeeId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'employeeId',
                lower: [],
                upper: [employeeId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'employeeId',
                lower: [employeeId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'employeeId',
                lower: [employeeId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'employeeId',
                lower: [],
                upper: [employeeId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  employeeIdGreaterThan(int employeeId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'employeeId',
          lower: [employeeId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  employeeIdLessThan(int employeeId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'employeeId',
          lower: [],
          upper: [employeeId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  employeeIdBetween(
    int lowerEmployeeId,
    int upperEmployeeId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'employeeId',
          lower: [lowerEmployeeId],
          includeLower: includeLower,
          upper: [upperEmployeeId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  clockInAtEqualTo(DateTime clockInAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'clockInAt', value: [clockInAt]),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  clockInAtNotEqualTo(DateTime clockInAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clockInAt',
                lower: [],
                upper: [clockInAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clockInAt',
                lower: [clockInAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clockInAt',
                lower: [clockInAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clockInAt',
                lower: [],
                upper: [clockInAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  clockInAtGreaterThan(DateTime clockInAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clockInAt',
          lower: [clockInAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  clockInAtLessThan(DateTime clockInAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clockInAt',
          lower: [],
          upper: [clockInAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterWhereClause>
  clockInAtBetween(
    DateTime lowerClockInAt,
    DateTime upperClockInAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clockInAt',
          lower: [lowerClockInAt],
          includeLower: includeLower,
          upper: [upperClockInAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension EmployeeAttendanceQueryFilter
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QFilterCondition> {
  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockInAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clockInAt', value: value),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockInAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clockInAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockInAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'clockInAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockInAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clockInAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockOutAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'clockOutAt'),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockOutAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'clockOutAt'),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockOutAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clockOutAt', value: value),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockOutAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clockOutAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockOutAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'clockOutAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  clockOutAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clockOutAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employeeId', value: value),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'employeeId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'employeeId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'employeeId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'employeeName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'employeeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employeeName', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  employeeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'employeeName', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
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

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
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

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
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

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'note',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'note',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }
}

extension EmployeeAttendanceQueryObject
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QFilterCondition> {}

extension EmployeeAttendanceQueryLinks
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QFilterCondition> {}

extension EmployeeAttendanceQuerySortBy
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QSortBy> {
  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByClockInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInAt', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByClockInAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInAt', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByClockOutAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutAt', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByClockOutAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutAt', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension EmployeeAttendanceQuerySortThenBy
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QSortThenBy> {
  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByClockInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInAt', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByClockInAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInAt', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByClockOutAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutAt', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByClockOutAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutAt', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QAfterSortBy>
  thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension EmployeeAttendanceQueryWhereDistinct
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QDistinct> {
  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QDistinct>
  distinctByClockInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockInAt');
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QDistinct>
  distinctByClockOutAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockOutAt');
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QDistinct>
  distinctByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeId');
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QDistinct>
  distinctByEmployeeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EmployeeAttendance, EmployeeAttendance, QDistinct>
  distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }
}

extension EmployeeAttendanceQueryProperty
    on QueryBuilder<EmployeeAttendance, EmployeeAttendance, QQueryProperty> {
  QueryBuilder<EmployeeAttendance, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EmployeeAttendance, DateTime, QQueryOperations>
  clockInAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockInAt');
    });
  }

  QueryBuilder<EmployeeAttendance, DateTime?, QQueryOperations>
  clockOutAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockOutAt');
    });
  }

  QueryBuilder<EmployeeAttendance, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<EmployeeAttendance, int, QQueryOperations> employeeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeId');
    });
  }

  QueryBuilder<EmployeeAttendance, String, QQueryOperations>
  employeeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeName');
    });
  }

  QueryBuilder<EmployeeAttendance, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }
}
