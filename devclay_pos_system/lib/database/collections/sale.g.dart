// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSaleCollection on Isar {
  IsarCollection<Sale> get sales => this.collection();
}

const SaleSchema = CollectionSchema(
  name: r'Sale',
  id: 2760258395233294300,
  properties: {
    r'amountPaid': PropertySchema(
      id: 0,
      name: r'amountPaid',
      type: IsarType.double,
    ),
    r'cashierId': PropertySchema(
      id: 1,
      name: r'cashierId',
      type: IsarType.long,
    ),
    r'cashierName': PropertySchema(
      id: 2,
      name: r'cashierName',
      type: IsarType.string,
    ),
    r'changeAmount': PropertySchema(
      id: 3,
      name: r'changeAmount',
      type: IsarType.double,
    ),
    r'customerId': PropertySchema(
      id: 4,
      name: r'customerId',
      type: IsarType.long,
    ),
    r'customerName': PropertySchema(
      id: 5,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'discount': PropertySchema(
      id: 6,
      name: r'discount',
      type: IsarType.double,
    ),
    r'invoiceNo': PropertySchema(
      id: 7,
      name: r'invoiceNo',
      type: IsarType.string,
    ),
    r'itemCount': PropertySchema(
      id: 8,
      name: r'itemCount',
      type: IsarType.long,
    ),
    r'linesJson': PropertySchema(
      id: 9,
      name: r'linesJson',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(id: 10, name: r'notes', type: IsarType.string),
    r'paymentMethod': PropertySchema(
      id: 11,
      name: r'paymentMethod',
      type: IsarType.string,
    ),
    r'returnedAmount': PropertySchema(
      id: 12,
      name: r'returnedAmount',
      type: IsarType.double,
    ),
    r'soldAt': PropertySchema(id: 13, name: r'soldAt', type: IsarType.dateTime),
    r'status': PropertySchema(id: 14, name: r'status', type: IsarType.string),
    r'subtotal': PropertySchema(
      id: 15,
      name: r'subtotal',
      type: IsarType.double,
    ),
    r'tax': PropertySchema(id: 16, name: r'tax', type: IsarType.double),
    r'total': PropertySchema(id: 17, name: r'total', type: IsarType.double),
  },

  estimateSize: _saleEstimateSize,
  serialize: _saleSerialize,
  deserialize: _saleDeserialize,
  deserializeProp: _saleDeserializeProp,
  idName: r'id',
  indexes: {
    r'invoiceNo': IndexSchema(
      id: -1348738007764533522,
      name: r'invoiceNo',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'invoiceNo',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'soldAt': IndexSchema(
      id: -4342579169361070045,
      name: r'soldAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'soldAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _saleGetId,
  getLinks: _saleGetLinks,
  attach: _saleAttach,
  version: '3.3.2',
);

int _saleEstimateSize(
  Sale object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cashierName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.customerName.length * 3;
  bytesCount += 3 + object.invoiceNo.length * 3;
  bytesCount += 3 + object.linesJson.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.paymentMethod.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _saleSerialize(
  Sale object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountPaid);
  writer.writeLong(offsets[1], object.cashierId);
  writer.writeString(offsets[2], object.cashierName);
  writer.writeDouble(offsets[3], object.changeAmount);
  writer.writeLong(offsets[4], object.customerId);
  writer.writeString(offsets[5], object.customerName);
  writer.writeDouble(offsets[6], object.discount);
  writer.writeString(offsets[7], object.invoiceNo);
  writer.writeLong(offsets[8], object.itemCount);
  writer.writeString(offsets[9], object.linesJson);
  writer.writeString(offsets[10], object.notes);
  writer.writeString(offsets[11], object.paymentMethod);
  writer.writeDouble(offsets[12], object.returnedAmount);
  writer.writeDateTime(offsets[13], object.soldAt);
  writer.writeString(offsets[14], object.status);
  writer.writeDouble(offsets[15], object.subtotal);
  writer.writeDouble(offsets[16], object.tax);
  writer.writeDouble(offsets[17], object.total);
}

Sale _saleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Sale();
  object.amountPaid = reader.readDouble(offsets[0]);
  object.cashierId = reader.readLongOrNull(offsets[1]);
  object.cashierName = reader.readStringOrNull(offsets[2]);
  object.changeAmount = reader.readDouble(offsets[3]);
  object.customerId = reader.readLongOrNull(offsets[4]);
  object.customerName = reader.readString(offsets[5]);
  object.discount = reader.readDouble(offsets[6]);
  object.id = id;
  object.invoiceNo = reader.readString(offsets[7]);
  object.itemCount = reader.readLong(offsets[8]);
  object.linesJson = reader.readString(offsets[9]);
  object.notes = reader.readStringOrNull(offsets[10]);
  object.paymentMethod = reader.readString(offsets[11]);
  object.returnedAmount = reader.readDouble(offsets[12]);
  object.soldAt = reader.readDateTime(offsets[13]);
  object.status = reader.readString(offsets[14]);
  object.subtotal = reader.readDouble(offsets[15]);
  object.tax = reader.readDouble(offsets[16]);
  object.total = reader.readDouble(offsets[17]);
  return object;
}

P _saleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _saleGetId(Sale object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _saleGetLinks(Sale object) {
  return [];
}

void _saleAttach(IsarCollection<dynamic> col, Id id, Sale object) {
  object.id = id;
}

extension SaleByIndex on IsarCollection<Sale> {
  Future<Sale?> getByInvoiceNo(String invoiceNo) {
    return getByIndex(r'invoiceNo', [invoiceNo]);
  }

  Sale? getByInvoiceNoSync(String invoiceNo) {
    return getByIndexSync(r'invoiceNo', [invoiceNo]);
  }

  Future<bool> deleteByInvoiceNo(String invoiceNo) {
    return deleteByIndex(r'invoiceNo', [invoiceNo]);
  }

  bool deleteByInvoiceNoSync(String invoiceNo) {
    return deleteByIndexSync(r'invoiceNo', [invoiceNo]);
  }

  Future<List<Sale?>> getAllByInvoiceNo(List<String> invoiceNoValues) {
    final values = invoiceNoValues.map((e) => [e]).toList();
    return getAllByIndex(r'invoiceNo', values);
  }

  List<Sale?> getAllByInvoiceNoSync(List<String> invoiceNoValues) {
    final values = invoiceNoValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'invoiceNo', values);
  }

  Future<int> deleteAllByInvoiceNo(List<String> invoiceNoValues) {
    final values = invoiceNoValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'invoiceNo', values);
  }

  int deleteAllByInvoiceNoSync(List<String> invoiceNoValues) {
    final values = invoiceNoValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'invoiceNo', values);
  }

  Future<Id> putByInvoiceNo(Sale object) {
    return putByIndex(r'invoiceNo', object);
  }

  Id putByInvoiceNoSync(Sale object, {bool saveLinks = true}) {
    return putByIndexSync(r'invoiceNo', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInvoiceNo(List<Sale> objects) {
    return putAllByIndex(r'invoiceNo', objects);
  }

  List<Id> putAllByInvoiceNoSync(List<Sale> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'invoiceNo', objects, saveLinks: saveLinks);
  }
}

extension SaleQueryWhereSort on QueryBuilder<Sale, Sale, QWhere> {
  QueryBuilder<Sale, Sale, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhere> anySoldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'soldAt'),
      );
    });
  }
}

extension SaleQueryWhere on QueryBuilder<Sale, Sale, QWhereClause> {
  QueryBuilder<Sale, Sale, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Sale, Sale, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> idBetween(
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

  QueryBuilder<Sale, Sale, QAfterWhereClause> invoiceNoEqualTo(
    String invoiceNo,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'invoiceNo', value: [invoiceNo]),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> invoiceNoNotEqualTo(
    String invoiceNo,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'invoiceNo',
                lower: [],
                upper: [invoiceNo],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'invoiceNo',
                lower: [invoiceNo],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'invoiceNo',
                lower: [invoiceNo],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'invoiceNo',
                lower: [],
                upper: [invoiceNo],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> soldAtEqualTo(DateTime soldAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'soldAt', value: [soldAt]),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> soldAtNotEqualTo(
    DateTime soldAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'soldAt',
                lower: [],
                upper: [soldAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'soldAt',
                lower: [soldAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'soldAt',
                lower: [soldAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'soldAt',
                lower: [],
                upper: [soldAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> soldAtGreaterThan(
    DateTime soldAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'soldAt',
          lower: [soldAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> soldAtLessThan(
    DateTime soldAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'soldAt',
          lower: [],
          upper: [soldAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> soldAtBetween(
    DateTime lowerSoldAt,
    DateTime upperSoldAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'soldAt',
          lower: [lowerSoldAt],
          includeLower: includeLower,
          upper: [upperSoldAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SaleQueryFilter on QueryBuilder<Sale, Sale, QFilterCondition> {
  QueryBuilder<Sale, Sale, QAfterFilterCondition> amountPaidEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amountPaid',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> amountPaidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amountPaid',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> amountPaidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amountPaid',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> amountPaidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amountPaid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cashierId'),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cashierId'),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cashierId', value: value),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cashierId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cashierId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cashierId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cashierName'),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cashierName'),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cashierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cashierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cashierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cashierName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cashierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cashierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cashierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cashierName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cashierName', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> cashierNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cashierName', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> changeAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'changeAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> changeAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'changeAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> changeAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'changeAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> changeAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'changeAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerId', value: value),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customerId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customerId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customerId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameBetween(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> discountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'discount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> discountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'discount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> discountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'discount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> discountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'discount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoEqualTo(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoBetween(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoEndsWith(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoContains(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoMatches(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'invoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> invoiceNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'invoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> itemCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemCount', value: value),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> itemCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> itemCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> itemCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'linesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'linesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'linesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'linesJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'linesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'linesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'linesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'linesJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> linesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodBetween(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> returnedAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'returnedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> returnedAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'returnedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> returnedAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'returnedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> returnedAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'returnedAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> soldAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'soldAt', value: value),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> soldAtGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> soldAtLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> soldAtBetween(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusBetween(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusStartsWith(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusEndsWith(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusContains(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusMatches(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> subtotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'subtotal',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> subtotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'subtotal',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> subtotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'subtotal',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> subtotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'subtotal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> taxEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tax',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> taxGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tax',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> taxLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tax',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> taxBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tax',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> totalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'total',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> totalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'total',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> totalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'total',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> totalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'total',
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

extension SaleQueryObject on QueryBuilder<Sale, Sale, QFilterCondition> {}

extension SaleQueryLinks on QueryBuilder<Sale, Sale, QFilterCondition> {}

extension SaleQuerySortBy on QueryBuilder<Sale, Sale, QSortBy> {
  QueryBuilder<Sale, Sale, QAfterSortBy> sortByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByAmountPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCashierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCashierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByChangeAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeAmount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByChangeAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeAmount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByReturnedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAmount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByReturnedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAmount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortBySoldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldAt', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortBySoldAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldAt', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension SaleQuerySortThenBy on QueryBuilder<Sale, Sale, QSortThenBy> {
  QueryBuilder<Sale, Sale, QAfterSortBy> thenByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByAmountPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCashierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCashierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByChangeAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeAmount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByChangeAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeAmount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByReturnedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAmount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByReturnedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAmount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenBySoldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldAt', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenBySoldAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldAt', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension SaleQueryWhereDistinct on QueryBuilder<Sale, Sale, QDistinct> {
  QueryBuilder<Sale, Sale, QDistinct> distinctByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountPaid');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierId');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByCashierName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByChangeAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'changeAmount');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByCustomerName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discount');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByInvoiceNo({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemCount');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByLinesJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByPaymentMethod({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paymentMethod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByReturnedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnedAmount');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctBySoldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'soldAt');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtotal');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tax');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }
}

extension SaleQueryProperty on QueryBuilder<Sale, Sale, QQueryProperty> {
  QueryBuilder<Sale, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> amountPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountPaid');
    });
  }

  QueryBuilder<Sale, int?, QQueryOperations> cashierIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierId');
    });
  }

  QueryBuilder<Sale, String?, QQueryOperations> cashierNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierName');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> changeAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'changeAmount');
    });
  }

  QueryBuilder<Sale, int?, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<Sale, String, QQueryOperations> customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<Sale, String, QQueryOperations> invoiceNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceNo');
    });
  }

  QueryBuilder<Sale, int, QQueryOperations> itemCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemCount');
    });
  }

  QueryBuilder<Sale, String, QQueryOperations> linesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linesJson');
    });
  }

  QueryBuilder<Sale, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Sale, String, QQueryOperations> paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> returnedAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnedAmount');
    });
  }

  QueryBuilder<Sale, DateTime, QQueryOperations> soldAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'soldAt');
    });
  }

  QueryBuilder<Sale, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> subtotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtotal');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> taxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tax');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }
}
