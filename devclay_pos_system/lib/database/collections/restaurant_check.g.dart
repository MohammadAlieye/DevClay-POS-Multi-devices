// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_check.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRestaurantCheckCollection on Isar {
  IsarCollection<RestaurantCheck> get restaurantChecks => this.collection();
}

const RestaurantCheckSchema = CollectionSchema(
  name: r'RestaurantCheck',
  id: -6654411355466212862,
  properties: {
    r'closedAt': PropertySchema(
      id: 0,
      name: r'closedAt',
      type: IsarType.dateTime,
    ),
    r'closedInvoiceNo': PropertySchema(
      id: 1,
      name: r'closedInvoiceNo',
      type: IsarType.string,
    ),
    r'closedSaleId': PropertySchema(
      id: 2,
      name: r'closedSaleId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'discount': PropertySchema(
      id: 4,
      name: r'discount',
      type: IsarType.double,
    ),
    r'guests': PropertySchema(id: 5, name: r'guests', type: IsarType.long),
    r'linesJson': PropertySchema(
      id: 6,
      name: r'linesJson',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(id: 7, name: r'notes', type: IsarType.string),
    r'sentAt': PropertySchema(id: 8, name: r'sentAt', type: IsarType.dateTime),
    r'serviceCharge': PropertySchema(
      id: 9,
      name: r'serviceCharge',
      type: IsarType.double,
    ),
    r'source': PropertySchema(id: 10, name: r'source', type: IsarType.string),
    r'status': PropertySchema(id: 11, name: r'status', type: IsarType.string),
    r'subtotal': PropertySchema(
      id: 12,
      name: r'subtotal',
      type: IsarType.double,
    ),
    r'tableCode': PropertySchema(
      id: 13,
      name: r'tableCode',
      type: IsarType.string,
    ),
    r'tableId': PropertySchema(id: 14, name: r'tableId', type: IsarType.long),
    r'total': PropertySchema(id: 15, name: r'total', type: IsarType.double),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'webAcceptStatus': PropertySchema(
      id: 17,
      name: r'webAcceptStatus',
      type: IsarType.string,
    ),
  },

  estimateSize: _restaurantCheckEstimateSize,
  serialize: _restaurantCheckSerialize,
  deserialize: _restaurantCheckDeserialize,
  deserializeProp: _restaurantCheckDeserializeProp,
  idName: r'id',
  indexes: {
    r'tableId': IndexSchema(
      id: 519297262500120396,
      name: r'tableId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tableId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _restaurantCheckGetId,
  getLinks: _restaurantCheckGetLinks,
  attach: _restaurantCheckAttach,
  version: '3.3.2',
);

int _restaurantCheckEstimateSize(
  RestaurantCheck object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.closedInvoiceNo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.linesJson.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.tableCode.length * 3;
  bytesCount += 3 + object.webAcceptStatus.length * 3;
  return bytesCount;
}

void _restaurantCheckSerialize(
  RestaurantCheck object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.closedAt);
  writer.writeString(offsets[1], object.closedInvoiceNo);
  writer.writeLong(offsets[2], object.closedSaleId);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeDouble(offsets[4], object.discount);
  writer.writeLong(offsets[5], object.guests);
  writer.writeString(offsets[6], object.linesJson);
  writer.writeString(offsets[7], object.notes);
  writer.writeDateTime(offsets[8], object.sentAt);
  writer.writeDouble(offsets[9], object.serviceCharge);
  writer.writeString(offsets[10], object.source);
  writer.writeString(offsets[11], object.status);
  writer.writeDouble(offsets[12], object.subtotal);
  writer.writeString(offsets[13], object.tableCode);
  writer.writeLong(offsets[14], object.tableId);
  writer.writeDouble(offsets[15], object.total);
  writer.writeDateTime(offsets[16], object.updatedAt);
  writer.writeString(offsets[17], object.webAcceptStatus);
}

RestaurantCheck _restaurantCheckDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RestaurantCheck();
  object.closedAt = reader.readDateTimeOrNull(offsets[0]);
  object.closedInvoiceNo = reader.readStringOrNull(offsets[1]);
  object.closedSaleId = reader.readLongOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.discount = reader.readDouble(offsets[4]);
  object.guests = reader.readLong(offsets[5]);
  object.id = id;
  object.linesJson = reader.readString(offsets[6]);
  object.notes = reader.readString(offsets[7]);
  object.sentAt = reader.readDateTimeOrNull(offsets[8]);
  object.serviceCharge = reader.readDouble(offsets[9]);
  object.source = reader.readString(offsets[10]);
  object.status = reader.readString(offsets[11]);
  object.subtotal = reader.readDouble(offsets[12]);
  object.tableCode = reader.readString(offsets[13]);
  object.tableId = reader.readLong(offsets[14]);
  object.total = reader.readDouble(offsets[15]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[16]);
  object.webAcceptStatus = reader.readString(offsets[17]);
  return object;
}

P _restaurantCheckDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _restaurantCheckGetId(RestaurantCheck object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _restaurantCheckGetLinks(RestaurantCheck object) {
  return [];
}

void _restaurantCheckAttach(
  IsarCollection<dynamic> col,
  Id id,
  RestaurantCheck object,
) {
  object.id = id;
}

extension RestaurantCheckQueryWhereSort
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QWhere> {
  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhere> anyTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tableId'),
      );
    });
  }
}

extension RestaurantCheckQueryWhere
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QWhereClause> {
  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause> idBetween(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
  tableIdEqualTo(int tableId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'tableId', value: [tableId]),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
  tableIdNotEqualTo(int tableId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tableId',
                lower: [],
                upper: [tableId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tableId',
                lower: [tableId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tableId',
                lower: [tableId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tableId',
                lower: [],
                upper: [tableId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
  tableIdGreaterThan(int tableId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tableId',
          lower: [tableId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
  tableIdLessThan(int tableId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tableId',
          lower: [],
          upper: [tableId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
  tableIdBetween(
    int lowerTableId,
    int upperTableId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tableId',
          lower: [lowerTableId],
          includeLower: includeLower,
          upper: [upperTableId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
  statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterWhereClause>
  statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension RestaurantCheckQueryFilter
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QFilterCondition> {
  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'closedAt'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'closedAt'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'closedAt', value: value),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedAtGreaterThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedAtLessThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedAtBetween(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'closedInvoiceNo'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'closedInvoiceNo'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'closedInvoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'closedInvoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'closedInvoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'closedInvoiceNo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'closedInvoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'closedInvoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'closedInvoiceNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'closedInvoiceNo',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'closedInvoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedInvoiceNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'closedInvoiceNo', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedSaleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'closedSaleId'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedSaleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'closedSaleId'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedSaleIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'closedSaleId', value: value),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedSaleIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'closedSaleId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedSaleIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'closedSaleId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  closedSaleIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'closedSaleId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  discountEqualTo(double value, {double epsilon = Query.epsilon}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  discountGreaterThan(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  discountLessThan(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  discountBetween(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  guestsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'guests', value: value),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  guestsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'guests',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  guestsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'guests',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  guestsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'guests',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  linesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  linesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesGreaterThan(
    String value, {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesLessThan(
    String value, {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesBetween(
    String lower,
    String upper, {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sentAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sentAt'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sentAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sentAt'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sentAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sentAt', value: value),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sentAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sentAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sentAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sentAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sentAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sentAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  serviceChargeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'serviceCharge',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  serviceChargeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'serviceCharge',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  serviceChargeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'serviceCharge',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  serviceChargeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'serviceCharge',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'source',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'source',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusGreaterThan(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusLessThan(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusBetween(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  subtotalEqualTo(double value, {double epsilon = Query.epsilon}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  subtotalGreaterThan(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  subtotalLessThan(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  subtotalBetween(
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tableCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tableCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tableCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tableCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tableCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tableCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tableCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tableCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tableCode', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tableCode', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tableId', value: value),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tableId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tableId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  tableIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tableId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  updatedAtLessThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'webAcceptStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'webAcceptStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'webAcceptStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'webAcceptStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'webAcceptStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'webAcceptStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'webAcceptStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'webAcceptStatus',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'webAcceptStatus', value: ''),
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterFilterCondition>
  webAcceptStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'webAcceptStatus', value: ''),
      );
    });
  }
}

extension RestaurantCheckQueryObject
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QFilterCondition> {}

extension RestaurantCheckQueryLinks
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QFilterCondition> {}

extension RestaurantCheckQuerySortBy
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QSortBy> {
  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByClosedInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedInvoiceNo', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByClosedInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedInvoiceNo', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByClosedSaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedSaleId', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByClosedSaleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedSaleId', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> sortByGuests() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guests', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByGuestsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guests', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> sortBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortBySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByServiceCharge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceCharge', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByServiceChargeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceCharge', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByTableCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableCode', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByTableCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableCode', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> sortByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByTableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByWebAcceptStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webAcceptStatus', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  sortByWebAcceptStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webAcceptStatus', Sort.desc);
    });
  }
}

extension RestaurantCheckQuerySortThenBy
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QSortThenBy> {
  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByClosedInvoiceNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedInvoiceNo', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByClosedInvoiceNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedInvoiceNo', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByClosedSaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedSaleId', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByClosedSaleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedSaleId', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenByGuests() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guests', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByGuestsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guests', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenBySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByServiceCharge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceCharge', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByServiceChargeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceCharge', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByTableCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableCode', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByTableCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableCode', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByTableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy> thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByWebAcceptStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webAcceptStatus', Sort.asc);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QAfterSortBy>
  thenByWebAcceptStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webAcceptStatus', Sort.desc);
    });
  }
}

extension RestaurantCheckQueryWhereDistinct
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct> {
  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closedAt');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByClosedInvoiceNo({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'closedInvoiceNo',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByClosedSaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closedSaleId');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discount');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct> distinctByGuests() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guests');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByLinesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct> distinctBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sentAt');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByServiceCharge() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceCharge');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct> distinctBySource({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtotal');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByTableCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tableCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tableId');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct> distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<RestaurantCheck, RestaurantCheck, QDistinct>
  distinctByWebAcceptStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'webAcceptStatus',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension RestaurantCheckQueryProperty
    on QueryBuilder<RestaurantCheck, RestaurantCheck, QQueryProperty> {
  QueryBuilder<RestaurantCheck, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RestaurantCheck, DateTime?, QQueryOperations>
  closedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closedAt');
    });
  }

  QueryBuilder<RestaurantCheck, String?, QQueryOperations>
  closedInvoiceNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closedInvoiceNo');
    });
  }

  QueryBuilder<RestaurantCheck, int?, QQueryOperations> closedSaleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closedSaleId');
    });
  }

  QueryBuilder<RestaurantCheck, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<RestaurantCheck, double, QQueryOperations> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<RestaurantCheck, int, QQueryOperations> guestsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guests');
    });
  }

  QueryBuilder<RestaurantCheck, String, QQueryOperations> linesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linesJson');
    });
  }

  QueryBuilder<RestaurantCheck, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<RestaurantCheck, DateTime?, QQueryOperations> sentAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sentAt');
    });
  }

  QueryBuilder<RestaurantCheck, double, QQueryOperations>
  serviceChargeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceCharge');
    });
  }

  QueryBuilder<RestaurantCheck, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<RestaurantCheck, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<RestaurantCheck, double, QQueryOperations> subtotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtotal');
    });
  }

  QueryBuilder<RestaurantCheck, String, QQueryOperations> tableCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tableCode');
    });
  }

  QueryBuilder<RestaurantCheck, int, QQueryOperations> tableIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tableId');
    });
  }

  QueryBuilder<RestaurantCheck, double, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }

  QueryBuilder<RestaurantCheck, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<RestaurantCheck, String, QQueryOperations>
  webAcceptStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'webAcceptStatus');
    });
  }
}
