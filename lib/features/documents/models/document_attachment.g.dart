// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_attachment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDocumentAttachmentCollection on Isar {
  IsarCollection<DocumentAttachment> get documentAttachments =>
      this.collection();
}

const DocumentAttachmentSchema = CollectionSchema(
  name: r'DocumentAttachment',
  id: 3297275349781533839,
  properties: {
    r'displayName': PropertySchema(
      id: 0,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'extension': PropertySchema(
      id: 1,
      name: r'extension',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 2,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'fileSizeBytes': PropertySchema(
      id: 3,
      name: r'fileSizeBytes',
      type: IsarType.long,
    ),
    r'mimeType': PropertySchema(
      id: 4,
      name: r'mimeType',
      type: IsarType.string,
    ),
    r'originalFileName': PropertySchema(
      id: 5,
      name: r'originalFileName',
      type: IsarType.string,
    ),
    r'ownerId': PropertySchema(
      id: 6,
      name: r'ownerId',
      type: IsarType.long,
    ),
    r'ownerType': PropertySchema(
      id: 7,
      name: r'ownerType',
      type: IsarType.byte,
      enumMap: _DocumentAttachmentownerTypeEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uploadedAt': PropertySchema(
      id: 9,
      name: r'uploadedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _documentAttachmentEstimateSize,
  serialize: _documentAttachmentSerialize,
  deserialize: _documentAttachmentDeserialize,
  deserializeProp: _documentAttachmentDeserializeProp,
  idName: r'id',
  indexes: {
    r'ownerType': IndexSchema(
      id: -6578611696362250502,
      name: r'ownerType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ownerType',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'ownerId': IndexSchema(
      id: -7594796109721319539,
      name: r'ownerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ownerId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'displayName': IndexSchema(
      id: -825365117524145674,
      name: r'displayName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'displayName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'uploadedAt': IndexSchema(
      id: -7684458188835683807,
      name: r'uploadedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uploadedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _documentAttachmentGetId,
  getLinks: _documentAttachmentGetLinks,
  attach: _documentAttachmentAttach,
  version: '3.1.0+1',
);

int _documentAttachmentEstimateSize(
  DocumentAttachment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  {
    final value = object.extension;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.filePath.length * 3;
  {
    final value = object.mimeType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.originalFileName.length * 3;
  return bytesCount;
}

void _documentAttachmentSerialize(
  DocumentAttachment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.displayName);
  writer.writeString(offsets[1], object.extension);
  writer.writeString(offsets[2], object.filePath);
  writer.writeLong(offsets[3], object.fileSizeBytes);
  writer.writeString(offsets[4], object.mimeType);
  writer.writeString(offsets[5], object.originalFileName);
  writer.writeLong(offsets[6], object.ownerId);
  writer.writeByte(offsets[7], object.ownerType.index);
  writer.writeDateTime(offsets[8], object.updatedAt);
  writer.writeDateTime(offsets[9], object.uploadedAt);
}

DocumentAttachment _documentAttachmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DocumentAttachment();
  object.displayName = reader.readString(offsets[0]);
  object.extension = reader.readStringOrNull(offsets[1]);
  object.filePath = reader.readString(offsets[2]);
  object.fileSizeBytes = reader.readLong(offsets[3]);
  object.id = id;
  object.mimeType = reader.readStringOrNull(offsets[4]);
  object.originalFileName = reader.readString(offsets[5]);
  object.ownerId = reader.readLong(offsets[6]);
  object.ownerType = _DocumentAttachmentownerTypeValueEnumMap[
          reader.readByteOrNull(offsets[7])] ??
      AttachmentOwnerType.business;
  object.updatedAt = reader.readDateTime(offsets[8]);
  object.uploadedAt = reader.readDateTime(offsets[9]);
  return object;
}

P _documentAttachmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (_DocumentAttachmentownerTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          AttachmentOwnerType.business) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DocumentAttachmentownerTypeEnumValueMap = {
  'business': 0,
  'transaction': 1,
};
const _DocumentAttachmentownerTypeValueEnumMap = {
  0: AttachmentOwnerType.business,
  1: AttachmentOwnerType.transaction,
};

Id _documentAttachmentGetId(DocumentAttachment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _documentAttachmentGetLinks(
    DocumentAttachment object) {
  return [];
}

void _documentAttachmentAttach(
    IsarCollection<dynamic> col, Id id, DocumentAttachment object) {
  object.id = id;
}

extension DocumentAttachmentQueryWhereSort
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QWhere> {
  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhere>
      anyOwnerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'ownerType'),
      );
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhere>
      anyOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'ownerId'),
      );
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhere>
      anyUploadedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'uploadedAt'),
      );
    });
  }
}

extension DocumentAttachmentQueryWhere
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QWhereClause> {
  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
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

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerTypeEqualTo(AttachmentOwnerType ownerType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ownerType',
        value: [ownerType],
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerTypeNotEqualTo(AttachmentOwnerType ownerType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType',
              lower: [],
              upper: [ownerType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType',
              lower: [ownerType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType',
              lower: [ownerType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType',
              lower: [],
              upper: [ownerType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerTypeGreaterThan(
    AttachmentOwnerType ownerType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerType',
        lower: [ownerType],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerTypeLessThan(
    AttachmentOwnerType ownerType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerType',
        lower: [],
        upper: [ownerType],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerTypeBetween(
    AttachmentOwnerType lowerOwnerType,
    AttachmentOwnerType upperOwnerType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerType',
        lower: [lowerOwnerType],
        includeLower: includeLower,
        upper: [upperOwnerType],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerIdEqualTo(int ownerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ownerId',
        value: [ownerId],
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerIdNotEqualTo(int ownerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerId',
              lower: [],
              upper: [ownerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerId',
              lower: [ownerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerId',
              lower: [ownerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerId',
              lower: [],
              upper: [ownerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerIdGreaterThan(
    int ownerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerId',
        lower: [ownerId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerIdLessThan(
    int ownerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerId',
        lower: [],
        upper: [ownerId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      ownerIdBetween(
    int lowerOwnerId,
    int upperOwnerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerId',
        lower: [lowerOwnerId],
        includeLower: includeLower,
        upper: [upperOwnerId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      displayNameEqualTo(String displayName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'displayName',
        value: [displayName],
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      displayNameNotEqualTo(String displayName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayName',
              lower: [],
              upper: [displayName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayName',
              lower: [displayName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayName',
              lower: [displayName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayName',
              lower: [],
              upper: [displayName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      uploadedAtEqualTo(DateTime uploadedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uploadedAt',
        value: [uploadedAt],
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      uploadedAtNotEqualTo(DateTime uploadedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uploadedAt',
              lower: [],
              upper: [uploadedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uploadedAt',
              lower: [uploadedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uploadedAt',
              lower: [uploadedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uploadedAt',
              lower: [],
              upper: [uploadedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      uploadedAtGreaterThan(
    DateTime uploadedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'uploadedAt',
        lower: [uploadedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      uploadedAtLessThan(
    DateTime uploadedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'uploadedAt',
        lower: [],
        upper: [uploadedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterWhereClause>
      uploadedAtBetween(
    DateTime lowerUploadedAt,
    DateTime upperUploadedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'uploadedAt',
        lower: [lowerUploadedAt],
        includeLower: includeLower,
        upper: [upperUploadedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DocumentAttachmentQueryFilter
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QFilterCondition> {
  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extension',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extension',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extension',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extension',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extension',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      extensionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extension',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      fileSizeBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      fileSizeBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      fileSizeBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      fileSizeBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileSizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
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

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
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

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
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

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mimeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mimeType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      mimeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalFileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalFileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalFileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalFileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalFileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalFileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalFileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalFileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalFileName',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      originalFileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalFileName',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      ownerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerId',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      ownerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerId',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      ownerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerId',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      ownerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      ownerTypeEqualTo(AttachmentOwnerType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerType',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      ownerTypeGreaterThan(
    AttachmentOwnerType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerType',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      ownerTypeLessThan(
    AttachmentOwnerType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerType',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      ownerTypeBetween(
    AttachmentOwnerType lower,
    AttachmentOwnerType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
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

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      uploadedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uploadedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      uploadedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uploadedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      uploadedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uploadedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterFilterCondition>
      uploadedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uploadedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DocumentAttachmentQueryObject
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QFilterCondition> {}

extension DocumentAttachmentQueryLinks
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QFilterCondition> {}

extension DocumentAttachmentQuerySortBy
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QSortBy> {
  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByExtensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByFileSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileSizeBytes', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByFileSizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileSizeBytes', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByOriginalFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalFileName', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByOriginalFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalFileName', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByOwnerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerType', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByOwnerTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerType', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByUploadedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadedAt', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      sortByUploadedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadedAt', Sort.desc);
    });
  }
}

extension DocumentAttachmentQuerySortThenBy
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QSortThenBy> {
  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByExtensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByFileSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileSizeBytes', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByFileSizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileSizeBytes', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByOriginalFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalFileName', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByOriginalFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalFileName', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByOwnerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerType', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByOwnerTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerType', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByUploadedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadedAt', Sort.asc);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QAfterSortBy>
      thenByUploadedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadedAt', Sort.desc);
    });
  }
}

extension DocumentAttachmentQueryWhereDistinct
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct> {
  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByExtension({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extension', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByFileSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileSizeBytes');
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByMimeType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mimeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByOriginalFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalFileName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerId');
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByOwnerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerType');
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<DocumentAttachment, DocumentAttachment, QDistinct>
      distinctByUploadedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uploadedAt');
    });
  }
}

extension DocumentAttachmentQueryProperty
    on QueryBuilder<DocumentAttachment, DocumentAttachment, QQueryProperty> {
  QueryBuilder<DocumentAttachment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DocumentAttachment, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<DocumentAttachment, String?, QQueryOperations>
      extensionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extension');
    });
  }

  QueryBuilder<DocumentAttachment, String, QQueryOperations>
      filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<DocumentAttachment, int, QQueryOperations>
      fileSizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileSizeBytes');
    });
  }

  QueryBuilder<DocumentAttachment, String?, QQueryOperations>
      mimeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mimeType');
    });
  }

  QueryBuilder<DocumentAttachment, String, QQueryOperations>
      originalFileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalFileName');
    });
  }

  QueryBuilder<DocumentAttachment, int, QQueryOperations> ownerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerId');
    });
  }

  QueryBuilder<DocumentAttachment, AttachmentOwnerType, QQueryOperations>
      ownerTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerType');
    });
  }

  QueryBuilder<DocumentAttachment, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<DocumentAttachment, DateTime, QQueryOperations>
      uploadedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uploadedAt');
    });
  }
}
