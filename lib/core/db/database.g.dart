// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMaleMeta = const VerificationMeta('isMale');
  @override
  late final GeneratedColumn<bool> isMale = GeneratedColumn<bool>(
    'is_male',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_male" IN (0, 1))',
    ),
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentWeightKgMeta = const VerificationMeta(
    'currentWeightKg',
  );
  @override
  late final GeneratedColumn<double> currentWeightKg = GeneratedColumn<double>(
    'current_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manualKcalTargetMeta = const VerificationMeta(
    'manualKcalTarget',
  );
  @override
  late final GeneratedColumn<int> manualKcalTarget = GeneratedColumn<int>(
    'manual_kcal_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    birthDate,
    isMale,
    heightCm,
    currentWeightKg,
    goal,
    activityLevel,
    manualKcalTarget,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('is_male')) {
      context.handle(
        _isMaleMeta,
        isMale.isAcceptableOrUnknown(data['is_male']!, _isMaleMeta),
      );
    } else if (isInserting) {
      context.missing(_isMaleMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('current_weight_kg')) {
      context.handle(
        _currentWeightKgMeta,
        currentWeightKg.isAcceptableOrUnknown(
          data['current_weight_kg']!,
          _currentWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentWeightKgMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityLevelMeta);
    }
    if (data.containsKey('manual_kcal_target')) {
      context.handle(
        _manualKcalTargetMeta,
        manualKcalTarget.isAcceptableOrUnknown(
          data['manual_kcal_target']!,
          _manualKcalTargetMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      isMale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_male'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_cm'],
      )!,
      currentWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_weight_kg'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      )!,
      manualKcalTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manual_kcal_target'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final bool isMale;
  final int heightCm;
  final double currentWeightKg;
  final String goal;
  final String activityLevel;
  final int? manualKcalTarget;
  final DateTime createdAt;
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.isMale,
    required this.heightCm,
    required this.currentWeightKg,
    required this.goal,
    required this.activityLevel,
    this.manualKcalTarget,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['is_male'] = Variable<bool>(isMale);
    map['height_cm'] = Variable<int>(heightCm);
    map['current_weight_kg'] = Variable<double>(currentWeightKg);
    map['goal'] = Variable<String>(goal);
    map['activity_level'] = Variable<String>(activityLevel);
    if (!nullToAbsent || manualKcalTarget != null) {
      map['manual_kcal_target'] = Variable<int>(manualKcalTarget);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      birthDate: Value(birthDate),
      isMale: Value(isMale),
      heightCm: Value(heightCm),
      currentWeightKg: Value(currentWeightKg),
      goal: Value(goal),
      activityLevel: Value(activityLevel),
      manualKcalTarget: manualKcalTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(manualKcalTarget),
      createdAt: Value(createdAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      isMale: serializer.fromJson<bool>(json['isMale']),
      heightCm: serializer.fromJson<int>(json['heightCm']),
      currentWeightKg: serializer.fromJson<double>(json['currentWeightKg']),
      goal: serializer.fromJson<String>(json['goal']),
      activityLevel: serializer.fromJson<String>(json['activityLevel']),
      manualKcalTarget: serializer.fromJson<int?>(json['manualKcalTarget']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'isMale': serializer.toJson<bool>(isMale),
      'heightCm': serializer.toJson<int>(heightCm),
      'currentWeightKg': serializer.toJson<double>(currentWeightKg),
      'goal': serializer.toJson<String>(goal),
      'activityLevel': serializer.toJson<String>(activityLevel),
      'manualKcalTarget': serializer.toJson<int?>(manualKcalTarget),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserProfile copyWith({
    int? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    bool? isMale,
    int? heightCm,
    double? currentWeightKg,
    String? goal,
    String? activityLevel,
    Value<int?> manualKcalTarget = const Value.absent(),
    DateTime? createdAt,
  }) => UserProfile(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    birthDate: birthDate ?? this.birthDate,
    isMale: isMale ?? this.isMale,
    heightCm: heightCm ?? this.heightCm,
    currentWeightKg: currentWeightKg ?? this.currentWeightKg,
    goal: goal ?? this.goal,
    activityLevel: activityLevel ?? this.activityLevel,
    manualKcalTarget: manualKcalTarget.present
        ? manualKcalTarget.value
        : this.manualKcalTarget,
    createdAt: createdAt ?? this.createdAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      isMale: data.isMale.present ? data.isMale.value : this.isMale,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      currentWeightKg: data.currentWeightKg.present
          ? data.currentWeightKg.value
          : this.currentWeightKg,
      goal: data.goal.present ? data.goal.value : this.goal,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      manualKcalTarget: data.manualKcalTarget.present
          ? data.manualKcalTarget.value
          : this.manualKcalTarget,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('birthDate: $birthDate, ')
          ..write('isMale: $isMale, ')
          ..write('heightCm: $heightCm, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('goal: $goal, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('manualKcalTarget: $manualKcalTarget, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    birthDate,
    isMale,
    heightCm,
    currentWeightKg,
    goal,
    activityLevel,
    manualKcalTarget,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.birthDate == this.birthDate &&
          other.isMale == this.isMale &&
          other.heightCm == this.heightCm &&
          other.currentWeightKg == this.currentWeightKg &&
          other.goal == this.goal &&
          other.activityLevel == this.activityLevel &&
          other.manualKcalTarget == this.manualKcalTarget &&
          other.createdAt == this.createdAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<DateTime> birthDate;
  final Value<bool> isMale;
  final Value<int> heightCm;
  final Value<double> currentWeightKg;
  final Value<String> goal;
  final Value<String> activityLevel;
  final Value<int?> manualKcalTarget;
  final Value<DateTime> createdAt;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.isMale = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.currentWeightKg = const Value.absent(),
    this.goal = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.manualKcalTarget = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required bool isMale,
    required int heightCm,
    required double currentWeightKg,
    required String goal,
    required String activityLevel,
    this.manualKcalTarget = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       birthDate = Value(birthDate),
       isMale = Value(isMale),
       heightCm = Value(heightCm),
       currentWeightKg = Value(currentWeightKg),
       goal = Value(goal),
       activityLevel = Value(activityLevel);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<DateTime>? birthDate,
    Expression<bool>? isMale,
    Expression<int>? heightCm,
    Expression<double>? currentWeightKg,
    Expression<String>? goal,
    Expression<String>? activityLevel,
    Expression<int>? manualKcalTarget,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (birthDate != null) 'birth_date': birthDate,
      if (isMale != null) 'is_male': isMale,
      if (heightCm != null) 'height_cm': heightCm,
      if (currentWeightKg != null) 'current_weight_kg': currentWeightKg,
      if (goal != null) 'goal': goal,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (manualKcalTarget != null) 'manual_kcal_target': manualKcalTarget,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<DateTime>? birthDate,
    Value<bool>? isMale,
    Value<int>? heightCm,
    Value<double>? currentWeightKg,
    Value<String>? goal,
    Value<String>? activityLevel,
    Value<int?>? manualKcalTarget,
    Value<DateTime>? createdAt,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      isMale: isMale ?? this.isMale,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      manualKcalTarget: manualKcalTarget ?? this.manualKcalTarget,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (isMale.present) {
      map['is_male'] = Variable<bool>(isMale.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (currentWeightKg.present) {
      map['current_weight_kg'] = Variable<double>(currentWeightKg.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (manualKcalTarget.present) {
      map['manual_kcal_target'] = Variable<int>(manualKcalTarget.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('birthDate: $birthDate, ')
          ..write('isMale: $isMale, ')
          ..write('heightCm: $heightCm, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('goal: $goal, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('manualKcalTarget: $manualKcalTarget, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kcalPer100gMeta = const VerificationMeta(
    'kcalPer100g',
  );
  @override
  late final GeneratedColumn<double> kcalPer100g = GeneratedColumn<double>(
    'kcal_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinPer100gMeta = const VerificationMeta(
    'proteinPer100g',
  );
  @override
  late final GeneratedColumn<double> proteinPer100g = GeneratedColumn<double>(
    'protein_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsPer100gMeta = const VerificationMeta(
    'carbsPer100g',
  );
  @override
  late final GeneratedColumn<double> carbsPer100g = GeneratedColumn<double>(
    'carbs_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatPer100gMeta = const VerificationMeta(
    'fatPer100g',
  );
  @override
  late final GeneratedColumn<double> fatPer100g = GeneratedColumn<double>(
    'fat_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portionGramsMeta = const VerificationMeta(
    'portionGrams',
  );
  @override
  late final GeneratedColumn<double> portionGrams = GeneratedColumn<double>(
    'portion_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kcalPer100g,
    proteinPer100g,
    carbsPer100g,
    fatPer100g,
    portionGrams,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kcal_per100g')) {
      context.handle(
        _kcalPer100gMeta,
        kcalPer100g.isAcceptableOrUnknown(
          data['kcal_per100g']!,
          _kcalPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kcalPer100gMeta);
    }
    if (data.containsKey('protein_per100g')) {
      context.handle(
        _proteinPer100gMeta,
        proteinPer100g.isAcceptableOrUnknown(
          data['protein_per100g']!,
          _proteinPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPer100gMeta);
    }
    if (data.containsKey('carbs_per100g')) {
      context.handle(
        _carbsPer100gMeta,
        carbsPer100g.isAcceptableOrUnknown(
          data['carbs_per100g']!,
          _carbsPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsPer100gMeta);
    }
    if (data.containsKey('fat_per100g')) {
      context.handle(
        _fatPer100gMeta,
        fatPer100g.isAcceptableOrUnknown(data['fat_per100g']!, _fatPer100gMeta),
      );
    } else if (isInserting) {
      context.missing(_fatPer100gMeta);
    }
    if (data.containsKey('portion_grams')) {
      context.handle(
        _portionGramsMeta,
        portionGrams.isAcceptableOrUnknown(
          data['portion_grams']!,
          _portionGramsMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kcalPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal_per100g'],
      )!,
      proteinPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per100g'],
      )!,
      carbsPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_per100g'],
      )!,
      fatPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_per100g'],
      )!,
      portionGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}portion_grams'],
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }
}

class FoodItem extends DataClass implements Insertable<FoodItem> {
  final int id;
  final String name;
  final double kcalPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double? portionGrams;
  final bool isCustom;
  const FoodItem({
    required this.id,
    required this.name,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.portionGrams,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['kcal_per100g'] = Variable<double>(kcalPer100g);
    map['protein_per100g'] = Variable<double>(proteinPer100g);
    map['carbs_per100g'] = Variable<double>(carbsPer100g);
    map['fat_per100g'] = Variable<double>(fatPer100g);
    if (!nullToAbsent || portionGrams != null) {
      map['portion_grams'] = Variable<double>(portionGrams);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      name: Value(name),
      kcalPer100g: Value(kcalPer100g),
      proteinPer100g: Value(proteinPer100g),
      carbsPer100g: Value(carbsPer100g),
      fatPer100g: Value(fatPer100g),
      portionGrams: portionGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(portionGrams),
      isCustom: Value(isCustom),
    );
  }

  factory FoodItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kcalPer100g: serializer.fromJson<double>(json['kcalPer100g']),
      proteinPer100g: serializer.fromJson<double>(json['proteinPer100g']),
      carbsPer100g: serializer.fromJson<double>(json['carbsPer100g']),
      fatPer100g: serializer.fromJson<double>(json['fatPer100g']),
      portionGrams: serializer.fromJson<double?>(json['portionGrams']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kcalPer100g': serializer.toJson<double>(kcalPer100g),
      'proteinPer100g': serializer.toJson<double>(proteinPer100g),
      'carbsPer100g': serializer.toJson<double>(carbsPer100g),
      'fatPer100g': serializer.toJson<double>(fatPer100g),
      'portionGrams': serializer.toJson<double?>(portionGrams),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  FoodItem copyWith({
    int? id,
    String? name,
    double? kcalPer100g,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatPer100g,
    Value<double?> portionGrams = const Value.absent(),
    bool? isCustom,
  }) => FoodItem(
    id: id ?? this.id,
    name: name ?? this.name,
    kcalPer100g: kcalPer100g ?? this.kcalPer100g,
    proteinPer100g: proteinPer100g ?? this.proteinPer100g,
    carbsPer100g: carbsPer100g ?? this.carbsPer100g,
    fatPer100g: fatPer100g ?? this.fatPer100g,
    portionGrams: portionGrams.present ? portionGrams.value : this.portionGrams,
    isCustom: isCustom ?? this.isCustom,
  );
  FoodItem copyWithCompanion(FoodItemsCompanion data) {
    return FoodItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kcalPer100g: data.kcalPer100g.present
          ? data.kcalPer100g.value
          : this.kcalPer100g,
      proteinPer100g: data.proteinPer100g.present
          ? data.proteinPer100g.value
          : this.proteinPer100g,
      carbsPer100g: data.carbsPer100g.present
          ? data.carbsPer100g.value
          : this.carbsPer100g,
      fatPer100g: data.fatPer100g.present
          ? data.fatPer100g.value
          : this.fatPer100g,
      portionGrams: data.portionGrams.present
          ? data.portionGrams.value
          : this.portionGrams,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kcalPer100g: $kcalPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('portionGrams: $portionGrams, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kcalPer100g,
    proteinPer100g,
    carbsPer100g,
    fatPer100g,
    portionGrams,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.kcalPer100g == this.kcalPer100g &&
          other.proteinPer100g == this.proteinPer100g &&
          other.carbsPer100g == this.carbsPer100g &&
          other.fatPer100g == this.fatPer100g &&
          other.portionGrams == this.portionGrams &&
          other.isCustom == this.isCustom);
}

class FoodItemsCompanion extends UpdateCompanion<FoodItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> kcalPer100g;
  final Value<double> proteinPer100g;
  final Value<double> carbsPer100g;
  final Value<double> fatPer100g;
  final Value<double?> portionGrams;
  final Value<bool> isCustom;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kcalPer100g = const Value.absent(),
    this.proteinPer100g = const Value.absent(),
    this.carbsPer100g = const Value.absent(),
    this.fatPer100g = const Value.absent(),
    this.portionGrams = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double kcalPer100g,
    required double proteinPer100g,
    required double carbsPer100g,
    required double fatPer100g,
    this.portionGrams = const Value.absent(),
    this.isCustom = const Value.absent(),
  }) : name = Value(name),
       kcalPer100g = Value(kcalPer100g),
       proteinPer100g = Value(proteinPer100g),
       carbsPer100g = Value(carbsPer100g),
       fatPer100g = Value(fatPer100g);
  static Insertable<FoodItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? kcalPer100g,
    Expression<double>? proteinPer100g,
    Expression<double>? carbsPer100g,
    Expression<double>? fatPer100g,
    Expression<double>? portionGrams,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kcalPer100g != null) 'kcal_per100g': kcalPer100g,
      if (proteinPer100g != null) 'protein_per100g': proteinPer100g,
      if (carbsPer100g != null) 'carbs_per100g': carbsPer100g,
      if (fatPer100g != null) 'fat_per100g': fatPer100g,
      if (portionGrams != null) 'portion_grams': portionGrams,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  FoodItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? kcalPer100g,
    Value<double>? proteinPer100g,
    Value<double>? carbsPer100g,
    Value<double>? fatPer100g,
    Value<double?>? portionGrams,
    Value<bool>? isCustom,
  }) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kcalPer100g: kcalPer100g ?? this.kcalPer100g,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fatPer100g: fatPer100g ?? this.fatPer100g,
      portionGrams: portionGrams ?? this.portionGrams,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kcalPer100g.present) {
      map['kcal_per100g'] = Variable<double>(kcalPer100g.value);
    }
    if (proteinPer100g.present) {
      map['protein_per100g'] = Variable<double>(proteinPer100g.value);
    }
    if (carbsPer100g.present) {
      map['carbs_per100g'] = Variable<double>(carbsPer100g.value);
    }
    if (fatPer100g.present) {
      map['fat_per100g'] = Variable<double>(fatPer100g.value);
    }
    if (portionGrams.present) {
      map['portion_grams'] = Variable<double>(portionGrams.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kcalPer100g: $kcalPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('portionGrams: $portionGrams, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $MealEntriesTable extends MealEntries
    with TableInfo<$MealEntriesTable, MealEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryDateTimeMeta = const VerificationMeta(
    'entryDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> entryDateTime =
      GeneratedColumn<DateTime>(
        'entry_date_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodItemIdMeta = const VerificationMeta(
    'foodItemId',
  );
  @override
  late final GeneratedColumn<int> foodItemId = GeneratedColumn<int>(
    'food_item_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kcalMeta = const VerificationMeta('kcal');
  @override
  late final GeneratedColumn<double> kcal = GeneratedColumn<double>(
    'kcal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryDateTime,
    mealType,
    foodItemId,
    foodName,
    grams,
    kcal,
    protein,
    carbs,
    fat,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_date_time')) {
      context.handle(
        _entryDateTimeMeta,
        entryDateTime.isAcceptableOrUnknown(
          data['entry_date_time']!,
          _entryDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entryDateTimeMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('food_item_id')) {
      context.handle(
        _foodItemIdMeta,
        foodItemId.isAcceptableOrUnknown(
          data['food_item_id']!,
          _foodItemIdMeta,
        ),
      );
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('grams')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta),
      );
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('kcal')) {
      context.handle(
        _kcalMeta,
        kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta),
      );
    } else if (isInserting) {
      context.missing(_kcalMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date_time'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      foodItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_item_id'],
      ),
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      )!,
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams'],
      )!,
      kcal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
    );
  }

  @override
  $MealEntriesTable createAlias(String alias) {
    return $MealEntriesTable(attachedDatabase, alias);
  }
}

class MealEntry extends DataClass implements Insertable<MealEntry> {
  final int id;
  final DateTime entryDateTime;

  /// 'breakfast' | 'lunch' | 'dinner' | 'snack'
  final String mealType;
  final int? foodItemId;
  final String foodName;
  final double grams;
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  const MealEntry({
    required this.id,
    required this.entryDateTime,
    required this.mealType,
    this.foodItemId,
    required this.foodName,
    required this.grams,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entry_date_time'] = Variable<DateTime>(entryDateTime);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || foodItemId != null) {
      map['food_item_id'] = Variable<int>(foodItemId);
    }
    map['food_name'] = Variable<String>(foodName);
    map['grams'] = Variable<double>(grams);
    map['kcal'] = Variable<double>(kcal);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    return map;
  }

  MealEntriesCompanion toCompanion(bool nullToAbsent) {
    return MealEntriesCompanion(
      id: Value(id),
      entryDateTime: Value(entryDateTime),
      mealType: Value(mealType),
      foodItemId: foodItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodItemId),
      foodName: Value(foodName),
      grams: Value(grams),
      kcal: Value(kcal),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
    );
  }

  factory MealEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealEntry(
      id: serializer.fromJson<int>(json['id']),
      entryDateTime: serializer.fromJson<DateTime>(json['entryDateTime']),
      mealType: serializer.fromJson<String>(json['mealType']),
      foodItemId: serializer.fromJson<int?>(json['foodItemId']),
      foodName: serializer.fromJson<String>(json['foodName']),
      grams: serializer.fromJson<double>(json['grams']),
      kcal: serializer.fromJson<double>(json['kcal']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entryDateTime': serializer.toJson<DateTime>(entryDateTime),
      'mealType': serializer.toJson<String>(mealType),
      'foodItemId': serializer.toJson<int?>(foodItemId),
      'foodName': serializer.toJson<String>(foodName),
      'grams': serializer.toJson<double>(grams),
      'kcal': serializer.toJson<double>(kcal),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
    };
  }

  MealEntry copyWith({
    int? id,
    DateTime? entryDateTime,
    String? mealType,
    Value<int?> foodItemId = const Value.absent(),
    String? foodName,
    double? grams,
    double? kcal,
    double? protein,
    double? carbs,
    double? fat,
  }) => MealEntry(
    id: id ?? this.id,
    entryDateTime: entryDateTime ?? this.entryDateTime,
    mealType: mealType ?? this.mealType,
    foodItemId: foodItemId.present ? foodItemId.value : this.foodItemId,
    foodName: foodName ?? this.foodName,
    grams: grams ?? this.grams,
    kcal: kcal ?? this.kcal,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
  );
  MealEntry copyWithCompanion(MealEntriesCompanion data) {
    return MealEntry(
      id: data.id.present ? data.id.value : this.id,
      entryDateTime: data.entryDateTime.present
          ? data.entryDateTime.value
          : this.entryDateTime,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      foodItemId: data.foodItemId.present
          ? data.foodItemId.value
          : this.foodItemId,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      grams: data.grams.present ? data.grams.value : this.grams,
      kcal: data.kcal.present ? data.kcal.value : this.kcal,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealEntry(')
          ..write('id: $id, ')
          ..write('entryDateTime: $entryDateTime, ')
          ..write('mealType: $mealType, ')
          ..write('foodItemId: $foodItemId, ')
          ..write('foodName: $foodName, ')
          ..write('grams: $grams, ')
          ..write('kcal: $kcal, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entryDateTime,
    mealType,
    foodItemId,
    foodName,
    grams,
    kcal,
    protein,
    carbs,
    fat,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealEntry &&
          other.id == this.id &&
          other.entryDateTime == this.entryDateTime &&
          other.mealType == this.mealType &&
          other.foodItemId == this.foodItemId &&
          other.foodName == this.foodName &&
          other.grams == this.grams &&
          other.kcal == this.kcal &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat);
}

class MealEntriesCompanion extends UpdateCompanion<MealEntry> {
  final Value<int> id;
  final Value<DateTime> entryDateTime;
  final Value<String> mealType;
  final Value<int?> foodItemId;
  final Value<String> foodName;
  final Value<double> grams;
  final Value<double> kcal;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fat;
  const MealEntriesCompanion({
    this.id = const Value.absent(),
    this.entryDateTime = const Value.absent(),
    this.mealType = const Value.absent(),
    this.foodItemId = const Value.absent(),
    this.foodName = const Value.absent(),
    this.grams = const Value.absent(),
    this.kcal = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
  });
  MealEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime entryDateTime,
    required String mealType,
    this.foodItemId = const Value.absent(),
    required String foodName,
    required double grams,
    required double kcal,
    required double protein,
    required double carbs,
    required double fat,
  }) : entryDateTime = Value(entryDateTime),
       mealType = Value(mealType),
       foodName = Value(foodName),
       grams = Value(grams),
       kcal = Value(kcal),
       protein = Value(protein),
       carbs = Value(carbs),
       fat = Value(fat);
  static Insertable<MealEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? entryDateTime,
    Expression<String>? mealType,
    Expression<int>? foodItemId,
    Expression<String>? foodName,
    Expression<double>? grams,
    Expression<double>? kcal,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryDateTime != null) 'entry_date_time': entryDateTime,
      if (mealType != null) 'meal_type': mealType,
      if (foodItemId != null) 'food_item_id': foodItemId,
      if (foodName != null) 'food_name': foodName,
      if (grams != null) 'grams': grams,
      if (kcal != null) 'kcal': kcal,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
    });
  }

  MealEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? entryDateTime,
    Value<String>? mealType,
    Value<int?>? foodItemId,
    Value<String>? foodName,
    Value<double>? grams,
    Value<double>? kcal,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fat,
  }) {
    return MealEntriesCompanion(
      id: id ?? this.id,
      entryDateTime: entryDateTime ?? this.entryDateTime,
      mealType: mealType ?? this.mealType,
      foodItemId: foodItemId ?? this.foodItemId,
      foodName: foodName ?? this.foodName,
      grams: grams ?? this.grams,
      kcal: kcal ?? this.kcal,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryDateTime.present) {
      map['entry_date_time'] = Variable<DateTime>(entryDateTime.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (foodItemId.present) {
      map['food_item_id'] = Variable<int>(foodItemId.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (kcal.present) {
      map['kcal'] = Variable<double>(kcal.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entryDateTime: $entryDateTime, ')
          ..write('mealType: $mealType, ')
          ..write('foodItemId: $foodItemId, ')
          ..write('foodName: $foodName, ')
          ..write('grams: $grams, ')
          ..write('kcal: $kcal, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries
    with TableInfo<$WeightEntriesTable, WeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryDateTimeMeta = const VerificationMeta(
    'entryDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> entryDateTime =
      GeneratedColumn<DateTime>(
        'entry_date_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatPctMeta = const VerificationMeta('fatPct');
  @override
  late final GeneratedColumn<double> fatPct = GeneratedColumn<double>(
    'fat_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _musclePctMeta = const VerificationMeta(
    'musclePct',
  );
  @override
  late final GeneratedColumn<double> musclePct = GeneratedColumn<double>(
    'muscle_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryDateTime,
    weightKg,
    fatPct,
    musclePct,
    photoPath,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_date_time')) {
      context.handle(
        _entryDateTimeMeta,
        entryDateTime.isAcceptableOrUnknown(
          data['entry_date_time']!,
          _entryDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entryDateTimeMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('fat_pct')) {
      context.handle(
        _fatPctMeta,
        fatPct.isAcceptableOrUnknown(data['fat_pct']!, _fatPctMeta),
      );
    }
    if (data.containsKey('muscle_pct')) {
      context.handle(
        _musclePctMeta,
        musclePct.isAcceptableOrUnknown(data['muscle_pct']!, _musclePctMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date_time'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      fatPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_pct'],
      ),
      musclePct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}muscle_pct'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $WeightEntriesTable createAlias(String alias) {
    return $WeightEntriesTable(attachedDatabase, alias);
  }
}

class WeightEntry extends DataClass implements Insertable<WeightEntry> {
  final int id;
  final DateTime entryDateTime;
  final double weightKg;

  /// Composizione corporea (se nota): percentuali.
  final double? fatPct;
  final double? musclePct;

  /// Percorsi locali della foto (documents dir dell'app).
  final String? photoPath;
  final String? note;
  const WeightEntry({
    required this.id,
    required this.entryDateTime,
    required this.weightKg,
    this.fatPct,
    this.musclePct,
    this.photoPath,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entry_date_time'] = Variable<DateTime>(entryDateTime);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || fatPct != null) {
      map['fat_pct'] = Variable<double>(fatPct);
    }
    if (!nullToAbsent || musclePct != null) {
      map['muscle_pct'] = Variable<double>(musclePct);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightEntriesCompanion(
      id: Value(id),
      entryDateTime: Value(entryDateTime),
      weightKg: Value(weightKg),
      fatPct: fatPct == null && nullToAbsent
          ? const Value.absent()
          : Value(fatPct),
      musclePct: musclePct == null && nullToAbsent
          ? const Value.absent()
          : Value(musclePct),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WeightEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightEntry(
      id: serializer.fromJson<int>(json['id']),
      entryDateTime: serializer.fromJson<DateTime>(json['entryDateTime']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      fatPct: serializer.fromJson<double?>(json['fatPct']),
      musclePct: serializer.fromJson<double?>(json['musclePct']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entryDateTime': serializer.toJson<DateTime>(entryDateTime),
      'weightKg': serializer.toJson<double>(weightKg),
      'fatPct': serializer.toJson<double?>(fatPct),
      'musclePct': serializer.toJson<double?>(musclePct),
      'photoPath': serializer.toJson<String?>(photoPath),
      'note': serializer.toJson<String?>(note),
    };
  }

  WeightEntry copyWith({
    int? id,
    DateTime? entryDateTime,
    double? weightKg,
    Value<double?> fatPct = const Value.absent(),
    Value<double?> musclePct = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => WeightEntry(
    id: id ?? this.id,
    entryDateTime: entryDateTime ?? this.entryDateTime,
    weightKg: weightKg ?? this.weightKg,
    fatPct: fatPct.present ? fatPct.value : this.fatPct,
    musclePct: musclePct.present ? musclePct.value : this.musclePct,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    note: note.present ? note.value : this.note,
  );
  WeightEntry copyWithCompanion(WeightEntriesCompanion data) {
    return WeightEntry(
      id: data.id.present ? data.id.value : this.id,
      entryDateTime: data.entryDateTime.present
          ? data.entryDateTime.value
          : this.entryDateTime,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      fatPct: data.fatPct.present ? data.fatPct.value : this.fatPct,
      musclePct: data.musclePct.present ? data.musclePct.value : this.musclePct,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntry(')
          ..write('id: $id, ')
          ..write('entryDateTime: $entryDateTime, ')
          ..write('weightKg: $weightKg, ')
          ..write('fatPct: $fatPct, ')
          ..write('musclePct: $musclePct, ')
          ..write('photoPath: $photoPath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entryDateTime,
    weightKg,
    fatPct,
    musclePct,
    photoPath,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightEntry &&
          other.id == this.id &&
          other.entryDateTime == this.entryDateTime &&
          other.weightKg == this.weightKg &&
          other.fatPct == this.fatPct &&
          other.musclePct == this.musclePct &&
          other.photoPath == this.photoPath &&
          other.note == this.note);
}

class WeightEntriesCompanion extends UpdateCompanion<WeightEntry> {
  final Value<int> id;
  final Value<DateTime> entryDateTime;
  final Value<double> weightKg;
  final Value<double?> fatPct;
  final Value<double?> musclePct;
  final Value<String?> photoPath;
  final Value<String?> note;
  const WeightEntriesCompanion({
    this.id = const Value.absent(),
    this.entryDateTime = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.fatPct = const Value.absent(),
    this.musclePct = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.note = const Value.absent(),
  });
  WeightEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime entryDateTime,
    required double weightKg,
    this.fatPct = const Value.absent(),
    this.musclePct = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.note = const Value.absent(),
  }) : entryDateTime = Value(entryDateTime),
       weightKg = Value(weightKg);
  static Insertable<WeightEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? entryDateTime,
    Expression<double>? weightKg,
    Expression<double>? fatPct,
    Expression<double>? musclePct,
    Expression<String>? photoPath,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryDateTime != null) 'entry_date_time': entryDateTime,
      if (weightKg != null) 'weight_kg': weightKg,
      if (fatPct != null) 'fat_pct': fatPct,
      if (musclePct != null) 'muscle_pct': musclePct,
      if (photoPath != null) 'photo_path': photoPath,
      if (note != null) 'note': note,
    });
  }

  WeightEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? entryDateTime,
    Value<double>? weightKg,
    Value<double?>? fatPct,
    Value<double?>? musclePct,
    Value<String?>? photoPath,
    Value<String?>? note,
  }) {
    return WeightEntriesCompanion(
      id: id ?? this.id,
      entryDateTime: entryDateTime ?? this.entryDateTime,
      weightKg: weightKg ?? this.weightKg,
      fatPct: fatPct ?? this.fatPct,
      musclePct: musclePct ?? this.musclePct,
      photoPath: photoPath ?? this.photoPath,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryDateTime.present) {
      map['entry_date_time'] = Variable<DateTime>(entryDateTime.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (fatPct.present) {
      map['fat_pct'] = Variable<double>(fatPct.value);
    }
    if (musclePct.present) {
      map['muscle_pct'] = Variable<double>(musclePct.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entryDateTime: $entryDateTime, ')
          ..write('weightKg: $weightKg, ')
          ..write('fatPct: $fatPct, ')
          ..write('musclePct: $musclePct, ')
          ..write('photoPath: $photoPath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $MeasurementPointsTable extends MeasurementPoints
    with TableInfo<$MeasurementPointsTable, MeasurementPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, label, isCustom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeasurementPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $MeasurementPointsTable createAlias(String alias) {
    return $MeasurementPointsTable(attachedDatabase, alias);
  }
}

class MeasurementPoint extends DataClass
    implements Insertable<MeasurementPoint> {
  final int id;

  /// 'waist' | 'chest' | 'bicep_l' | 'bicep_r' | 'custom:<nome>'
  final String key;
  final String label;
  final bool isCustom;
  const MeasurementPoint({
    required this.id,
    required this.key,
    required this.label,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['label'] = Variable<String>(label);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  MeasurementPointsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementPointsCompanion(
      id: Value(id),
      key: Value(key),
      label: Value(label),
      isCustom: Value(isCustom),
    );
  }

  factory MeasurementPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementPoint(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      label: serializer.fromJson<String>(json['label']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'label': serializer.toJson<String>(label),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  MeasurementPoint copyWith({
    int? id,
    String? key,
    String? label,
    bool? isCustom,
  }) => MeasurementPoint(
    id: id ?? this.id,
    key: key ?? this.key,
    label: label ?? this.label,
    isCustom: isCustom ?? this.isCustom,
  );
  MeasurementPoint copyWithCompanion(MeasurementPointsCompanion data) {
    return MeasurementPoint(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      label: data.label.present ? data.label.value : this.label,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementPoint(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, label, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementPoint &&
          other.id == this.id &&
          other.key == this.key &&
          other.label == this.label &&
          other.isCustom == this.isCustom);
}

class MeasurementPointsCompanion extends UpdateCompanion<MeasurementPoint> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> label;
  final Value<bool> isCustom;
  const MeasurementPointsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.label = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  MeasurementPointsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String label,
    this.isCustom = const Value.absent(),
  }) : key = Value(key),
       label = Value(label);
  static Insertable<MeasurementPoint> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? label,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (label != null) 'label': label,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  MeasurementPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? label,
    Value<bool>? isCustom,
  }) {
    return MeasurementPointsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      label: label ?? this.label,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementPointsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $WeightMeasurementsTable extends WeightMeasurements
    with TableInfo<$WeightMeasurementsTable, WeightMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weightEntryIdMeta = const VerificationMeta(
    'weightEntryId',
  );
  @override
  late final GeneratedColumn<int> weightEntryId = GeneratedColumn<int>(
    'weight_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES weight_entries (id)',
    ),
  );
  static const VerificationMeta _pointIdMeta = const VerificationMeta(
    'pointId',
  );
  @override
  late final GeneratedColumn<int> pointId = GeneratedColumn<int>(
    'point_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES measurement_points (id)',
    ),
  );
  static const VerificationMeta _valueCmMeta = const VerificationMeta(
    'valueCm',
  );
  @override
  late final GeneratedColumn<double> valueCm = GeneratedColumn<double>(
    'value_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrowXMeta = const VerificationMeta('arrowX');
  @override
  late final GeneratedColumn<double> arrowX = GeneratedColumn<double>(
    'arrow_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _arrowYMeta = const VerificationMeta('arrowY');
  @override
  late final GeneratedColumn<double> arrowY = GeneratedColumn<double>(
    'arrow_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _arrowAngleMeta = const VerificationMeta(
    'arrowAngle',
  );
  @override
  late final GeneratedColumn<double> arrowAngle = GeneratedColumn<double>(
    'arrow_angle',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weightEntryId,
    pointId,
    valueCm,
    arrowX,
    arrowY,
    arrowAngle,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightMeasurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weight_entry_id')) {
      context.handle(
        _weightEntryIdMeta,
        weightEntryId.isAcceptableOrUnknown(
          data['weight_entry_id']!,
          _weightEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightEntryIdMeta);
    }
    if (data.containsKey('point_id')) {
      context.handle(
        _pointIdMeta,
        pointId.isAcceptableOrUnknown(data['point_id']!, _pointIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pointIdMeta);
    }
    if (data.containsKey('value_cm')) {
      context.handle(
        _valueCmMeta,
        valueCm.isAcceptableOrUnknown(data['value_cm']!, _valueCmMeta),
      );
    } else if (isInserting) {
      context.missing(_valueCmMeta);
    }
    if (data.containsKey('arrow_x')) {
      context.handle(
        _arrowXMeta,
        arrowX.isAcceptableOrUnknown(data['arrow_x']!, _arrowXMeta),
      );
    }
    if (data.containsKey('arrow_y')) {
      context.handle(
        _arrowYMeta,
        arrowY.isAcceptableOrUnknown(data['arrow_y']!, _arrowYMeta),
      );
    }
    if (data.containsKey('arrow_angle')) {
      context.handle(
        _arrowAngleMeta,
        arrowAngle.isAcceptableOrUnknown(data['arrow_angle']!, _arrowAngleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightMeasurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weightEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_entry_id'],
      )!,
      pointId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}point_id'],
      )!,
      valueCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_cm'],
      )!,
      arrowX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}arrow_x'],
      )!,
      arrowY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}arrow_y'],
      )!,
      arrowAngle: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}arrow_angle'],
      )!,
    );
  }

  @override
  $WeightMeasurementsTable createAlias(String alias) {
    return $WeightMeasurementsTable(attachedDatabase, alias);
  }
}

class WeightMeasurement extends DataClass
    implements Insertable<WeightMeasurement> {
  final int id;
  final int weightEntryId;
  final int pointId;
  final double valueCm;
  final double arrowX;
  final double arrowY;
  final double arrowAngle;
  const WeightMeasurement({
    required this.id,
    required this.weightEntryId,
    required this.pointId,
    required this.valueCm,
    required this.arrowX,
    required this.arrowY,
    required this.arrowAngle,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weight_entry_id'] = Variable<int>(weightEntryId);
    map['point_id'] = Variable<int>(pointId);
    map['value_cm'] = Variable<double>(valueCm);
    map['arrow_x'] = Variable<double>(arrowX);
    map['arrow_y'] = Variable<double>(arrowY);
    map['arrow_angle'] = Variable<double>(arrowAngle);
    return map;
  }

  WeightMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return WeightMeasurementsCompanion(
      id: Value(id),
      weightEntryId: Value(weightEntryId),
      pointId: Value(pointId),
      valueCm: Value(valueCm),
      arrowX: Value(arrowX),
      arrowY: Value(arrowY),
      arrowAngle: Value(arrowAngle),
    );
  }

  factory WeightMeasurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightMeasurement(
      id: serializer.fromJson<int>(json['id']),
      weightEntryId: serializer.fromJson<int>(json['weightEntryId']),
      pointId: serializer.fromJson<int>(json['pointId']),
      valueCm: serializer.fromJson<double>(json['valueCm']),
      arrowX: serializer.fromJson<double>(json['arrowX']),
      arrowY: serializer.fromJson<double>(json['arrowY']),
      arrowAngle: serializer.fromJson<double>(json['arrowAngle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weightEntryId': serializer.toJson<int>(weightEntryId),
      'pointId': serializer.toJson<int>(pointId),
      'valueCm': serializer.toJson<double>(valueCm),
      'arrowX': serializer.toJson<double>(arrowX),
      'arrowY': serializer.toJson<double>(arrowY),
      'arrowAngle': serializer.toJson<double>(arrowAngle),
    };
  }

  WeightMeasurement copyWith({
    int? id,
    int? weightEntryId,
    int? pointId,
    double? valueCm,
    double? arrowX,
    double? arrowY,
    double? arrowAngle,
  }) => WeightMeasurement(
    id: id ?? this.id,
    weightEntryId: weightEntryId ?? this.weightEntryId,
    pointId: pointId ?? this.pointId,
    valueCm: valueCm ?? this.valueCm,
    arrowX: arrowX ?? this.arrowX,
    arrowY: arrowY ?? this.arrowY,
    arrowAngle: arrowAngle ?? this.arrowAngle,
  );
  WeightMeasurement copyWithCompanion(WeightMeasurementsCompanion data) {
    return WeightMeasurement(
      id: data.id.present ? data.id.value : this.id,
      weightEntryId: data.weightEntryId.present
          ? data.weightEntryId.value
          : this.weightEntryId,
      pointId: data.pointId.present ? data.pointId.value : this.pointId,
      valueCm: data.valueCm.present ? data.valueCm.value : this.valueCm,
      arrowX: data.arrowX.present ? data.arrowX.value : this.arrowX,
      arrowY: data.arrowY.present ? data.arrowY.value : this.arrowY,
      arrowAngle: data.arrowAngle.present
          ? data.arrowAngle.value
          : this.arrowAngle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightMeasurement(')
          ..write('id: $id, ')
          ..write('weightEntryId: $weightEntryId, ')
          ..write('pointId: $pointId, ')
          ..write('valueCm: $valueCm, ')
          ..write('arrowX: $arrowX, ')
          ..write('arrowY: $arrowY, ')
          ..write('arrowAngle: $arrowAngle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weightEntryId,
    pointId,
    valueCm,
    arrowX,
    arrowY,
    arrowAngle,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightMeasurement &&
          other.id == this.id &&
          other.weightEntryId == this.weightEntryId &&
          other.pointId == this.pointId &&
          other.valueCm == this.valueCm &&
          other.arrowX == this.arrowX &&
          other.arrowY == this.arrowY &&
          other.arrowAngle == this.arrowAngle);
}

class WeightMeasurementsCompanion extends UpdateCompanion<WeightMeasurement> {
  final Value<int> id;
  final Value<int> weightEntryId;
  final Value<int> pointId;
  final Value<double> valueCm;
  final Value<double> arrowX;
  final Value<double> arrowY;
  final Value<double> arrowAngle;
  const WeightMeasurementsCompanion({
    this.id = const Value.absent(),
    this.weightEntryId = const Value.absent(),
    this.pointId = const Value.absent(),
    this.valueCm = const Value.absent(),
    this.arrowX = const Value.absent(),
    this.arrowY = const Value.absent(),
    this.arrowAngle = const Value.absent(),
  });
  WeightMeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required int weightEntryId,
    required int pointId,
    required double valueCm,
    this.arrowX = const Value.absent(),
    this.arrowY = const Value.absent(),
    this.arrowAngle = const Value.absent(),
  }) : weightEntryId = Value(weightEntryId),
       pointId = Value(pointId),
       valueCm = Value(valueCm);
  static Insertable<WeightMeasurement> custom({
    Expression<int>? id,
    Expression<int>? weightEntryId,
    Expression<int>? pointId,
    Expression<double>? valueCm,
    Expression<double>? arrowX,
    Expression<double>? arrowY,
    Expression<double>? arrowAngle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weightEntryId != null) 'weight_entry_id': weightEntryId,
      if (pointId != null) 'point_id': pointId,
      if (valueCm != null) 'value_cm': valueCm,
      if (arrowX != null) 'arrow_x': arrowX,
      if (arrowY != null) 'arrow_y': arrowY,
      if (arrowAngle != null) 'arrow_angle': arrowAngle,
    });
  }

  WeightMeasurementsCompanion copyWith({
    Value<int>? id,
    Value<int>? weightEntryId,
    Value<int>? pointId,
    Value<double>? valueCm,
    Value<double>? arrowX,
    Value<double>? arrowY,
    Value<double>? arrowAngle,
  }) {
    return WeightMeasurementsCompanion(
      id: id ?? this.id,
      weightEntryId: weightEntryId ?? this.weightEntryId,
      pointId: pointId ?? this.pointId,
      valueCm: valueCm ?? this.valueCm,
      arrowX: arrowX ?? this.arrowX,
      arrowY: arrowY ?? this.arrowY,
      arrowAngle: arrowAngle ?? this.arrowAngle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weightEntryId.present) {
      map['weight_entry_id'] = Variable<int>(weightEntryId.value);
    }
    if (pointId.present) {
      map['point_id'] = Variable<int>(pointId.value);
    }
    if (valueCm.present) {
      map['value_cm'] = Variable<double>(valueCm.value);
    }
    if (arrowX.present) {
      map['arrow_x'] = Variable<double>(arrowX.value);
    }
    if (arrowY.present) {
      map['arrow_y'] = Variable<double>(arrowY.value);
    }
    if (arrowAngle.present) {
      map['arrow_angle'] = Variable<double>(arrowAngle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('weightEntryId: $weightEntryId, ')
          ..write('pointId: $pointId, ')
          ..write('valueCm: $valueCm, ')
          ..write('arrowX: $arrowX, ')
          ..write('arrowY: $arrowY, ')
          ..write('arrowAngle: $arrowAngle')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final $MealEntriesTable mealEntries = $MealEntriesTable(this);
  late final $WeightEntriesTable weightEntries = $WeightEntriesTable(this);
  late final $MeasurementPointsTable measurementPoints =
      $MeasurementPointsTable(this);
  late final $WeightMeasurementsTable weightMeasurements =
      $WeightMeasurementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    foodItems,
    mealEntries,
    weightEntries,
    measurementPoints,
    weightMeasurements,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      required String firstName,
      required String lastName,
      required DateTime birthDate,
      required bool isMale,
      required int heightCm,
      required double currentWeightKg,
      required String goal,
      required String activityLevel,
      Value<int?> manualKcalTarget,
      Value<DateTime> createdAt,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<DateTime> birthDate,
      Value<bool> isMale,
      Value<int> heightCm,
      Value<double> currentWeightKg,
      Value<String> goal,
      Value<String> activityLevel,
      Value<int?> manualKcalTarget,
      Value<DateTime> createdAt,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMale => $composableBuilder(
    column: $table.isMale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get manualKcalTarget => $composableBuilder(
    column: $table.manualKcalTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMale => $composableBuilder(
    column: $table.isMale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get manualKcalTarget => $composableBuilder(
    column: $table.manualKcalTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<bool> get isMale =>
      $composableBuilder(column: $table.isMale, builder: (column) => column);

  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get manualKcalTarget => $composableBuilder(
    column: $table.manualKcalTarget,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<bool> isMale = const Value.absent(),
                Value<int> heightCm = const Value.absent(),
                Value<double> currentWeightKg = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<String> activityLevel = const Value.absent(),
                Value<int?> manualKcalTarget = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                birthDate: birthDate,
                isMale: isMale,
                heightCm: heightCm,
                currentWeightKg: currentWeightKg,
                goal: goal,
                activityLevel: activityLevel,
                manualKcalTarget: manualKcalTarget,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstName,
                required String lastName,
                required DateTime birthDate,
                required bool isMale,
                required int heightCm,
                required double currentWeightKg,
                required String goal,
                required String activityLevel,
                Value<int?> manualKcalTarget = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                birthDate: birthDate,
                isMale: isMale,
                heightCm: heightCm,
                currentWeightKg: currentWeightKg,
                goal: goal,
                activityLevel: activityLevel,
                manualKcalTarget: manualKcalTarget,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$FoodItemsTableCreateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  required String name,
  required double kcalPer100g,
  required double proteinPer100g,
  required double carbsPer100g,
  required double fatPer100g,
  Value<double?> portionGrams,
  Value<bool> isCustom,
});
typedef $$FoodItemsTableUpdateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> kcalPer100g,
  Value<double> proteinPer100g,
  Value<double> carbsPer100g,
  Value<double> fatPer100g,
  Value<double?> portionGrams,
  Value<bool> isCustom,
});

class $$FoodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcalPer100g => $composableBuilder(
    column: $table.kcalPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get portionGrams => $composableBuilder(
    column: $table.portionGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcalPer100g => $composableBuilder(
    column: $table.kcalPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get portionGrams => $composableBuilder(
    column: $table.portionGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get kcalPer100g => $composableBuilder(
    column: $table.kcalPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get portionGrams => $composableBuilder(
    column: $table.portionGrams,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$FoodItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodItemsTable,
          FoodItem,
          $$FoodItemsTableFilterComposer,
          $$FoodItemsTableOrderingComposer,
          $$FoodItemsTableAnnotationComposer,
          $$FoodItemsTableCreateCompanionBuilder,
          $$FoodItemsTableUpdateCompanionBuilder,
          (FoodItem, BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>),
          FoodItem,
          PrefetchHooks Function()
        > {
  $$FoodItemsTableTableManager(_$AppDatabase db, $FoodItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> kcalPer100g = const Value.absent(),
                Value<double> proteinPer100g = const Value.absent(),
                Value<double> carbsPer100g = const Value.absent(),
                Value<double> fatPer100g = const Value.absent(),
                Value<double?> portionGrams = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => FoodItemsCompanion(
                id: id,
                name: name,
                kcalPer100g: kcalPer100g,
                proteinPer100g: proteinPer100g,
                carbsPer100g: carbsPer100g,
                fatPer100g: fatPer100g,
                portionGrams: portionGrams,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double kcalPer100g,
                required double proteinPer100g,
                required double carbsPer100g,
                required double fatPer100g,
                Value<double?> portionGrams = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => FoodItemsCompanion.insert(
                id: id,
                name: name,
                kcalPer100g: kcalPer100g,
                proteinPer100g: proteinPer100g,
                carbsPer100g: carbsPer100g,
                fatPer100g: fatPer100g,
                portionGrams: portionGrams,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodItemsTable, FoodItem>(table),
                  BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodItemsTable,
      FoodItem,
      $$FoodItemsTableFilterComposer,
      $$FoodItemsTableOrderingComposer,
      $$FoodItemsTableAnnotationComposer,
      $$FoodItemsTableCreateCompanionBuilder,
      $$FoodItemsTableUpdateCompanionBuilder,
      (FoodItem, BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>),
      FoodItem,
      PrefetchHooks Function()
    >;
typedef $$MealEntriesTableCreateCompanionBuilder =
    MealEntriesCompanion Function({
      Value<int> id,
      required DateTime entryDateTime,
      required String mealType,
      Value<int?> foodItemId,
      required String foodName,
      required double grams,
      required double kcal,
      required double protein,
      required double carbs,
      required double fat,
    });
typedef $$MealEntriesTableUpdateCompanionBuilder =
    MealEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> entryDateTime,
      Value<String> mealType,
      Value<int?> foodItemId,
      Value<String> foodName,
      Value<double> grams,
      Value<double> kcal,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fat,
    });

class $$MealEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryDateTime => $composableBuilder(
    column: $table.entryDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get foodItemId => $composableBuilder(
    column: $table.foodItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryDateTime => $composableBuilder(
    column: $table.entryDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get foodItemId => $composableBuilder(
    column: $table.foodItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDateTime => $composableBuilder(
    column: $table.entryDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<int> get foodItemId => $composableBuilder(
    column: $table.foodItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<double> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);
}

class $$MealEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealEntriesTable,
          MealEntry,
          $$MealEntriesTableFilterComposer,
          $$MealEntriesTableOrderingComposer,
          $$MealEntriesTableAnnotationComposer,
          $$MealEntriesTableCreateCompanionBuilder,
          $$MealEntriesTableUpdateCompanionBuilder,
          (
            MealEntry,
            BaseReferences<_$AppDatabase, $MealEntriesTable, MealEntry>,
          ),
          MealEntry,
          PrefetchHooks Function()
        > {
  $$MealEntriesTableTableManager(_$AppDatabase db, $MealEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> entryDateTime = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int?> foodItemId = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<double> grams = const Value.absent(),
                Value<double> kcal = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
              }) => MealEntriesCompanion(
                id: id,
                entryDateTime: entryDateTime,
                mealType: mealType,
                foodItemId: foodItemId,
                foodName: foodName,
                grams: grams,
                kcal: kcal,
                protein: protein,
                carbs: carbs,
                fat: fat,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime entryDateTime,
                required String mealType,
                Value<int?> foodItemId = const Value.absent(),
                required String foodName,
                required double grams,
                required double kcal,
                required double protein,
                required double carbs,
                required double fat,
              }) => MealEntriesCompanion.insert(
                id: id,
                entryDateTime: entryDateTime,
                mealType: mealType,
                foodItemId: foodItemId,
                foodName: foodName,
                grams: grams,
                kcal: kcal,
                protein: protein,
                carbs: carbs,
                fat: fat,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealEntriesTable, MealEntry>(table),
                  BaseReferences<_$AppDatabase, $MealEntriesTable, MealEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealEntriesTable,
      MealEntry,
      $$MealEntriesTableFilterComposer,
      $$MealEntriesTableOrderingComposer,
      $$MealEntriesTableAnnotationComposer,
      $$MealEntriesTableCreateCompanionBuilder,
      $$MealEntriesTableUpdateCompanionBuilder,
      (MealEntry, BaseReferences<_$AppDatabase, $MealEntriesTable, MealEntry>),
      MealEntry,
      PrefetchHooks Function()
    >;
typedef $$WeightEntriesTableCreateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<int> id,
      required DateTime entryDateTime,
      required double weightKg,
      Value<double?> fatPct,
      Value<double?> musclePct,
      Value<String?> photoPath,
      Value<String?> note,
    });
typedef $$WeightEntriesTableUpdateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> entryDateTime,
      Value<double> weightKg,
      Value<double?> fatPct,
      Value<double?> musclePct,
      Value<String?> photoPath,
      Value<String?> note,
    });

final class $$WeightEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry> {
  $$WeightEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WeightMeasurementsTable, List<WeightMeasurement>>
  _weightMeasurementsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weightMeasurements,
        aliasName: 'weight_entries__id__weight_measurements__weight_entry_id',
      );

  $$WeightMeasurementsTableProcessedTableManager get weightMeasurementsRefs {
    final manager = $$WeightMeasurementsTableTableManager(
      $_db,
      $_db.weightMeasurements,
    ).filter((f) => f.weightEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weightMeasurementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryDateTime => $composableBuilder(
    column: $table.entryDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPct => $composableBuilder(
    column: $table.fatPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get musclePct => $composableBuilder(
    column: $table.musclePct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weightMeasurementsRefs(
    Expression<bool> Function($$WeightMeasurementsTableFilterComposer f) f,
  ) {
    final $$WeightMeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weightMeasurements,
      getReferencedColumn: (t) => t.weightEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightMeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.weightMeasurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryDateTime => $composableBuilder(
    column: $table.entryDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPct => $composableBuilder(
    column: $table.fatPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get musclePct => $composableBuilder(
    column: $table.musclePct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDateTime => $composableBuilder(
    column: $table.entryDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get fatPct =>
      $composableBuilder(column: $table.fatPct, builder: (column) => column);

  GeneratedColumn<double> get musclePct =>
      $composableBuilder(column: $table.musclePct, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  Expression<T> weightMeasurementsRefs<T extends Object>(
    Expression<T> Function($$WeightMeasurementsTableAnnotationComposer a) f,
  ) {
    final $$WeightMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weightMeasurements,
          getReferencedColumn: (t) => t.weightEntryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeightMeasurementsTableAnnotationComposer(
                $db: $db,
                $table: $db.weightMeasurements,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightEntriesTable,
          WeightEntry,
          $$WeightEntriesTableFilterComposer,
          $$WeightEntriesTableOrderingComposer,
          $$WeightEntriesTableAnnotationComposer,
          $$WeightEntriesTableCreateCompanionBuilder,
          $$WeightEntriesTableUpdateCompanionBuilder,
          (WeightEntry, $$WeightEntriesTableReferences),
          WeightEntry,
          PrefetchHooks Function({bool weightMeasurementsRefs})
        > {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> entryDateTime = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double?> fatPct = const Value.absent(),
                Value<double?> musclePct = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => WeightEntriesCompanion(
                id: id,
                entryDateTime: entryDateTime,
                weightKg: weightKg,
                fatPct: fatPct,
                musclePct: musclePct,
                photoPath: photoPath,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime entryDateTime,
                required double weightKg,
                Value<double?> fatPct = const Value.absent(),
                Value<double?> musclePct = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => WeightEntriesCompanion.insert(
                id: id,
                entryDateTime: entryDateTime,
                weightKg: weightKg,
                fatPct: fatPct,
                musclePct: musclePct,
                photoPath: photoPath,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeightEntriesTable, WeightEntry>(table),
                  $$WeightEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weightMeasurementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (weightMeasurementsRefs) db.weightMeasurements,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (weightMeasurementsRefs)
                    await $_getPrefetchedData<
                      WeightEntry,
                      $WeightEntriesTable,
                      WeightMeasurement
                    >(
                      currentTable: table,
                      referencedTable: $$WeightEntriesTableReferences
                          ._weightMeasurementsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WeightEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).weightMeasurementsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.weightEntryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightEntriesTable,
      WeightEntry,
      $$WeightEntriesTableFilterComposer,
      $$WeightEntriesTableOrderingComposer,
      $$WeightEntriesTableAnnotationComposer,
      $$WeightEntriesTableCreateCompanionBuilder,
      $$WeightEntriesTableUpdateCompanionBuilder,
      (WeightEntry, $$WeightEntriesTableReferences),
      WeightEntry,
      PrefetchHooks Function({bool weightMeasurementsRefs})
    >;
typedef $$MeasurementPointsTableCreateCompanionBuilder =
    MeasurementPointsCompanion Function({
      Value<int> id,
      required String key,
      required String label,
      Value<bool> isCustom,
    });
typedef $$MeasurementPointsTableUpdateCompanionBuilder =
    MeasurementPointsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> label,
      Value<bool> isCustom,
    });

final class $$MeasurementPointsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MeasurementPointsTable,
          MeasurementPoint
        > {
  $$MeasurementPointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WeightMeasurementsTable, List<WeightMeasurement>>
  _weightMeasurementsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weightMeasurements,
        aliasName: 'measurement_points__id__weight_measurements__point_id',
      );

  $$WeightMeasurementsTableProcessedTableManager get weightMeasurementsRefs {
    final manager = $$WeightMeasurementsTableTableManager(
      $_db,
      $_db.weightMeasurements,
    ).filter((f) => f.pointId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weightMeasurementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MeasurementPointsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementPointsTable> {
  $$MeasurementPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weightMeasurementsRefs(
    Expression<bool> Function($$WeightMeasurementsTableFilterComposer f) f,
  ) {
    final $$WeightMeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weightMeasurements,
      getReferencedColumn: (t) => t.pointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightMeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.weightMeasurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MeasurementPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementPointsTable> {
  $$MeasurementPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeasurementPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementPointsTable> {
  $$MeasurementPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> weightMeasurementsRefs<T extends Object>(
    Expression<T> Function($$WeightMeasurementsTableAnnotationComposer a) f,
  ) {
    final $$WeightMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weightMeasurements,
          getReferencedColumn: (t) => t.pointId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeightMeasurementsTableAnnotationComposer(
                $db: $db,
                $table: $db.weightMeasurements,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MeasurementPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementPointsTable,
          MeasurementPoint,
          $$MeasurementPointsTableFilterComposer,
          $$MeasurementPointsTableOrderingComposer,
          $$MeasurementPointsTableAnnotationComposer,
          $$MeasurementPointsTableCreateCompanionBuilder,
          $$MeasurementPointsTableUpdateCompanionBuilder,
          (MeasurementPoint, $$MeasurementPointsTableReferences),
          MeasurementPoint,
          PrefetchHooks Function({bool weightMeasurementsRefs})
        > {
  $$MeasurementPointsTableTableManager(
    _$AppDatabase db,
    $MeasurementPointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasurementPointsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => MeasurementPointsCompanion(
                id: id,
                key: key,
                label: label,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String label,
                Value<bool> isCustom = const Value.absent(),
              }) => MeasurementPointsCompanion.insert(
                id: id,
                key: key,
                label: label,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MeasurementPointsTable, MeasurementPoint>(table),
                  $$MeasurementPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weightMeasurementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (weightMeasurementsRefs) db.weightMeasurements,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (weightMeasurementsRefs)
                    await $_getPrefetchedData<
                      MeasurementPoint,
                      $MeasurementPointsTable,
                      WeightMeasurement
                    >(
                      currentTable: table,
                      referencedTable: $$MeasurementPointsTableReferences
                          ._weightMeasurementsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MeasurementPointsTableReferences(
                            db,
                            table,
                            p0,
                          ).weightMeasurementsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.pointId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MeasurementPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementPointsTable,
      MeasurementPoint,
      $$MeasurementPointsTableFilterComposer,
      $$MeasurementPointsTableOrderingComposer,
      $$MeasurementPointsTableAnnotationComposer,
      $$MeasurementPointsTableCreateCompanionBuilder,
      $$MeasurementPointsTableUpdateCompanionBuilder,
      (MeasurementPoint, $$MeasurementPointsTableReferences),
      MeasurementPoint,
      PrefetchHooks Function({bool weightMeasurementsRefs})
    >;
typedef $$WeightMeasurementsTableCreateCompanionBuilder =
    WeightMeasurementsCompanion Function({
      Value<int> id,
      required int weightEntryId,
      required int pointId,
      required double valueCm,
      Value<double> arrowX,
      Value<double> arrowY,
      Value<double> arrowAngle,
    });
typedef $$WeightMeasurementsTableUpdateCompanionBuilder =
    WeightMeasurementsCompanion Function({
      Value<int> id,
      Value<int> weightEntryId,
      Value<int> pointId,
      Value<double> valueCm,
      Value<double> arrowX,
      Value<double> arrowY,
      Value<double> arrowAngle,
    });

final class $$WeightMeasurementsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeightMeasurementsTable,
          WeightMeasurement
        > {
  $$WeightMeasurementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeightEntriesTable _weightEntryIdTable(_$AppDatabase db) => db
      .weightEntries
      .createAlias('weight_measurements__weight_entry_id__weight_entries__id');

  $$WeightEntriesTableProcessedTableManager get weightEntryId {
    final $_column = $_itemColumn<int>('weight_entry_id')!;

    final manager = $$WeightEntriesTableTableManager(
      $_db,
      $_db.weightEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weightEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MeasurementPointsTable _pointIdTable(_$AppDatabase db) => db
      .measurementPoints
      .createAlias('weight_measurements__point_id__measurement_points__id');

  $$MeasurementPointsTableProcessedTableManager get pointId {
    final $_column = $_itemColumn<int>('point_id')!;

    final manager = $$MeasurementPointsTableTableManager(
      $_db,
      $_db.measurementPoints,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pointIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeightMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightMeasurementsTable> {
  $$WeightMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valueCm => $composableBuilder(
    column: $table.valueCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get arrowX => $composableBuilder(
    column: $table.arrowX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get arrowY => $composableBuilder(
    column: $table.arrowY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get arrowAngle => $composableBuilder(
    column: $table.arrowAngle,
    builder: (column) => ColumnFilters(column),
  );

  $$WeightEntriesTableFilterComposer get weightEntryId {
    final $$WeightEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weightEntryId,
      referencedTable: $db.weightEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightEntriesTableFilterComposer(
            $db: $db,
            $table: $db.weightEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeasurementPointsTableFilterComposer get pointId {
    final $$MeasurementPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pointId,
      referencedTable: $db.measurementPoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementPointsTableFilterComposer(
            $db: $db,
            $table: $db.measurementPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightMeasurementsTable> {
  $$WeightMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valueCm => $composableBuilder(
    column: $table.valueCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get arrowX => $composableBuilder(
    column: $table.arrowX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get arrowY => $composableBuilder(
    column: $table.arrowY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get arrowAngle => $composableBuilder(
    column: $table.arrowAngle,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeightEntriesTableOrderingComposer get weightEntryId {
    final $$WeightEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weightEntryId,
      referencedTable: $db.weightEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.weightEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeasurementPointsTableOrderingComposer get pointId {
    final $$MeasurementPointsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pointId,
      referencedTable: $db.measurementPoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementPointsTableOrderingComposer(
            $db: $db,
            $table: $db.measurementPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightMeasurementsTable> {
  $$WeightMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get valueCm =>
      $composableBuilder(column: $table.valueCm, builder: (column) => column);

  GeneratedColumn<double> get arrowX =>
      $composableBuilder(column: $table.arrowX, builder: (column) => column);

  GeneratedColumn<double> get arrowY =>
      $composableBuilder(column: $table.arrowY, builder: (column) => column);

  GeneratedColumn<double> get arrowAngle => $composableBuilder(
    column: $table.arrowAngle,
    builder: (column) => column,
  );

  $$WeightEntriesTableAnnotationComposer get weightEntryId {
    final $$WeightEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weightEntryId,
      referencedTable: $db.weightEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.weightEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeasurementPointsTableAnnotationComposer get pointId {
    final $$MeasurementPointsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.pointId,
          referencedTable: $db.measurementPoints,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementPointsTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementPoints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WeightMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightMeasurementsTable,
          WeightMeasurement,
          $$WeightMeasurementsTableFilterComposer,
          $$WeightMeasurementsTableOrderingComposer,
          $$WeightMeasurementsTableAnnotationComposer,
          $$WeightMeasurementsTableCreateCompanionBuilder,
          $$WeightMeasurementsTableUpdateCompanionBuilder,
          (WeightMeasurement, $$WeightMeasurementsTableReferences),
          WeightMeasurement,
          PrefetchHooks Function({bool weightEntryId, bool pointId})
        > {
  $$WeightMeasurementsTableTableManager(
    _$AppDatabase db,
    $WeightMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightMeasurementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weightEntryId = const Value.absent(),
                Value<int> pointId = const Value.absent(),
                Value<double> valueCm = const Value.absent(),
                Value<double> arrowX = const Value.absent(),
                Value<double> arrowY = const Value.absent(),
                Value<double> arrowAngle = const Value.absent(),
              }) => WeightMeasurementsCompanion(
                id: id,
                weightEntryId: weightEntryId,
                pointId: pointId,
                valueCm: valueCm,
                arrowX: arrowX,
                arrowY: arrowY,
                arrowAngle: arrowAngle,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weightEntryId,
                required int pointId,
                required double valueCm,
                Value<double> arrowX = const Value.absent(),
                Value<double> arrowY = const Value.absent(),
                Value<double> arrowAngle = const Value.absent(),
              }) => WeightMeasurementsCompanion.insert(
                id: id,
                weightEntryId: weightEntryId,
                pointId: pointId,
                valueCm: valueCm,
                arrowX: arrowX,
                arrowY: arrowY,
                arrowAngle: arrowAngle,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeightMeasurementsTable, WeightMeasurement>(
                    table,
                  ),
                  $$WeightMeasurementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weightEntryId = false, pointId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weightEntryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.weightEntryId,
                        referencedTable: $$WeightMeasurementsTableReferences
                            ._weightEntryIdTable(db),
                        referencedColumn: $$WeightMeasurementsTableReferences
                            ._weightEntryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (pointId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.pointId,
                        referencedTable: $$WeightMeasurementsTableReferences
                            ._pointIdTable(db),
                        referencedColumn: $$WeightMeasurementsTableReferences
                            ._pointIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeightMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightMeasurementsTable,
      WeightMeasurement,
      $$WeightMeasurementsTableFilterComposer,
      $$WeightMeasurementsTableOrderingComposer,
      $$WeightMeasurementsTableAnnotationComposer,
      $$WeightMeasurementsTableCreateCompanionBuilder,
      $$WeightMeasurementsTableUpdateCompanionBuilder,
      (WeightMeasurement, $$WeightMeasurementsTableReferences),
      WeightMeasurement,
      PrefetchHooks Function({bool weightEntryId, bool pointId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
  $$MealEntriesTableTableManager get mealEntries =>
      $$MealEntriesTableTableManager(_db, _db.mealEntries);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db, _db.weightEntries);
  $$MeasurementPointsTableTableManager get measurementPoints =>
      $$MeasurementPointsTableTableManager(_db, _db.measurementPoints);
  $$WeightMeasurementsTableTableManager get weightMeasurements =>
      $$WeightMeasurementsTableTableManager(_db, _db.weightMeasurements);
}
