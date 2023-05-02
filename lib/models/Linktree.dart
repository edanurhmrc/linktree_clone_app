/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Linktree type in your schema. */
@immutable
class Linktree extends Model {
  static const classType = const _LinktreeModelType();
  final String id;
  final String? _email;
  final String? _profile_photo;
  final String? _background_picture;
  final List<String>? _link;
  final Profile? _profil;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;
  final String? _linktreeProfilId;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  LinktreeModelIdentifier get modelIdentifier {
      return LinktreeModelIdentifier(
        id: id
      );
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get profile_photo {
    return _profile_photo;
  }
  
  String? get background_picture {
    return _background_picture;
  }
  
  List<String>? get link {
    return _link;
  }
  
  Profile? get profil {
    return _profil;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String? get linktreeProfilId {
    return _linktreeProfilId;
  }
  
  const Linktree._internal({required this.id, required email, profile_photo, background_picture, link, profil, createdAt, updatedAt, linktreeProfilId}): _email = email, _profile_photo = profile_photo, _background_picture = background_picture, _link = link, _profil = profil, _createdAt = createdAt, _updatedAt = updatedAt, _linktreeProfilId = linktreeProfilId;
  
  factory Linktree({String? id, required String email, String? profile_photo, String? background_picture, List<String>? link, Profile? profil, String? linktreeProfilId}) {
    return Linktree._internal(
      id: id == null ? UUID.getUUID() : id,
      email: email,
      profile_photo: profile_photo,
      background_picture: background_picture,
      link: link != null ? List<String>.unmodifiable(link) : link,
      profil: profil,
      linktreeProfilId: linktreeProfilId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Linktree &&
      id == other.id &&
      _email == other._email &&
      _profile_photo == other._profile_photo &&
      _background_picture == other._background_picture &&
      DeepCollectionEquality().equals(_link, other._link) &&
      _profil == other._profil &&
      _linktreeProfilId == other._linktreeProfilId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Linktree {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("profile_photo=" + "$_profile_photo" + ", ");
    buffer.write("background_picture=" + "$_background_picture" + ", ");
    buffer.write("link=" + (_link != null ? _link!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("linktreeProfilId=" + "$_linktreeProfilId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Linktree copyWith({String? email, String? profile_photo, String? background_picture, List<String>? link, Profile? profil, String? linktreeProfilId}) {
    return Linktree._internal(
      id: id,
      email: email ?? this.email,
      profile_photo: profile_photo ?? this.profile_photo,
      background_picture: background_picture ?? this.background_picture,
      link: link ?? this.link,
      profil: profil ?? this.profil,
      linktreeProfilId: linktreeProfilId ?? this.linktreeProfilId);
  }
  
  Linktree.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _email = json['email'],
      _profile_photo = json['profile_photo'],
      _background_picture = json['background_picture'],
      _link = json['link']?.cast<String>(),
      _profil = json['profil']?['serializedData'] != null
        ? Profile.fromJson(new Map<String, dynamic>.from(json['profil']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null,
      _linktreeProfilId = json['linktreeProfilId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'email': _email, 'profile_photo': _profile_photo, 'background_picture': _background_picture, 'link': _link, 'profil': _profil?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'linktreeProfilId': _linktreeProfilId
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'email': _email, 'profile_photo': _profile_photo, 'background_picture': _background_picture, 'link': _link, 'profil': _profil, 'createdAt': _createdAt, 'updatedAt': _updatedAt, 'linktreeProfilId': _linktreeProfilId
  };

  static final QueryModelIdentifier<LinktreeModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<LinktreeModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static final QueryField PROFILE_PHOTO = QueryField(fieldName: "profile_photo");
  static final QueryField BACKGROUND_PICTURE = QueryField(fieldName: "background_picture");
  static final QueryField LINK = QueryField(fieldName: "link");
  static final QueryField PROFIL = QueryField(
    fieldName: "profil",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: 'Profile'));
  static final QueryField LINKTREEPROFILID = QueryField(fieldName: "linktreeProfilId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Linktree";
    modelSchemaDefinition.pluralName = "Linktrees";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Linktree.EMAIL,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Linktree.PROFILE_PHOTO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Linktree.BACKGROUND_PICTURE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Linktree.LINK,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasOne(
      key: Linktree.PROFIL,
      isRequired: false,
      ofModelName: 'Profile',
      associatedKey: Profile.ID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Linktree.LINKTREEPROFILID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _LinktreeModelType extends ModelType<Linktree> {
  const _LinktreeModelType();
  
  @override
  Linktree fromJson(Map<String, dynamic> jsonData) {
    return Linktree.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Linktree';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Linktree] in your schema.
 */
@immutable
class LinktreeModelIdentifier implements ModelIdentifier<Linktree> {
  final String id;

  /** Create an instance of LinktreeModelIdentifier using [id] the primary key. */
  const LinktreeModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'LinktreeModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is LinktreeModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}