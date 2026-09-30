// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_return.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPurchaseReturnCollection on Isar {
  IsarCollection<PurchaseReturn> get purchaseReturns => this.collection();
}

const PurchaseReturnSchema = CollectionSchema(
  name: r'PurchaseReturn',
  id: -1370882832056716479,
  properties: {
    r'invoiceNo': PropertySchema(
      id: 0,
      name: r'invoiceNo',
      type: IsarType.string,
    ),
    r'linesJson': PropertySchema(
      id: 1,
      name: r'linesJson',
      type: IsarType.string,
    ),
    r'purchaseId': PropertySchema(
      id: 2,
      name: r'purchaseId',
      type: IsarType.long,
    ),
    r'reason': PropertySchema(id: 3, name: r'reason', type: IsarType.string),
    r'returnNo': PropertySchema(
      id: 4,
      name: r'returnNo',
      type: IsarType.string,
    ),
    r'returnedAt': PropertySchema(
      id: 5,
      name: r'returnedAt',
      type: IsarType.dateTime,
    ),
    r'supplierId': PropertySchema(
      id: 6,
      name: r'supplierId',
      type: IsarType.long,
    ),
    r'supplierName': PropertySchema(
      id: 7,
      name: r'supplierName',
      type: IsarType.string,
    ),
    r'total': PropertySchema(id: 8, name: r'total', type: IsarType.double),
    r'userId': PropertySchema(id: 9, name: r'userId', type: IsarType.long),
    r'userName': PropertySchema(
      id: 10,
      name: r'userName',
      type: IsarType.string,
    ),
  },

  estimateSize: _purchaseReturnEstimateSize,
  serialize: _purchaseReturnSerialize,
  deserialize: _purchaseReturnDeserialize,
  deserializeProp: _purchaseReturnDeserializeProp,
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
    r'purchaseId': IndexSchema(
      id: -162747061722907333,
      name: r'purchaseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'purchaseId',
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

  getId: _purchaseReturnGetId,
  getLinks: _purchaseReturnGetLinks,
  attach: _purchaseReturnAttach,
  version: '3.3.2',
);

int _purchaseReturnEstimateSize(
  PurchaseReturn object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.invoiceNo.length * 3;
  bytesCount += 3 + object.linesJson.length * 3;
  bytesCount += 3 + object.reason.length * 3;
  bytesCount += 3 + object.returnNo.length * 3;
  bytesCount += 3 + object.supplierName.length * 3;
  {
    final value = object.userName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _purchaseReturnSerialize(
  PurchaseReturn object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.invoiceNo);
  writer.writeString(offsets[1], object.linesJson);
  writer.writeLong(offsets[2], object.purchaseId);
  writer.writeString(offsets[3], object.reason);
  writer.writeString(offsets[4], object.returnNo);
  writer.writeDateTime(offsets[5], object.returnedAt);
  writer.writeLong(offsets[6], object.supplierId);
  writer.writeString(offsets[7], object.supplierName);
  writer.writeDouble(offsets[8], object.total);
  writer.writeLong(offsets[9], object.userId);
  writer.writeString(offsets[10], object.userName);
}

PurchaseReturn _purchaseReturnDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PurchaseReturn();
  object.id = id;
  object.invoiceNo = reader.readString(offsets[0]);
  object.linesJson = reader.readString(offsets[1]);
  object.purchaseId = reader.readLong(offsets[2]);
  object.reason = reader.readString(offsets[3]);
  object.returnNo = reader.readString(offsets[4]);
  object.returnedAt = reader.readDateTime(offsets[5]);
  object.supplierId = reader.readLong(offsets[6]);
  object.supplierName = reader.readString(offsets[7]);
  object.total = reader.readDouble(offsets[8]);
  object.userId = reader.readLongOrNull(offsets[9]);
  object.userName = reader.readStringOrNull(offsets[10]);
  return object;
}

P _purchaseReturnDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _purchaseReturnGetId(PurchaseReturn object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _purchaseReturnGetLinks(PurchaseReturn object) {
  return [];
}

void _purchaseReturnAttach(
  IsarCollection<dynamic> col,
  Id id,
  PurchaseReturn object,
) {
  object.id = id;
}

extension PurchaseReturnByIndex on IsarCollection<PurchaseReturn> {
  Future<PurchaseReturn?> getByReturnNo(String returnNo) {
    return getByIndex(r'returnNo', [returnNo]);
  }

  PurchaseReturn? getByReturnNoSync(String returnNo) {
    return getByIndexSync(r'returnNo', [returnNo]);
  }

  Future<bool> deleteByReturnNo(String returnNo) {
    return deleteByIndex(r'returnNo', [returnNo]);
  }

  bool deleteByReturnNoSync(String returnNo) {
    return deleteByIndexSync(r'returnNo', [returnNo]);
  }

  Future<List<PurchaseReturn?>> getAllByReturnNo(List<String> returnNoValues) {
    final values = returnNoValues.map((e) => [e]).toList();
    return getAllByIndex(r'returnNo', values);
  }

  List<PurchaseReturn?> getAllByReturnNoSync(List<String> returnNoValues) {
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

  Future<Id> putByReturnNo(PurchaseReturn object) {
    return putByIndex(r'returnNo', object);
  }

  Id putByReturnNoSync(PurchaseReturn object, {bool saveLinks = true}) {
    return putByIndexSync(r'returnNo', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReturnNo(List<PurchaseReturn> objects) {
    return putAllByIndex(r'returnNo', objects);
  }

  List<Id> putAllByReturnNoSync(
    List<PurchaseReturn> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'returnNo', objects, saveLinks: saveLinks);
  }
}

extension PurchaseReturnQueryWhereSort
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QWhere> {
  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhere> anyPurchaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'purchaseId'),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhere> anyReturnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'returnedAt'),
      );
    });
  }
}

extension PurchaseReturnQueryWhere
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QWhereClause> {
  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause> idBetween(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  returnNoEqualTo(String returnNo) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'returnNo', value: [returnNo]),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  returnNoNotEqualTo(String returnNo) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  purchaseIdEqualTo(int purchaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'purchaseId', value: [purchaseId]),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  purchaseIdNotEqualTo(int purchaseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'purchaseId',
                lower: [],
                upper: [purchaseId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'purchaseId',
                lower: [purchaseId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'purchaseId',
                lower: [purchaseId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'purchaseId',
                lower: [],
                upper: [purchaseId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  purchaseIdGreaterThan(int purchaseId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'purchaseId',
          lower: [purchaseId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  purchaseIdLessThan(int purchaseId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'purchaseId',
          lower: [],
          upper: [purchaseId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  purchaseIdBetween(
    int lowerPurchaseId,
    int upperPurchaseId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'purchaseId',
          lower: [lowerPurchaseId],
          includeLower: includeLower,
          upper: [upperPurchaseId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  returnedAtEqualTo(DateTime returnedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'returnedAt', value: [returnedAt]),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  returnedAtNotEqualTo(DateTime returnedAt) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  returnedAtGreaterThan(DateTime returnedAt, {bool include = false}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  returnedAtLessThan(DateTime returnedAt, {bool include = false}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterWhereClause>
  returnedAtBetween(
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

extension PurchaseReturnQueryFilter
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QFilterCondition> {
  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  invoiceNoEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  invoiceNoLessThan(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  invoiceNoBetween(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  invoiceNoEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  invoiceNoContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  invoiceNoMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  invoiceNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'invoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  invoiceNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'invoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  linesJsonEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  linesJsonLessThan(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  linesJsonBetween(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  linesJsonEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  linesJsonContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  linesJsonMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  linesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  linesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  purchaseIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'purchaseId', value: value),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  purchaseIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'purchaseId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  purchaseIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'purchaseId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  purchaseIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'purchaseId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonGreaterThan(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonLessThan(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonBetween(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reason', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  reasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'reason', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnNoEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnNoLessThan(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnNoBetween(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnNoEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnNoContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnNoMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'returnNo', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'returnNo', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'returnedAt', value: value),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  returnedAtBetween(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supplierId', value: value),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'supplierId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'supplierId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'supplierId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'supplierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'supplierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'supplierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'supplierName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'supplierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'supplierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'supplierName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'supplierName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supplierName', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  supplierNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'supplierName', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  totalEqualTo(double value, {double epsilon = Query.epsilon}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  totalGreaterThan(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  totalLessThan(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  totalBetween(
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userId'),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userId'),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: value),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userIdGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userIdLessThan(int? value, {bool include = false}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userIdBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userName'),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userName'),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameGreaterThan(
    String? value, {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameLessThan(
    String? value, {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userName', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterFilterCondition>
  userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userName', value: ''),
      );
    });
  }
}

extension PurchaseReturnQueryObject
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QFilterCondition> {}

extension PurchaseReturnQueryLinks
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QFilterCondition> {}

extension PurchaseReturnQuerySortBy
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QSortBy> {
  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> sortByInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> sortByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByPurchaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByPurchaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> sortByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> sortByReturnNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnNo', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByReturnNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnNo', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByReturnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAt', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByReturnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAt', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortBySupplierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortBySupplierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortBySupplierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierName', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortBySupplierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierName', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension PurchaseReturnQuerySortThenBy
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QSortThenBy> {
  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNo', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByPurchaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByPurchaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByReturnNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnNo', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByReturnNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnNo', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByReturnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAt', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByReturnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnedAt', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenBySupplierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenBySupplierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenBySupplierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierName', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenBySupplierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierName', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy> thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QAfterSortBy>
  thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension PurchaseReturnQueryWhereDistinct
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct> {
  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct> distinctByInvoiceNo({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct> distinctByLinesJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct>
  distinctByPurchaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseId');
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct> distinctByReason({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct> distinctByReturnNo({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct>
  distinctByReturnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnedAt');
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct>
  distinctBySupplierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supplierId');
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct>
  distinctBySupplierName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supplierName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct> distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }

  QueryBuilder<PurchaseReturn, PurchaseReturn, QDistinct> distinctByUserName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }
}

extension PurchaseReturnQueryProperty
    on QueryBuilder<PurchaseReturn, PurchaseReturn, QQueryProperty> {
  QueryBuilder<PurchaseReturn, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PurchaseReturn, String, QQueryOperations> invoiceNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceNo');
    });
  }

  QueryBuilder<PurchaseReturn, String, QQueryOperations> linesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linesJson');
    });
  }

  QueryBuilder<PurchaseReturn, int, QQueryOperations> purchaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseId');
    });
  }

  QueryBuilder<PurchaseReturn, String, QQueryOperations> reasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reason');
    });
  }

  QueryBuilder<PurchaseReturn, String, QQueryOperations> returnNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnNo');
    });
  }

  QueryBuilder<PurchaseReturn, DateTime, QQueryOperations>
  returnedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnedAt');
    });
  }

  QueryBuilder<PurchaseReturn, int, QQueryOperations> supplierIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supplierId');
    });
  }

  QueryBuilder<PurchaseReturn, String, QQueryOperations>
  supplierNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supplierName');
    });
  }

  QueryBuilder<PurchaseReturn, double, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }

  QueryBuilder<PurchaseReturn, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<PurchaseReturn, String?, QQueryOperations> userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }
}
