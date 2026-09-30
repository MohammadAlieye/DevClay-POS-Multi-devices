// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_ticket.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKitchenTicketCollection on Isar {
  IsarCollection<KitchenTicket> get kitchenTickets => this.collection();
}

const KitchenTicketSchema = CollectionSchema(
  name: r'KitchenTicket',
  id: -2426109739492987220,
  properties: {
    r'bumpedAt': PropertySchema(
      id: 0,
      name: r'bumpedAt',
      type: IsarType.dateTime,
    ),
    r'checkId': PropertySchema(id: 1, name: r'checkId', type: IsarType.long),
    r'course': PropertySchema(id: 2, name: r'course', type: IsarType.string),
    r'firedAt': PropertySchema(
      id: 3,
      name: r'firedAt',
      type: IsarType.dateTime,
    ),
    r'linesJson': PropertySchema(
      id: 4,
      name: r'linesJson',
      type: IsarType.string,
    ),
    r'readyAt': PropertySchema(
      id: 5,
      name: r'readyAt',
      type: IsarType.dateTime,
    ),
    r'station': PropertySchema(id: 6, name: r'station', type: IsarType.string),
    r'status': PropertySchema(id: 7, name: r'status', type: IsarType.string),
    r'tableCode': PropertySchema(
      id: 8,
      name: r'tableCode',
      type: IsarType.string,
    ),
    r'tableId': PropertySchema(id: 9, name: r'tableId', type: IsarType.long),
  },

  estimateSize: _kitchenTicketEstimateSize,
  serialize: _kitchenTicketSerialize,
  deserialize: _kitchenTicketDeserialize,
  deserializeProp: _kitchenTicketDeserializeProp,
  idName: r'id',
  indexes: {
    r'checkId': IndexSchema(
      id: 2350701668606553625,
      name: r'checkId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'checkId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
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

  getId: _kitchenTicketGetId,
  getLinks: _kitchenTicketGetLinks,
  attach: _kitchenTicketAttach,
  version: '3.3.2',
);

int _kitchenTicketEstimateSize(
  KitchenTicket object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.course.length * 3;
  bytesCount += 3 + object.linesJson.length * 3;
  bytesCount += 3 + object.station.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.tableCode.length * 3;
  return bytesCount;
}

void _kitchenTicketSerialize(
  KitchenTicket object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.bumpedAt);
  writer.writeLong(offsets[1], object.checkId);
  writer.writeString(offsets[2], object.course);
  writer.writeDateTime(offsets[3], object.firedAt);
  writer.writeString(offsets[4], object.linesJson);
  writer.writeDateTime(offsets[5], object.readyAt);
  writer.writeString(offsets[6], object.station);
  writer.writeString(offsets[7], object.status);
  writer.writeString(offsets[8], object.tableCode);
  writer.writeLong(offsets[9], object.tableId);
}

KitchenTicket _kitchenTicketDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KitchenTicket();
  object.bumpedAt = reader.readDateTimeOrNull(offsets[0]);
  object.checkId = reader.readLong(offsets[1]);
  object.course = reader.readString(offsets[2]);
  object.firedAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.linesJson = reader.readString(offsets[4]);
  object.readyAt = reader.readDateTimeOrNull(offsets[5]);
  object.station = reader.readString(offsets[6]);
  object.status = reader.readString(offsets[7]);
  object.tableCode = reader.readString(offsets[8]);
  object.tableId = reader.readLong(offsets[9]);
  return object;
}

P _kitchenTicketDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _kitchenTicketGetId(KitchenTicket object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _kitchenTicketGetLinks(KitchenTicket object) {
  return [];
}

void _kitchenTicketAttach(
  IsarCollection<dynamic> col,
  Id id,
  KitchenTicket object,
) {
  object.id = id;
}

extension KitchenTicketQueryWhereSort
    on QueryBuilder<KitchenTicket, KitchenTicket, QWhere> {
  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhere> anyCheckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'checkId'),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhere> anyTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tableId'),
      );
    });
  }
}

extension KitchenTicketQueryWhere
    on QueryBuilder<KitchenTicket, KitchenTicket, QWhereClause> {
  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> idBetween(
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> checkIdEqualTo(
    int checkId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'checkId', value: [checkId]),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause>
  checkIdNotEqualTo(int checkId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'checkId',
                lower: [],
                upper: [checkId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'checkId',
                lower: [checkId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'checkId',
                lower: [checkId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'checkId',
                lower: [],
                upper: [checkId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause>
  checkIdGreaterThan(int checkId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'checkId',
          lower: [checkId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> checkIdLessThan(
    int checkId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'checkId',
          lower: [],
          upper: [checkId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> checkIdBetween(
    int lowerCheckId,
    int upperCheckId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'checkId',
          lower: [lowerCheckId],
          includeLower: includeLower,
          upper: [upperCheckId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> tableIdEqualTo(
    int tableId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'tableId', value: [tableId]),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> tableIdLessThan(
    int tableId, {
    bool include = false,
  }) {
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> tableIdBetween(
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause> statusEqualTo(
    String status,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterWhereClause>
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

extension KitchenTicketQueryFilter
    on QueryBuilder<KitchenTicket, KitchenTicket, QFilterCondition> {
  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  bumpedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bumpedAt'),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  bumpedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bumpedAt'),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  bumpedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bumpedAt', value: value),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  bumpedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bumpedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  bumpedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bumpedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  bumpedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bumpedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  checkIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkId', value: value),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  checkIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'checkId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  checkIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'checkId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  checkIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'checkId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'course',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'course',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'course',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'course',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'course',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'course',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'course',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'course',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'course', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  courseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'course', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  firedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'firedAt', value: value),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  firedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'firedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  firedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'firedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  firedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'firedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition> idBetween(
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  linesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  linesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'linesJson', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  readyAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'readyAt'),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  readyAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'readyAt'),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  readyAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'readyAt', value: value),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  readyAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'readyAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  readyAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'readyAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  readyAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'readyAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'station',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'station',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'station',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'station',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'station',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'station',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'station',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'station',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'station', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  stationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'station', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  tableCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tableCode', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  tableCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tableCode', value: ''),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
  tableIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tableId', value: value),
      );
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterFilterCondition>
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
}

extension KitchenTicketQueryObject
    on QueryBuilder<KitchenTicket, KitchenTicket, QFilterCondition> {}

extension KitchenTicketQueryLinks
    on QueryBuilder<KitchenTicket, KitchenTicket, QFilterCondition> {}

extension KitchenTicketQuerySortBy
    on QueryBuilder<KitchenTicket, KitchenTicket, QSortBy> {
  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByBumpedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bumpedAt', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy>
  sortByBumpedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bumpedAt', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByCheckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkId', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByCheckIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkId', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByCourse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'course', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByCourseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'course', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByFiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy>
  sortByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByReadyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readyAt', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByReadyAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readyAt', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByStation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'station', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByStationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'station', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByTableCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableCode', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy>
  sortByTableCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableCode', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> sortByTableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.desc);
    });
  }
}

extension KitchenTicketQuerySortThenBy
    on QueryBuilder<KitchenTicket, KitchenTicket, QSortThenBy> {
  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByBumpedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bumpedAt', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy>
  thenByBumpedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bumpedAt', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByCheckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkId', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByCheckIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkId', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByCourse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'course', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByCourseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'course', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByFiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByLinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy>
  thenByLinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linesJson', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByReadyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readyAt', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByReadyAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readyAt', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByStation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'station', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByStationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'station', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByTableCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableCode', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy>
  thenByTableCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableCode', Sort.desc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.asc);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QAfterSortBy> thenByTableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.desc);
    });
  }
}

extension KitchenTicketQueryWhereDistinct
    on QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> {
  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByBumpedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bumpedAt');
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByCheckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkId');
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByCourse({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'course', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firedAt');
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByLinesJson({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linesJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByReadyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readyAt');
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByStation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'station', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByTableCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tableCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KitchenTicket, KitchenTicket, QDistinct> distinctByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tableId');
    });
  }
}

extension KitchenTicketQueryProperty
    on QueryBuilder<KitchenTicket, KitchenTicket, QQueryProperty> {
  QueryBuilder<KitchenTicket, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KitchenTicket, DateTime?, QQueryOperations> bumpedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bumpedAt');
    });
  }

  QueryBuilder<KitchenTicket, int, QQueryOperations> checkIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkId');
    });
  }

  QueryBuilder<KitchenTicket, String, QQueryOperations> courseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'course');
    });
  }

  QueryBuilder<KitchenTicket, DateTime, QQueryOperations> firedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firedAt');
    });
  }

  QueryBuilder<KitchenTicket, String, QQueryOperations> linesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linesJson');
    });
  }

  QueryBuilder<KitchenTicket, DateTime?, QQueryOperations> readyAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readyAt');
    });
  }

  QueryBuilder<KitchenTicket, String, QQueryOperations> stationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'station');
    });
  }

  QueryBuilder<KitchenTicket, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<KitchenTicket, String, QQueryOperations> tableCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tableCode');
    });
  }

  QueryBuilder<KitchenTicket, int, QQueryOperations> tableIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tableId');
    });
  }
}
