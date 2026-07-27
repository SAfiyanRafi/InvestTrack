// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppNotificationCollection on Isar {
  IsarCollection<AppNotification> get appNotifications => this.collection();
}

const AppNotificationSchema = CollectionSchema(
  name: r'AppNotification',
  id: 7576332975032865864,
  properties: {
    r'actionRoute': PropertySchema(
      id: 0,
      name: r'actionRoute',
      type: IsarType.string,
    ),
    r'archived': PropertySchema(id: 1, name: r'archived', type: IsarType.bool),
    r'body': PropertySchema(id: 2, name: r'body', type: IsarType.string),
    r'category': PropertySchema(
      id: 3,
      name: r'category',
      type: IsarType.byte,
      enumMap: _AppNotificationcategoryEnumValueMap,
    ),
    r'deleted': PropertySchema(id: 4, name: r'deleted', type: IsarType.bool),
    r'isRead': PropertySchema(id: 5, name: r'isRead', type: IsarType.bool),
    r'pinned': PropertySchema(id: 6, name: r'pinned', type: IsarType.bool),
    r'relatedBusinessId': PropertySchema(
      id: 7,
      name: r'relatedBusinessId',
      type: IsarType.long,
    ),
    r'relatedDocumentId': PropertySchema(
      id: 8,
      name: r'relatedDocumentId',
      type: IsarType.long,
    ),
    r'relatedReminderId': PropertySchema(
      id: 9,
      name: r'relatedReminderId',
      type: IsarType.long,
    ),
    r'relatedTransactionId': PropertySchema(
      id: 10,
      name: r'relatedTransactionId',
      type: IsarType.long,
    ),
    r'timestamp': PropertySchema(
      id: 11,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(id: 12, name: r'title', type: IsarType.string),
    r'type': PropertySchema(
      id: 13,
      name: r'type',
      type: IsarType.byte,
      enumMap: _AppNotificationtypeEnumValueMap,
    ),
  },
  estimateSize: _appNotificationEstimateSize,
  serialize: _appNotificationSerialize,
  deserialize: _appNotificationDeserialize,
  deserializeProp: _appNotificationDeserializeProp,
  idName: r'id',
  indexes: {
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'type': IndexSchema(
      id: 5117122708147080838,
      name: r'type',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'isRead': IndexSchema(
      id: -944277114070112791,
      name: r'isRead',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isRead',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _appNotificationGetId,
  getLinks: _appNotificationGetLinks,
  attach: _appNotificationAttach,
  version: '3.1.0+1',
);

int _appNotificationEstimateSize(
  AppNotification object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actionRoute;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.body.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _appNotificationSerialize(
  AppNotification object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actionRoute);
  writer.writeBool(offsets[1], object.archived);
  writer.writeString(offsets[2], object.body);
  writer.writeByte(offsets[3], object.category.index);
  writer.writeBool(offsets[4], object.deleted);
  writer.writeBool(offsets[5], object.isRead);
  writer.writeBool(offsets[6], object.pinned);
  writer.writeLong(offsets[7], object.relatedBusinessId);
  writer.writeLong(offsets[8], object.relatedDocumentId);
  writer.writeLong(offsets[9], object.relatedReminderId);
  writer.writeLong(offsets[10], object.relatedTransactionId);
  writer.writeDateTime(offsets[11], object.timestamp);
  writer.writeString(offsets[12], object.title);
  writer.writeByte(offsets[13], object.type.index);
}

AppNotification _appNotificationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppNotification();
  object.actionRoute = reader.readStringOrNull(offsets[0]);
  object.archived = reader.readBool(offsets[1]);
  object.body = reader.readString(offsets[2]);
  object.category =
      _AppNotificationcategoryValueEnumMap[reader.readByteOrNull(offsets[3])] ??
      NotificationCategory.financial;
  object.deleted = reader.readBool(offsets[4]);
  object.id = id;
  object.isRead = reader.readBool(offsets[5]);
  object.pinned = reader.readBool(offsets[6]);
  object.relatedBusinessId = reader.readLongOrNull(offsets[7]);
  object.relatedDocumentId = reader.readLongOrNull(offsets[8]);
  object.relatedReminderId = reader.readLongOrNull(offsets[9]);
  object.relatedTransactionId = reader.readLongOrNull(offsets[10]);
  object.timestamp = reader.readDateTime(offsets[11]);
  object.title = reader.readString(offsets[12]);
  object.type =
      _AppNotificationtypeValueEnumMap[reader.readByteOrNull(offsets[13])] ??
      NotificationType.informational;
  return object;
}

P _appNotificationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_AppNotificationcategoryValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              NotificationCategory.financial)
          as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (_AppNotificationtypeValueEnumMap[reader.readByteOrNull(offset)] ??
              NotificationType.informational)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AppNotificationcategoryEnumValueMap = {
  'financial': 0,
  'business': 1,
  'reports': 2,
  'documents': 3,
  'reminder': 4,
  'system': 5,
};
const _AppNotificationcategoryValueEnumMap = {
  0: NotificationCategory.financial,
  1: NotificationCategory.business,
  2: NotificationCategory.reports,
  3: NotificationCategory.documents,
  4: NotificationCategory.reminder,
  5: NotificationCategory.system,
};
const _AppNotificationtypeEnumValueMap = {
  'informational': 0,
  'success': 1,
  'warning': 2,
  'critical': 3,
};
const _AppNotificationtypeValueEnumMap = {
  0: NotificationType.informational,
  1: NotificationType.success,
  2: NotificationType.warning,
  3: NotificationType.critical,
};

Id _appNotificationGetId(AppNotification object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appNotificationGetLinks(AppNotification object) {
  return [];
}

void _appNotificationAttach(
  IsarCollection<dynamic> col,
  Id id,
  AppNotification object,
) {
  object.id = id;
}

extension AppNotificationQueryWhereSort
    on QueryBuilder<AppNotification, AppNotification, QWhere> {
  QueryBuilder<AppNotification, AppNotification, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhere> anyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'type'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhere> anyCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'category'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhere> anyIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isRead'),
      );
    });
  }
}

extension AppNotificationQueryWhere
    on QueryBuilder<AppNotification, AppNotification, QWhereClause> {
  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
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

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause> idBetween(
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

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  titleEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'title', value: [title]),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  titleNotEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [],
                upper: [title],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [title],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [title],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [],
                upper: [title],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  timestampEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'timestamp', value: [timestamp]),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  timestampNotEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [],
                upper: [timestamp],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [timestamp],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [timestamp],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [],
                upper: [timestamp],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  timestampGreaterThan(DateTime timestamp, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [timestamp],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  timestampLessThan(DateTime timestamp, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [],
          upper: [timestamp],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [lowerTimestamp],
          includeLower: includeLower,
          upper: [upperTimestamp],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause> typeEqualTo(
    NotificationType type,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'type', value: [type]),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  typeNotEqualTo(NotificationType type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [],
                upper: [type],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [type],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [type],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [],
                upper: [type],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  typeGreaterThan(NotificationType type, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'type',
          lower: [type],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  typeLessThan(NotificationType type, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'type',
          lower: [],
          upper: [type],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause> typeBetween(
    NotificationType lowerType,
    NotificationType upperType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'type',
          lower: [lowerType],
          includeLower: includeLower,
          upper: [upperType],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  categoryEqualTo(NotificationCategory category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'category', value: [category]),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  categoryNotEqualTo(NotificationCategory category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  categoryGreaterThan(NotificationCategory category, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'category',
          lower: [category],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  categoryLessThan(NotificationCategory category, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'category',
          lower: [],
          upper: [category],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  categoryBetween(
    NotificationCategory lowerCategory,
    NotificationCategory upperCategory, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'category',
          lower: [lowerCategory],
          includeLower: includeLower,
          upper: [upperCategory],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  isReadEqualTo(bool isRead) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isRead', value: [isRead]),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterWhereClause>
  isReadNotEqualTo(bool isRead) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isRead',
                lower: [],
                upper: [isRead],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isRead',
                lower: [isRead],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isRead',
                lower: [isRead],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isRead',
                lower: [],
                upper: [isRead],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension AppNotificationQueryFilter
    on QueryBuilder<AppNotification, AppNotification, QFilterCondition> {
  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'actionRoute'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'actionRoute'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'actionRoute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'actionRoute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'actionRoute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'actionRoute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'actionRoute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'actionRoute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'actionRoute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'actionRoute',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'actionRoute', value: ''),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  actionRouteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'actionRoute', value: ''),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  archivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'archived', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'body',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'body',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'body',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'body',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'body',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'body',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'body',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'body',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'body', value: ''),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'body', value: ''),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  categoryEqualTo(NotificationCategory value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  categoryGreaterThan(NotificationCategory value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  categoryLessThan(NotificationCategory value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  categoryBetween(
    NotificationCategory lower,
    NotificationCategory upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  deletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deleted', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
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

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  isReadEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isRead', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  pinnedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pinned', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedBusinessIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'relatedBusinessId'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedBusinessIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'relatedBusinessId'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedBusinessIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'relatedBusinessId', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedBusinessIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relatedBusinessId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedBusinessIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relatedBusinessId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedBusinessIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relatedBusinessId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedDocumentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'relatedDocumentId'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedDocumentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'relatedDocumentId'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedDocumentIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'relatedDocumentId', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedDocumentIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relatedDocumentId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedDocumentIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relatedDocumentId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedDocumentIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relatedDocumentId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedReminderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'relatedReminderId'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedReminderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'relatedReminderId'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedReminderIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'relatedReminderId', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedReminderIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relatedReminderId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedReminderIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relatedReminderId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedReminderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relatedReminderId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedTransactionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'relatedTransactionId'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedTransactionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'relatedTransactionId'),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedTransactionIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'relatedTransactionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedTransactionIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relatedTransactionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedTransactionIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relatedTransactionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  relatedTransactionIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relatedTransactionId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestamp', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  timestampGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  timestampLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timestamp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  typeEqualTo(NotificationType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  typeGreaterThan(NotificationType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  typeLessThan(NotificationType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterFilterCondition>
  typeBetween(
    NotificationType lower,
    NotificationType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AppNotificationQueryObject
    on QueryBuilder<AppNotification, AppNotification, QFilterCondition> {}

extension AppNotificationQueryLinks
    on QueryBuilder<AppNotification, AppNotification, QFilterCondition> {}

extension AppNotificationQuerySortBy
    on QueryBuilder<AppNotification, AppNotification, QSortBy> {
  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByActionRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByActionRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archived', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archived', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> sortByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> sortByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRead', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByIsReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRead', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> sortByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByRelatedBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedBusinessId', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByRelatedBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedBusinessId', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByRelatedDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedDocumentId', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByRelatedDocumentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedDocumentId', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByRelatedReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedReminderId', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByRelatedReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedReminderId', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByRelatedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedTransactionId', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByRelatedTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedTransactionId', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AppNotificationQuerySortThenBy
    on QueryBuilder<AppNotification, AppNotification, QSortThenBy> {
  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByActionRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByActionRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archived', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archived', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> thenByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> thenByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRead', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByIsReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRead', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> thenByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByRelatedBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedBusinessId', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByRelatedBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedBusinessId', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByRelatedDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedDocumentId', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByRelatedDocumentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedDocumentId', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByRelatedReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedReminderId', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByRelatedReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedReminderId', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByRelatedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedTransactionId', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByRelatedTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedTransactionId', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AppNotificationQueryWhereDistinct
    on QueryBuilder<AppNotification, AppNotification, QDistinct> {
  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByActionRoute({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionRoute', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'archived');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct> distinctByBody({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleted');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct> distinctByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRead');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct> distinctByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinned');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByRelatedBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relatedBusinessId');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByRelatedDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relatedDocumentId');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByRelatedReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relatedReminderId');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByRelatedTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relatedTransactionId');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct>
  distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppNotification, AppNotification, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension AppNotificationQueryProperty
    on QueryBuilder<AppNotification, AppNotification, QQueryProperty> {
  QueryBuilder<AppNotification, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppNotification, String?, QQueryOperations>
  actionRouteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionRoute');
    });
  }

  QueryBuilder<AppNotification, bool, QQueryOperations> archivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archived');
    });
  }

  QueryBuilder<AppNotification, String, QQueryOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<AppNotification, NotificationCategory, QQueryOperations>
  categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<AppNotification, bool, QQueryOperations> deletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleted');
    });
  }

  QueryBuilder<AppNotification, bool, QQueryOperations> isReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRead');
    });
  }

  QueryBuilder<AppNotification, bool, QQueryOperations> pinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinned');
    });
  }

  QueryBuilder<AppNotification, int?, QQueryOperations>
  relatedBusinessIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relatedBusinessId');
    });
  }

  QueryBuilder<AppNotification, int?, QQueryOperations>
  relatedDocumentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relatedDocumentId');
    });
  }

  QueryBuilder<AppNotification, int?, QQueryOperations>
  relatedReminderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relatedReminderId');
    });
  }

  QueryBuilder<AppNotification, int?, QQueryOperations>
  relatedTransactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relatedTransactionId');
    });
  }

  QueryBuilder<AppNotification, DateTime, QQueryOperations>
  timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<AppNotification, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<AppNotification, NotificationType, QQueryOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
