// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLabelTemplateCollection on Isar {
  IsarCollection<LabelTemplate> get labelTemplates => this.collection();
}

const LabelTemplateSchema = CollectionSchema(
  name: r'LabelTemplate',
  id: 8341353780753628,
  properties: {
    r'defaultCopies': PropertySchema(
      id: 0,
      name: r'defaultCopies',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'heightMm': PropertySchema(
      id: 2,
      name: r'heightMm',
      type: IsarType.double,
    ),
    r'isBuiltIn': PropertySchema(
      id: 3,
      name: r'isBuiltIn',
      type: IsarType.bool,
    ),
    r'isDefault': PropertySchema(
      id: 4,
      name: r'isDefault',
      type: IsarType.bool,
    ),
    r'key': PropertySchema(id: 5, name: r'key', type: IsarType.string),
    r'name': PropertySchema(id: 6, name: r'name', type: IsarType.string),
    r'payloadFormat': PropertySchema(
      id: 7,
      name: r'payloadFormat',
      type: IsarType.string,
    ),
    r'showBatchSlot': PropertySchema(
      id: 8,
      name: r'showBatchSlot',
      type: IsarType.bool,
    ),
    r'showBrand': PropertySchema(
      id: 9,
      name: r'showBrand',
      type: IsarType.bool,
    ),
    r'showCategory': PropertySchema(
      id: 10,
      name: r'showCategory',
      type: IsarType.bool,
    ),
    r'showExpirySlot': PropertySchema(
      id: 11,
      name: r'showExpirySlot',
      type: IsarType.bool,
    ),
    r'showPrice': PropertySchema(
      id: 12,
      name: r'showPrice',
      type: IsarType.bool,
    ),
    r'showProductName': PropertySchema(
      id: 13,
      name: r'showProductName',
      type: IsarType.bool,
    ),
    r'showSku': PropertySchema(id: 14, name: r'showSku', type: IsarType.bool),
    r'showUnit': PropertySchema(id: 15, name: r'showUnit', type: IsarType.bool),
    r'storeType': PropertySchema(
      id: 16,
      name: r'storeType',
      type: IsarType.string,
    ),
    r'symbology': PropertySchema(
      id: 17,
      name: r'symbology',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 18,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'widthMm': PropertySchema(id: 19, name: r'widthMm', type: IsarType.double),
  },

  estimateSize: _labelTemplateEstimateSize,
  serialize: _labelTemplateSerialize,
  deserialize: _labelTemplateDeserialize,
  deserializeProp: _labelTemplateDeserializeProp,
  idName: r'id',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _labelTemplateGetId,
  getLinks: _labelTemplateGetLinks,
  attach: _labelTemplateAttach,
  version: '3.3.2',
);

int _labelTemplateEstimateSize(
  LabelTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.payloadFormat.length * 3;
  bytesCount += 3 + object.storeType.length * 3;
  bytesCount += 3 + object.symbology.length * 3;
  return bytesCount;
}

void _labelTemplateSerialize(
  LabelTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.defaultCopies);
  writer.writeString(offsets[1], object.description);
  writer.writeDouble(offsets[2], object.heightMm);
  writer.writeBool(offsets[3], object.isBuiltIn);
  writer.writeBool(offsets[4], object.isDefault);
  writer.writeString(offsets[5], object.key);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.payloadFormat);
  writer.writeBool(offsets[8], object.showBatchSlot);
  writer.writeBool(offsets[9], object.showBrand);
  writer.writeBool(offsets[10], object.showCategory);
  writer.writeBool(offsets[11], object.showExpirySlot);
  writer.writeBool(offsets[12], object.showPrice);
  writer.writeBool(offsets[13], object.showProductName);
  writer.writeBool(offsets[14], object.showSku);
  writer.writeBool(offsets[15], object.showUnit);
  writer.writeString(offsets[16], object.storeType);
  writer.writeString(offsets[17], object.symbology);
  writer.writeDateTime(offsets[18], object.updatedAt);
  writer.writeDouble(offsets[19], object.widthMm);
}

LabelTemplate _labelTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LabelTemplate();
  object.defaultCopies = reader.readLong(offsets[0]);
  object.description = reader.readString(offsets[1]);
  object.heightMm = reader.readDouble(offsets[2]);
  object.id = id;
  object.isBuiltIn = reader.readBool(offsets[3]);
  object.isDefault = reader.readBool(offsets[4]);
  object.key = reader.readString(offsets[5]);
  object.name = reader.readString(offsets[6]);
  object.payloadFormat = reader.readString(offsets[7]);
  object.showBatchSlot = reader.readBool(offsets[8]);
  object.showBrand = reader.readBool(offsets[9]);
  object.showCategory = reader.readBool(offsets[10]);
  object.showExpirySlot = reader.readBool(offsets[11]);
  object.showPrice = reader.readBool(offsets[12]);
  object.showProductName = reader.readBool(offsets[13]);
  object.showSku = reader.readBool(offsets[14]);
  object.showUnit = reader.readBool(offsets[15]);
  object.storeType = reader.readString(offsets[16]);
  object.symbology = reader.readString(offsets[17]);
  object.updatedAt = reader.readDateTime(offsets[18]);
  object.widthMm = reader.readDouble(offsets[19]);
  return object;
}

P _labelTemplateDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readDateTime(offset)) as P;
    case 19:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _labelTemplateGetId(LabelTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _labelTemplateGetLinks(LabelTemplate object) {
  return [];
}

void _labelTemplateAttach(
  IsarCollection<dynamic> col,
  Id id,
  LabelTemplate object,
) {
  object.id = id;
}

extension LabelTemplateByIndex on IsarCollection<LabelTemplate> {
  Future<LabelTemplate?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  LabelTemplate? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<LabelTemplate?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<LabelTemplate?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(LabelTemplate object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(LabelTemplate object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<LabelTemplate> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(
    List<LabelTemplate> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension LabelTemplateQueryWhereSort
    on QueryBuilder<LabelTemplate, LabelTemplate, QWhere> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LabelTemplateQueryWhere
    on QueryBuilder<LabelTemplate, LabelTemplate, QWhereClause> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idBetween(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> keyEqualTo(
    String key,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'key', value: [key]),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> keyNotEqualTo(
    String key,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [],
                upper: [key],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [key],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [key],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [],
                upper: [key],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension LabelTemplateQueryFilter
    on QueryBuilder<LabelTemplate, LabelTemplate, QFilterCondition> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  defaultCopiesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultCopies', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  defaultCopiesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultCopies',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  defaultCopiesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultCopies',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  defaultCopiesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultCopies',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  descriptionEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  descriptionGreaterThan(
    String value, {
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  descriptionLessThan(
    String value, {
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  descriptionBetween(
    String lower,
    String upper, {
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  heightMmEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'heightMm',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  heightMmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'heightMm',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  heightMmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'heightMm',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  heightMmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'heightMm',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  isBuiltInEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isBuiltIn', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  isDefaultEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isDefault', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  keyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> keyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> keyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'payloadFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'payloadFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'payloadFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'payloadFormat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'payloadFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'payloadFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'payloadFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'payloadFormat',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'payloadFormat', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  payloadFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'payloadFormat', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  showBatchSlotEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showBatchSlot', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  showBrandEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showBrand', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  showCategoryEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showCategory', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  showExpirySlotEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showExpirySlot', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  showPriceEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showPrice', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  showProductNameEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showProductName', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  showSkuEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showSku', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  showUnitEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showUnit', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'storeType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'storeType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'storeType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'storeType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'storeType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'storeType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'storeType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'storeType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'storeType', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  storeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'storeType', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'symbology',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'symbology',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'symbology',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'symbology',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'symbology',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'symbology',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'symbology',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'symbology',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'symbology', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  symbologyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'symbology', value: ''),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  widthMmEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'widthMm',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  widthMmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'widthMm',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  widthMmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'widthMm',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
  widthMmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'widthMm',
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

extension LabelTemplateQueryObject
    on QueryBuilder<LabelTemplate, LabelTemplate, QFilterCondition> {}

extension LabelTemplateQueryLinks
    on QueryBuilder<LabelTemplate, LabelTemplate, QFilterCondition> {}

extension LabelTemplateQuerySortBy
    on QueryBuilder<LabelTemplate, LabelTemplate, QSortBy> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByDefaultCopies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultCopies', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByDefaultCopiesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultCopies', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByHeightMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightMm', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByHeightMmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightMm', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByIsBuiltInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByPayloadFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadFormat', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByPayloadFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadFormat', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowBatchSlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBatchSlot', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowBatchSlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBatchSlot', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBrand', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBrand', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCategory', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCategory', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowExpirySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showExpirySlot', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowExpirySlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showExpirySlot', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPrice', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPrice', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showProductName', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showProductName', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowSku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showSku', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowSkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showSku', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showUnit', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByShowUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showUnit', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByStoreType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeType', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByStoreTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeType', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortBySymbology() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbology', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortBySymbologyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbology', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'widthMm', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByWidthMmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'widthMm', Sort.desc);
    });
  }
}

extension LabelTemplateQuerySortThenBy
    on QueryBuilder<LabelTemplate, LabelTemplate, QSortThenBy> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByDefaultCopies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultCopies', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByDefaultCopiesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultCopies', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByHeightMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightMm', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByHeightMmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightMm', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByIsBuiltInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByPayloadFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadFormat', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByPayloadFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadFormat', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowBatchSlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBatchSlot', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowBatchSlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBatchSlot', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBrand', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBrand', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCategory', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCategory', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowExpirySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showExpirySlot', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowExpirySlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showExpirySlot', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPrice', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPrice', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showProductName', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showProductName', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowSku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showSku', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowSkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showSku', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showUnit', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByShowUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showUnit', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByStoreType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeType', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByStoreTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeType', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenBySymbology() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbology', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenBySymbologyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbology', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'widthMm', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByWidthMmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'widthMm', Sort.desc);
    });
  }
}

extension LabelTemplateQueryWhereDistinct
    on QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> {
  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
  distinctByDefaultCopies() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultCopies');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByHeightMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heightMm');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBuiltIn');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDefault');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
  distinctByPayloadFormat({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'payloadFormat',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
  distinctByShowBatchSlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showBatchSlot');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByShowBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showBrand');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
  distinctByShowCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showCategory');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
  distinctByShowExpirySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showExpirySlot');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByShowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showPrice');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
  distinctByShowProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showProductName');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByShowSku() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showSku');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByShowUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showUnit');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByStoreType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'storeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctBySymbology({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'symbology', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'widthMm');
    });
  }
}

extension LabelTemplateQueryProperty
    on QueryBuilder<LabelTemplate, LabelTemplate, QQueryProperty> {
  QueryBuilder<LabelTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LabelTemplate, int, QQueryOperations> defaultCopiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultCopies');
    });
  }

  QueryBuilder<LabelTemplate, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<LabelTemplate, double, QQueryOperations> heightMmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heightMm');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> isBuiltInProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBuiltIn');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> isDefaultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDefault');
    });
  }

  QueryBuilder<LabelTemplate, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<LabelTemplate, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LabelTemplate, String, QQueryOperations>
  payloadFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadFormat');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showBatchSlotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showBatchSlot');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showBrandProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showBrand');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showCategory');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showExpirySlotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showExpirySlot');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showPrice');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations>
  showProductNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showProductName');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showSkuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showSku');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showUnit');
    });
  }

  QueryBuilder<LabelTemplate, String, QQueryOperations> storeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'storeType');
    });
  }

  QueryBuilder<LabelTemplate, String, QQueryOperations> symbologyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'symbology');
    });
  }

  QueryBuilder<LabelTemplate, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LabelTemplate, double, QQueryOperations> widthMmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'widthMm');
    });
  }
}
