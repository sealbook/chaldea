// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../models/userdata/battle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleSimSetting _$BattleSimSettingFromJson(Map json) => $checkedCreate(
      'BattleSimSetting',
      json,
      ($checkedConvert) {
        final val = BattleSimSetting(
          playerDataSource: $checkedConvert('playerDataSource',
              (v) => $enumDecodeNullable(_$PreferPlayerSvtDataSourceEnumMap, v) ?? PreferPlayerSvtDataSource.none),
          pingedCEs: $checkedConvert('pingedCEs', (v) => (v as List<dynamic>?)?.map((e) => e as int).toSet()),
          pingedSvts: $checkedConvert('pingedSvts', (v) => (v as List<dynamic>?)?.map((e) => e as int).toSet()),
          autoAdd7KnightsTrait: $checkedConvert('autoAdd7KnightsTrait', (v) => v as bool? ?? true),
          previousQuestPhase: $checkedConvert('previousQuestPhase', (v) => v as String?),
          defaultLvs: $checkedConvert('defaultLvs',
              (v) => v == null ? null : PlayerSvtDefaultData.fromJson(Map<String, dynamic>.from(v as Map))),
          formations: $checkedConvert(
              'formations',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => BattleTeamFormation.fromJson(Map<String, dynamic>.from(e as Map)))
                  .toList()),
          curFormationIndex: $checkedConvert('curFormationIndex', (v) => v as int? ?? 0),
          tdDmgOptions: $checkedConvert(
              'tdDmgOptions', (v) => v == null ? null : TdDamageOptions.fromJson(Map<String, dynamic>.from(v as Map))),
        );
        return val;
      },
    );

Map<String, dynamic> _$BattleSimSettingToJson(BattleSimSetting instance) => <String, dynamic>{
      'playerDataSource': _$PreferPlayerSvtDataSourceEnumMap[instance.playerDataSource]!,
      'pingedCEs': instance.pingedCEs.toList(),
      'pingedSvts': instance.pingedSvts.toList(),
      'autoAdd7KnightsTrait': instance.autoAdd7KnightsTrait,
      'previousQuestPhase': instance.previousQuestPhase,
      'defaultLvs': instance.defaultLvs.toJson(),
      'formations': instance.formations.map((e) => e.toJson()).toList(),
      'curFormationIndex': instance.curFormationIndex,
      'tdDmgOptions': instance.tdDmgOptions.toJson(),
    };

const _$PreferPlayerSvtDataSourceEnumMap = {
  PreferPlayerSvtDataSource.none: 'none',
  PreferPlayerSvtDataSource.current: 'current',
  PreferPlayerSvtDataSource.target: 'target',
};

BattleShareData _$BattleShareDataFromJson(Map json) => $checkedCreate(
      'BattleShareData',
      json,
      ($checkedConvert) {
        final val = BattleShareData(
          minVer: $checkedConvert('minVer', (v) => v as String?),
          quest: $checkedConvert(
              'quest', (v) => v == null ? null : BattleQuestInfo.fromJson(Map<String, dynamic>.from(v as Map))),
          team: $checkedConvert('team', (v) => BattleTeamFormation.fromJson(Map<String, dynamic>.from(v as Map))),
        );
        return val;
      },
    );

Map<String, dynamic> _$BattleShareDataToJson(BattleShareData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('minVer', instance.minVer);
  writeNotNull('quest', instance.quest?.toJson());
  val['team'] = instance.team.toJson();
  return val;
}

BattleQuestInfo _$BattleQuestInfoFromJson(Map json) => $checkedCreate(
      'BattleQuestInfo',
      json,
      ($checkedConvert) {
        final val = BattleQuestInfo(
          id: $checkedConvert('id', (v) => v as int),
          phase: $checkedConvert('phase', (v) => v as int),
          hash: $checkedConvert('hash', (v) => v as String?),
          region: $checkedConvert(
              'region', (v) => _$JsonConverterFromJson<String, Region>(v, const RegionConverter().fromJson)),
        );
        return val;
      },
    );

Map<String, dynamic> _$BattleQuestInfoToJson(BattleQuestInfo instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'phase': instance.phase,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('hash', instance.hash);
  writeNotNull('region', _$JsonConverterToJson<String, Region>(instance.region, const RegionConverter().toJson));
  return val;
}

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

BattleTeamFormation _$BattleTeamFormationFromJson(Map json) => $checkedCreate(
      'BattleTeamFormation',
      json,
      ($checkedConvert) {
        final val = BattleTeamFormation(
          name: $checkedConvert('name', (v) => v as String?),
          onFieldSvts: $checkedConvert(
              'onFieldSvts',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => e == null ? null : SvtSaveData.fromJson(Map<String, dynamic>.from(e as Map)))
                  .toList()),
          backupSvts: $checkedConvert(
              'backupSvts',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => e == null ? null : SvtSaveData.fromJson(Map<String, dynamic>.from(e as Map)))
                  .toList()),
          mysticCode: $checkedConvert(
              'mysticCode', (v) => v == null ? null : MysticCodeSaveData.fromJson(Map<String, dynamic>.from(v as Map))),
        );
        return val;
      },
    );

Map<String, dynamic> _$BattleTeamFormationToJson(BattleTeamFormation instance) => <String, dynamic>{
      'name': instance.name,
      'onFieldSvts': instance.onFieldSvts.map((e) => e?.toJson()).toList(),
      'backupSvts': instance.backupSvts.map((e) => e?.toJson()).toList(),
      'mysticCode': instance.mysticCode.toJson(),
    };

SvtSaveData _$SvtSaveDataFromJson(Map json) => $checkedCreate(
      'SvtSaveData',
      json,
      ($checkedConvert) {
        final val = SvtSaveData(
          svtId: $checkedConvert('svtId', (v) => v as int?),
          limitCount: $checkedConvert('limitCount', (v) => v as int? ?? 4),
          skillLvs: $checkedConvert('skillLvs', (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          skillIds: $checkedConvert('skillIds', (v) => (v as List<dynamic>?)?.map((e) => e as int?).toList()),
          appendLvs: $checkedConvert('appendLvs', (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          disabledExtraSkills:
              $checkedConvert('disabledExtraSkills', (v) => (v as List<dynamic>?)?.map((e) => e as int).toSet()),
          additionalPassives: $checkedConvert(
              'additionalPassives',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => BaseSkill.fromJson(Map<String, dynamic>.from(e as Map))).toList()),
          additionalPassiveLvs:
              $checkedConvert('additionalPassiveLvs', (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          tdId: $checkedConvert('tdId', (v) => v as int? ?? 0),
          tdLv: $checkedConvert('tdLv', (v) => v as int? ?? 5),
          lv: $checkedConvert('lv', (v) => v as int? ?? 1),
          atkFou: $checkedConvert('atkFou', (v) => v as int? ?? 1000),
          hpFou: $checkedConvert('hpFou', (v) => v as int? ?? 1000),
          fixedAtk: $checkedConvert('fixedAtk', (v) => v as int?),
          fixedHp: $checkedConvert('fixedHp', (v) => v as int?),
          ceId: $checkedConvert('ceId', (v) => v as int?),
          ceLimitBreak: $checkedConvert('ceLimitBreak', (v) => v as bool? ?? false),
          ceLv: $checkedConvert('ceLv', (v) => v as int? ?? 0),
          supportType: $checkedConvert(
              'supportType', (v) => $enumDecodeNullable(_$SupportSvtTypeEnumMap, v) ?? SupportSvtType.none),
          cardStrengthens:
              $checkedConvert('cardStrengthens', (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          commandCodeIds:
              $checkedConvert('commandCodeIds', (v) => (v as List<dynamic>?)?.map((e) => e as int?).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$SvtSaveDataToJson(SvtSaveData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('svtId', instance.svtId);
  val['limitCount'] = instance.limitCount;
  val['skillIds'] = instance.skillIds;
  val['skillLvs'] = instance.skillLvs;
  val['appendLvs'] = instance.appendLvs;
  val['disabledExtraSkills'] = instance.disabledExtraSkills.toList();
  val['additionalPassives'] = instance.additionalPassives.map((e) => e.toJson()).toList();
  val['additionalPassiveLvs'] = instance.additionalPassiveLvs;
  writeNotNull('tdId', instance.tdId);
  val['tdLv'] = instance.tdLv;
  val['lv'] = instance.lv;
  val['atkFou'] = instance.atkFou;
  val['hpFou'] = instance.hpFou;
  writeNotNull('fixedAtk', instance.fixedAtk);
  writeNotNull('fixedHp', instance.fixedHp);
  writeNotNull('ceId', instance.ceId);
  val['ceLimitBreak'] = instance.ceLimitBreak;
  val['ceLv'] = instance.ceLv;
  val['supportType'] = _$SupportSvtTypeEnumMap[instance.supportType]!;
  val['cardStrengthens'] = instance.cardStrengthens;
  val['commandCodeIds'] = instance.commandCodeIds;
  return val;
}

const _$SupportSvtTypeEnumMap = {
  SupportSvtType.none: 'none',
  SupportSvtType.friend: 'friend',
  SupportSvtType.npc: 'npc',
};

MysticCodeSaveData _$MysticCodeSaveDataFromJson(Map json) => $checkedCreate(
      'MysticCodeSaveData',
      json,
      ($checkedConvert) {
        final val = MysticCodeSaveData(
          mysticCodeId: $checkedConvert('mysticCodeId', (v) => v as int? ?? 210),
          level: $checkedConvert('level', (v) => v as int? ?? 10),
        );
        return val;
      },
    );

Map<String, dynamic> _$MysticCodeSaveDataToJson(MysticCodeSaveData instance) => <String, dynamic>{
      'mysticCodeId': instance.mysticCodeId,
      'level': instance.level,
    };

PlayerSvtDefaultData _$PlayerSvtDefaultDataFromJson(Map json) => $checkedCreate(
      'PlayerSvtDefaultData',
      json,
      ($checkedConvert) {
        final val = PlayerSvtDefaultData(
          lv: $checkedConvert('lv', (v) => v as int? ?? 90),
          useMaxLv: $checkedConvert('useMaxLv', (v) => v as bool? ?? true),
          tdLv: $checkedConvert('tdLv', (v) => v as int? ?? 5),
          useDefaultTdLv: $checkedConvert('useDefaultTdLv', (v) => v as bool? ?? true),
          limitCount: $checkedConvert('limitCount', (v) => v as int? ?? 4),
          activeSkillLv: $checkedConvert('activeSkillLv', (v) => v as int? ?? 10),
          appendLvs: $checkedConvert('appendLvs', (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          atkFou: $checkedConvert('atkFou', (v) => v as int? ?? 100),
          hpFou: $checkedConvert('hpFou', (v) => v as int? ?? 100),
          cardStrengthens:
              $checkedConvert('cardStrengthens', (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          ceMaxLimitBreak: $checkedConvert('ceMaxLimitBreak', (v) => v as bool? ?? false),
          ceMaxLv: $checkedConvert('ceMaxLv', (v) => v as bool? ?? false),
        );
        return val;
      },
    );

Map<String, dynamic> _$PlayerSvtDefaultDataToJson(PlayerSvtDefaultData instance) => <String, dynamic>{
      'useMaxLv': instance.useMaxLv,
      'lv': instance.lv,
      'useDefaultTdLv': instance.useDefaultTdLv,
      'tdLv': instance.tdLv,
      'limitCount': instance.limitCount,
      'activeSkillLv': instance.activeSkillLv,
      'appendLvs': instance.appendLvs,
      'atkFou': instance.atkFou,
      'hpFou': instance.hpFou,
      'cardStrengthens': instance.cardStrengthens,
      'ceMaxLimitBreak': instance.ceMaxLimitBreak,
      'ceMaxLv': instance.ceMaxLv,
    };

CustomSkillData _$CustomSkillDataFromJson(Map json) => $checkedCreate(
      'CustomSkillData',
      json,
      ($checkedConvert) {
        final val = CustomSkillData(
          skillId: $checkedConvert('skillId', (v) => v as int?),
          name: $checkedConvert('name', (v) => v as String? ?? ''),
          cd: $checkedConvert('cd', (v) => v as int? ?? 0),
          skillType:
              $checkedConvert('skillType', (v) => $enumDecodeNullable(_$SkillTypeEnumMap, v) ?? SkillType.passive),
          effects: $checkedConvert(
              'effects',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => CustomFuncData.fromJson(Map<String, dynamic>.from(e as Map)))
                  .toList()),
          buffOnly: $checkedConvert('buffOnly', (v) => v as bool? ?? false),
          hasTurnCount: $checkedConvert('hasTurnCount', (v) => v as bool? ?? true),
        );
        return val;
      },
    );

Map<String, dynamic> _$CustomSkillDataToJson(CustomSkillData instance) => <String, dynamic>{
      'skillId': instance.skillId,
      'name': instance.name,
      'cd': instance.cd,
      'skillType': _$SkillTypeEnumMap[instance.skillType]!,
      'effects': instance.effects.map((e) => e.toJson()).toList(),
      'buffOnly': instance.buffOnly,
      'hasTurnCount': instance.hasTurnCount,
    };

const _$SkillTypeEnumMap = {
  SkillType.active: 'active',
  SkillType.passive: 'passive',
};

CustomFuncData _$CustomFuncDataFromJson(Map json) => $checkedCreate(
      'CustomFuncData',
      json,
      ($checkedConvert) {
        final val = CustomFuncData(
          funcId: $checkedConvert('funcId', (v) => v as int?),
          buffId: $checkedConvert('buffId', (v) => v as int?),
          turn: $checkedConvert('turn', (v) => v as int? ?? -1),
          count: $checkedConvert('count', (v) => v as int? ?? -1),
          rate: $checkedConvert('rate', (v) => v as int? ?? 5000),
          value: $checkedConvert('value', (v) => v as int? ?? 0),
          enabled: $checkedConvert('enabled', (v) => v as bool? ?? false),
          useValue: $checkedConvert('useValue', (v) => v as bool? ?? true),
          target:
              $checkedConvert('target', (v) => $enumDecodeNullable(_$FuncTargetTypeEnumMap, v) ?? FuncTargetType.self),
        );
        return val;
      },
    );

Map<String, dynamic> _$CustomFuncDataToJson(CustomFuncData instance) => <String, dynamic>{
      'funcId': instance.funcId,
      'buffId': instance.buffId,
      'turn': instance.turn,
      'count': instance.count,
      'rate': instance.rate,
      'value': instance.value,
      'enabled': instance.enabled,
      'useValue': instance.useValue,
      'target': _$FuncTargetTypeEnumMap[instance.target]!,
    };

const _$FuncTargetTypeEnumMap = {
  FuncTargetType.self: 'self',
  FuncTargetType.ptOne: 'ptOne',
  FuncTargetType.ptAnother: 'ptAnother',
  FuncTargetType.ptAll: 'ptAll',
  FuncTargetType.enemy: 'enemy',
  FuncTargetType.enemyAnother: 'enemyAnother',
  FuncTargetType.enemyAll: 'enemyAll',
  FuncTargetType.ptFull: 'ptFull',
  FuncTargetType.enemyFull: 'enemyFull',
  FuncTargetType.ptOther: 'ptOther',
  FuncTargetType.ptOneOther: 'ptOneOther',
  FuncTargetType.ptRandom: 'ptRandom',
  FuncTargetType.enemyOther: 'enemyOther',
  FuncTargetType.enemyRandom: 'enemyRandom',
  FuncTargetType.ptOtherFull: 'ptOtherFull',
  FuncTargetType.enemyOtherFull: 'enemyOtherFull',
  FuncTargetType.ptselectOneSub: 'ptselectOneSub',
  FuncTargetType.ptselectSub: 'ptselectSub',
  FuncTargetType.ptOneAnotherRandom: 'ptOneAnotherRandom',
  FuncTargetType.ptSelfAnotherRandom: 'ptSelfAnotherRandom',
  FuncTargetType.enemyOneAnotherRandom: 'enemyOneAnotherRandom',
  FuncTargetType.ptSelfAnotherFirst: 'ptSelfAnotherFirst',
  FuncTargetType.ptSelfBefore: 'ptSelfBefore',
  FuncTargetType.ptSelfAfter: 'ptSelfAfter',
  FuncTargetType.ptSelfAnotherLast: 'ptSelfAnotherLast',
  FuncTargetType.commandTypeSelfTreasureDevice: 'commandTypeSelfTreasureDevice',
  FuncTargetType.fieldOther: 'fieldOther',
  FuncTargetType.enemyOneNoTargetNoAction: 'enemyOneNoTargetNoAction',
  FuncTargetType.ptOneHpLowestValue: 'ptOneHpLowestValue',
  FuncTargetType.ptOneHpLowestRate: 'ptOneHpLowestRate',
  FuncTargetType.enemyRange: 'enemyRange',
};

TdDamageOptions _$TdDamageOptionsFromJson(Map json) => $checkedCreate(
      'TdDamageOptions',
      json,
      ($checkedConvert) {
        final val = TdDamageOptions(
          enemy: $checkedConvert(
              'enemy',
              (v) =>
                  _$JsonConverterFromJson<Map<dynamic, dynamic>, QuestEnemy>(v, const _QuestEnemyConverter().fromJson)),
          supports: $checkedConvert('supports', (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          enemyCount: $checkedConvert('enemyCount', (v) => v as int? ?? 1),
          usePlayerSvt: $checkedConvert('usePlayerSvt',
              (v) => $enumDecodeNullable(_$PreferPlayerSvtDataSourceEnumMap, v) ?? PreferPlayerSvtDataSource.none),
          addDebuffImmune: $checkedConvert('addDebuffImmune', (v) => v as bool? ?? true),
          addDebuffImmuneEnemy: $checkedConvert('addDebuffImmuneEnemy', (v) => v as bool? ?? false),
          upResistSubState: $checkedConvert('upResistSubState', (v) => v as bool? ?? true),
          enableActiveSkills: $checkedConvert('enableActiveSkills', (v) => v as bool? ?? true),
          twiceActiveSkill: $checkedConvert('twiceActiveSkill', (v) => v as bool? ?? false),
          enableAppendSkills: $checkedConvert('enableAppendSkills', (v) => v as bool? ?? false),
          svtLv: $checkedConvert('svtLv', (v) => $enumDecodeNullable(_$SvtLvEnumMap, v) ?? SvtLv.maxLv),
          tdR3: $checkedConvert('tdR3', (v) => v as int? ?? 5),
          tdR4: $checkedConvert('tdR4', (v) => v as int? ?? 2),
          tdR5: $checkedConvert('tdR5', (v) => v as int? ?? 1),
          oc: $checkedConvert('oc', (v) => v as int? ?? 1),
          fixedOC: $checkedConvert('fixedOC', (v) => v as bool? ?? true),
          region:
              $checkedConvert('region', (v) => v == null ? Region.jp : const RegionConverter().fromJson(v as String)),
          ceId: $checkedConvert('ceId', (v) => v as int?),
          ceLv: $checkedConvert('ceLv', (v) => v as int? ?? 0),
          ceMLB: $checkedConvert('ceMLB', (v) => v as bool? ?? true),
          mcId: $checkedConvert('mcId', (v) => v as int?),
          mcLv: $checkedConvert('mcLv', (v) => v as int? ?? 10),
          extraBuffs: $checkedConvert(
              'extraBuffs', (v) => v == null ? null : CustomSkillData.fromJson(Map<String, dynamic>.from(v as Map))),
          fixedRandom: $checkedConvert('fixedRandom', (v) => v as int? ?? 1000),
          probabilityThreshold: $checkedConvert('probabilityThreshold', (v) => v as int? ?? 1000),
          forceDamageNpSe: $checkedConvert('forceDamageNpSe', (v) => v as bool? ?? false),
          damageNpIndivSumCount: $checkedConvert('damageNpIndivSumCount', (v) => v as int?),
          damageNpHpRatioMax: $checkedConvert('damageNpHpRatioMax', (v) => v as bool? ?? false),
        );
        return val;
      },
    );

Map<String, dynamic> _$TdDamageOptionsToJson(TdDamageOptions instance) => <String, dynamic>{
      'enemy': const _QuestEnemyConverter().toJson(instance.enemy),
      'supports': instance.supports,
      'enemyCount': instance.enemyCount,
      'usePlayerSvt': _$PreferPlayerSvtDataSourceEnumMap[instance.usePlayerSvt]!,
      'addDebuffImmune': instance.addDebuffImmune,
      'addDebuffImmuneEnemy': instance.addDebuffImmuneEnemy,
      'upResistSubState': instance.upResistSubState,
      'enableActiveSkills': instance.enableActiveSkills,
      'twiceActiveSkill': instance.twiceActiveSkill,
      'enableAppendSkills': instance.enableAppendSkills,
      'svtLv': _$SvtLvEnumMap[instance.svtLv]!,
      'tdR3': instance.tdR3,
      'tdR4': instance.tdR4,
      'tdR5': instance.tdR5,
      'oc': instance.oc,
      'fixedOC': instance.fixedOC,
      'region': const RegionConverter().toJson(instance.region),
      'ceId': instance.ceId,
      'ceLv': instance.ceLv,
      'ceMLB': instance.ceMLB,
      'mcId': instance.mcId,
      'mcLv': instance.mcLv,
      'extraBuffs': instance.extraBuffs.toJson(),
      'fixedRandom': instance.fixedRandom,
      'probabilityThreshold': instance.probabilityThreshold,
      'forceDamageNpSe': instance.forceDamageNpSe,
      'damageNpIndivSumCount': instance.damageNpIndivSumCount,
      'damageNpHpRatioMax': instance.damageNpHpRatioMax,
    };

const _$SvtLvEnumMap = {
  SvtLv.maxLv: 'maxLv',
  SvtLv.lv90: 'lv90',
  SvtLv.lv100: 'lv100',
  SvtLv.lv120: 'lv120',
};
