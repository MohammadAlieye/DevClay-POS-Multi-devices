// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_batch.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProductBatchCollection on Isar {
  IsarCollection<ProductBatch> get productBatchs => this.collection();
}

const ProductBatchSchema = CollectionSchema(
  name: r'ProductBatch',
  id: -1833035094970046264,
  properties: {
    r'batchCode': PropertySchema(
      id: 0,
      name: r'batchCode',
      type: IsarType.string,
    ),
    r'expiryDate': PropertySchema(
      id: 1,
      name: r'expiryDate',
      type: IsarType.dateTime,
    ),
    r'manufactureDate': PropertySchema(
      id: 2,
      name: r'manufactureDate',
      type: IsarType.dateTime,
    ),
    r'note': PropertySchema(id: 3, name: r'note', type: IsarType.string),
    r'productId': PropertySchema(
      id: 4,
      name: r'productId',
      type: IsarType.long,
    ),
    r'quantity': PropertySchema(id: 5, name: r'quantity', type: IsarType.long),
    r'receivedAt': PropertySchema(
      id: 6,
      name: r'receivedAt',
      type: IsarType.dateTime,
    ),
    r'unitCost': PropertySchema(
      id: 7,
      name: r'unitCost',
      type: IsarType.double,
    ),
  },

  estimateSize: _productBatchEstimateSize,
  serialize: _productBatchSerialize,
  deserialize: _productBatchDeserialize,
  deserializeProp: _productBatchDeserializeProp,
  idName: r'id',
  indexes: {
    r'productId': IndexSchema(
      id: 5580769080710688203,
      name: r'productId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'productId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'receivedAt': IndexSchema(
      id: -6277795886715409418,
      name: r'receivedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'receivedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _productBatchGetId,
  getLinks: _productBatchGetLinks,
  attach: _productBatchAttach,
  version: '3.3.2',
);

int _productBatchEstimateSize(
  ProductBatch object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.batchCode;
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
  return bytesCount;
}

void _productBatchSerialize(
  ProductBatch object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.batchCode);
  writer.writeDateTime(offsets[1], object.expiryDate);
  writer.writeDateTime(offsets[2], object.manufactureDate);
  writer.writeString(offsets[3], object.note);
  writer.writeLong(offsets[4], object.productId);
  writer.writeLong(offsets[5], object.quantity);
  writer.writeDateTime(offsets[6], object.receivedAt);
  writer.writeDouble(offsets[7], object.unitCost);
}

ProductBatch _productBatchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProductBatch();
  object.batchCode = reader.readStringOrNull(offsets[0]);
  object.expiryDate = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.manufactureDate = reader.readDateTimeOrNull(offsets[2]);
  object.note = reader.readStringOrNull(offsets[3]);
  object.productId = reader.readLong(offsets[4]);
  object.quantity = reader.readLong(offsets[5]);
  object.receivedAt = reader.readDateTime(offsets[6]);
  object.unitCost = reader.readDouble(offsets[7]);
  return object;
}

P _productBatchDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _productBatchGetId(ProductBatch object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _productBatchGetLinks(ProductBatch object) {
  return [];
}

void _productBatchAttach(
  IsarCollection<dynamic> col,
  Id id,
  ProductBatch object,
) {
  object.id = id;
}

extension ProductBatchQueryWhereSort
    on QueryBuilder<ProductBatch, ProductBatch, QWhere> {
  QueryBuilder<ProductBatch, ProductBatch, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhere> anyProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'productId'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhere> anyReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'receivedAt'),
      );
    });
  }
}

extension ProductBatchQueryWhere
    on QueryBuilder<ProductBatch, ProductBatch, QWhereClause> {
  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> productIdEqualTo(
    int productId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'productId', value: [productId]),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause>
  productIdNotEqualTo(int productId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'productId',
                lower: [],
                upper: [productId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'productId',
                lower: [productId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'productId',
                lower: [productId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'productId',
                lower: [],
                upper: [productId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause>
  productIdGreaterThan(int productId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'productId',
          lower: [productId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> productIdLessThan(
    int productId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'productId',
          lower: [],
          upper: [productId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> productIdBetween(
    int lowerProductId,
    int upperProductId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'productId',
          lower: [lowerProductId],
          includeLower: includeLower,
          upper: [upperProductId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> receivedAtEqualTo(
    DateTime receivedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'receivedAt', value: [receivedAt]),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause>
  receivedAtNotEqualTo(DateTime receivedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'receivedAt',
                lower: [],
                upper: [receivedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'receivedAt',
                lower: [receivedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'receivedAt',
                lower: [receivedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'receivedAt',
                lower: [],
                upper: [receivedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause>
  receivedAtGreaterThan(DateTime receivedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'receivedAt',
          lower: [receivedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause>
  receivedAtLessThan(DateTime receivedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'receivedAt',
          lower: [],
          upper: [receivedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterWhereClause> receivedAtBetween(
    DateTime lowerReceivedAt,
    DateTime upperReceivedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'receivedAt',
          lower: [lowerReceivedAt],
          includeLower: includeLower,
          upper: [upperReceivedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ProductBatchQueryFilter
    on QueryBuilder<ProductBatch, ProductBatch, QFilterCondition> {
  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'batchCode'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'batchCode'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'batchCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'batchCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'batchCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'batchCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'batchCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'batchCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'batchCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'batchCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'batchCode', value: ''),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  batchCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'batchCode', value: ''),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  expiryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'expiryDate'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  expiryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'expiryDate'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  expiryDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'expiryDate', value: value),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  expiryDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'expiryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  expiryDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'expiryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  expiryDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'expiryDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  manufactureDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'manufactureDate'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  manufactureDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'manufactureDate'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  manufactureDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'manufactureDate', value: value),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  manufactureDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'manufactureDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  manufactureDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'manufactureDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  manufactureDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'manufactureDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> noteEqualTo(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> noteLessThan(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> noteEndsWith(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> noteContains(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition> noteMatches(
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

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  productIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'productId', value: value),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  productIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'productId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  productIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'productId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'productId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  quantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'quantity', value: value),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  quantityGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'quantity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  quantityLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'quantity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  quantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'quantity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  receivedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receivedAt', value: value),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  receivedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receivedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  receivedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receivedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  receivedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receivedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  unitCostEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unitCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  unitCostGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unitCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  unitCostLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unitCost',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterFilterCondition>
  unitCostBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unitCost',
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

extension ProductBatchQueryObject
    on QueryBuilder<ProductBatch, ProductBatch, QFilterCondition> {}

extension ProductBatchQueryLinks
    on QueryBuilder<ProductBatch, ProductBatch, QFilterCondition> {}

extension ProductBatchQuerySortBy
    on QueryBuilder<ProductBatch, ProductBatch, QSortBy> {
  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByBatchCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchCode', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByBatchCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchCode', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy>
  sortByExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy>
  sortByManufactureDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manufactureDate', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy>
  sortByManufactureDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manufactureDate', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy>
  sortByReceivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByUnitCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCost', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> sortByUnitCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCost', Sort.desc);
    });
  }
}

extension ProductBatchQuerySortThenBy
    on QueryBuilder<ProductBatch, ProductBatch, QSortThenBy> {
  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByBatchCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchCode', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByBatchCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchCode', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy>
  thenByExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy>
  thenByManufactureDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manufactureDate', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy>
  thenByManufactureDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manufactureDate', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy>
  thenByReceivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByUnitCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCost', Sort.asc);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QAfterSortBy> thenByUnitCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCost', Sort.desc);
    });
  }
}

extension ProductBatchQueryWhereDistinct
    on QueryBuilder<ProductBatch, ProductBatch, QDistinct> {
  QueryBuilder<ProductBatch, ProductBatch, QDistinct> distinctByBatchCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batchCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QDistinct> distinctByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiryDate');
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QDistinct>
  distinctByManufactureDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manufactureDate');
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QDistinct> distinctByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QDistinct> distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QDistinct> distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QDistinct> distinctByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receivedAt');
    });
  }

  QueryBuilder<ProductBatch, ProductBatch, QDistinct> distinctByUnitCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitCost');
    });
  }
}

extension ProductBatchQueryProperty
    on QueryBuilder<ProductBatch, ProductBatch, QQueryProperty> {
  QueryBuilder<ProductBatch, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProductBatch, String?, QQueryOperations> batchCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batchCode');
    });
  }

  QueryBuilder<ProductBatch, DateTime?, QQueryOperations> expiryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiryDate');
    });
  }

  QueryBuilder<ProductBatch, DateTime?, QQueryOperations>
  manufactureDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manufactureDate');
    });
  }

  QueryBuilder<ProductBatch, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<ProductBatch, int, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<ProductBatch, int, QQueryOperations> quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }

  QueryBuilder<ProductBatch, DateTime, QQueryOperations> receivedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receivedAt');
    });
  }

  QueryBuilder<ProductBatch, double, QQueryOperations> unitCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitCost');
    });
  }
}
