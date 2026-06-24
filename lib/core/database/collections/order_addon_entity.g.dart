// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_addon_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderAddonEntityCollection on Isar {
  IsarCollection<OrderAddonEntity> get orderAddonEntitys => this.collection();
}

const OrderAddonEntitySchema = CollectionSchema(
  name: r'OrderAddonEntity',
  id: 1571936796270703776,
  properties: {
    r'addonName': PropertySchema(
      id: 0,
      name: r'addonName',
      type: IsarType.string,
    ),
    r'orderItemId': PropertySchema(
      id: 1,
      name: r'orderItemId',
      type: IsarType.long,
    ),
    r'price': PropertySchema(
      id: 2,
      name: r'price',
      type: IsarType.double,
    ),
    r'quantity': PropertySchema(
      id: 3,
      name: r'quantity',
      type: IsarType.long,
    ),
    r'subtotal': PropertySchema(
      id: 4,
      name: r'subtotal',
      type: IsarType.double,
    )
  },
  estimateSize: _orderAddonEntityEstimateSize,
  serialize: _orderAddonEntitySerialize,
  deserialize: _orderAddonEntityDeserialize,
  deserializeProp: _orderAddonEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _orderAddonEntityGetId,
  getLinks: _orderAddonEntityGetLinks,
  attach: _orderAddonEntityAttach,
  version: '3.1.0+1',
);

int _orderAddonEntityEstimateSize(
  OrderAddonEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.addonName.length * 3;
  return bytesCount;
}

void _orderAddonEntitySerialize(
  OrderAddonEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.addonName);
  writer.writeLong(offsets[1], object.orderItemId);
  writer.writeDouble(offsets[2], object.price);
  writer.writeLong(offsets[3], object.quantity);
  writer.writeDouble(offsets[4], object.subtotal);
}

OrderAddonEntity _orderAddonEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderAddonEntity();
  object.addonName = reader.readString(offsets[0]);
  object.id = id;
  object.orderItemId = reader.readLong(offsets[1]);
  object.price = reader.readDouble(offsets[2]);
  object.quantity = reader.readLong(offsets[3]);
  object.subtotal = reader.readDouble(offsets[4]);
  return object;
}

P _orderAddonEntityDeserializeProp<P>(
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
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderAddonEntityGetId(OrderAddonEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderAddonEntityGetLinks(OrderAddonEntity object) {
  return [];
}

void _orderAddonEntityAttach(
    IsarCollection<dynamic> col, Id id, OrderAddonEntity object) {
  object.id = id;
}

extension OrderAddonEntityQueryWhereSort
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QWhere> {
  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OrderAddonEntityQueryWhere
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QWhereClause> {
  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterWhereClause> idBetween(
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

extension OrderAddonEntityQueryFilter
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QFilterCondition> {
  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addonName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'addonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'addonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'addonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'addonName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addonName',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      addonNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'addonName',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      orderItemIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      orderItemIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      orderItemIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      orderItemIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderItemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      quantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      quantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      quantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      quantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      subtotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      subtotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      subtotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterFilterCondition>
      subtotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension OrderAddonEntityQueryObject
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QFilterCondition> {}

extension OrderAddonEntityQueryLinks
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QFilterCondition> {}

extension OrderAddonEntityQuerySortBy
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QSortBy> {
  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortByAddonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addonName', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortByAddonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addonName', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortByOrderItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemId', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortByOrderItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemId', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      sortBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }
}

extension OrderAddonEntityQuerySortThenBy
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QSortThenBy> {
  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenByAddonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addonName', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenByAddonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addonName', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenByOrderItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemId', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenByOrderItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemId', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QAfterSortBy>
      thenBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }
}

extension OrderAddonEntityQueryWhereDistinct
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QDistinct> {
  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QDistinct>
      distinctByAddonName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addonName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QDistinct>
      distinctByOrderItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderItemId');
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QDistinct>
      distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QDistinct>
      distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }

  QueryBuilder<OrderAddonEntity, OrderAddonEntity, QDistinct>
      distinctBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtotal');
    });
  }
}

extension OrderAddonEntityQueryProperty
    on QueryBuilder<OrderAddonEntity, OrderAddonEntity, QQueryProperty> {
  QueryBuilder<OrderAddonEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderAddonEntity, String, QQueryOperations> addonNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addonName');
    });
  }

  QueryBuilder<OrderAddonEntity, int, QQueryOperations> orderItemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderItemId');
    });
  }

  QueryBuilder<OrderAddonEntity, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<OrderAddonEntity, int, QQueryOperations> quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }

  QueryBuilder<OrderAddonEntity, double, QQueryOperations> subtotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtotal');
    });
  }
}
