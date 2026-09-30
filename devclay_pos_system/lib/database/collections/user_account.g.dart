// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserAccountCollection on Isar {
  IsarCollection<UserAccount> get userAccounts => this.collection();
}

const UserAccountSchema = CollectionSchema(
  name: r'UserAccount',
  id: 4436833819297478104,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 1,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'displayName': PropertySchema(
      id: 2,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(id: 3, name: r'isActive', type: IsarType.bool),
    r'passwordHash': PropertySchema(
      id: 4,
      name: r'passwordHash',
      type: IsarType.string,
    ),
    r'passwordSalt': PropertySchema(
      id: 5,
      name: r'passwordSalt',
      type: IsarType.string,
    ),
    r'permissions': PropertySchema(
      id: 6,
      name: r'permissions',
      type: IsarType.stringList,
    ),
    r'role': PropertySchema(id: 7, name: r'role', type: IsarType.string),
    r'username': PropertySchema(
      id: 8,
      name: r'username',
      type: IsarType.string,
    ),
  },

  estimateSize: _userAccountEstimateSize,
  serialize: _userAccountSerialize,
  deserialize: _userAccountDeserialize,
  deserializeProp: _userAccountDeserializeProp,
  idName: r'id',
  indexes: {
    r'username': IndexSchema(
      id: -2899563114555695793,
      name: r'username',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'username',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _userAccountGetId,
  getLinks: _userAccountGetLinks,
  attach: _userAccountAttach,
  version: '3.3.2',
);

int _userAccountEstimateSize(
  UserAccount object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.passwordHash.length * 3;
  bytesCount += 3 + object.passwordSalt.length * 3;
  bytesCount += 3 + object.permissions.length * 3;
  {
    for (var i = 0; i < object.permissions.length; i++) {
      final value = object.permissions[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.role.length * 3;
  bytesCount += 3 + object.username.length * 3;
  return bytesCount;
}

void _userAccountSerialize(
  UserAccount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.deletedAt);
  writer.writeString(offsets[2], object.displayName);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeString(offsets[4], object.passwordHash);
  writer.writeString(offsets[5], object.passwordSalt);
  writer.writeStringList(offsets[6], object.permissions);
  writer.writeString(offsets[7], object.role);
  writer.writeString(offsets[8], object.username);
}

UserAccount _userAccountDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserAccount();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[1]);
  object.displayName = reader.readString(offsets[2]);
  object.id = id;
  object.isActive = reader.readBool(offsets[3]);
  object.passwordHash = reader.readString(offsets[4]);
  object.passwordSalt = reader.readString(offsets[5]);
  object.permissions = reader.readStringList(offsets[6]) ?? [];
  object.role = reader.readString(offsets[7]);
  object.username = reader.readString(offsets[8]);
  return object;
}

P _userAccountDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringList(offset) ?? []) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userAccountGetId(UserAccount object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userAccountGetLinks(UserAccount object) {
  return [];
}

void _userAccountAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserAccount object,
) {
  object.id = id;
}

extension UserAccountByIndex on IsarCollection<UserAccount> {
  Future<UserAccount?> getByUsername(String username) {
    return getByIndex(r'username', [username]);
  }

  UserAccount? getByUsernameSync(String username) {
    return getByIndexSync(r'username', [username]);
  }

  Future<bool> deleteByUsername(String username) {
    return deleteByIndex(r'username', [username]);
  }

  bool deleteByUsernameSync(String username) {
    return deleteByIndexSync(r'username', [username]);
  }

  Future<List<UserAccount?>> getAllByUsername(List<String> usernameValues) {
    final values = usernameValues.map((e) => [e]).toList();
    return getAllByIndex(r'username', values);
  }

  List<UserAccount?> getAllByUsernameSync(List<String> usernameValues) {
    final values = usernameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'username', values);
  }

  Future<int> deleteAllByUsername(List<String> usernameValues) {
    final values = usernameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'username', values);
  }

  int deleteAllByUsernameSync(List<String> usernameValues) {
    final values = usernameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'username', values);
  }

  Future<Id> putByUsername(UserAccount object) {
    return putByIndex(r'username', object);
  }

  Id putByUsernameSync(UserAccount object, {bool saveLinks = true}) {
    return putByIndexSync(r'username', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUsername(List<UserAccount> objects) {
    return putAllByIndex(r'username', objects);
  }

  List<Id> putAllByUsernameSync(
    List<UserAccount> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'username', objects, saveLinks: saveLinks);
  }
}

extension UserAccountQueryWhereSort
    on QueryBuilder<UserAccount, UserAccount, QWhere> {
  QueryBuilder<UserAccount, UserAccount, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserAccountQueryWhere
    on QueryBuilder<UserAccount, UserAccount, QWhereClause> {
  QueryBuilder<UserAccount, UserAccount, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<UserAccount, UserAccount, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterWhereClause> idBetween(
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

  QueryBuilder<UserAccount, UserAccount, QAfterWhereClause> usernameEqualTo(
    String username,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'username', value: [username]),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterWhereClause> usernameNotEqualTo(
    String username,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'username',
                lower: [],
                upper: [username],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'username',
                lower: [username],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'username',
                lower: [username],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'username',
                lower: [],
                upper: [username],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension UserAccountQueryFilter
    on QueryBuilder<UserAccount, UserAccount, QFilterCondition> {
  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deletedAt', value: value),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'displayName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> isActiveEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'passwordHash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'passwordHash',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'passwordHash', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'passwordHash', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'passwordSalt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'passwordSalt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'passwordSalt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'passwordSalt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'passwordSalt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'passwordSalt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'passwordSalt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'passwordSalt',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'passwordSalt', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  passwordSaltIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'passwordSalt', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'permissions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'permissions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'permissions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'permissions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'permissions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'permissions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'permissions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'permissions',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'permissions', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'permissions', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'permissions', length, true, length, true);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'permissions', 0, true, 0, true);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'permissions', 0, false, 999999, true);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'permissions', 0, true, length, include);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'permissions', length, include, 999999, true);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  permissionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'role',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'role',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'role',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> roleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'role', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  roleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'role', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> usernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  usernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  usernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> usernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'username',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  usernameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  usernameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  usernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition> usernameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'username',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'username', value: ''),
      );
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterFilterCondition>
  usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'username', value: ''),
      );
    });
  }
}

extension UserAccountQueryObject
    on QueryBuilder<UserAccount, UserAccount, QFilterCondition> {}

extension UserAccountQueryLinks
    on QueryBuilder<UserAccount, UserAccount, QFilterCondition> {}

extension UserAccountQuerySortBy
    on QueryBuilder<UserAccount, UserAccount, QSortBy> {
  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByPasswordHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy>
  sortByPasswordHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByPasswordSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSalt', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy>
  sortByPasswordSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSalt', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension UserAccountQuerySortThenBy
    on QueryBuilder<UserAccount, UserAccount, QSortThenBy> {
  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByPasswordHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy>
  thenByPasswordHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByPasswordSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSalt', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy>
  thenByPasswordSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSalt', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QAfterSortBy> thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension UserAccountQueryWhereDistinct
    on QueryBuilder<UserAccount, UserAccount, QDistinct> {
  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByDisplayName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByPasswordHash({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByPasswordSalt({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordSalt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByPermissions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'permissions');
    });
  }

  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByRole({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'role', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserAccount, UserAccount, QDistinct> distinctByUsername({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension UserAccountQueryProperty
    on QueryBuilder<UserAccount, UserAccount, QQueryProperty> {
  QueryBuilder<UserAccount, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserAccount, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<UserAccount, DateTime?, QQueryOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<UserAccount, String, QQueryOperations> displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<UserAccount, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<UserAccount, String, QQueryOperations> passwordHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordHash');
    });
  }

  QueryBuilder<UserAccount, String, QQueryOperations> passwordSaltProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordSalt');
    });
  }

  QueryBuilder<UserAccount, List<String>, QQueryOperations>
  permissionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'permissions');
    });
  }

  QueryBuilder<UserAccount, String, QQueryOperations> roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'role');
    });
  }

  QueryBuilder<UserAccount, String, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
