// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAuthSessionCollection on Isar {
  IsarCollection<AuthSession> get authSessions => this.collection();
}

const AuthSessionSchema = CollectionSchema(
  name: r'AuthSession',
  id: 7043438331616121534,
  properties: {
    r'key': PropertySchema(id: 0, name: r'key', type: IsarType.string),
    r'loggedInAt': PropertySchema(
      id: 1,
      name: r'loggedInAt',
      type: IsarType.dateTime,
    ),
    r'rememberMe': PropertySchema(
      id: 2,
      name: r'rememberMe',
      type: IsarType.bool,
    ),
    r'storeId': PropertySchema(id: 3, name: r'storeId', type: IsarType.long),
    r'userId': PropertySchema(id: 4, name: r'userId', type: IsarType.long),
  },

  estimateSize: _authSessionEstimateSize,
  serialize: _authSessionSerialize,
  deserialize: _authSessionDeserialize,
  deserializeProp: _authSessionDeserializeProp,
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

  getId: _authSessionGetId,
  getLinks: _authSessionGetLinks,
  attach: _authSessionAttach,
  version: '3.3.2',
);

int _authSessionEstimateSize(
  AuthSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _authSessionSerialize(
  AuthSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeDateTime(offsets[1], object.loggedInAt);
  writer.writeBool(offsets[2], object.rememberMe);
  writer.writeLong(offsets[3], object.storeId);
  writer.writeLong(offsets[4], object.userId);
}

AuthSession _authSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AuthSession();
  object.id = id;
  object.key = reader.readString(offsets[0]);
  object.loggedInAt = reader.readDateTimeOrNull(offsets[1]);
  object.rememberMe = reader.readBool(offsets[2]);
  object.storeId = reader.readLongOrNull(offsets[3]);
  object.userId = reader.readLongOrNull(offsets[4]);
  return object;
}

P _authSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _authSessionGetId(AuthSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _authSessionGetLinks(AuthSession object) {
  return [];
}

void _authSessionAttach(
  IsarCollection<dynamic> col,
  Id id,
  AuthSession object,
) {
  object.id = id;
}

extension AuthSessionByIndex on IsarCollection<AuthSession> {
  Future<AuthSession?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  AuthSession? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<AuthSession?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<AuthSession?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(AuthSession object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(AuthSession object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<AuthSession> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<AuthSession> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension AuthSessionQueryWhereSort
    on QueryBuilder<AuthSession, AuthSession, QWhere> {
  QueryBuilder<AuthSession, AuthSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AuthSessionQueryWhere
    on QueryBuilder<AuthSession, AuthSession, QWhereClause> {
  QueryBuilder<AuthSession, AuthSession, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AuthSession, AuthSession, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterWhereClause> idBetween(
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

  QueryBuilder<AuthSession, AuthSession, QAfterWhereClause> keyEqualTo(
    String key,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'key', value: [key]),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterWhereClause> keyNotEqualTo(
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

extension AuthSessionQueryFilter
    on QueryBuilder<AuthSession, AuthSession, QFilterCondition> {
  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyEqualTo(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyGreaterThan(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyLessThan(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyBetween(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyStartsWith(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyEndsWith(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyContains(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyMatches(
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  loggedInAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'loggedInAt'),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  loggedInAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'loggedInAt'),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  loggedInAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'loggedInAt', value: value),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  loggedInAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'loggedInAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  loggedInAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'loggedInAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  loggedInAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'loggedInAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  rememberMeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rememberMe', value: value),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  storeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'storeId'),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  storeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'storeId'),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> storeIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'storeId', value: value),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  storeIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'storeId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> storeIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'storeId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> storeIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'storeId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userId'),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
  userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userId'),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> userIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: value),
      );
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition>
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> userIdLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<AuthSession, AuthSession, QAfterFilterCondition> userIdBetween(
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
}

extension AuthSessionQueryObject
    on QueryBuilder<AuthSession, AuthSession, QFilterCondition> {}

extension AuthSessionQueryLinks
    on QueryBuilder<AuthSession, AuthSession, QFilterCondition> {}

extension AuthSessionQuerySortBy
    on QueryBuilder<AuthSession, AuthSession, QSortBy> {
  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByLoggedInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedInAt', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByLoggedInAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedInAt', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByRememberMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberMe', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByRememberMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberMe', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByStoreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeId', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByStoreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeId', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension AuthSessionQuerySortThenBy
    on QueryBuilder<AuthSession, AuthSession, QSortThenBy> {
  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByLoggedInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedInAt', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByLoggedInAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedInAt', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByRememberMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberMe', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByRememberMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberMe', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByStoreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeId', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByStoreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storeId', Sort.desc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension AuthSessionQueryWhereDistinct
    on QueryBuilder<AuthSession, AuthSession, QDistinct> {
  QueryBuilder<AuthSession, AuthSession, QDistinct> distinctByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AuthSession, AuthSession, QDistinct> distinctByLoggedInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loggedInAt');
    });
  }

  QueryBuilder<AuthSession, AuthSession, QDistinct> distinctByRememberMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rememberMe');
    });
  }

  QueryBuilder<AuthSession, AuthSession, QDistinct> distinctByStoreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'storeId');
    });
  }

  QueryBuilder<AuthSession, AuthSession, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension AuthSessionQueryProperty
    on QueryBuilder<AuthSession, AuthSession, QQueryProperty> {
  QueryBuilder<AuthSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AuthSession, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<AuthSession, DateTime?, QQueryOperations> loggedInAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loggedInAt');
    });
  }

  QueryBuilder<AuthSession, bool, QQueryOperations> rememberMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rememberMe');
    });
  }

  QueryBuilder<AuthSession, int?, QQueryOperations> storeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'storeId');
    });
  }

  QueryBuilder<AuthSession, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
