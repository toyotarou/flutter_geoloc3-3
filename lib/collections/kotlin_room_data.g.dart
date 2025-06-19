// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kotlin_room_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKotlinRoomDataCollection on Isar {
  IsarCollection<KotlinRoomData> get kotlinRoomDatas => this.collection();
}

const KotlinRoomDataSchema = CollectionSchema(
  name: r'KotlinRoomData',
  id: 8450506062382938485,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.string,
    ),
    r'latitude': PropertySchema(
      id: 1,
      name: r'latitude',
      type: IsarType.string,
    ),
    r'longitude': PropertySchema(
      id: 2,
      name: r'longitude',
      type: IsarType.string,
    ),
    r'ssid': PropertySchema(
      id: 3,
      name: r'ssid',
      type: IsarType.string,
    ),
    r'time': PropertySchema(
      id: 4,
      name: r'time',
      type: IsarType.string,
    )
  },
  estimateSize: _kotlinRoomDataEstimateSize,
  serialize: _kotlinRoomDataSerialize,
  deserialize: _kotlinRoomDataDeserialize,
  deserializeProp: _kotlinRoomDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _kotlinRoomDataGetId,
  getLinks: _kotlinRoomDataGetLinks,
  attach: _kotlinRoomDataAttach,
  version: '3.1.0+1',
);

int _kotlinRoomDataEstimateSize(
  KotlinRoomData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.latitude.length * 3;
  bytesCount += 3 + object.longitude.length * 3;
  bytesCount += 3 + object.ssid.length * 3;
  bytesCount += 3 + object.time.length * 3;
  return bytesCount;
}

void _kotlinRoomDataSerialize(
  KotlinRoomData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.date);
  writer.writeString(offsets[1], object.latitude);
  writer.writeString(offsets[2], object.longitude);
  writer.writeString(offsets[3], object.ssid);
  writer.writeString(offsets[4], object.time);
}

KotlinRoomData _kotlinRoomDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KotlinRoomData();
  object.date = reader.readString(offsets[0]);
  object.id = id;
  object.latitude = reader.readString(offsets[1]);
  object.longitude = reader.readString(offsets[2]);
  object.ssid = reader.readString(offsets[3]);
  object.time = reader.readString(offsets[4]);
  return object;
}

P _kotlinRoomDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _kotlinRoomDataGetId(KotlinRoomData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _kotlinRoomDataGetLinks(KotlinRoomData object) {
  return [];
}

void _kotlinRoomDataAttach(
    IsarCollection<dynamic> col, Id id, KotlinRoomData object) {
  object.id = id;
}

extension KotlinRoomDataQueryWhereSort
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QWhere> {
  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension KotlinRoomDataQueryWhere
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QWhereClause> {
  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension KotlinRoomDataQueryFilter
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QFilterCondition> {
  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'latitude',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      latitudeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'latitude',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'longitude',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      longitudeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'longitude',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ssid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ssid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ssid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ssid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ssid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ssid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ssid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ssid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ssid',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      ssidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ssid',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'time',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: '',
      ));
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterFilterCondition>
      timeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'time',
        value: '',
      ));
    });
  }
}

extension KotlinRoomDataQueryObject
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QFilterCondition> {}

extension KotlinRoomDataQueryLinks
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QFilterCondition> {}

extension KotlinRoomDataQuerySortBy
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QSortBy> {
  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> sortBySsid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ssid', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> sortBySsidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ssid', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension KotlinRoomDataQuerySortThenBy
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QSortThenBy> {
  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenBySsid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ssid', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenBySsidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ssid', Sort.desc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QAfterSortBy> thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension KotlinRoomDataQueryWhereDistinct
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QDistinct> {
  QueryBuilder<KotlinRoomData, KotlinRoomData, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QDistinct> distinctByLatitude(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QDistinct> distinctByLongitude(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QDistinct> distinctBySsid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ssid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KotlinRoomData, KotlinRoomData, QDistinct> distinctByTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time', caseSensitive: caseSensitive);
    });
  }
}

extension KotlinRoomDataQueryProperty
    on QueryBuilder<KotlinRoomData, KotlinRoomData, QQueryProperty> {
  QueryBuilder<KotlinRoomData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KotlinRoomData, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<KotlinRoomData, String, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<KotlinRoomData, String, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<KotlinRoomData, String, QQueryOperations> ssidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ssid');
    });
  }

  QueryBuilder<KotlinRoomData, String, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }
}
