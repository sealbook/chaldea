// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:chaldea/app/modules/skill/skill_detail.dart';
import 'package:chaldea/app/modules/skill/td_detail.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/utils/utils.dart';
import '../../app/app.dart';
import '../../app/tools/gamedata_loader.dart';
import '../db.dart';
import '_helper.dart';
import 'gamedata.dart';

export 'func.dart';
export 'vals.dart';
part '../../generated/models/gamedata/skill.g.dart';

const kActiveSkillNums = [1, 2, 3];
// actual num is 100,101,102
const kAppendSkillNums = [1, 2, 3];

abstract class SkillOrTd implements RouteInfo {
  int get id;
  String get name;
  Transl<String, String> get lName;
  String get ruby;
  String? get icon;
  String? get unmodifiedDetail;
  String? get lDetail;
  List<NiceFunction> get functions;
  SkillScript? get script;

  List<T> filteredFunction<T extends BaseFunction>({
    bool showPlayer = true,
    bool showEnemy = false,
    bool showNone = false,
    bool includeTrigger = false,
  }) {
    return NiceFunction.filterFuncs<T>(
      funcs: functions.cast(),
      showPlayer: showPlayer,
      showEnemy: showEnemy,
      showNone: showNone,
      includeTrigger: includeTrigger,
    ).toList();
  }

  String? get detail {
    if (unmodifiedDetail == null) return null;
    return unmodifiedDetail!.replaceAll(RegExp(r'\[/?[og]\]'), '');
  }
}

@JsonSerializable()
class BaseSkill extends SkillOrTd with RouteInfo {
  @override
  int id;
  int num;
  @override
  String name;
  @override
  String ruby;
  @override
  String? unmodifiedDetail; // String? detail;
  SkillType type;
  @override
  String? icon;
  List<int> coolDown;
  List<NiceTrait> actIndividuality;
  @override
  SkillScript? script;
  List<SkillAdd> skillAdd;
  Map<AiType, List<int>>? aiIds;
  List<SkillGroupOverwrite>? groupOverwrites;
  @override
  List<NiceFunction> functions;

  BaseSkill.create({
    required this.id,
    this.num = -1,
    required this.name,
    this.ruby = '',
    // this.detail,
    this.unmodifiedDetail,
    required this.type,
    this.icon,
    this.coolDown = const [0],
    this.actIndividuality = const [],
    this.script,
    this.skillAdd = const [],
    this.aiIds,
    this.groupOverwrites,
    required this.functions,
  });

  factory BaseSkill({
    required int id,
    int num = -1,
    required String name,
    String ruby = '',
    String? unmodifiedDetail,
    required SkillType type,
    String? icon,
    List<int> coolDown = const [0],
    List<NiceTrait> actIndividuality = const [],
    SkillScript? script,
    List<SkillAdd> skillAdd = const [],
    Map<AiType, List<int>>? aiIds,
    List<SkillGroupOverwrite>? groupOverwrites,
    required List<NiceFunction> functions,
  }) =>
      GameDataLoader.instance.tmp.getBaseSkill(
          id,
          () => BaseSkill.create(
                id: id,
                num: num,
                name: name,
                ruby: ruby,
                unmodifiedDetail: unmodifiedDetail,
                type: type,
                icon: icon,
                coolDown: coolDown,
                actIndividuality: actIndividuality,
                script: script,
                skillAdd: skillAdd,
                aiIds: aiIds,
                groupOverwrites: groupOverwrites,
                functions: functions,
              ));

  factory BaseSkill.fromJson(Map<String, dynamic> json) => _$BaseSkillFromJson(json);

  @override
  Transl<String, String> get lName => Transl.skillNames(name);

  int get maxLv => functions.firstOrNull?.svals.length ?? 0;

  @override
  String? get lDetail {
    if (unmodifiedDetail == null) return null;
    String content = Transl.skillDetail(detail ?? '').l;
    if (db.runtimeData.showSkillOriginText) return content;
    return content.replaceAll('{0}', 'Lv.').replaceFirstMapped(
      RegExp(r'\[servantName (\d+)\]'),
      (match) {
        final svt = db.gameData.servantsById[int.parse(match.group(1)!)];
        if (svt != null) {
          return svt.lName.l;
        }
        return match.group(0).toString();
      },
    );
  }

  bool isEventSkill(Event event) {
    return functions.any((func) {
      if (func.svals.getOrNull(0)?.EventId == event.id) return true;
      if (event.warIds.isNotEmpty) {
        if (<int>{for (final trait in func.funcquestTvals) ...?db.gameData.mappingData.fieldTrait[trait.id]?.warIds}
            .intersection(event.warIds.toSet())
            .isNotEmpty) {
          return true;
        }
      }
      return false;
    });
  }

  NiceSkill toNice() {
    return NiceSkill(
      id: id,
      name: name,
      ruby: ruby,
      unmodifiedDetail: unmodifiedDetail,
      type: type,
      icon: icon,
      coolDown: coolDown,
      actIndividuality: actIndividuality,
      script: script,
      skillAdd: skillAdd,
      aiIds: aiIds,
      functions: functions,
      num: -1,
      strengthStatus: 0,
      priority: 0,
      condQuestId: 0,
      condQuestPhase: 0,
      condLv: 0,
      condLimitCount: 0,
    );
  }

  @override
  String get route => Routes.skillI(id);
  @override
  void routeTo({Widget? child, bool popDetails = false, Region? region}) {
    return super.routeTo(
      child: child ?? SkillDetailPage(skill: this, region: region),
      popDetails: popDetails,
    );
  }

  Map<String, dynamic> toJson() => _$BaseSkillToJson(this);
}

@JsonSerializable()
class NiceSkill extends BaseSkill {
  BaseSkill _baseSkill;
  @override
  int get id => _baseSkill.id;
  @override
  String get name => _baseSkill.name;
  @override
  String get ruby => _baseSkill.ruby;
  @override
  String? get unmodifiedDetail => _baseSkill.unmodifiedDetail;
  @override
  SkillType get type => _baseSkill.type;
  @override
  String? get icon => _baseSkill.icon;
  @override
  List<int> get coolDown => _baseSkill.coolDown;
  @override
  List<NiceTrait> get actIndividuality => _baseSkill.actIndividuality;
  @override
  SkillScript? get script => _baseSkill.script;
  @override
  List<SkillAdd> get skillAdd => _baseSkill.skillAdd;
  @override
  Map<AiType, List<int>>? get aiIds => _baseSkill.aiIds;
  @override
  List<SkillGroupOverwrite>? get groupOverwrites => _baseSkill.groupOverwrites;
  @override
  List<NiceFunction> get functions => _baseSkill.functions;

  List<SkillSvt> skillSvts;
  int strengthStatus;
  int priority;
  int condQuestId;
  int condQuestPhase;
  int condLv;
  int condLimitCount;
  List<ExtraPassive> extraPassive;
  List<SvtSkillRelease> releaseConditions;

  NiceSkill({
    required super.id,
    required super.name,
    super.ruby = '',
    super.unmodifiedDetail,
    required super.type,
    super.icon,
    super.coolDown = const [0],
    super.actIndividuality = const [],
    super.script,
    super.skillAdd = const [],
    super.aiIds,
    super.groupOverwrites,
    super.functions = const [],
    // ignore: avoid_types_as_parameter_names
    super.num = 0,
    this.skillSvts = const [],
    this.strengthStatus = 0,
    this.priority = 0,
    this.condQuestId = 0,
    this.condQuestPhase = 0,
    this.condLv = 0,
    this.condLimitCount = 0,
    this.extraPassive = const [],
    this.releaseConditions = const [],
  })  : _baseSkill = BaseSkill(
          id: id,
          num: num,
          name: name,
          ruby: ruby,
          unmodifiedDetail: unmodifiedDetail,
          type: type,
          icon: icon,
          coolDown: coolDown,
          actIndividuality: actIndividuality,
          script: script,
          skillAdd: skillAdd,
          aiIds: aiIds,
          groupOverwrites: groupOverwrites,
          functions: functions,
        ),
        super.create();

  factory NiceSkill.fromJson(Map<String, dynamic> json) {
    if (json['type'] == null) {
      final baseSkill = GameDataLoader.instance.tmp.gameJson!['baseSkills']![json['id'].toString()]!;
      json.addAll(Map.from(baseSkill));
    }
    return _$NiceSkillFromJson(json);
  }

  bool isExtraPassiveEnabledForEvent(int eventId) {
    return extraPassive.any((e) {
      if (e.eventId == 0) {
        if (e.endedAt - e.startedAt > 90 * kSecsPerDay && e.endedAt > kNeverClosedTimestamp) {
          return true;
        } else {
          return false;
        }
      }
      if (e.eventId == eventId) return true;
      return false;
    });
  }

  @override
  Map<String, dynamic> toJson() => _$NiceSkillToJson(this);
}

@JsonSerializable()
class BaseTd extends SkillOrTd with RouteInfo {
  @override
  int id;
  CardType card;
  @override
  String name;
  @override
  String ruby;
  @override
  String? icon;
  String rank;
  String type;
  // The support flag is not accurate
  @protected
  List<TdEffectFlag> effectFlags;
  @override
  String? unmodifiedDetail;
  NpGain npGain;
  List<int> npDistribution;
  List<NiceTrait> individuality;
  @override
  SkillScript? script;
  @override
  List<NiceFunction> functions;

  BaseTd.create({
    required this.id,
    required this.card,
    required this.name,
    this.ruby = "",
    this.icon,
    required this.rank,
    required this.type,
    this.effectFlags = const [],
    // this.detail,
    this.unmodifiedDetail,
    required this.npGain,
    required this.npDistribution,
    this.individuality = const [],
    this.script,
    required this.functions,
  });

  factory BaseTd({
    required int id,
    required CardType card,
    required String name,
    String ruby = '',
    String? icon,
    required String rank,
    required String type,
    List<TdEffectFlag> effectFlags = const [],
    String? unmodifiedDetail,
    required NpGain npGain,
    required List<int> npDistribution,
    List<NiceTrait> individuality = const [],
    SkillScript? script,
    required List<NiceFunction> functions,
  }) =>
      GameDataLoader.instance.tmp.getBaseTd(
          id,
          () => BaseTd.create(
                id: id,
                card: card,
                name: name,
                ruby: ruby,
                icon: icon,
                rank: rank,
                type: type,
                effectFlags: effectFlags,
                unmodifiedDetail: unmodifiedDetail,
                npGain: npGain,
                npDistribution: npDistribution,
                individuality: individuality,
                script: script,
                functions: functions,
              ));

  factory BaseTd.fromJson(Map<String, dynamic> json) => _$BaseTdFromJson(json);
  TdEffectFlag? _damageType;

  TdEffectFlag get damageType {
    if (_damageType != null) return _damageType!;
    for (var func in functions) {
      // if (func.funcTargetTeam == FuncApplyTarget.enemy) continue;
      if (func.funcType.name.startsWith('damageNp')) {
        if ([
          FuncTargetType.enemyAll,
          FuncTargetType.enemyFull,
          FuncTargetType.enemyOtherFull,
          FuncTargetType.enemyOther
        ].contains(func.funcTargetType)) {
          _damageType = TdEffectFlag.attackEnemyAll;
        } else if ([
          FuncTargetType.enemy,
          FuncTargetType.enemyRandom,
          FuncTargetType.enemyOneAnotherRandom,
          FuncTargetType.enemyOneNoTargetNoAction,
          FuncTargetType.enemyAnother,
        ].contains(func.funcTargetType)) {
          _damageType = TdEffectFlag.attackEnemyOne;
        } else {
          assert(() {
            throw 'Unknown damageType: ${func.funcTargetType}';
          }());
        }
      }
    }
    return _damageType ??= TdEffectFlag.support;
  }

  @override
  Transl<String, String> get lName => Transl.tdNames(name);

  String get nameWithRank {
    if (['なし', '无', 'None', '無', '없음'].contains(rank)) return lName.l;
    return '${lName.l} $rank';
  }

  @override
  String? get lDetail {
    if (unmodifiedDetail == null) return null;
    final content = Transl.tdDetail(detail ?? '').l;
    if (db.runtimeData.showSkillOriginText) return content;
    return content.replaceAll('{0}', 'Lv.');
  }

  @override
  String get route => Routes.tdI(id);
  @override
  void routeTo({Widget? child, bool popDetails = false, Region? region}) {
    return super.routeTo(
      child: child ?? TdDetailPage(td: this, region: region),
      popDetails: popDetails,
    );
  }

  Map<String, dynamic> toJson() => _$BaseTdToJson(this);
}

@JsonSerializable()
class SkillSvt {
  int svtId;
  int num;
  int priority;
  Map? script; // "strengthStatusReleaseId": 40060301, (commonRelease)
  int strengthStatus;
  int condQuestId;
  int condQuestPhase;
  int condLv;
  int condLimitCount;
  int eventId;
  int flag;
  List<SvtSkillRelease> releaseConditions;

  SkillSvt({
    required this.svtId,
    this.num = -1,
    this.priority = 0,
    this.script,
    this.strengthStatus = 0,
    this.condQuestId = 0,
    this.condQuestPhase = 0,
    this.condLv = 0,
    this.condLimitCount = 0,
    this.eventId = 0,
    this.flag = 0,
    this.releaseConditions = const [],
  });

  factory SkillSvt.fromJson(Map<String, dynamic> json) => _$SkillSvtFromJson(json);

  Map<String, dynamic> toJson() => _$SkillSvtToJson(this);
}

@JsonSerializable()
class TdSvt {
  int svtId;
  int num;
  int priority;
  List<int> damage;
  int strengthStatus;
  int flag;
  int imageIndex;
  int condQuestId;
  int condQuestPhase;
  int condLv;
  int condFriendshipRank;
  int motion;
  CardType card;
  List<SvtSkillRelease> releaseConditions;

  TdSvt({
    required this.svtId,
    this.num = -1,
    this.priority = 0,
    this.damage = const [],
    this.strengthStatus = 0,
    this.flag = 0,
    this.imageIndex = 0,
    this.condQuestId = 0,
    this.condQuestPhase = 0,
    this.condLv = 0,
    this.condFriendshipRank = 0,
    this.motion = 0,
    this.card = CardType.none,
    this.releaseConditions = const [],
  });

  factory TdSvt.fromJson(Map<String, dynamic> json) => _$TdSvtFromJson(json);

  Map<String, dynamic> toJson() => _$TdSvtToJson(this);
}

@JsonSerializable()
class NiceTd extends BaseTd {
  BaseTd _baseTd;

  @override
  int get id => _baseTd.id;
  @override
  String get name => _baseTd.name;
  @override
  String get ruby => _baseTd.ruby;
  @override
  String get rank => _baseTd.rank;
  @override
  String get type => _baseTd.type;
  @override
  String? get unmodifiedDetail => _baseTd.unmodifiedDetail;
  @override
  NpGain get npGain => _baseTd.npGain;
  @override
  List<NiceTrait> get individuality => _baseTd.individuality;
  @override
  SkillScript? get script => _baseTd.script;
  @override
  List<NiceFunction> get functions => _baseTd.functions;

  // use it only for td fetched from api
  List<TdSvt> npSvts;

  int num;
  int strengthStatus;
  int priority;
  int condQuestId;
  int condQuestPhase;
  List<SvtSkillRelease> releaseConditions;

  NiceTd({
    required super.id,
    required this.num,
    required super.card,
    required super.name,
    super.ruby = "",
    super.icon,
    required super.rank,
    required super.type,
    List<TdEffectFlag> effectFlags = const [],
    // this.detail,
    super.unmodifiedDetail,
    required super.npGain,
    required super.npDistribution,
    required super.individuality,
    super.script,
    required super.functions,
    this.npSvts = const [],
    this.strengthStatus = 0,
    this.priority = 0,
    this.condQuestId = 0,
    this.condQuestPhase = 0,
    this.releaseConditions = const [],
  })  : _baseTd = BaseTd(
          id: id,
          card: card,
          name: name,
          ruby: ruby,
          icon: icon,
          rank: rank,
          type: type,
          effectFlags: effectFlags,
          unmodifiedDetail: unmodifiedDetail,
          npGain: npGain,
          npDistribution: npDistribution,
          individuality: individuality,
          script: script,
          functions: functions,
        ),
        super.create();

  factory NiceTd.fromJson(Map<String, dynamic> json) {
    if (json['type'] == null) {
      final baseTd = GameDataLoader.instance.tmp.gameJson!['baseTds']![json['id'].toString()]!;
      json = Map.from(baseTd)..addAll(json);
    }
    return _$NiceTdFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$NiceTdToJson(this);
}

@JsonSerializable()
class CommonRelease with RouteInfo {
  int id;
  int priority;
  int condGroup;
  @CondTypeConverter()
  CondType condType;
  int condId;
  int condNum;

  CommonRelease({
    required this.id,
    required this.priority,
    required this.condGroup,
    required this.condType,
    required this.condId,
    required this.condNum,
  });

  factory CommonRelease.fromJson(Map<String, dynamic> json) => _$CommonReleaseFromJson(json);

  @override
  String get route => Routes.commonRelease(id);

  Map<String, dynamic> toJson() => _$CommonReleaseToJson(this);
}

@JsonSerializable()
class ExtraPassive {
  int num;
  int priority;
  int condQuestId;
  int condQuestPhase;
  int condLv;
  int condLimitCount;
  int condFriendshipRank;
  int eventId;
  int flag;
  int startedAt;
  int endedAt;

  ExtraPassive({
    required this.num,
    required this.priority,
    this.condQuestId = 0,
    this.condQuestPhase = 0,
    this.condLv = 0,
    this.condLimitCount = 0,
    this.condFriendshipRank = 0,
    this.eventId = 0,
    this.flag = 0,
    required this.startedAt,
    required this.endedAt,
  });

  factory ExtraPassive.fromJson(Map<String, dynamic> json) => _$ExtraPassiveFromJson(json);

  Map<String, dynamic> toJson() => _$ExtraPassiveToJson(this);
}

@JsonSerializable(includeIfNull: false)
class SkillScript with DataScriptBase {
  final List<int>? NP_HIGHER; // lv, 50->50%
  final List<int>? NP_LOWER;
  final List<int>? STAR_HIGHER;
  final List<int>? STAR_LOWER;
  final List<int>? HP_VAL_HIGHER;
  final List<int>? HP_VAL_LOWER;
  final List<int>? HP_PER_HIGHER; // 500->50%
  final List<int>? HP_PER_LOWER;
  final List<int>? additionalSkillId;
  final List<int>? additionalSkillLv;
  final List<int>? additionalSkillActorType; // BattleLogicTask.ACTORTYPE
  final List<int>? tdTypeChangeIDs;
  final List<int>? excludeTdChangeTypes;
  final List<SkillSelectAddInfo>? SelectAddInfo;

  bool get isNotEmpty =>
      NP_HIGHER?.isNotEmpty == true ||
      NP_LOWER?.isNotEmpty == true ||
      STAR_HIGHER?.isNotEmpty == true ||
      STAR_LOWER?.isNotEmpty == true ||
      HP_VAL_HIGHER?.isNotEmpty == true ||
      HP_VAL_LOWER?.isNotEmpty == true ||
      HP_PER_HIGHER?.isNotEmpty == true ||
      HP_PER_LOWER?.isNotEmpty == true ||
      additionalSkillId?.isNotEmpty == true ||
      additionalSkillLv?.isNotEmpty == true ||
      additionalSkillActorType?.isNotEmpty == true ||
      tdTypeChangeIDs?.isNotEmpty == true ||
      SelectAddInfo?.isNotEmpty == true ||
      excludeTdChangeTypes?.isNotEmpty == true;

  SkillScript({
    this.NP_HIGHER,
    this.NP_LOWER,
    this.STAR_HIGHER,
    this.STAR_LOWER,
    this.HP_VAL_HIGHER,
    this.HP_VAL_LOWER,
    this.HP_PER_HIGHER,
    this.HP_PER_LOWER,
    this.additionalSkillId,
    this.additionalSkillLv,
    this.additionalSkillActorType,
    this.tdTypeChangeIDs,
    this.excludeTdChangeTypes,
    this.SelectAddInfo,
  });

  factory SkillScript.fromJson(Map<String, dynamic> json) => _$SkillScriptFromJson(json)..setSource(json);

  Map<String, dynamic> toJson() => _$SkillScriptToJson(this);
}

@JsonSerializable()
class SkillSelectAddInfo {
  final String title;
  final List<SkillSelectAddInfoBtn> btn;

  SkillSelectAddInfo({
    this.title = '',
    this.btn = const [],
  });

  factory SkillSelectAddInfo.fromJson(Map<String, dynamic> json) => _$SkillSelectAddInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SkillSelectAddInfoToJson(this);
}

@JsonSerializable()
class SkillSelectAddInfoBtn {
  final String name;
  final List<SkillSelectAddInfoBtnCond> conds;

  SkillSelectAddInfoBtn({
    this.name = '',
    this.conds = const [],
  });

  factory SkillSelectAddInfoBtn.fromJson(Map<String, dynamic> json) => _$SkillSelectAddInfoBtnFromJson(json);

  Map<String, dynamic> toJson() => _$SkillSelectAddInfoBtnToJson(this);
}

@JsonSerializable()
class SkillSelectAddInfoBtnCond {
  final SkillScriptCond cond;
  final int? value;

  SkillSelectAddInfoBtnCond({
    this.cond = SkillScriptCond.none,
    this.value,
  });

  factory SkillSelectAddInfoBtnCond.fromJson(Map<String, dynamic> json) => _$SkillSelectAddInfoBtnCondFromJson(json);

  Map<String, dynamic> toJson() => _$SkillSelectAddInfoBtnCondToJson(this);
}

@JsonSerializable()
class SkillAdd {
  int priority;
  List<CommonRelease> releaseConditions;
  String name;
  String ruby;

  SkillAdd({
    required this.priority,
    required this.releaseConditions,
    required this.name,
    required this.ruby,
  });

  factory SkillAdd.fromJson(Map<String, dynamic> json) => _$SkillAddFromJson(json);

  Map<String, dynamic> toJson() => _$SkillAddToJson(this);
}

@JsonSerializable(converters: [CondTypeConverter()])
class SvtSkillRelease {
  // int svtId;
  // int num;
  // int priority;
  int idx;

  /// [CondType.equipWithTargetCostume] for Mash and Melusine
  /// [CondType.questClear] or [CondType.questClearPhase] for 151-154 servants and Mysterious X, ignore.
  /// [CondType.svtLimit] max servant limit (0-4), not current display limitCount, ignore.
  CondType condType;
  int condTargetId; // svtId for equipWithTargetCostume
  int condNum; // display limitCount for equipWithTargetCostume
  int condGroup;

  SvtSkillRelease({
    // this.svtId = 0,
    // this.num = 0,
    // this.priority = 0,
    this.idx = 1,
    this.condType = CondType.none,
    this.condTargetId = 0,
    this.condNum = 0,
    this.condGroup = 0,
  });

  factory SvtSkillRelease.fromJson(Map<String, dynamic> json) => _$SvtSkillReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$SvtSkillReleaseToJson(this);
}

@JsonSerializable()
class SkillGroupOverwrite {
  int level;
  int skillGroupId;
  int startedAt;
  int endedAt;
  String? icon;
  // String detail;
  String unmodifiedDetail;
  // Since each skill level has their own group overwrite, the svals field only contains data for 1 level.
  List<NiceFunction> functions;

  SkillGroupOverwrite({
    required this.level,
    required this.skillGroupId,
    required this.startedAt,
    required this.endedAt,
    this.icon,
    this.unmodifiedDetail = '',
    this.functions = const [],
  });

  factory SkillGroupOverwrite.fromJson(Map<String, dynamic> json) => _$SkillGroupOverwriteFromJson(json);

  Map<String, dynamic> toJson() => _$SkillGroupOverwriteToJson(this);
}

@JsonSerializable()
class NpGain {
  List<int> buster;
  List<int> arts;
  List<int> quick;
  List<int> extra;
  List<int> np;
  List<int> defence;

  NpGain({
    required this.buster,
    required this.arts,
    required this.quick,
    required this.extra,
    required this.np,
    required this.defence,
  });

  List<int?> get firstValues => [
        buster.getOrNull(0),
        arts.getOrNull(0),
        quick.getOrNull(0),
        extra.getOrNull(0),
        np.getOrNull(0),
        defence.getOrNull(0),
      ];

  factory NpGain.fromJson(Map<String, dynamic> json) => _$NpGainFromJson(json);

  Map<String, dynamic> toJson() => _$NpGainToJson(this);
}

enum SkillType {
  active,
  passive,
  ;

  String get shortName {
    switch (this) {
      case SkillType.active:
        return S.current.active_skill_short;
      case SkillType.passive:
        return S.current.passive_skill_short;
    }
  }
}

enum TdEffectFlag {
  support,
  attackEnemyAll,
  attackEnemyOne,
}

enum AiType {
  svt,
  field,
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum SkillScriptCond {
  none,
  npHigher,
  npLower,
  starHigher,
  starLower,
  hpValHigher,
  hpValLower,
  hpPerHigher,
  hpPerLower,
  ;

  String get rawName => _$SkillScriptCondEnumMap[this] ?? name;
}
