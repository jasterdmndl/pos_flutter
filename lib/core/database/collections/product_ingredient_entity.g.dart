// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_ingredient_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProductIngredientEntityCollection on Isar {
  IsarCollection<ProductIngredientEntity> get productIngredientEntitys =>
      this.collection();
}

const ProductIngredientEntitySchema = CollectionSchema(
  name: r'ProductIngredientEntity',
  id: -6869938346191276816,
  properties: {
    r'amountUsed': PropertySchema(
      id: 0,
      name: r'amountUsed',
      type: IsarType.double,
    ),
    r'ingredientId': PropertySchema(
      id: 1,
      name: r'ingredientId',
      type: IsarType.long,
    ),
    r'ingredientSyncId': PropertySchema(
      id: 2,
      name: r'ingredientSyncId',
      type: IsarType.string,
    ),
    r'isDeleted': PropertySchema(
      id: 3,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'productId': PropertySchema(
      id: 4,
      name: r'productId',
      type: IsarType.long,
    ),
    r'productSyncId': PropertySchema(
      id: 5,
      name: r'productSyncId',
      type: IsarType.string,
    ),
    r'syncId': PropertySchema(
      id: 6,
      name: r'syncId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _productIngredientEntityEstimateSize,
  serialize: _productIngredientEntitySerialize,
  deserialize: _productIngredientEntityDeserialize,
  deserializeProp: _productIngredientEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'syncId': IndexSchema(
      id: 7538593479801827566,
      name: r'syncId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'syncId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _productIngredientEntityGetId,
  getLinks: _productIngredientEntityGetLinks,
  attach: _productIngredientEntityAttach,
  version: '3.1.0+1',
);

int _productIngredientEntityEstimateSize(
  ProductIngredientEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.ingredientSyncId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.productSyncId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.syncId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _productIngredientEntitySerialize(
  ProductIngredientEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountUsed);
  writer.writeLong(offsets[1], object.ingredientId);
  writer.writeString(offsets[2], object.ingredientSyncId);
  writer.writeBool(offsets[3], object.isDeleted);
  writer.writeLong(offsets[4], object.productId);
  writer.writeString(offsets[5], object.productSyncId);
  writer.writeString(offsets[6], object.syncId);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

ProductIngredientEntity _productIngredientEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProductIngredientEntity();
  object.amountUsed = reader.readDouble(offsets[0]);
  object.id = id;
  object.ingredientId = reader.readLong(offsets[1]);
  object.ingredientSyncId = reader.readStringOrNull(offsets[2]);
  object.isDeleted = reader.readBool(offsets[3]);
  object.productId = reader.readLong(offsets[4]);
  object.productSyncId = reader.readStringOrNull(offsets[5]);
  object.syncId = reader.readStringOrNull(offsets[6]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _productIngredientEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _productIngredientEntityGetId(ProductIngredientEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _productIngredientEntityGetLinks(
    ProductIngredientEntity object) {
  return [];
}

void _productIngredientEntityAttach(
    IsarCollection<dynamic> col, Id id, ProductIngredientEntity object) {
  object.id = id;
}

extension ProductIngredientEntityByIndex
    on IsarCollection<ProductIngredientEntity> {
  Future<ProductIngredientEntity?> getBySyncId(String? syncId) {
    return getByIndex(r'syncId', [syncId]);
  }

  ProductIngredientEntity? getBySyncIdSync(String? syncId) {
    return getByIndexSync(r'syncId', [syncId]);
  }

  Future<bool> deleteBySyncId(String? syncId) {
    return deleteByIndex(r'syncId', [syncId]);
  }

  bool deleteBySyncIdSync(String? syncId) {
    return deleteByIndexSync(r'syncId', [syncId]);
  }

  Future<List<ProductIngredientEntity?>> getAllBySyncId(
      List<String?> syncIdValues) {
    final values = syncIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'syncId', values);
  }

  List<ProductIngredientEntity?> getAllBySyncIdSync(
      List<String?> syncIdValues) {
    final values = syncIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'syncId', values);
  }

  Future<int> deleteAllBySyncId(List<String?> syncIdValues) {
    final values = syncIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'syncId', values);
  }

  int deleteAllBySyncIdSync(List<String?> syncIdValues) {
    final values = syncIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'syncId', values);
  }

  Future<Id> putBySyncId(ProductIngredientEntity object) {
    return putByIndex(r'syncId', object);
  }

  Id putBySyncIdSync(ProductIngredientEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'syncId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySyncId(List<ProductIngredientEntity> objects) {
    return putAllByIndex(r'syncId', objects);
  }

  List<Id> putAllBySyncIdSync(List<ProductIngredientEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'syncId', objects, saveLinks: saveLinks);
  }
}

extension ProductIngredientEntityQueryWhereSort
    on QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QWhere> {
  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProductIngredientEntityQueryWhere on QueryBuilder<
    ProductIngredientEntity, ProductIngredientEntity, QWhereClause> {
  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> syncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'syncId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> syncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'syncId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> syncIdEqualTo(String? syncId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'syncId',
        value: [syncId],
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterWhereClause> syncIdNotEqualTo(String? syncId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncId',
              lower: [],
              upper: [syncId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncId',
              lower: [syncId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncId',
              lower: [syncId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncId',
              lower: [],
              upper: [syncId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ProductIngredientEntityQueryFilter on QueryBuilder<
    ProductIngredientEntity, ProductIngredientEntity, QFilterCondition> {
  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> amountUsedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountUsed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> amountUsedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountUsed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> amountUsedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountUsed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> amountUsedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingredientId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingredientId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingredientId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ingredientSyncId',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ingredientSyncId',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingredientSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingredientSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingredientSyncId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ingredientSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ingredientSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
          QAfterFilterCondition>
      ingredientSyncIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ingredientSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
          QAfterFilterCondition>
      ingredientSyncIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ingredientSyncId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientSyncId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> ingredientSyncIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ingredientSyncId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productSyncId',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productSyncId',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productSyncId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
          QAfterFilterCondition>
      productSyncIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productSyncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
          QAfterFilterCondition>
      productSyncIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productSyncId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productSyncId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> productSyncIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productSyncId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'syncId',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'syncId',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
          QAfterFilterCondition>
      syncIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
          QAfterFilterCondition>
      syncIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> syncIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity,
      QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProductIngredientEntityQueryObject on QueryBuilder<
    ProductIngredientEntity, ProductIngredientEntity, QFilterCondition> {}

extension ProductIngredientEntityQueryLinks on QueryBuilder<
    ProductIngredientEntity, ProductIngredientEntity, QFilterCondition> {}

extension ProductIngredientEntityQuerySortBy
    on QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QSortBy> {
  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByAmountUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUsed', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByAmountUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUsed', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByIngredientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByIngredientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByIngredientSyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientSyncId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByIngredientSyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientSyncId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByProductSyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productSyncId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByProductSyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productSyncId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ProductIngredientEntityQuerySortThenBy on QueryBuilder<
    ProductIngredientEntity, ProductIngredientEntity, QSortThenBy> {
  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByAmountUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUsed', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByAmountUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUsed', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByIngredientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByIngredientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByIngredientSyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientSyncId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByIngredientSyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientSyncId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByProductSyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productSyncId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByProductSyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productSyncId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ProductIngredientEntityQueryWhereDistinct on QueryBuilder<
    ProductIngredientEntity, ProductIngredientEntity, QDistinct> {
  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QDistinct>
      distinctByAmountUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountUsed');
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QDistinct>
      distinctByIngredientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingredientId');
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QDistinct>
      distinctByIngredientSyncId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingredientSyncId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QDistinct>
      distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QDistinct>
      distinctByProductSyncId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productSyncId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QDistinct>
      distinctBySyncId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductIngredientEntity, ProductIngredientEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ProductIngredientEntityQueryProperty on QueryBuilder<
    ProductIngredientEntity, ProductIngredientEntity, QQueryProperty> {
  QueryBuilder<ProductIngredientEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProductIngredientEntity, double, QQueryOperations>
      amountUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountUsed');
    });
  }

  QueryBuilder<ProductIngredientEntity, int, QQueryOperations>
      ingredientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingredientId');
    });
  }

  QueryBuilder<ProductIngredientEntity, String?, QQueryOperations>
      ingredientSyncIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingredientSyncId');
    });
  }

  QueryBuilder<ProductIngredientEntity, bool, QQueryOperations>
      isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<ProductIngredientEntity, int, QQueryOperations>
      productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<ProductIngredientEntity, String?, QQueryOperations>
      productSyncIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productSyncId');
    });
  }

  QueryBuilder<ProductIngredientEntity, String?, QQueryOperations>
      syncIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncId');
    });
  }

  QueryBuilder<ProductIngredientEntity, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
