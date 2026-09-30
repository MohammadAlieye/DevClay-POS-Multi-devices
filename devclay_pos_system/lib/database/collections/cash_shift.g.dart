// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_shift.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCashShiftCollection on Isar {
  IsarCollection<CashShift> get cashShifts => this.collection();
}

const CashShiftSchema = CollectionSchema(
  name: r'CashShift',
  id: -8107776888497036668,
  properties: {
    r'cashAccountId': PropertySchema(
      id: 0,
      name: r'cashAccountId',
      type: IsarType.long,
    ),
    r'cashAccountName': PropertySchema(
      id: 1,
      name: r'cashAccountName',
      type: IsarType.string,
    ),
    r'closedAt': PropertySchema(
      id: 2,
      name: r'closedAt',
      type: IsarType.dateTime,
    ),
    r'closingCash': PropertySchema(
      id: 3,
      name: r'closingCash',
      type: IsarType.double,
    ),
    r'expectedCash': PropertySchema(
      id: 4,
      name: r'expectedCash',
      type: IsarType.double,
    ),
    r'note': PropertySchema(id: 5, name: r'note', type: IsarType.string),
    r'openedAt': PropertySchema(
      id: 6,
      name: r'openedAt',
      type: IsarType.dateTime,
    ),
    r'openingCash': PropertySchema(
      id: 7,
      name: r'openingCash',
      type: IsarType.double,
    ),
    r'status': PropertySchema(id: 8, name: r'status', type: IsarType.string),
    r'userId': PropertySchema(id: 9, name: r'userId', type: IsarType.long),
    r'userName': PropertySchema(
      id: 10,
      name: r'userName',
      type: IsarType.string,
    ),
    r'variance': PropertySchema(
      id: 11,
      name: r'variance',
      type: IsarType.double,
    ),
  },

  estimateSize: _cashShiftEstimateSize,
  serialize: _cashShiftSerialize,
  deserialize: _cashShiftDeserialize,
  deserializeProp: _cashShiftDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'openedAt': IndexSchema(
      id: -5170574981129517220,
      name: r'openedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'openedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _cashShiftGetId,
  getLinks: _cashShiftGetLinks,
  attach: _cashShiftAttach,
  version: '3.3.2',
);

int _cashShiftEstimateSize(
  CashShift object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cashAccountName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.userName.length * 3;
  return bytesCount;
}

void _cashShiftSerialize(
  CashShift object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cashAccountId);
  writer.writeString(offsets[1], object.cashAccountName);
  writer.writeDateTime(offsets[2], object.closedAt);
  writer.writeDouble(offsets[3], object.closingCash);
  writer.writeDouble(offsets[4], object.expectedCash);
  writer.writeString(offsets[5], object.note);
  writer.writeDateTime(offsets[6], object.openedAt);
  writer.writeDouble(offsets[7], object.openingCash);
  writer.writeString(offsets[8], object.status);
  writer.writeLong(offsets[9], object.userId);
  writer.writeString(offsets[10], object.userName);
  writer.writeDouble(offsets[11], object.variance);
}

CashShift _cashShiftDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CashShift();
  object.cashAccountId = reader.readLongOrNull(offsets[0]);
  object.cashAccountName = reader.readStringOrNull(offsets[1]);
  object.closedAt = reader.readDateTimeOrNull(offsets[2]);
  object.closingCash = reader.readDoubleOrNull(offsets[3]);
  object.expectedCash = reader.readDouble(offsets[4]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[5]);
  object.openedAt = reader.readDateTime(offsets[6]);
  object.openingCash = reader.readDouble(offsets[7]);
  object.status = reader.readString(offsets[8]);
  object.userId = reader.readLong(offsets[9]);
  object.userName = reader.readString(offsets[10]);
  object.variance = reader.readDoubleOrNull(offsets[11]);
  return object;
}

P _cashShiftDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cashShiftGetId(CashShift object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cashShiftGetLinks(CashShift object) {
  return [];
}

void _cashShiftAttach(IsarCollection<dynamic> col, Id id, CashShift object) {
  object.id = id;
}

extension CashShiftQueryWhereSort
    on QueryBuilder<CashShift, CashShift, QWhere> {
  QueryBuilder<CashShift, CashShift, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhere> anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhere> anyOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'openedAt'),
      );
    });
  }
}

extension CashShiftQueryWhere
    on QueryBuilder<CashShift, CashShift, QWhereClause> {
  QueryBuilder<CashShift, CashShift, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> idBetween(
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

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> userIdEqualTo(
    int userId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> userIdNotEqualTo(
    int userId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> userIdGreaterThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'userId',
          lower: [userId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> userIdLessThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'userId',
          lower: [],
          upper: [userId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> userIdBetween(
    int lowerUserId,
    int upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'userId',
          lower: [lowerUserId],
          includeLower: includeLower,
          upper: [upperUserId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> openedAtEqualTo(
    DateTime openedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'openedAt', value: [openedAt]),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> openedAtNotEqualTo(
    DateTime openedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'openedAt',
                lower: [],
                upper: [openedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'openedAt',
                lower: [openedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'openedAt',
                lower: [openedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'openedAt',
                lower: [],
                upper: [openedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> openedAtGreaterThan(
    DateTime openedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'openedAt',
          lower: [openedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> openedAtLessThan(
    DateTime openedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'openedAt',
          lower: [],
          upper: [openedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterWhereClause> openedAtBetween(
    DateTime lowerOpenedAt,
    DateTime upperOpenedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'openedAt',
          lower: [lowerOpenedAt],
          includeLower: includeLower,
          upper: [upperOpenedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CashShiftQueryFilter
    on QueryBuilder<CashShift, CashShift, QFilterCondition> {
  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cashAccountId'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cashAccountId'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cashAccountId', value: value),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cashAccountId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cashAccountId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cashAccountId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cashAccountName'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cashAccountName'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cashAccountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cashAccountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cashAccountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cashAccountName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cashAccountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cashAccountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cashAccountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cashAccountName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cashAccountName', value: ''),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  cashAccountNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cashAccountName', value: ''),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> closedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'closedAt'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  closedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'closedAt'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> closedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'closedAt', value: value),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> closedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'closedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> closedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'closedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> closedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'closedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  closingCashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'closingCash'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  closingCashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'closingCash'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> closingCashEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'closingCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  closingCashGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'closingCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> closingCashLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'closingCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> closingCashBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'closingCash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> expectedCashEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'expectedCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  expectedCashGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'expectedCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  expectedCashLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'expectedCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> expectedCashBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'expectedCash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteGreaterThan(
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteLessThan(
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> openedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'openedAt', value: value),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> openedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'openedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> openedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'openedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> openedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'openedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> openingCashEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'openingCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  openingCashGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'openingCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> openingCashLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'openingCash',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> openingCashBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'openingCash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: value),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userName', value: ''),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userName', value: ''),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> varianceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'variance'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition>
  varianceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'variance'),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> varianceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'variance',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> varianceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'variance',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> varianceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'variance',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterFilterCondition> varianceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'variance',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension CashShiftQueryObject
    on QueryBuilder<CashShift, CashShift, QFilterCondition> {}

extension CashShiftQueryLinks
    on QueryBuilder<CashShift, CashShift, QFilterCondition> {}

extension CashShiftQuerySortBy on QueryBuilder<CashShift, CashShift, QSortBy> {
  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByCashAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashAccountId', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByCashAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashAccountId', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByCashAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashAccountName', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByCashAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashAccountName', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByClosingCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingCash', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByClosingCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingCash', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByExpectedCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCash', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByExpectedCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCash', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByOpeningCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingCash', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByOpeningCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingCash', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByVariance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variance', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> sortByVarianceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variance', Sort.desc);
    });
  }
}

extension CashShiftQuerySortThenBy
    on QueryBuilder<CashShift, CashShift, QSortThenBy> {
  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByCashAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashAccountId', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByCashAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashAccountId', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByCashAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashAccountName', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByCashAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashAccountName', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByClosingCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingCash', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByClosingCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingCash', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByExpectedCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCash', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByExpectedCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCash', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByOpeningCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingCash', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByOpeningCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingCash', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByVariance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variance', Sort.asc);
    });
  }

  QueryBuilder<CashShift, CashShift, QAfterSortBy> thenByVarianceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variance', Sort.desc);
    });
  }
}

extension CashShiftQueryWhereDistinct
    on QueryBuilder<CashShift, CashShift, QDistinct> {
  QueryBuilder<CashShift, CashShift, QDistinct> distinctByCashAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashAccountId');
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByCashAccountName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'cashAccountName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closedAt');
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByClosingCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closingCash');
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByExpectedCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedCash');
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openedAt');
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByOpeningCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openingCash');
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByUserName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CashShift, CashShift, QDistinct> distinctByVariance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'variance');
    });
  }
}

extension CashShiftQueryProperty
    on QueryBuilder<CashShift, CashShift, QQueryProperty> {
  QueryBuilder<CashShift, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CashShift, int?, QQueryOperations> cashAccountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashAccountId');
    });
  }

  QueryBuilder<CashShift, String?, QQueryOperations> cashAccountNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashAccountName');
    });
  }

  QueryBuilder<CashShift, DateTime?, QQueryOperations> closedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closedAt');
    });
  }

  QueryBuilder<CashShift, double?, QQueryOperations> closingCashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closingCash');
    });
  }

  QueryBuilder<CashShift, double, QQueryOperations> expectedCashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedCash');
    });
  }

  QueryBuilder<CashShift, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<CashShift, DateTime, QQueryOperations> openedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openedAt');
    });
  }

  QueryBuilder<CashShift, double, QQueryOperations> openingCashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openingCash');
    });
  }

  QueryBuilder<CashShift, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<CashShift, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<CashShift, String, QQueryOperations> userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }

  QueryBuilder<CashShift, double?, QQueryOperations> varianceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'variance');
    });
  }
}
