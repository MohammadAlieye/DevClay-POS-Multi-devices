// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_return.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSaleReturnCollection on Isar {
  IsarCollection<SaleReturn> get saleReturns => this.collection();
}

const SaleReturnSchema = CollectionSchema(
  name: r'SaleReturn',
  id: -8708141304476728185,
  properties: {
    r'approvedById': PropertySchema(
      id: 0,
      name: r'approvedById',
      type: IsarType.long,
    ),
    r'approvedByName': PropertySchema(
      id: 1,
      name: r'approvedByName',
      type: IsarType.string,
    ),
    r'cashierId': PropertySchema(
      id: 2,
      name: r'cashierId',
      type: IsarType.long,
    ),
    r'cashierName': PropertySchema(
      id: 3,
      name: r'cashierName',
      type: IsarType.string,
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
    r'invoiceNo': PropertySchema(
      id: 6,
      name: r'invoiceNo',
      type: IsarType.string,
    ),
    r'isVoid': PropertySchema(id: 7, name: r'isVoid', type: IsarType.bool),
    r'linesJson': PropertySchema(
      id: 8,
      name: r'linesJson',
      type: IsarType.string,
    ),
    r'reason': PropertySchema(id: 9, name: r'reason', type: IsarType.string),
    r'refundAmount': PropertySchema(
      id: 10,
      name: r'refundAmount',
      type: IsarType.double,
    ),
    r'refundMethod': PropertySchema(
      id: 11,
      name: r'refundMethod',
      type: IsarType.string,
    ),
    r'returnNo': PropertySchema(
      id: 12,
      name: r'returnNo',
      type: IsarType.string,
    ),
    r'returnedAt': PropertySchema(
      id: 13,
      name: r'returnedAt',
      type: IsarType.dateTime,
    ),
    r'saleId': PropertySchema(id: 14, name: r'saleId', type: IsarType.long),
  },

  estimateSize: _saleReturnEstimateSize,
  serialize: _saleReturnSerialize,
  deserialize: _saleReturnDeserialize,
  deserializeProp: _saleReturnDeserializeProp,
  idName: r'id',
  indexes: {
    r'returnNo': IndexSchema(
      id: -6651635092629802729,
      name: r'returnNo',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'returnNo',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'saleId': IndexSchema(
      id: -4056742760800787207,
      name: r'saleId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'saleId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'returnedAt': IndexSchema(
      id: -6994526082465098569,
      name: r'returnedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'returnedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _saleReturnGetId,
  getLinks: _saleReturnGetLinks,
  attach: _saleReturnAttach,
  version: '3.3.2',
);

int _saleReturnEstimateSize(
  SaleReturn object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.approvedByName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cashierName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.invoiceNo.length * 3;
  bytesCount += 3 + object.linesJson.length * 3;
  bytesCount += 3 + object.reason.length * 3;
  bytesCount += 3 + object.refundMethod.length * 3;
  bytesCount += 3 + object.returnNo.length * 3;
  return bytesCount;
}

void _saleReturnSerialize(
  SaleReturn object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.approvedById);
  writer.writeString(offsets[1], object.approvedByName);
  writer.writeLong(offsets[2], object.cashierId);
  writer.writeString(offsets[3], object.cashierName);
  writer.writeLong(offsets[4], object.customerId);
  writer.writeString(offsets[5], object.customerName);
  writer.writeString(offsets[6], object.invoiceNo);
  writer.writeBool(offsets[7], object.isVoid);
  writer.writeString(offsets[8], object.linesJson);
  writer.writeString(offsets[9], object.reason);
  writer.writeDouble(offsets[10], object.refundAmount);
  writer.writeString(offsets[11], object.refundMethod);
  writer.writeString(offsets[12], object.returnNo);
  writer.writeDateTime(offsets[13], object.returnedAt);
  writer.writeLong(offsets[14], object.saleId);
}

SaleReturn _saleReturnDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaleReturn();
  object.approvedById = reader.readLongOrNull(offsets[0]);
  object.approvedByName = reader.readStringOrNull(offsets[1]);
  object.cashierId = reader.readLongOrNull(offsets[2]);
  object.cashierName = reader.readStringOrNull(offsets[3]);
  object.customerId = reader.readLongOrNull(offsets[4]);
  object.customerName = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.invoiceNo = reader.readString(offsets[6]);
  object.isVoid = reader.readBool(offsets[7]);
  object.linesJson = reader.readString(offsets[8]);
  object.reason = reader.readString(offsets[9]);
  object.refundAmount = reader.readDouble(offsets[10]);
  object.refundMethod = reader.readString(offsets[11]);
  object.returnNo = reader.readString(offsets[12]);
  object.returnedAt = reader.readDateTime(offsets[13]);
  object.saleId = reader.readLong(offsets[14]);
  return object;
}

P _saleReturnDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _saleReturnGetId(SaleReturn object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _saleReturnGetLinks(SaleReturn object) {
  return [];
}

void _saleReturnAttach(IsarCollection<dynamic> col, Id id, SaleReturn object) {
  object.id = id;
}

extension SaleReturnByIndex on IsarCollection<SaleReturn> {
  Future<SaleReturn?> getByReturnNo(String returnNo) {
    return getByIndex(r'returnNo', [returnNo]);
  }

  SaleReturn? getByReturnNoSync(String returnNo) {
    return getByIndexSync(r'returnNo', [returnNo]);
  }

  Future<bool> deleteByReturnNo(String returnNo) {
    return deleteByIndex(r'returnNo', [returnNo]);
  }

  bool deleteByReturnNoSync(String returnNo) {
    return deleteByIndexSync(r'returnNo', [returnNo]);
  }

  Future<List<SaleReturn?>> getAllByReturnNo(List<String> returnNoValues) {
    final values = returnNoValues.map((e) => [e]).toList();
    return getAllByIndex(r'returnNo', values);
  }

  List<SaleReturn?> getAllByReturnNoSync(List<String> returnNoValues) {
    final values = returnNoValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'returnNo', values);
  }

  Future<int> deleteAllByReturnNo(List<String> returnNoValues) {
    final values = returnNoValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'returnNo', values);
  }

  int deleteAllByReturnNoSync(List<String> returnNoValues) {
    final values = returnNoValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'returnNo', values);
  }

  Future<Id> putByReturnNo(SaleReturn object) {
    return putByIndex(r'returnNo', object);
  }

  Id putByReturnNoSync(SaleReturn object, {bool saveLinks = true}) {
    return putByIndexSync(r'returnNo', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReturnNo(List<SaleReturn> objects) {
    return putAllByIndex(r'returnNo', objects);
  }

  List<Id> putAllByReturnNoSync(
    List<SaleReturn> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'returnNo', objects, saveLinks: saveLinks);
  }
}

extension SaleReturnQueryWhereSort
    on QueryBuilder<SaleReturn, SaleReturn, QWhere> {
  QueryBuilder<SaleReturn, SaleReturn, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhere> anySaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'saleId'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhere> anyReturnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'returnedAt'),
      );
    });
  }
}

extension SaleReturnQueryWhere
    on QueryBuilder<SaleReturn, SaleReturn, QWhereClause> {
  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> idBetween(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> returnNoEqualTo(
    String returnNo,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'returnNo', value: [returnNo]),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> returnNoNotEqualTo(
    String returnNo,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'returnNo',
                lower: [],
                upper: [returnNo],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'returnNo',
                lower: [returnNo],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'returnNo',
                lower: [returnNo],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'returnNo',
                lower: [],
                upper: [returnNo],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> saleIdEqualTo(
    int saleId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'saleId', value: [saleId]),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> saleIdNotEqualTo(
    int saleId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'saleId',
                lower: [],
                upper: [saleId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'saleId',
                lower: [saleId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'saleId',
                lower: [saleId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'saleId',
                lower: [],
                upper: [saleId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> saleIdGreaterThan(
    int saleId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'saleId',
          lower: [saleId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> saleIdLessThan(
    int saleId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'saleId',
          lower: [],
          upper: [saleId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> saleIdBetween(
    int lowerSaleId,
    int upperSaleId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'saleId',
          lower: [lowerSaleId],
          includeLower: includeLower,
          upper: [upperSaleId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> returnedAtEqualTo(
    DateTime returnedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'returnedAt', value: [returnedAt]),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> returnedAtNotEqualTo(
    DateTime returnedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'returnedAt',
                lower: [],
                upper: [returnedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'returnedAt',
                lower: [returnedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'returnedAt',
                lower: [returnedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'returnedAt',
                lower: [],
                upper: [returnedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> returnedAtGreaterThan(
    DateTime returnedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'returnedAt',
          lower: [returnedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> returnedAtLessThan(
    DateTime returnedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'returnedAt',
          lower: [],
          upper: [returnedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterWhereClause> returnedAtBetween(
    DateTime lowerReturnedAt,
    DateTime upperReturnedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'returnedAt',
          lower: [lowerReturnedAt],
          includeLower: includeLower,
          upper: [upperReturnedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SaleReturnQueryFilter
    on QueryBuilder<SaleReturn, SaleReturn, QFilterCondition> {
  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'approvedById'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'approvedById'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'approvedById', value: value),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'approvedById',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'approvedById',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'approvedById',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'approvedByName'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'approvedByName'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'approvedByName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'approvedByName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'approvedByName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'approvedByName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'approvedByName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'approvedByName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'approvedByName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'approvedByName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'approvedByName', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  approvedByNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'approvedByName', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cashierId'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cashierId'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> cashierIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cashierId', value: value),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierIdGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> cashierIdLessThan(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> cashierIdBetween(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cashierName'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cashierName'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameGreaterThan(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameLessThan(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameBetween(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cashierName', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  cashierNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cashierName', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> customerIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerId', value: value),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerIdGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerIdLessThan(int? value, {bool include = false}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> customerIdBetween(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerName'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerName'),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerNameEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerNameGreaterThan(
    String? value, {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerNameLessThan(
    String? value, {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerNameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> invoiceNoEqualTo(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> invoiceNoLessThan(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> invoiceNoBetween(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> invoiceNoEndsWith(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> invoiceNoContains(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> invoiceNoMatches(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  invoiceNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'invoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  invoiceNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'invoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> isVoidEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isVoid', value: value),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> linesJsonEqualTo(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  linesJsonGreaterThan(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> linesJsonLessThan(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> linesJsonBetween(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  linesJsonStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> linesJsonEndsWith(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> linesJsonContains(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> linesJsonMatches(
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

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  linesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  linesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'reason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reason',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'reason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'reason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'reason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'reason',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> reasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reason', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  reasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'reason', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'refundAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'refundAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'refundAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'refundAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'refundMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'refundMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'refundMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'refundMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'refundMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'refundMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'refundMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'refundMethod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'refundMethod', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  refundMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'refundMethod', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> returnNoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'returnNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  returnNoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'returnNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> returnNoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'returnNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> returnNoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'returnNo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  returnNoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'returnNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> returnNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'returnNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> returnNoContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'returnNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> returnNoMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'returnNo',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  returnNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'returnNo', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  returnNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'returnNo', value: ''),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> returnedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'returnedAt', value: value),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  returnedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'returnedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition>
  returnedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'returnedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> returnedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'returnedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> saleIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'saleId', value: value),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> saleIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'saleId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> saleIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'saleId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterFilterCondition> saleIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'saleId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SaleReturnQueryObject
    on QueryBuilder<SaleReturn, SaleReturn, QFilterCondition> {}

extension SaleReturnQueryLinks
    on QueryBuilder<SaleReturn, SaleReturn, QFilterCondition> {}

extension SaleReturnQuerySortBy
    on QueryBuilder<SaleReturn, SaleReturn, QSortBy> {
  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByApprovedById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'approvedById', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByApprovedByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'approvedById', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByApprovedByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'approvedByName', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy>
  sortByApprovedByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'approvedByName', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByCashierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByCashierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByIsVoid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoid', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByIsVoidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoid', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByRefundAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundAmount', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByRefundAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundAmount', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByRefundMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundMethod', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByRefundMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundMethod', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByReturnNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnNo', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByReturnNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnNo', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByReturnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAt', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortByReturnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAt', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortBySaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleId', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> sortBySaleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleId', Sort.desc);
    });
  }
}

extension SaleReturnQuerySortThenBy
    on QueryBuilder<SaleReturn, SaleReturn, QSortThenBy> {
  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByApprovedById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'approvedById', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByApprovedByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'approvedById', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByApprovedByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'approvedByName', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy>
  thenByApprovedByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'approvedByName', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByCashierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByCashierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByIsVoid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoid', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByIsVoidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoid', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByRefundAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundAmount', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByRefundAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundAmount', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByRefundMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundMethod', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByRefundMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundMethod', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByReturnNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnNo', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByReturnNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnNo', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByReturnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAt', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenByReturnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAt', Sort.desc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenBySaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleId', Sort.asc);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QAfterSortBy> thenBySaleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleId', Sort.desc);
    });
  }
}

extension SaleReturnQueryWhereDistinct
    on QueryBuilder<SaleReturn, SaleReturn, QDistinct> {
  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByApprovedById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'approvedById');
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByApprovedByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'approvedByName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierId');
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByCashierName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId');
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByCustomerName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByInvoiceNo({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByIsVoid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isVoid');
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByLinesJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByReason({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByRefundAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refundAmount');
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByRefundMethod({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refundMethod', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByReturnNo({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctByReturnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnedAt');
    });
  }

  QueryBuilder<SaleReturn, SaleReturn, QDistinct> distinctBySaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleId');
    });
  }
}

extension SaleReturnQueryProperty
    on QueryBuilder<SaleReturn, SaleReturn, QQueryProperty> {
  QueryBuilder<SaleReturn, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SaleReturn, int?, QQueryOperations> approvedByIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'approvedById');
    });
  }

  QueryBuilder<SaleReturn, String?, QQueryOperations> approvedByNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'approvedByName');
    });
  }

  QueryBuilder<SaleReturn, int?, QQueryOperations> cashierIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierId');
    });
  }

  QueryBuilder<SaleReturn, String?, QQueryOperations> cashierNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierName');
    });
  }

  QueryBuilder<SaleReturn, int?, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<SaleReturn, String?, QQueryOperations> customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<SaleReturn, String, QQueryOperations> invoiceNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceNo');
    });
  }

  QueryBuilder<SaleReturn, bool, QQueryOperations> isVoidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isVoid');
    });
  }

  QueryBuilder<SaleReturn, String, QQueryOperations> linesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linesJson');
    });
  }

  QueryBuilder<SaleReturn, String, QQueryOperations> reasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reason');
    });
  }

  QueryBuilder<SaleReturn, double, QQueryOperations> refundAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refundAmount');
    });
  }

  QueryBuilder<SaleReturn, String, QQueryOperations> refundMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refundMethod');
    });
  }

  QueryBuilder<SaleReturn, String, QQueryOperations> returnNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnNo');
    });
  }

  QueryBuilder<SaleReturn, DateTime, QQueryOperations> returnedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnedAt');
    });
  }

  QueryBuilder<SaleReturn, int, QQueryOperations> saleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleId');
    });
  }
}
