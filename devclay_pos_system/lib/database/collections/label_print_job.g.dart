// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_print_job.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLabelPrintJobCollection on Isar {
  IsarCollection<LabelPrintJob> get labelPrintJobs => this.collection();
}

const LabelPrintJobSchema = CollectionSchema(
  name: r'LabelPrintJob',
  id: 8037538970744025097,
  properties: {
    r'itemsSummary': PropertySchema(
      id: 0,
      name: r'itemsSummary',
      type: IsarType.string,
    ),
    r'labelCount': PropertySchema(
      id: 1,
      name: r'labelCount',
      type: IsarType.long,
    ),
    r'note': PropertySchema(id: 2, name: r'note', type: IsarType.string),
    r'payloadFormat': PropertySchema(
      id: 3,
      name: r'payloadFormat',
      type: IsarType.string,
    ),
    r'printedAt': PropertySchema(
      id: 4,
      name: r'printedAt',
      type: IsarType.dateTime,
    ),
    r'productCount': PropertySchema(
      id: 5,
      name: r'productCount',
      type: IsarType.long,
    ),
    r'status': PropertySchema(id: 6, name: r'status', type: IsarType.string),
    r'storeType': PropertySchema(
      id: 7,
      name: r'storeType',
      type: IsarType.string,
    ),
    r'templateName': PropertySchema(
      id: 8,
      name: r'templateName',
      type: IsarType.string,
    ),
  },

  estimateSize: _labelPrintJobEstimateSize,
  serialize: _labelPrintJobSerialize,
  deserialize: _labelPrintJobDeserialize,
  deserializeProp: _labelPrintJobDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _labelPrintJobGetId,
  getLinks: _labelPrintJobGetLinks,
  attach: _labelPrintJobAttach,
  version: '3.3.2',
);

int _labelPrintJobEstimateSize(
  LabelPrintJob object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.itemsSummary.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.payloadFormat.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.storeType.length * 3;
  bytesCount += 3 + object.templateName.length * 3;
  return bytesCount;
}

void _labelPrintJobSerialize(
  LabelPrintJob object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.itemsSummary);
  writer.writeLong(offsets[1], object.labelCount);
  writer.writeString(offsets[2], object.note);
  writer.writeString(offsets[3], object.payloadFormat);
  writer.writeDateTime(offsets[4], object.printedAt);
  writer.writeLong(offsets[5], object.productCount);
  writer.writeString(offsets[6], object.status);
  writer.writeString(offsets[7], object.storeType);
  writer.writeString(offsets[8], object.templateName);
}

LabelPrintJob _labelPrintJobDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LabelPrintJob();
  object.id = id;
  object.itemsSummary = reader.readString(offsets[0]);
  object.labelCount = reader.readLong(offsets[1]);
  object.note = reader.readStringOrNull(offsets[2]);
  object.payloadFormat = reader.readString(offsets[3]);
  object.printedAt = reader.readDateTime(offsets[4]);
  object.productCount = reader.readLong(offsets[5]);
  object.status = reader.readString(offsets[6]);
  object.storeType = reader.readString(offsets[7]);
  object.templateName = reader.readString(offsets[8]);
  return object;
}

P _labelPrintJobDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _labelPrintJobGetId(LabelPrintJob object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _labelPrintJobGetLinks(LabelPrintJob object) {
  return [];
}

void _labelPrintJobAttach(
  IsarCollection<dynamic> col,
  Id id,
  LabelPrintJob object,
) {
  object.id = id;
}

extension LabelPrintJobQueryWhereSort
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QWhere> {
  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LabelPrintJobQueryWhere
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QWhereClause> {
  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterWhereClause> idBetween(
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

extension LabelPrintJobQueryFilter
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QFilterCondition> {
  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'itemsSummary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemsSummary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemsSummary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemsSummary',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'itemsSummary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'itemsSummary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'itemsSummary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'itemsSummary',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemsSummary', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  itemsSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'itemsSummary', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  labelCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'labelCount', value: value),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  labelCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'labelCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  labelCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'labelCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  labelCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'labelCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition> noteEqualTo(
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  noteLessThan(
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  noteEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  noteContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition> noteMatches(
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  payloadFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'payloadFormat', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  payloadFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'payloadFormat', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  printedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'printedAt', value: value),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  printedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'printedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  printedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'printedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  printedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'printedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  productCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'productCount', value: value),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  productCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'productCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  productCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'productCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  productCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'productCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
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

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  storeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'storeType', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  storeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'storeType', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'templateName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'templateName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'templateName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'templateName', value: ''),
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterFilterCondition>
  templateNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'templateName', value: ''),
      );
    });
  }
}

extension LabelPrintJobQueryObject
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QFilterCondition> {}

extension LabelPrintJobQueryLinks
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QFilterCondition> {}

extension LabelPrintJobQuerySortBy
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QSortBy> {
  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByItemsSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsSummary', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByItemsSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsSummary', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> sortByLabelCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelCount', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByLabelCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelCount', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByPayloadFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadFormat', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByPayloadFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadFormat', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> sortByPrintedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printedAt', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByPrintedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printedAt', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByProductCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productCount', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByProductCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productCount', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> sortByStoreType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeType', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByStoreTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeType', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByTemplateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  sortByTemplateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.desc);
    });
  }
}

extension LabelPrintJobQuerySortThenBy
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QSortThenBy> {
  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByItemsSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsSummary', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByItemsSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsSummary', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenByLabelCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelCount', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByLabelCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelCount', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByPayloadFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadFormat', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByPayloadFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadFormat', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenByPrintedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printedAt', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByPrintedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printedAt', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByProductCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productCount', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByProductCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productCount', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy> thenByStoreType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeType', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByStoreTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeType', Sort.desc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByTemplateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.asc);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QAfterSortBy>
  thenByTemplateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.desc);
    });
  }
}

extension LabelPrintJobQueryWhereDistinct
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct> {
  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct> distinctByItemsSummary({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemsSummary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct> distinctByLabelCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'labelCount');
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct> distinctByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct>
  distinctByPayloadFormat({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'payloadFormat',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct> distinctByPrintedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'printedAt');
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct>
  distinctByProductCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productCount');
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct> distinctByStoreType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'storeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelPrintJob, LabelPrintJob, QDistinct> distinctByTemplateName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'templateName', caseSensitive: caseSensitive);
    });
  }
}

extension LabelPrintJobQueryProperty
    on QueryBuilder<LabelPrintJob, LabelPrintJob, QQueryProperty> {
  QueryBuilder<LabelPrintJob, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LabelPrintJob, String, QQueryOperations> itemsSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemsSummary');
    });
  }

  QueryBuilder<LabelPrintJob, int, QQueryOperations> labelCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'labelCount');
    });
  }

  QueryBuilder<LabelPrintJob, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<LabelPrintJob, String, QQueryOperations>
  payloadFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadFormat');
    });
  }

  QueryBuilder<LabelPrintJob, DateTime, QQueryOperations> printedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'printedAt');
    });
  }

  QueryBuilder<LabelPrintJob, int, QQueryOperations> productCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productCount');
    });
  }

  QueryBuilder<LabelPrintJob, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<LabelPrintJob, String, QQueryOperations> storeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'storeType');
    });
  }

  QueryBuilder<LabelPrintJob, String, QQueryOperations> templateNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'templateName');
    });
  }
}
