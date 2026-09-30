// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_commission.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEmployeeCommissionCollection on Isar {
  IsarCollection<EmployeeCommission> get employeeCommissions =>
      this.collection();
}

const EmployeeCommissionSchema = CollectionSchema(
  name: r'EmployeeCommission',
  id: 3559520856765246023,
  properties: {
    r'accountId': PropertySchema(
      id: 0,
      name: r'accountId',
      type: IsarType.long,
    ),
    r'accountName': PropertySchema(
      id: 1,
      name: r'accountName',
      type: IsarType.string,
    ),
    r'amount': PropertySchema(id: 2, name: r'amount', type: IsarType.double),
    r'baseAmount': PropertySchema(
      id: 3,
      name: r'baseAmount',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'employeeId': PropertySchema(
      id: 5,
      name: r'employeeId',
      type: IsarType.long,
    ),
    r'employeeName': PropertySchema(
      id: 6,
      name: r'employeeName',
      type: IsarType.string,
    ),
    r'entryDate': PropertySchema(
      id: 7,
      name: r'entryDate',
      type: IsarType.dateTime,
    ),
    r'ledgerEntryId': PropertySchema(
      id: 8,
      name: r'ledgerEntryId',
      type: IsarType.long,
    ),
    r'mode': PropertySchema(id: 9, name: r'mode', type: IsarType.string),
    r'note': PropertySchema(id: 10, name: r'note', type: IsarType.string),
    r'percentage': PropertySchema(
      id: 11,
      name: r'percentage',
      type: IsarType.double,
    ),
    r'reference': PropertySchema(
      id: 12,
      name: r'reference',
      type: IsarType.string,
    ),
  },

  estimateSize: _employeeCommissionEstimateSize,
  serialize: _employeeCommissionSerialize,
  deserialize: _employeeCommissionDeserialize,
  deserializeProp: _employeeCommissionDeserializeProp,
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
    r'accountId': IndexSchema(
      id: -1591555361937770434,
      name: r'accountId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'accountId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'entryDate': IndexSchema(
      id: 4711483602383013270,
      name: r'entryDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entryDate',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _employeeCommissionGetId,
  getLinks: _employeeCommissionGetLinks,
  attach: _employeeCommissionAttach,
  version: '3.3.2',
);

int _employeeCommissionEstimateSize(
  EmployeeCommission object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountName.length * 3;
  bytesCount += 3 + object.employeeName.length * 3;
  bytesCount += 3 + object.mode.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reference;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _employeeCommissionSerialize(
  EmployeeCommission object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.accountId);
  writer.writeString(offsets[1], object.accountName);
  writer.writeDouble(offsets[2], object.amount);
  writer.writeDouble(offsets[3], object.baseAmount);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeLong(offsets[5], object.employeeId);
  writer.writeString(offsets[6], object.employeeName);
  writer.writeDateTime(offsets[7], object.entryDate);
  writer.writeLong(offsets[8], object.ledgerEntryId);
  writer.writeString(offsets[9], object.mode);
  writer.writeString(offsets[10], object.note);
  writer.writeDouble(offsets[11], object.percentage);
  writer.writeString(offsets[12], object.reference);
}

EmployeeCommission _employeeCommissionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmployeeCommission();
  object.accountId = reader.readLong(offsets[0]);
  object.accountName = reader.readString(offsets[1]);
  object.amount = reader.readDouble(offsets[2]);
  object.baseAmount = reader.readDoubleOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.employeeId = reader.readLong(offsets[5]);
  object.employeeName = reader.readString(offsets[6]);
  object.entryDate = reader.readDateTime(offsets[7]);
  object.id = id;
  object.ledgerEntryId = reader.readLongOrNull(offsets[8]);
  object.mode = reader.readString(offsets[9]);
  object.note = reader.readStringOrNull(offsets[10]);
  object.percentage = reader.readDoubleOrNull(offsets[11]);
  object.reference = reader.readStringOrNull(offsets[12]);
  return object;
}

P _employeeCommissionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _employeeCommissionGetId(EmployeeCommission object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _employeeCommissionGetLinks(
  EmployeeCommission object,
) {
  return [];
}

void _employeeCommissionAttach(
  IsarCollection<dynamic> col,
  Id id,
  EmployeeCommission object,
) {
  object.id = id;
}

extension EmployeeCommissionQueryWhereSort
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QWhere> {
  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhere>
  anyEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'employeeId'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhere>
  anyAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'accountId'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhere>
  anyEntryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'entryDate'),
      );
    });
  }
}

extension EmployeeCommissionQueryWhere
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QWhereClause> {
  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  employeeIdEqualTo(int employeeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'employeeId', value: [employeeId]),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  accountIdEqualTo(int accountId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'accountId', value: [accountId]),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  accountIdNotEqualTo(int accountId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountId',
                lower: [],
                upper: [accountId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountId',
                lower: [accountId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountId',
                lower: [accountId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountId',
                lower: [],
                upper: [accountId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  accountIdGreaterThan(int accountId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'accountId',
          lower: [accountId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  accountIdLessThan(int accountId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'accountId',
          lower: [],
          upper: [accountId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  accountIdBetween(
    int lowerAccountId,
    int upperAccountId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'accountId',
          lower: [lowerAccountId],
          includeLower: includeLower,
          upper: [upperAccountId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  entryDateEqualTo(DateTime entryDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'entryDate', value: [entryDate]),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  entryDateNotEqualTo(DateTime entryDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entryDate',
                lower: [],
                upper: [entryDate],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entryDate',
                lower: [entryDate],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entryDate',
                lower: [entryDate],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entryDate',
                lower: [],
                upper: [entryDate],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  entryDateGreaterThan(DateTime entryDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entryDate',
          lower: [entryDate],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  entryDateLessThan(DateTime entryDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entryDate',
          lower: [],
          upper: [entryDate],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterWhereClause>
  entryDateBetween(
    DateTime lowerEntryDate,
    DateTime upperEntryDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entryDate',
          lower: [lowerEntryDate],
          includeLower: includeLower,
          upper: [upperEntryDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension EmployeeCommissionQueryFilter
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QFilterCondition> {
  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountId', value: value),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountName', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  accountNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountName', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  amountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  baseAmountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'baseAmount'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  baseAmountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'baseAmount'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  baseAmountEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'baseAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  baseAmountGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baseAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  baseAmountLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baseAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  baseAmountBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baseAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  employeeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employeeId', value: value),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  employeeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employeeName', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  employeeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'employeeName', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  entryDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entryDate', value: value),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  entryDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  entryDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  entryDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entryDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  ledgerEntryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'ledgerEntryId'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  ledgerEntryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'ledgerEntryId'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  ledgerEntryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ledgerEntryId', value: value),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  ledgerEntryIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ledgerEntryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  ledgerEntryIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ledgerEntryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  ledgerEntryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ledgerEntryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'mode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mode', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  modeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'mode', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
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

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  percentageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'percentage'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  percentageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'percentage'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  percentageEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'percentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  percentageGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'percentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  percentageLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'percentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  percentageBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'percentage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'reference'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'reference'),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'reference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reference',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'reference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'reference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'reference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'reference',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reference', value: ''),
      );
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterFilterCondition>
  referenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'reference', value: ''),
      );
    });
  }
}

extension EmployeeCommissionQueryObject
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QFilterCondition> {}

extension EmployeeCommissionQueryLinks
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QFilterCondition> {}

extension EmployeeCommissionQuerySortBy
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QSortBy> {
  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByBaseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseAmount', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByBaseAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseAmount', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByEntryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryDate', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByEntryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryDate', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByLedgerEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerEntryId', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByLedgerEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerEntryId', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  sortByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }
}

extension EmployeeCommissionQuerySortThenBy
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QSortThenBy> {
  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByBaseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseAmount', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByBaseAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseAmount', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByEntryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryDate', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByEntryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryDate', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByLedgerEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerEntryId', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByLedgerEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerEntryId', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.desc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QAfterSortBy>
  thenByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }
}

extension EmployeeCommissionQueryWhereDistinct
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct> {
  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId');
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByAccountName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByBaseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseAmount');
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeId');
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByEmployeeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByEntryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryDate');
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByLedgerEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ledgerEntryId');
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentage');
    });
  }

  QueryBuilder<EmployeeCommission, EmployeeCommission, QDistinct>
  distinctByReference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reference', caseSensitive: caseSensitive);
    });
  }
}

extension EmployeeCommissionQueryProperty
    on QueryBuilder<EmployeeCommission, EmployeeCommission, QQueryProperty> {
  QueryBuilder<EmployeeCommission, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EmployeeCommission, int, QQueryOperations> accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<EmployeeCommission, String, QQueryOperations>
  accountNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountName');
    });
  }

  QueryBuilder<EmployeeCommission, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<EmployeeCommission, double?, QQueryOperations>
  baseAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseAmount');
    });
  }

  QueryBuilder<EmployeeCommission, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<EmployeeCommission, int, QQueryOperations> employeeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeId');
    });
  }

  QueryBuilder<EmployeeCommission, String, QQueryOperations>
  employeeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeName');
    });
  }

  QueryBuilder<EmployeeCommission, DateTime, QQueryOperations>
  entryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryDate');
    });
  }

  QueryBuilder<EmployeeCommission, int?, QQueryOperations>
  ledgerEntryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ledgerEntryId');
    });
  }

  QueryBuilder<EmployeeCommission, String, QQueryOperations> modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mode');
    });
  }

  QueryBuilder<EmployeeCommission, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<EmployeeCommission, double?, QQueryOperations>
  percentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentage');
    });
  }

  QueryBuilder<EmployeeCommission, String?, QQueryOperations>
  referenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reference');
    });
  }
}
