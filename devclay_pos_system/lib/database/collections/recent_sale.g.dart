// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_sale.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecentSaleCollection on Isar {
  IsarCollection<RecentSale> get recentSales => this.collection();
}

const RecentSaleSchema = CollectionSchema(
  name: r'RecentSale',
  id: 4801889319841277332,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.double),
    r'customerName': PropertySchema(
      id: 1,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'invoiceNo': PropertySchema(
      id: 2,
      name: r'invoiceNo',
      type: IsarType.string,
    ),
    r'paymentMethod': PropertySchema(
      id: 3,
      name: r'paymentMethod',
      type: IsarType.string,
    ),
    r'soldAt': PropertySchema(id: 4, name: r'soldAt', type: IsarType.dateTime),
  },

  estimateSize: _recentSaleEstimateSize,
  serialize: _recentSaleSerialize,
  deserialize: _recentSaleDeserialize,
  deserializeProp: _recentSaleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _recentSaleGetId,
  getLinks: _recentSaleGetLinks,
  attach: _recentSaleAttach,
  version: '3.3.2',
);

int _recentSaleEstimateSize(
  RecentSale object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.customerName.length * 3;
  bytesCount += 3 + object.invoiceNo.length * 3;
  bytesCount += 3 + object.paymentMethod.length * 3;
  return bytesCount;
}

void _recentSaleSerialize(
  RecentSale object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.customerName);
  writer.writeString(offsets[2], object.invoiceNo);
  writer.writeString(offsets[3], object.paymentMethod);
  writer.writeDateTime(offsets[4], object.soldAt);
}

RecentSale _recentSaleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecentSale();
  object.amount = reader.readDouble(offsets[0]);
  object.customerName = reader.readString(offsets[1]);
  object.id = id;
  object.invoiceNo = reader.readString(offsets[2]);
  object.paymentMethod = reader.readString(offsets[3]);
  object.soldAt = reader.readDateTime(offsets[4]);
  return object;
}

P _recentSaleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recentSaleGetId(RecentSale object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recentSaleGetLinks(RecentSale object) {
  return [];
}

void _recentSaleAttach(IsarCollection<dynamic> col, Id id, RecentSale object) {
  object.id = id;
}

extension RecentSaleQueryWhereSort
    on QueryBuilder<RecentSale, RecentSale, QWhere> {
  QueryBuilder<RecentSale, RecentSale, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecentSaleQueryWhere
    on QueryBuilder<RecentSale, RecentSale, QWhereClause> {
  QueryBuilder<RecentSale, RecentSale, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<RecentSale, RecentSale, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterWhereClause> idBetween(
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
}

extension RecentSaleQueryFilter
    on QueryBuilder<RecentSale, RecentSale, QFilterCondition> {
  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
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

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> amountGreaterThan(
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

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> amountLessThan(
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

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> amountBetween(
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

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customerName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customerName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> invoiceNoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'invoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  invoiceNoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'invoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> invoiceNoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'invoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> invoiceNoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'invoiceNo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  invoiceNoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'invoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> invoiceNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'invoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> invoiceNoContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'invoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> invoiceNoMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'invoiceNo',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  invoiceNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'invoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  invoiceNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'invoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paymentMethod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition>
  paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> soldAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'soldAt', value: value),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> soldAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'soldAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> soldAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'soldAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterFilterCondition> soldAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'soldAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RecentSaleQueryObject
    on QueryBuilder<RecentSale, RecentSale, QFilterCondition> {}

extension RecentSaleQueryLinks
    on QueryBuilder<RecentSale, RecentSale, QFilterCondition> {}

extension RecentSaleQuerySortBy
    on QueryBuilder<RecentSale, RecentSale, QSortBy> {
  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortByInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortByInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortBySoldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldAt', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> sortBySoldAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldAt', Sort.desc);
    });
  }
}

extension RecentSaleQuerySortThenBy
    on QueryBuilder<RecentSale, RecentSale, QSortThenBy> {
  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenBySoldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldAt', Sort.asc);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QAfterSortBy> thenBySoldAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldAt', Sort.desc);
    });
  }
}

extension RecentSaleQueryWhereDistinct
    on QueryBuilder<RecentSale, RecentSale, QDistinct> {
  QueryBuilder<RecentSale, RecentSale, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<RecentSale, RecentSale, QDistinct> distinctByCustomerName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QDistinct> distinctByInvoiceNo({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentSale, RecentSale, QDistinct> distinctByPaymentMethod({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paymentMethod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<RecentSale, RecentSale, QDistinct> distinctBySoldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'soldAt');
    });
  }
}

extension RecentSaleQueryProperty
    on QueryBuilder<RecentSale, RecentSale, QQueryProperty> {
  QueryBuilder<RecentSale, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecentSale, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<RecentSale, String, QQueryOperations> customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<RecentSale, String, QQueryOperations> invoiceNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceNo');
    });
  }

  QueryBuilder<RecentSale, String, QQueryOperations> paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<RecentSale, DateTime, QQueryOperations> soldAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'soldAt');
    });
  }
}
