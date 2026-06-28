// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'z_reading_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetZReadingEntityCollection on Isar {
  IsarCollection<ZReadingEntity> get zReadingEntitys => this.collection();
}

const ZReadingEntitySchema = CollectionSchema(
  name: r'ZReadingEntity',
  id: -5689194227517132445,
  properties: {
    r'firstInvoiceId': PropertySchema(
      id: 0,
      name: r'firstInvoiceId',
      type: IsarType.long,
    ),
    r'grossSales': PropertySchema(
      id: 1,
      name: r'grossSales',
      type: IsarType.double,
    ),
    r'isSynced': PropertySchema(
      id: 2,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastInvoiceId': PropertySchema(
      id: 3,
      name: r'lastInvoiceId',
      type: IsarType.long,
    ),
    r'netSales': PropertySchema(
      id: 4,
      name: r'netSales',
      type: IsarType.double,
    ),
    r'readingDate': PropertySchema(
      id: 5,
      name: r'readingDate',
      type: IsarType.dateTime,
    ),
    r'resetCounter': PropertySchema(
      id: 6,
      name: r'resetCounter',
      type: IsarType.long,
    ),
    r'totalDiscounts': PropertySchema(
      id: 7,
      name: r'totalDiscounts',
      type: IsarType.double,
    ),
    r'totalTransactionCount': PropertySchema(
      id: 8,
      name: r'totalTransactionCount',
      type: IsarType.long,
    ),
    r'vatAmount': PropertySchema(
      id: 9,
      name: r'vatAmount',
      type: IsarType.double,
    )
  },
  estimateSize: _zReadingEntityEstimateSize,
  serialize: _zReadingEntitySerialize,
  deserialize: _zReadingEntityDeserialize,
  deserializeProp: _zReadingEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _zReadingEntityGetId,
  getLinks: _zReadingEntityGetLinks,
  attach: _zReadingEntityAttach,
  version: '3.1.0+1',
);

int _zReadingEntityEstimateSize(
  ZReadingEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _zReadingEntitySerialize(
  ZReadingEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.firstInvoiceId);
  writer.writeDouble(offsets[1], object.grossSales);
  writer.writeBool(offsets[2], object.isSynced);
  writer.writeLong(offsets[3], object.lastInvoiceId);
  writer.writeDouble(offsets[4], object.netSales);
  writer.writeDateTime(offsets[5], object.readingDate);
  writer.writeLong(offsets[6], object.resetCounter);
  writer.writeDouble(offsets[7], object.totalDiscounts);
  writer.writeLong(offsets[8], object.totalTransactionCount);
  writer.writeDouble(offsets[9], object.vatAmount);
}

ZReadingEntity _zReadingEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ZReadingEntity();
  object.firstInvoiceId = reader.readLong(offsets[0]);
  object.grossSales = reader.readDouble(offsets[1]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[2]);
  object.lastInvoiceId = reader.readLong(offsets[3]);
  object.netSales = reader.readDouble(offsets[4]);
  object.readingDate = reader.readDateTime(offsets[5]);
  object.resetCounter = reader.readLong(offsets[6]);
  object.totalDiscounts = reader.readDouble(offsets[7]);
  object.totalTransactionCount = reader.readLong(offsets[8]);
  object.vatAmount = reader.readDouble(offsets[9]);
  return object;
}

P _zReadingEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _zReadingEntityGetId(ZReadingEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _zReadingEntityGetLinks(ZReadingEntity object) {
  return [];
}

void _zReadingEntityAttach(
    IsarCollection<dynamic> col, Id id, ZReadingEntity object) {
  object.id = id;
}

extension ZReadingEntityQueryWhereSort
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QWhere> {
  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ZReadingEntityQueryWhere
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QWhereClause> {
  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterWhereClause> idBetween(
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

extension ZReadingEntityQueryFilter
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QFilterCondition> {
  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      firstInvoiceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstInvoiceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      firstInvoiceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstInvoiceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      firstInvoiceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstInvoiceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      firstInvoiceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstInvoiceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      grossSalesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grossSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      grossSalesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grossSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      grossSalesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grossSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      grossSalesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grossSales',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
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

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
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

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      lastInvoiceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastInvoiceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      lastInvoiceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastInvoiceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      lastInvoiceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastInvoiceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      lastInvoiceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastInvoiceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      netSalesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'netSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      netSalesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'netSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      netSalesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'netSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      netSalesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'netSales',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      readingDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      readingDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      readingDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      readingDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      resetCounterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resetCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      resetCounterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resetCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      resetCounterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resetCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      resetCounterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resetCounter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      totalDiscountsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDiscounts',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      totalDiscountsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDiscounts',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      totalDiscountsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDiscounts',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      totalDiscountsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDiscounts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      totalTransactionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTransactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      totalTransactionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTransactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      totalTransactionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTransactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      totalTransactionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTransactionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      vatAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vatAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      vatAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vatAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      vatAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vatAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterFilterCondition>
      vatAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vatAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ZReadingEntityQueryObject
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QFilterCondition> {}

extension ZReadingEntityQueryLinks
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QFilterCondition> {}

extension ZReadingEntityQuerySortBy
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QSortBy> {
  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByFirstInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstInvoiceId', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByFirstInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstInvoiceId', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByGrossSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grossSales', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByGrossSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grossSales', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByLastInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInvoiceId', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByLastInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInvoiceId', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy> sortByNetSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netSales', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByNetSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netSales', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingDate', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingDate', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByResetCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetCounter', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByResetCounterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetCounter', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByTotalDiscounts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDiscounts', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByTotalDiscountsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDiscounts', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByTotalTransactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTransactionCount', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByTotalTransactionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTransactionCount', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy> sortByVatAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatAmount', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      sortByVatAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatAmount', Sort.desc);
    });
  }
}

extension ZReadingEntityQuerySortThenBy
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QSortThenBy> {
  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByFirstInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstInvoiceId', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByFirstInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstInvoiceId', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByGrossSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grossSales', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByGrossSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grossSales', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByLastInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInvoiceId', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByLastInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInvoiceId', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy> thenByNetSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netSales', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByNetSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netSales', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingDate', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingDate', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByResetCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetCounter', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByResetCounterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetCounter', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByTotalDiscounts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDiscounts', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByTotalDiscountsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDiscounts', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByTotalTransactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTransactionCount', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByTotalTransactionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTransactionCount', Sort.desc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy> thenByVatAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatAmount', Sort.asc);
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QAfterSortBy>
      thenByVatAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatAmount', Sort.desc);
    });
  }
}

extension ZReadingEntityQueryWhereDistinct
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct> {
  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct>
      distinctByFirstInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstInvoiceId');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct>
      distinctByGrossSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grossSales');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct>
      distinctByLastInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastInvoiceId');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct> distinctByNetSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'netSales');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct>
      distinctByReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingDate');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct>
      distinctByResetCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resetCounter');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct>
      distinctByTotalDiscounts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDiscounts');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct>
      distinctByTotalTransactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTransactionCount');
    });
  }

  QueryBuilder<ZReadingEntity, ZReadingEntity, QDistinct>
      distinctByVatAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vatAmount');
    });
  }
}

extension ZReadingEntityQueryProperty
    on QueryBuilder<ZReadingEntity, ZReadingEntity, QQueryProperty> {
  QueryBuilder<ZReadingEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ZReadingEntity, int, QQueryOperations> firstInvoiceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstInvoiceId');
    });
  }

  QueryBuilder<ZReadingEntity, double, QQueryOperations> grossSalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grossSales');
    });
  }

  QueryBuilder<ZReadingEntity, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ZReadingEntity, int, QQueryOperations> lastInvoiceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastInvoiceId');
    });
  }

  QueryBuilder<ZReadingEntity, double, QQueryOperations> netSalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'netSales');
    });
  }

  QueryBuilder<ZReadingEntity, DateTime, QQueryOperations>
      readingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingDate');
    });
  }

  QueryBuilder<ZReadingEntity, int, QQueryOperations> resetCounterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resetCounter');
    });
  }

  QueryBuilder<ZReadingEntity, double, QQueryOperations>
      totalDiscountsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDiscounts');
    });
  }

  QueryBuilder<ZReadingEntity, int, QQueryOperations>
      totalTransactionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTransactionCount');
    });
  }

  QueryBuilder<ZReadingEntity, double, QQueryOperations> vatAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vatAmount');
    });
  }
}
