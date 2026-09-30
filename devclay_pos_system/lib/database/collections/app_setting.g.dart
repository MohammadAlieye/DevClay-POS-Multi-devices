// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingCollection on Isar {
  IsarCollection<AppSetting> get appSettings => this.collection();
}

const AppSettingSchema = CollectionSchema(
  name: r'AppSetting',
  id: -948817443998796339,
  properties: {
    r'accentPreset': PropertySchema(
      id: 0,
      name: r'accentPreset',
      type: IsarType.string,
    ),
    r'autoPrintReceipt': PropertySchema(
      id: 1,
      name: r'autoPrintReceipt',
      type: IsarType.bool,
    ),
    r'businessAddress': PropertySchema(
      id: 2,
      name: r'businessAddress',
      type: IsarType.string,
    ),
    r'businessEmail': PropertySchema(
      id: 3,
      name: r'businessEmail',
      type: IsarType.string,
    ),
    r'businessName': PropertySchema(
      id: 4,
      name: r'businessName',
      type: IsarType.string,
    ),
    r'businessPhone': PropertySchema(
      id: 5,
      name: r'businessPhone',
      type: IsarType.string,
    ),
    r'cashierShiftRequired': PropertySchema(
      id: 6,
      name: r'cashierShiftRequired',
      type: IsarType.bool,
    ),
    r'defaultTaxInclusive': PropertySchema(
      id: 7,
      name: r'defaultTaxInclusive',
      type: IsarType.bool,
    ),
    r'defaultTaxRate': PropertySchema(
      id: 8,
      name: r'defaultTaxRate',
      type: IsarType.double,
    ),
    r'fbrInvoiceEnabled': PropertySchema(
      id: 9,
      name: r'fbrInvoiceEnabled',
      type: IsarType.bool,
    ),
    r'key': PropertySchema(id: 10, name: r'key', type: IsarType.string),
    r'lastBackupAt': PropertySchema(
      id: 11,
      name: r'lastBackupAt',
      type: IsarType.dateTime,
    ),
    r'lastBackupPath': PropertySchema(
      id: 12,
      name: r'lastBackupPath',
      type: IsarType.string,
    ),
    r'paperWidthMm': PropertySchema(
      id: 13,
      name: r'paperWidthMm',
      type: IsarType.long,
    ),
    r'primaryPreset': PropertySchema(
      id: 14,
      name: r'primaryPreset',
      type: IsarType.string,
    ),
    r'printerName': PropertySchema(
      id: 15,
      name: r'printerName',
      type: IsarType.string,
    ),
    r'productCategoriesCsv': PropertySchema(
      id: 16,
      name: r'productCategoriesCsv',
      type: IsarType.string,
    ),
    r'productUnitsCsv': PropertySchema(
      id: 17,
      name: r'productUnitsCsv',
      type: IsarType.string,
    ),
    r'receiptContentWidthMm': PropertySchema(
      id: 18,
      name: r'receiptContentWidthMm',
      type: IsarType.long,
    ),
    r'receiptCounterName': PropertySchema(
      id: 19,
      name: r'receiptCounterName',
      type: IsarType.string,
    ),
    r'receiptFooter': PropertySchema(
      id: 20,
      name: r'receiptFooter',
      type: IsarType.string,
    ),
    r'receiptLogoPath': PropertySchema(
      id: 21,
      name: r'receiptLogoPath',
      type: IsarType.string,
    ),
    r'receiptPrintAlign': PropertySchema(
      id: 22,
      name: r'receiptPrintAlign',
      type: IsarType.string,
    ),
    r'receiptSystemName': PropertySchema(
      id: 23,
      name: r'receiptSystemName',
      type: IsarType.string,
    ),
    r'receiptTerms': PropertySchema(
      id: 24,
      name: r'receiptTerms',
      type: IsarType.string,
    ),
    r'receiptTitle': PropertySchema(
      id: 25,
      name: r'receiptTitle',
      type: IsarType.string,
    ),
    r'seedRevision': PropertySchema(
      id: 26,
      name: r'seedRevision',
      type: IsarType.string,
    ),
    r'showBusinessInfoOnReceipt': PropertySchema(
      id: 27,
      name: r'showBusinessInfoOnReceipt',
      type: IsarType.bool,
    ),
    r'stockBaseUnitsMigrated': PropertySchema(
      id: 28,
      name: r'stockBaseUnitsMigrated',
      type: IsarType.bool,
    ),
    r'taxEnabled': PropertySchema(
      id: 29,
      name: r'taxEnabled',
      type: IsarType.bool,
    ),
    r'taxNumber': PropertySchema(
      id: 30,
      name: r'taxNumber',
      type: IsarType.string,
    ),
    r'themeMode': PropertySchema(
      id: 31,
      name: r'themeMode',
      type: IsarType.string,
    ),
  },

  estimateSize: _appSettingEstimateSize,
  serialize: _appSettingSerialize,
  deserialize: _appSettingDeserialize,
  deserializeProp: _appSettingDeserializeProp,
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

  getId: _appSettingGetId,
  getLinks: _appSettingGetLinks,
  attach: _appSettingAttach,
  version: '3.3.2',
);

int _appSettingEstimateSize(
  AppSetting object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accentPreset.length * 3;
  bytesCount += 3 + object.businessAddress.length * 3;
  bytesCount += 3 + object.businessEmail.length * 3;
  bytesCount += 3 + object.businessName.length * 3;
  bytesCount += 3 + object.businessPhone.length * 3;
  bytesCount += 3 + object.key.length * 3;
  {
    final value = object.lastBackupPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.primaryPreset.length * 3;
  bytesCount += 3 + object.printerName.length * 3;
  bytesCount += 3 + object.productCategoriesCsv.length * 3;
  bytesCount += 3 + object.productUnitsCsv.length * 3;
  bytesCount += 3 + object.receiptCounterName.length * 3;
  bytesCount += 3 + object.receiptFooter.length * 3;
  {
    final value = object.receiptLogoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.receiptPrintAlign.length * 3;
  bytesCount += 3 + object.receiptSystemName.length * 3;
  bytesCount += 3 + object.receiptTerms.length * 3;
  bytesCount += 3 + object.receiptTitle.length * 3;
  bytesCount += 3 + object.seedRevision.length * 3;
  bytesCount += 3 + object.taxNumber.length * 3;
  bytesCount += 3 + object.themeMode.length * 3;
  return bytesCount;
}

void _appSettingSerialize(
  AppSetting object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accentPreset);
  writer.writeBool(offsets[1], object.autoPrintReceipt);
  writer.writeString(offsets[2], object.businessAddress);
  writer.writeString(offsets[3], object.businessEmail);
  writer.writeString(offsets[4], object.businessName);
  writer.writeString(offsets[5], object.businessPhone);
  writer.writeBool(offsets[6], object.cashierShiftRequired);
  writer.writeBool(offsets[7], object.defaultTaxInclusive);
  writer.writeDouble(offsets[8], object.defaultTaxRate);
  writer.writeBool(offsets[9], object.fbrInvoiceEnabled);
  writer.writeString(offsets[10], object.key);
  writer.writeDateTime(offsets[11], object.lastBackupAt);
  writer.writeString(offsets[12], object.lastBackupPath);
  writer.writeLong(offsets[13], object.paperWidthMm);
  writer.writeString(offsets[14], object.primaryPreset);
  writer.writeString(offsets[15], object.printerName);
  writer.writeString(offsets[16], object.productCategoriesCsv);
  writer.writeString(offsets[17], object.productUnitsCsv);
  writer.writeLong(offsets[18], object.receiptContentWidthMm);
  writer.writeString(offsets[19], object.receiptCounterName);
  writer.writeString(offsets[20], object.receiptFooter);
  writer.writeString(offsets[21], object.receiptLogoPath);
  writer.writeString(offsets[22], object.receiptPrintAlign);
  writer.writeString(offsets[23], object.receiptSystemName);
  writer.writeString(offsets[24], object.receiptTerms);
  writer.writeString(offsets[25], object.receiptTitle);
  writer.writeString(offsets[26], object.seedRevision);
  writer.writeBool(offsets[27], object.showBusinessInfoOnReceipt);
  writer.writeBool(offsets[28], object.stockBaseUnitsMigrated);
  writer.writeBool(offsets[29], object.taxEnabled);
  writer.writeString(offsets[30], object.taxNumber);
  writer.writeString(offsets[31], object.themeMode);
}

AppSetting _appSettingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSetting();
  object.accentPreset = reader.readString(offsets[0]);
  object.autoPrintReceipt = reader.readBool(offsets[1]);
  object.businessAddress = reader.readString(offsets[2]);
  object.businessEmail = reader.readString(offsets[3]);
  object.businessName = reader.readString(offsets[4]);
  object.businessPhone = reader.readString(offsets[5]);
  object.cashierShiftRequired = reader.readBool(offsets[6]);
  object.defaultTaxInclusive = reader.readBool(offsets[7]);
  object.defaultTaxRate = reader.readDouble(offsets[8]);
  object.fbrInvoiceEnabled = reader.readBool(offsets[9]);
  object.id = id;
  object.key = reader.readString(offsets[10]);
  object.lastBackupAt = reader.readDateTimeOrNull(offsets[11]);
  object.lastBackupPath = reader.readStringOrNull(offsets[12]);
  object.paperWidthMm = reader.readLong(offsets[13]);
  object.primaryPreset = reader.readString(offsets[14]);
  object.printerName = reader.readString(offsets[15]);
  object.productCategoriesCsv = reader.readString(offsets[16]);
  object.productUnitsCsv = reader.readString(offsets[17]);
  object.receiptContentWidthMm = reader.readLong(offsets[18]);
  object.receiptCounterName = reader.readString(offsets[19]);
  object.receiptFooter = reader.readString(offsets[20]);
  object.receiptLogoPath = reader.readStringOrNull(offsets[21]);
  object.receiptPrintAlign = reader.readString(offsets[22]);
  object.receiptSystemName = reader.readString(offsets[23]);
  object.receiptTerms = reader.readString(offsets[24]);
  object.receiptTitle = reader.readString(offsets[25]);
  object.seedRevision = reader.readString(offsets[26]);
  object.showBusinessInfoOnReceipt = reader.readBool(offsets[27]);
  object.stockBaseUnitsMigrated = reader.readBool(offsets[28]);
  object.taxEnabled = reader.readBool(offsets[29]);
  object.taxNumber = reader.readString(offsets[30]);
  object.themeMode = reader.readString(offsets[31]);
  return object;
}

P _appSettingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    case 26:
      return (reader.readString(offset)) as P;
    case 27:
      return (reader.readBool(offset)) as P;
    case 28:
      return (reader.readBool(offset)) as P;
    case 29:
      return (reader.readBool(offset)) as P;
    case 30:
      return (reader.readString(offset)) as P;
    case 31:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingGetId(AppSetting object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingGetLinks(AppSetting object) {
  return [];
}

void _appSettingAttach(IsarCollection<dynamic> col, Id id, AppSetting object) {
  object.id = id;
}

extension AppSettingByIndex on IsarCollection<AppSetting> {
  Future<AppSetting?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  AppSetting? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<AppSetting?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<AppSetting?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(AppSetting object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(AppSetting object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<AppSetting> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<AppSetting> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension AppSettingQueryWhereSort
    on QueryBuilder<AppSetting, AppSetting, QWhere> {
  QueryBuilder<AppSetting, AppSetting, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingQueryWhere
    on QueryBuilder<AppSetting, AppSetting, QWhereClause> {
  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> idBetween(
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

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> keyEqualTo(
    String key,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'key', value: [key]),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> keyNotEqualTo(
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

extension AppSettingQueryFilter
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {
  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accentPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accentPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accentPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accentPreset',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accentPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accentPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accentPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accentPreset',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accentPreset', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  accentPresetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accentPreset', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  autoPrintReceiptEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoPrintReceipt', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'businessAddress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'businessAddress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'businessAddress', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'businessAddress', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'businessEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'businessEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'businessEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'businessEmail',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'businessEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'businessEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'businessEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'businessEmail',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'businessEmail', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'businessEmail', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'businessName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'businessName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'businessName', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'businessName', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'businessPhone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'businessPhone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'businessPhone', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  businessPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'businessPhone', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  cashierShiftRequiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cashierShiftRequired',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  defaultTaxInclusiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultTaxInclusive', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  defaultTaxRateEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultTaxRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  defaultTaxRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultTaxRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  defaultTaxRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultTaxRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  defaultTaxRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultTaxRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  fbrInvoiceEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fbrInvoiceEnabled', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyEqualTo(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyGreaterThan(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyLessThan(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyBetween(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyEndsWith(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyContains(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyMatches(
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

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastBackupAt'),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastBackupAt'),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastBackupAt', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastBackupAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastBackupAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastBackupAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastBackupPath'),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastBackupPath'),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastBackupPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastBackupPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastBackupPath', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  lastBackupPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastBackupPath', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  paperWidthMmEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paperWidthMm', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  paperWidthMmGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paperWidthMm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  paperWidthMmLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paperWidthMm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  paperWidthMmBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paperWidthMm',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'primaryPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'primaryPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'primaryPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'primaryPreset',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'primaryPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'primaryPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'primaryPreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'primaryPreset',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'primaryPreset', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  primaryPresetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'primaryPreset', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'printerName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'printerName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'printerName', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  printerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'printerName', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'productCategoriesCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'productCategoriesCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'productCategoriesCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'productCategoriesCsv',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'productCategoriesCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'productCategoriesCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'productCategoriesCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'productCategoriesCsv',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'productCategoriesCsv', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productCategoriesCsvIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'productCategoriesCsv',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'productUnitsCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'productUnitsCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'productUnitsCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'productUnitsCsv',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'productUnitsCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'productUnitsCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'productUnitsCsv',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'productUnitsCsv',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'productUnitsCsv', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  productUnitsCsvIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'productUnitsCsv', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptContentWidthMmEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptContentWidthMm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptContentWidthMmGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptContentWidthMm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptContentWidthMmLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptContentWidthMm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptContentWidthMmBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptContentWidthMm',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptCounterName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptCounterName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptCounterName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptCounterName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptCounterName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptCounterName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptCounterName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptCounterName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptCounterName', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptCounterNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptCounterName', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptFooter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptFooter',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptFooter', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptFooterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptFooter', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'receiptLogoPath'),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'receiptLogoPath'),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptLogoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptLogoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptLogoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptLogoPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptLogoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptLogoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptLogoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptLogoPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptLogoPath', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptLogoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptLogoPath', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptPrintAlign',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptPrintAlign',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptPrintAlign',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptPrintAlign',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptPrintAlign',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptPrintAlign',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptPrintAlign',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptPrintAlign',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptPrintAlign', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptPrintAlignIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptPrintAlign', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptSystemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptSystemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptSystemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptSystemName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptSystemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptSystemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptSystemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptSystemName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptSystemName', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptSystemNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptSystemName', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptTerms',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptTerms',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptTerms',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptTerms',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptTerms',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptTerms',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptTerms',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptTerms',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptTerms', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTermsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptTerms', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptTitle', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  receiptTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptTitle', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'seedRevision',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'seedRevision',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'seedRevision',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'seedRevision',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'seedRevision',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'seedRevision',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'seedRevision',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'seedRevision',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'seedRevision', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  seedRevisionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'seedRevision', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  showBusinessInfoOnReceiptEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'showBusinessInfoOnReceipt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  stockBaseUnitsMigratedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stockBaseUnitsMigrated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> taxEnabledEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taxEnabled', value: value),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> taxNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'taxNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  taxNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'taxNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> taxNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'taxNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> taxNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'taxNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  taxNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'taxNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> taxNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'taxNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> taxNumberContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'taxNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> taxNumberMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'taxNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  taxNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taxNumber', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  taxNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'taxNumber', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> themeModeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  themeModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> themeModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> themeModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'themeMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  themeModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> themeModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> themeModeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> themeModeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'themeMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  themeModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themeMode', value: ''),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
  themeModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'themeMode', value: ''),
      );
    });
  }
}

extension AppSettingQueryObject
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {}

extension AppSettingQueryLinks
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {}

extension AppSettingQuerySortBy
    on QueryBuilder<AppSetting, AppSetting, QSortBy> {
  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByAccentPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentPreset', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByAccentPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentPreset', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByAutoPrintReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrintReceipt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByAutoPrintReceiptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrintReceipt', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBusinessAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByBusinessAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBusinessEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessEmail', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBusinessEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessEmail', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBusinessPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPhone', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByBusinessPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPhone', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByCashierShiftRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierShiftRequired', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByCashierShiftRequiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierShiftRequired', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByDefaultTaxInclusive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTaxInclusive', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByDefaultTaxInclusiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTaxInclusive', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByDefaultTaxRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTaxRate', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByDefaultTaxRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTaxRate', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByFbrInvoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fbrInvoiceEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByFbrInvoiceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fbrInvoiceEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByLastBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupAt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByLastBackupAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupAt', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByLastBackupPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupPath', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByLastBackupPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupPath', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByPaperWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperWidthMm', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByPaperWidthMmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperWidthMm', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByPrimaryPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPreset', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByPrimaryPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPreset', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByPrinterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerName', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByPrinterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerName', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByProductCategoriesCsv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productCategoriesCsv', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByProductCategoriesCsvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productCategoriesCsv', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByProductUnitsCsv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productUnitsCsv', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByProductUnitsCsvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productUnitsCsv', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByReceiptContentWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptContentWidthMm', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByReceiptContentWidthMmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptContentWidthMm', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByReceiptCounterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptCounterName', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByReceiptCounterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptCounterName', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptFooter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptFooter', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptFooterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptFooter', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptLogoPath', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByReceiptLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptLogoPath', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptPrintAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptPrintAlign', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByReceiptPrintAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptPrintAlign', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptSystemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptSystemName', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByReceiptSystemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptSystemName', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptTerms() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptTerms', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptTermsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptTerms', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptTitle', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByReceiptTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptTitle', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortBySeedRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seedRevision', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortBySeedRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seedRevision', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByShowBusinessInfoOnReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBusinessInfoOnReceipt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByShowBusinessInfoOnReceiptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBusinessInfoOnReceipt', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByStockBaseUnitsMigrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockBaseUnitsMigrated', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  sortByStockBaseUnitsMigratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockBaseUnitsMigrated', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByTaxEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByTaxEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByTaxNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxNumber', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByTaxNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxNumber', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }
}

extension AppSettingQuerySortThenBy
    on QueryBuilder<AppSetting, AppSetting, QSortThenBy> {
  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByAccentPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentPreset', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByAccentPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentPreset', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByAutoPrintReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrintReceipt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByAutoPrintReceiptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrintReceipt', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBusinessAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByBusinessAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBusinessEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessEmail', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBusinessEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessEmail', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBusinessPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPhone', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByBusinessPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPhone', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByCashierShiftRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierShiftRequired', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByCashierShiftRequiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierShiftRequired', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByDefaultTaxInclusive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTaxInclusive', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByDefaultTaxInclusiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTaxInclusive', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByDefaultTaxRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTaxRate', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByDefaultTaxRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTaxRate', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByFbrInvoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fbrInvoiceEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByFbrInvoiceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fbrInvoiceEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByLastBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupAt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByLastBackupAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupAt', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByLastBackupPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupPath', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByLastBackupPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupPath', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByPaperWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperWidthMm', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByPaperWidthMmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperWidthMm', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByPrimaryPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPreset', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByPrimaryPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPreset', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByPrinterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerName', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByPrinterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerName', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByProductCategoriesCsv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productCategoriesCsv', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByProductCategoriesCsvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productCategoriesCsv', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByProductUnitsCsv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productUnitsCsv', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByProductUnitsCsvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productUnitsCsv', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByReceiptContentWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptContentWidthMm', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByReceiptContentWidthMmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptContentWidthMm', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByReceiptCounterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptCounterName', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByReceiptCounterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptCounterName', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptFooter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptFooter', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptFooterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptFooter', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptLogoPath', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByReceiptLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptLogoPath', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptPrintAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptPrintAlign', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByReceiptPrintAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptPrintAlign', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptSystemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptSystemName', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByReceiptSystemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptSystemName', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptTerms() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptTerms', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptTermsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptTerms', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptTitle', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByReceiptTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptTitle', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenBySeedRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seedRevision', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenBySeedRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seedRevision', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByShowBusinessInfoOnReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBusinessInfoOnReceipt', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByShowBusinessInfoOnReceiptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBusinessInfoOnReceipt', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByStockBaseUnitsMigrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockBaseUnitsMigrated', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy>
  thenByStockBaseUnitsMigratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockBaseUnitsMigrated', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByTaxEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByTaxEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByTaxNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxNumber', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByTaxNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxNumber', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }
}

extension AppSettingQueryWhereDistinct
    on QueryBuilder<AppSetting, AppSetting, QDistinct> {
  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByAccentPreset({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accentPreset', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByAutoPrintReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoPrintReceipt');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByBusinessAddress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'businessAddress',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByBusinessEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'businessEmail',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByBusinessName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByBusinessPhone({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'businessPhone',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct>
  distinctByCashierShiftRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierShiftRequired');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct>
  distinctByDefaultTaxInclusive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultTaxInclusive');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByDefaultTaxRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultTaxRate');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct>
  distinctByFbrInvoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fbrInvoiceEnabled');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByLastBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBackupAt');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByLastBackupPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastBackupPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByPaperWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paperWidthMm');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByPrimaryPreset({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'primaryPreset',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByPrinterName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'printerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct>
  distinctByProductCategoriesCsv({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'productCategoriesCsv',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByProductUnitsCsv({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'productUnitsCsv',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct>
  distinctByReceiptContentWidthMm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptContentWidthMm');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByReceiptCounterName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'receiptCounterName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByReceiptFooter({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'receiptFooter',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByReceiptLogoPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'receiptLogoPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByReceiptPrintAlign({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'receiptPrintAlign',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByReceiptSystemName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'receiptSystemName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByReceiptTerms({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptTerms', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByReceiptTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctBySeedRevision({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seedRevision', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct>
  distinctByShowBusinessInfoOnReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showBusinessInfoOnReceipt');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct>
  distinctByStockBaseUnitsMigrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stockBaseUnitsMigrated');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByTaxEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxEnabled');
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByTaxNumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByThemeMode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeMode', caseSensitive: caseSensitive);
    });
  }
}

extension AppSettingQueryProperty
    on QueryBuilder<AppSetting, AppSetting, QQueryProperty> {
  QueryBuilder<AppSetting, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> accentPresetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accentPreset');
    });
  }

  QueryBuilder<AppSetting, bool, QQueryOperations> autoPrintReceiptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoPrintReceipt');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> businessAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessAddress');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> businessEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessEmail');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> businessNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessName');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> businessPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessPhone');
    });
  }

  QueryBuilder<AppSetting, bool, QQueryOperations>
  cashierShiftRequiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierShiftRequired');
    });
  }

  QueryBuilder<AppSetting, bool, QQueryOperations>
  defaultTaxInclusiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultTaxInclusive');
    });
  }

  QueryBuilder<AppSetting, double, QQueryOperations> defaultTaxRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultTaxRate');
    });
  }

  QueryBuilder<AppSetting, bool, QQueryOperations> fbrInvoiceEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fbrInvoiceEnabled');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<AppSetting, DateTime?, QQueryOperations> lastBackupAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBackupAt');
    });
  }

  QueryBuilder<AppSetting, String?, QQueryOperations> lastBackupPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBackupPath');
    });
  }

  QueryBuilder<AppSetting, int, QQueryOperations> paperWidthMmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paperWidthMm');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> primaryPresetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryPreset');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> printerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'printerName');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations>
  productCategoriesCsvProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productCategoriesCsv');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> productUnitsCsvProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productUnitsCsv');
    });
  }

  QueryBuilder<AppSetting, int, QQueryOperations>
  receiptContentWidthMmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptContentWidthMm');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations>
  receiptCounterNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptCounterName');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> receiptFooterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptFooter');
    });
  }

  QueryBuilder<AppSetting, String?, QQueryOperations>
  receiptLogoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptLogoPath');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations>
  receiptPrintAlignProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptPrintAlign');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations>
  receiptSystemNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptSystemName');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> receiptTermsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptTerms');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> receiptTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptTitle');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> seedRevisionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seedRevision');
    });
  }

  QueryBuilder<AppSetting, bool, QQueryOperations>
  showBusinessInfoOnReceiptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showBusinessInfoOnReceipt');
    });
  }

  QueryBuilder<AppSetting, bool, QQueryOperations>
  stockBaseUnitsMigratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stockBaseUnitsMigrated');
    });
  }

  QueryBuilder<AppSetting, bool, QQueryOperations> taxEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxEnabled');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> taxNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxNumber');
    });
  }

  QueryBuilder<AppSetting, String, QQueryOperations> themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeMode');
    });
  }
}
