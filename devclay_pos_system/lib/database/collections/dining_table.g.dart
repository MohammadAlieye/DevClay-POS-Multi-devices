// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dining_table.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiningTableCollection on Isar {
  IsarCollection<DiningTable> get diningTables => this.collection();
}

const DiningTableSchema = CollectionSchema(
  name: r'DiningTable',
  id: -1014392136960968526,
  properties: {
    r'capacity': PropertySchema(id: 0, name: r'capacity', type: IsarType.long),
    r'code': PropertySchema(id: 1, name: r'code', type: IsarType.string),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 3,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'floorId': PropertySchema(id: 4, name: r'floorId', type: IsarType.long),
    r'guestToken': PropertySchema(
      id: 5,
      name: r'guestToken',
      type: IsarType.string,
    ),
    r'guests': PropertySchema(id: 6, name: r'guests', type: IsarType.long),
    r'isActive': PropertySchema(id: 7, name: r'isActive', type: IsarType.bool),
    r'name': PropertySchema(id: 8, name: r'name', type: IsarType.string),
    r'openCheckId': PropertySchema(
      id: 9,
      name: r'openCheckId',
      type: IsarType.long,
    ),
    r'posX': PropertySchema(id: 10, name: r'posX', type: IsarType.double),
    r'posY': PropertySchema(id: 11, name: r'posY', type: IsarType.double),
    r'shape': PropertySchema(id: 12, name: r'shape', type: IsarType.string),
    r'status': PropertySchema(id: 13, name: r'status', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _diningTableEstimateSize,
  serialize: _diningTableSerialize,
  deserialize: _diningTableDeserialize,
  deserializeProp: _diningTableDeserializeProp,
  idName: r'id',
  indexes: {
    r'floorId': IndexSchema(
      id: -5614466107289224596,
      name: r'floorId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'floorId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'code': IndexSchema(
      id: 329780482934683790,
      name: r'code',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'code',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _diningTableGetId,
  getLinks: _diningTableGetLinks,
  attach: _diningTableAttach,
  version: '3.3.2',
);

int _diningTableEstimateSize(
  DiningTable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.guestToken.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.shape.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _diningTableSerialize(
  DiningTable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.capacity);
  writer.writeString(offsets[1], object.code);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.deletedAt);
  writer.writeLong(offsets[4], object.floorId);
  writer.writeString(offsets[5], object.guestToken);
  writer.writeLong(offsets[6], object.guests);
  writer.writeBool(offsets[7], object.isActive);
  writer.writeString(offsets[8], object.name);
  writer.writeLong(offsets[9], object.openCheckId);
  writer.writeDouble(offsets[10], object.posX);
  writer.writeDouble(offsets[11], object.posY);
  writer.writeString(offsets[12], object.shape);
  writer.writeString(offsets[13], object.status);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

DiningTable _diningTableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiningTable();
  object.capacity = reader.readLong(offsets[0]);
  object.code = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[3]);
  object.floorId = reader.readLong(offsets[4]);
  object.guestToken = reader.readString(offsets[5]);
  object.guests = reader.readLong(offsets[6]);
  object.id = id;
  object.isActive = reader.readBool(offsets[7]);
  object.name = reader.readString(offsets[8]);
  object.openCheckId = reader.readLongOrNull(offsets[9]);
  object.posX = reader.readDouble(offsets[10]);
  object.posY = reader.readDouble(offsets[11]);
  object.shape = reader.readString(offsets[12]);
  object.status = reader.readString(offsets[13]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[14]);
  return object;
}

P _diningTableDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _diningTableGetId(DiningTable object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _diningTableGetLinks(DiningTable object) {
  return [];
}

void _diningTableAttach(
  IsarCollection<dynamic> col,
  Id id,
  DiningTable object,
) {
  object.id = id;
}

extension DiningTableByIndex on IsarCollection<DiningTable> {
  Future<DiningTable?> getByCode(String code) {
    return getByIndex(r'code', [code]);
  }

  DiningTable? getByCodeSync(String code) {
    return getByIndexSync(r'code', [code]);
  }

  Future<bool> deleteByCode(String code) {
    return deleteByIndex(r'code', [code]);
  }

  bool deleteByCodeSync(String code) {
    return deleteByIndexSync(r'code', [code]);
  }

  Future<List<DiningTable?>> getAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndex(r'code', values);
  }

  List<DiningTable?> getAllByCodeSync(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'code', values);
  }

  Future<int> deleteAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'code', values);
  }

  int deleteAllByCodeSync(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'code', values);
  }

  Future<Id> putByCode(DiningTable object) {
    return putByIndex(r'code', object);
  }

  Id putByCodeSync(DiningTable object, {bool saveLinks = true}) {
    return putByIndexSync(r'code', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCode(List<DiningTable> objects) {
    return putAllByIndex(r'code', objects);
  }

  List<Id> putAllByCodeSync(
    List<DiningTable> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'code', objects, saveLinks: saveLinks);
  }
}

extension DiningTableQueryWhereSort
    on QueryBuilder<DiningTable, DiningTable, QWhere> {
  QueryBuilder<DiningTable, DiningTable, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhere> anyFloorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'floorId'),
      );
    });
  }
}

extension DiningTableQueryWhere
    on QueryBuilder<DiningTable, DiningTable, QWhereClause> {
  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> idBetween(
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

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> floorIdEqualTo(
    int floorId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'floorId', value: [floorId]),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> floorIdNotEqualTo(
    int floorId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'floorId',
                lower: [],
                upper: [floorId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'floorId',
                lower: [floorId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'floorId',
                lower: [floorId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'floorId',
                lower: [],
                upper: [floorId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> floorIdGreaterThan(
    int floorId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'floorId',
          lower: [floorId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> floorIdLessThan(
    int floorId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'floorId',
          lower: [],
          upper: [floorId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> floorIdBetween(
    int lowerFloorId,
    int upperFloorId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'floorId',
          lower: [lowerFloorId],
          includeLower: includeLower,
          upper: [upperFloorId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> codeEqualTo(
    String code,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'code', value: [code]),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterWhereClause> codeNotEqualTo(
    String code,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [],
                upper: [code],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [code],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [code],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [],
                upper: [code],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DiningTableQueryFilter
    on QueryBuilder<DiningTable, DiningTable, QFilterCondition> {
  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> capacityEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'capacity', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  capacityGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'capacity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  capacityLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'capacity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> capacityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'capacity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'code',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'code',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deletedAt', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> floorIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'floorId', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  floorIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'floorId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> floorIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'floorId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> floorIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'floorId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'guestToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'guestToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'guestToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'guestToken',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'guestToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'guestToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'guestToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'guestToken',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'guestToken', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  guestTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'guestToken', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> guestsEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'guests', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> guestsLessThan(
    int value, {
    bool include = false,
  }) {
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> guestsBetween(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> isActiveEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  openCheckIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'openCheckId'),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  openCheckIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'openCheckId'),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  openCheckIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'openCheckId', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  openCheckIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'openCheckId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  openCheckIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'openCheckId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  openCheckIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'openCheckId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> posXEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'posX',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> posXGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'posX',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> posXLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'posX',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> posXBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'posX',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> posYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'posY',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> posYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'posY',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> posYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'posY',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> posYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'posY',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> shapeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'shape',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  shapeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shape',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> shapeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shape',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> shapeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shape',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> shapeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'shape',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> shapeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'shape',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> shapeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'shape',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> shapeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'shape',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> shapeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shape', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  shapeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'shape', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> statusLessThan(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> statusBetween(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> statusEndsWith(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> statusContains(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition> statusMatches(
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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

  QueryBuilder<DiningTable, DiningTable, QAfterFilterCondition>
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
}

extension DiningTableQueryObject
    on QueryBuilder<DiningTable, DiningTable, QFilterCondition> {}

extension DiningTableQueryLinks
    on QueryBuilder<DiningTable, DiningTable, QFilterCondition> {}

extension DiningTableQuerySortBy
    on QueryBuilder<DiningTable, DiningTable, QSortBy> {
  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacity', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByCapacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacity', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByFloorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'floorId', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByFloorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'floorId', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByGuestToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestToken', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByGuestTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestToken', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByGuests() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guests', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByGuestsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guests', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByOpenCheckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openCheckId', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByOpenCheckIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openCheckId', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByPosX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posX', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByPosXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posX', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByPosY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posY', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByPosYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posY', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByShape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shape', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByShapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shape', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DiningTableQuerySortThenBy
    on QueryBuilder<DiningTable, DiningTable, QSortThenBy> {
  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacity', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByCapacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacity', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByFloorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'floorId', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByFloorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'floorId', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByGuestToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestToken', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByGuestTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestToken', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByGuests() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guests', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByGuestsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guests', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByOpenCheckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openCheckId', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByOpenCheckIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openCheckId', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByPosX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posX', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByPosXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posX', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByPosY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posY', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByPosYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posY', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByShape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shape', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByShapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shape', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DiningTableQueryWhereDistinct
    on QueryBuilder<DiningTable, DiningTable, QDistinct> {
  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capacity');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByFloorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'floorId');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByGuestToken({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guestToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByGuests() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guests');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByOpenCheckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openCheckId');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByPosX() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posX');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByPosY() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posY');
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByShape({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shape', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiningTable, DiningTable, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DiningTableQueryProperty
    on QueryBuilder<DiningTable, DiningTable, QQueryProperty> {
  QueryBuilder<DiningTable, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiningTable, int, QQueryOperations> capacityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capacity');
    });
  }

  QueryBuilder<DiningTable, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<DiningTable, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DiningTable, DateTime?, QQueryOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<DiningTable, int, QQueryOperations> floorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'floorId');
    });
  }

  QueryBuilder<DiningTable, String, QQueryOperations> guestTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guestToken');
    });
  }

  QueryBuilder<DiningTable, int, QQueryOperations> guestsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guests');
    });
  }

  QueryBuilder<DiningTable, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<DiningTable, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<DiningTable, int?, QQueryOperations> openCheckIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openCheckId');
    });
  }

  QueryBuilder<DiningTable, double, QQueryOperations> posXProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posX');
    });
  }

  QueryBuilder<DiningTable, double, QQueryOperations> posYProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posY');
    });
  }

  QueryBuilder<DiningTable, String, QQueryOperations> shapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shape');
    });
  }

  QueryBuilder<DiningTable, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DiningTable, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
