// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'held_sale.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHeldSaleCollection on Isar {
  IsarCollection<HeldSale> get heldSales => this.collection();
}

const HeldSaleSchema = CollectionSchema(
  name: r'HeldSale',
  id: -8264155753588997111,
  properties: {
    r'customerId': PropertySchema(
      id: 0,
      name: r'customerId',
      type: IsarType.long,
    ),
    r'customerName': PropertySchema(
      id: 1,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'deletedAt': PropertySchema(
      id: 2,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'discountAmount': PropertySchema(
      id: 3,
      name: r'discountAmount',
      type: IsarType.double,
    ),
    r'discountIsPercent': PropertySchema(
      id: 4,
      name: r'discountIsPercent',
      type: IsarType.bool,
    ),
    r'heldAt': PropertySchema(id: 5, name: r'heldAt', type: IsarType.dateTime),
    r'holdCode': PropertySchema(
      id: 6,
      name: r'holdCode',
      type: IsarType.string,
    ),
    r'itemsJson': PropertySchema(
      id: 7,
      name: r'itemsJson',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(id: 8, name: r'notes', type: IsarType.string),
  },

  estimateSize: _heldSaleEstimateSize,
  serialize: _heldSaleSerialize,
  deserialize: _heldSaleDeserialize,
  deserializeProp: _heldSaleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _heldSaleGetId,
  getLinks: _heldSaleGetLinks,
  attach: _heldSaleAttach,
  version: '3.3.2',
);

int _heldSaleEstimateSize(
  HeldSale object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.customerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.holdCode.length * 3;
  bytesCount += 3 + object.itemsJson.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _heldSaleSerialize(
  HeldSale object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.customerId);
  writer.writeString(offsets[1], object.customerName);
  writer.writeDateTime(offsets[2], object.deletedAt);
  writer.writeDouble(offsets[3], object.discountAmount);
  writer.writeBool(offsets[4], object.discountIsPercent);
  writer.writeDateTime(offsets[5], object.heldAt);
  writer.writeString(offsets[6], object.holdCode);
  writer.writeString(offsets[7], object.itemsJson);
  writer.writeString(offsets[8], object.notes);
}

HeldSale _heldSaleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HeldSale();
  object.customerId = reader.readLongOrNull(offsets[0]);
  object.customerName = reader.readStringOrNull(offsets[1]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[2]);
  object.discountAmount = reader.readDouble(offsets[3]);
  object.discountIsPercent = reader.readBool(offsets[4]);
  object.heldAt = reader.readDateTime(offsets[5]);
  object.holdCode = reader.readString(offsets[6]);
  object.id = id;
  object.itemsJson = reader.readString(offsets[7]);
  object.notes = reader.readStringOrNull(offsets[8]);
  return object;
}

P _heldSaleDeserializeProp<P>(
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
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _heldSaleGetId(HeldSale object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _heldSaleGetLinks(HeldSale object) {
  return [];
}

void _heldSaleAttach(IsarCollection<dynamic> col, Id id, HeldSale object) {
  object.id = id;
}

extension HeldSaleQueryWhereSort on QueryBuilder<HeldSale, HeldSale, QWhere> {
  QueryBuilder<HeldSale, HeldSale, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HeldSaleQueryWhere on QueryBuilder<HeldSale, HeldSale, QWhereClause> {
  QueryBuilder<HeldSale, HeldSale, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HeldSale, HeldSale, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterWhereClause> idBetween(
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

extension HeldSaleQueryFilter
    on QueryBuilder<HeldSale, HeldSale, QFilterCondition> {
  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
  customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerId', value: value),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerIdGreaterThan(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerIdLessThan(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerIdBetween(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerName'),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
  customerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerName'),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerNameEqualTo(
    String? value, {
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerNameLessThan(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerNameBetween(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerNameEndsWith(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerNameContains(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> customerNameMatches(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
  customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
  customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> deletedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deletedAt', value: value),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> deletedAtBetween(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> discountAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'discountAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
  discountAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'discountAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
  discountAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'discountAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> discountAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'discountAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
  discountIsPercentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'discountIsPercent', value: value),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> heldAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'heldAt', value: value),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> heldAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'heldAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> heldAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'heldAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> heldAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'heldAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'holdCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'holdCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'holdCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'holdCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'holdCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'holdCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'holdCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'holdCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'holdCode', value: ''),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> holdCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'holdCode', value: ''),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'itemsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'itemsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'itemsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'itemsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'itemsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> itemsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemsJson', value: ''),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition>
  itemsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'itemsJson', value: ''),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesEqualTo(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesGreaterThan(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesLessThan(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesBetween(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesStartsWith(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesEndsWith(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesContains(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesMatches(
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

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }
}

extension HeldSaleQueryObject
    on QueryBuilder<HeldSale, HeldSale, QFilterCondition> {}

extension HeldSaleQueryLinks
    on QueryBuilder<HeldSale, HeldSale, QFilterCondition> {}

extension HeldSaleQuerySortBy on QueryBuilder<HeldSale, HeldSale, QSortBy> {
  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByDiscountAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountAmount', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByDiscountAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountAmount', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByDiscountIsPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountIsPercent', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByDiscountIsPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountIsPercent', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByHeldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heldAt', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByHeldAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heldAt', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByHoldCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holdCode', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByHoldCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holdCode', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByItemsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByItemsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }
}

extension HeldSaleQuerySortThenBy
    on QueryBuilder<HeldSale, HeldSale, QSortThenBy> {
  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByDiscountAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountAmount', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByDiscountAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountAmount', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByDiscountIsPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountIsPercent', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByDiscountIsPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountIsPercent', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByHeldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heldAt', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByHeldAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heldAt', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByHoldCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holdCode', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByHoldCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holdCode', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByItemsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByItemsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.desc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }
}

extension HeldSaleQueryWhereDistinct
    on QueryBuilder<HeldSale, HeldSale, QDistinct> {
  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId');
    });
  }

  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByCustomerName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByDiscountAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discountAmount');
    });
  }

  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByDiscountIsPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discountIsPercent');
    });
  }

  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByHeldAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heldAt');
    });
  }

  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByHoldCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'holdCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByItemsJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HeldSale, HeldSale, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }
}

extension HeldSaleQueryProperty
    on QueryBuilder<HeldSale, HeldSale, QQueryProperty> {
  QueryBuilder<HeldSale, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HeldSale, int?, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<HeldSale, String?, QQueryOperations> customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<HeldSale, DateTime?, QQueryOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<HeldSale, double, QQueryOperations> discountAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discountAmount');
    });
  }

  QueryBuilder<HeldSale, bool, QQueryOperations> discountIsPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discountIsPercent');
    });
  }

  QueryBuilder<HeldSale, DateTime, QQueryOperations> heldAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heldAt');
    });
  }

  QueryBuilder<HeldSale, String, QQueryOperations> holdCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'holdCode');
    });
  }

  QueryBuilder<HeldSale, String, QQueryOperations> itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemsJson');
    });
  }

  QueryBuilder<HeldSale, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }
}
