// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_expense.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFinanceExpenseCollection on Isar {
  IsarCollection<FinanceExpense> get financeExpenses => this.collection();
}

const FinanceExpenseSchema = CollectionSchema(
  name: r'FinanceExpense',
  id: -6149909327058870493,
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
    r'category': PropertySchema(
      id: 3,
      name: r'category',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 5,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 6,
      name: r'description',
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
    r'paidBy': PropertySchema(id: 9, name: r'paidBy', type: IsarType.string),
    r'receiptPath': PropertySchema(
      id: 10,
      name: r'receiptPath',
      type: IsarType.string,
    ),
  },

  estimateSize: _financeExpenseEstimateSize,
  serialize: _financeExpenseSerialize,
  deserialize: _financeExpenseDeserialize,
  deserializeProp: _financeExpenseDeserializeProp,
  idName: r'id',
  indexes: {
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
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

  getId: _financeExpenseGetId,
  getLinks: _financeExpenseGetLinks,
  attach: _financeExpenseAttach,
  version: '3.3.2',
);

int _financeExpenseEstimateSize(
  FinanceExpense object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountName.length * 3;
  bytesCount += 3 + object.category.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.paidBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.receiptPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _financeExpenseSerialize(
  FinanceExpense object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.accountId);
  writer.writeString(offsets[1], object.accountName);
  writer.writeDouble(offsets[2], object.amount);
  writer.writeString(offsets[3], object.category);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeDateTime(offsets[5], object.deletedAt);
  writer.writeString(offsets[6], object.description);
  writer.writeDateTime(offsets[7], object.entryDate);
  writer.writeLong(offsets[8], object.ledgerEntryId);
  writer.writeString(offsets[9], object.paidBy);
  writer.writeString(offsets[10], object.receiptPath);
}

FinanceExpense _financeExpenseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FinanceExpense();
  object.accountId = reader.readLong(offsets[0]);
  object.accountName = reader.readString(offsets[1]);
  object.amount = reader.readDouble(offsets[2]);
  object.category = reader.readString(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[5]);
  object.description = reader.readStringOrNull(offsets[6]);
  object.entryDate = reader.readDateTime(offsets[7]);
  object.id = id;
  object.ledgerEntryId = reader.readLongOrNull(offsets[8]);
  object.paidBy = reader.readStringOrNull(offsets[9]);
  object.receiptPath = reader.readStringOrNull(offsets[10]);
  return object;
}

P _financeExpenseDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _financeExpenseGetId(FinanceExpense object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _financeExpenseGetLinks(FinanceExpense object) {
  return [];
}

void _financeExpenseAttach(
  IsarCollection<dynamic> col,
  Id id,
  FinanceExpense object,
) {
  object.id = id;
}

extension FinanceExpenseQueryWhereSort
    on QueryBuilder<FinanceExpense, FinanceExpense, QWhere> {
  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhere> anyAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'accountId'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhere> anyEntryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'entryDate'),
      );
    });
  }
}

extension FinanceExpenseQueryWhere
    on QueryBuilder<FinanceExpense, FinanceExpense, QWhereClause> {
  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause> idBetween(
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
  categoryEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'category', value: [category]),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
  categoryNotEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
  accountIdEqualTo(int accountId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'accountId', value: [accountId]),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
  entryDateEqualTo(DateTime entryDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'entryDate', value: [entryDate]),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterWhereClause>
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

extension FinanceExpenseQueryFilter
    on QueryBuilder<FinanceExpense, FinanceExpense, QFilterCondition> {
  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  accountIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountId', value: value),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  accountNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountName', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  accountNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountName', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deletedAt', value: value),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  deletedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deletedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  deletedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deletedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deletedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'description'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'description'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  entryDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entryDate', value: value),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  ledgerEntryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'ledgerEntryId'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  ledgerEntryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'ledgerEntryId'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  ledgerEntryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ledgerEntryId', value: value),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
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

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'paidBy'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'paidBy'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paidBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paidBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paidBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paidBy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paidBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paidBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paidBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paidBy',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paidBy', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  paidByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paidBy', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'receiptPath'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'receiptPath'),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptPath', value: ''),
      );
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterFilterCondition>
  receiptPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptPath', value: ''),
      );
    });
  }
}

extension FinanceExpenseQueryObject
    on QueryBuilder<FinanceExpense, FinanceExpense, QFilterCondition> {}

extension FinanceExpenseQueryLinks
    on QueryBuilder<FinanceExpense, FinanceExpense, QFilterCondition> {}

extension FinanceExpenseQuerySortBy
    on QueryBuilder<FinanceExpense, FinanceExpense, QSortBy> {
  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> sortByEntryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryDate', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByEntryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryDate', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByLedgerEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerEntryId', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByLedgerEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerEntryId', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> sortByPaidBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidBy', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByPaidByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidBy', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByReceiptPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptPath', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  sortByReceiptPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptPath', Sort.desc);
    });
  }
}

extension FinanceExpenseQuerySortThenBy
    on QueryBuilder<FinanceExpense, FinanceExpense, QSortThenBy> {
  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenByEntryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryDate', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByEntryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryDate', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByLedgerEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerEntryId', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByLedgerEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerEntryId', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy> thenByPaidBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidBy', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByPaidByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidBy', Sort.desc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByReceiptPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptPath', Sort.asc);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QAfterSortBy>
  thenByReceiptPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptPath', Sort.desc);
    });
  }
}

extension FinanceExpenseQueryWhereDistinct
    on QueryBuilder<FinanceExpense, FinanceExpense, QDistinct> {
  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct>
  distinctByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId');
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct>
  distinctByAccountName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct> distinctByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct>
  distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct>
  distinctByEntryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryDate');
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct>
  distinctByLedgerEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ledgerEntryId');
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct> distinctByPaidBy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paidBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinanceExpense, FinanceExpense, QDistinct>
  distinctByReceiptPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptPath', caseSensitive: caseSensitive);
    });
  }
}

extension FinanceExpenseQueryProperty
    on QueryBuilder<FinanceExpense, FinanceExpense, QQueryProperty> {
  QueryBuilder<FinanceExpense, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FinanceExpense, int, QQueryOperations> accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<FinanceExpense, String, QQueryOperations> accountNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountName');
    });
  }

  QueryBuilder<FinanceExpense, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<FinanceExpense, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<FinanceExpense, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FinanceExpense, DateTime?, QQueryOperations>
  deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<FinanceExpense, String?, QQueryOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<FinanceExpense, DateTime, QQueryOperations> entryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryDate');
    });
  }

  QueryBuilder<FinanceExpense, int?, QQueryOperations> ledgerEntryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ledgerEntryId');
    });
  }

  QueryBuilder<FinanceExpense, String?, QQueryOperations> paidByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paidBy');
    });
  }

  QueryBuilder<FinanceExpense, String?, QQueryOperations>
  receiptPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptPath');
    });
  }
}
