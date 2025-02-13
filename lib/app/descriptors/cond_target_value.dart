import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:chaldea/app/descriptors/cond_target_num.dart';
import 'package:chaldea/models/models.dart';
import 'package:chaldea/utils/utils.dart';
import 'descriptor_base.dart';
import 'multi_entry.dart';

class CondTargetValueDescriptor extends StatelessWidget with DescriptorBase {
  final CondType condType;
  final int target;
  final int value;
  final String? forceFalseDescription;
  @override
  List<int> get targetIds => [target];
  @override
  final bool? useAnd;
  @override
  final TextStyle? style;
  @override
  final double? textScaleFactor;
  @override
  final InlineSpan? leading;
  final List<EventMission> missions;
  @override
  final String? unknownMsg;

  const CondTargetValueDescriptor({
    super.key,
    required this.condType,
    required this.target,
    required this.value,
    this.forceFalseDescription,
    this.style,
    this.textScaleFactor,
    this.leading,
    this.missions = const [],
    this.useAnd,
    this.unknownMsg,
  });
  CondTargetValueDescriptor.commonRelease({
    super.key,
    required CommonRelease commonRelease,
    this.forceFalseDescription,
    this.style,
    this.textScaleFactor,
    this.leading,
    this.missions = const [],
    this.useAnd,
    this.unknownMsg,
  })  : condType = commonRelease.condType,
        target = commonRelease.condId,
        value = commonRelease.condNum;

  @override
  List<InlineSpan> buildContent(BuildContext context) {
    switch (condType) {
      case CondType.none:
        return localized(
          jp: null,
          cn: null,
          tw: null,
          na: () => text('NONE'),
          kr: null,
        );
      case CondType.questClear:
        return localized(
          jp: () => combineToRich(context, null, quests(context), 'をクリアした'),
          cn: () => combineToRich(context, '通关', quests(context)),
          tw: null,
          na: () => combineToRich(context, 'Has cleared quest ', quests(context)),
          kr: null,
        );
      case CondType.questClearBeforeEventStart:
        return localized(
          jp: null,
          cn: () => combineToRich(
            context,
            '在活动',
            MultiDescriptor.events(context, [value]),
            '开始前通关',
            quests(context),
          ),
          tw: null,
          na: () => combineToRich(
              context, 'Clear ', quests(context), ' before event start', MultiDescriptor.events(context, [value])),
          kr: null,
        );
      case CondType.notQuestClearBeforeEventStart:
        return localized(
          jp: null,
          cn: () => combineToRich(
            context,
            '在活动',
            MultiDescriptor.events(context, [value]),
            '开始前未通关',
            quests(context),
          ),
          tw: null,
          na: () => combineToRich(context, 'Have not cleared ', quests(context), ' before event start',
              MultiDescriptor.events(context, [value])),
          kr: null,
        );
      case CondType.svtLimit:
        return localized(
          jp: () => combineToRich(context, null, servants(context), 'の霊基再臨を$value段階目にする'),
          cn: () => combineToRich(context, null, servants(context), '达到灵基再临第$value阶段'),
          tw: null,
          na: () => combineToRich(
            context,
            null,
            servants(context),
            ' at ascension $value',
          ),
          kr: null,
        );
      case CondType.svtGet:
        return localized(
          jp: () => combineToRich(context, null, servants(context), 'は霊基一覧の中にいる'),
          cn: () => combineToRich(context, null, servants(context), '在灵基一览中'),
          tw: null,
          na: () => combineToRich(
            context,
            null,
            servants(context),
            ' in Spirit Origin Collection',
          ),
          kr: null,
        );
      case CondType.svtFriendship:
        return localized(
          jp: () => combineToRich(context, null, servants(context), 'の絆レベルが$valueになる'),
          cn: () => combineToRich(context, null, servants(context), '的羁绊等级达到$value'),
          tw: null,
          na: () => combineToRich(
            context,
            null,
            servants(context),
            ' at bond level $value',
          ),
          kr: null,
        );
      case CondType.svtFriendshipBelow:
        return localized(
          jp: () => combineToRich(context, null, servants(context), 'の絆レベルは$value以下'),
          cn: () => combineToRich(context, null, servants(context), '的羁绊等级为$value或以下'),
          tw: null,
          na: () => combineToRich(
            context,
            null,
            servants(context),
            ' at bond level $value or lower',
          ),
          kr: null,
        );
      case CondType.svtFriendshipAbove:
        return localized(
          jp: () => combineToRich(context, null, servants(context), 'の絆レベルは$value以上'),
          cn: () => combineToRich(context, null, servants(context), '的羁绊等级为$value或以上'),
          tw: null,
          na: () => combineToRich(
            context,
            null,
            servants(context),
            ' at bond level $value',
          ),
          kr: null,
        );
      case CondType.costumeGet:
      case CondType.notCostumeGet:
      case CondType.purchaseShop:
      case CondType.notShopPurchase:
        return CondTargetNumDescriptor(
          condType: condType,
          targetNum: value,
          targetIds: [target],
          unknownMsg: unknownMsg,
        ).buildContent(context);
      case CondType.eventEnd:
        return localized(
          jp: () => combineToRich(context, 'イベント', events(context), 'は終了した'),
          cn: () => combineToRich(context, '活动', events(context), '结束'),
          tw: null,
          na: () => combineToRich(context, 'Event ', events(context), ' has ended'),
          kr: null,
        );
      case CondType.questNotClear:
        return localized(
          jp: () => combineToRich(context, null, quests(context), 'をクリアされていません'),
          cn: () => combineToRich(context, '未通关', quests(context)),
          tw: null,
          na: () => combineToRich(context, 'Has not cleared quest ', quests(context)),
          kr: null,
        );
      case CondType.svtHaving:
        return localized(
          jp: () => combineToRich(context, 'サーヴァント', servants(context), 'を持っている'),
          cn: () => combineToRich(context, '持有从者', servants(context)),
          tw: null,
          na: () => combineToRich(context, 'Presence of Servant ', servants(context)),
          kr: null,
        );
      case CondType.questClearPhase:
        return localized(
          jp: () => combineToRich(context, null, quests(context), '進行度$valueをクリアした'),
          cn: () => combineToRich(context, '已通关', quests(context), '进度$value'),
          tw: null,
          na: () => combineToRich(context, 'Has cleared arrow $value of quest', quests(context)),
          kr: null,
        );
      case CondType.notQuestClearPhase:
        return localized(
          jp: () => combineToRich(context, null, quests(context), '進行度$valueをクリアしていません'),
          cn: () => combineToRich(context, '未通关', quests(context), '进度$value'),
          tw: null,
          na: () => combineToRich(context, 'Has not cleared arrow $value of quest', quests(context)),
          kr: null,
        );
      case CondType.svtRecoverd:
        return localized(
          jp: null,
          cn: null,
          tw: null,
          na: () => text('Servant Recovered'),
          kr: null,
        );
      case CondType.eventRewardDispCount:
        return localized(
          jp: () => combineToRich(context, null, events(context), ' のイベントボイス、および少なくとも${value - 1}の他のボイスが再生されました'),
          cn: () => combineToRich(context, null, events(context), ' 活动语音，且至少${value - 1}条其他语音已播放过'),
          tw: null,
          na: () => combineToRich(context, 'Event ', events(context),
              ' reward voice line and at least ${value - 1} other reward lines played before this one'),
          kr: null,
        );
      case CondType.playerGenderType:
        bool isMale = target == 1;
        return localized(
          jp: () => text('使用${isMale ? "男性" : "女性"}主人公'),
          cn: () => text('使用${isMale ? "男性" : "女性"}主人公'),
          tw: null,
          na: () => text('Using ${isMale ? "male" : "female"} protagonist'),
          kr: null,
        );
      case CondType.forceFalse:
        final desc = forceFalseDescription == null ? '' : ' ($forceFalseDescription)';
        return localized(
          jp: () => text('不可能です$desc'),
          cn: () => text('不可能$desc'),
          tw: null,
          na: () => text('Not Possible$desc'),
          kr: null,
        );
      case CondType.limitCountAbove:
        return localized(
          jp: () => combineToRich(context, null, servants(context), 'の霊基再臨を ≥ $value段階目にする'),
          cn: () => combineToRich(context, '从者', servants(context), '的灵基再临 ≥ $value'),
          tw: null,
          na: () => combineToRich(
            context,
            'Servant',
            servants(context),
            ' at ascension ≥ $value',
          ),
          kr: null,
        );
      case CondType.limitCountBelow:
        return localized(
          jp: () => combineToRich(context, null, servants(context), 'の霊基再臨を ≤ $value段階目にする'),
          cn: () => combineToRich(context, '从者', servants(context), '的灵基再临 ≤ $value'),
          tw: null,
          na: () => combineToRich(
            context,
            'Servant',
            servants(context),
            ' at ascension ≤ $value',
          ),
          kr: null,
        );
      case CondType.date:
        // if (value == 0) return [];
        final time = DateTime.fromMillisecondsSinceEpoch(value * 1000).toStringShort(omitSec: true);
        return localized(
          jp: () => text('$time以降に開放'),
          cn: () => text('$time后开放'),
          tw: null,
          na: () => text('After $time'),
          kr: null,
        );
      case CondType.itemGet:
        return localized(
          jp: () => combineToRich(context, 'アイテム', items(context), '×$valueを持っている'),
          cn: () => combineToRich(context, '拥有', items(context), '×$value'),
          tw: null,
          na: () => combineToRich(context, 'Has ', items(context), '×$value'),
          kr: null,
        );
      case CondType.notItemGet:
        return localized(
          jp: () => combineToRich(context, 'アイテム', items(context), '×$valueを持っていません'),
          cn: () => combineToRich(context, '未拥有', items(context), '×$value'),
          tw: null,
          na: () => combineToRich(context, "Doesn't have ", items(context), '×$value'),
          kr: null,
        );
      case CondType.eventTotalPoint:
        // target=event id
        return localized(
          jp: () => text('イベントポイントを$value点獲得'),
          cn: () => text('活动点数达到$value点'),
          tw: null,
          na: () => text('Reach $value event points'),
          kr: null,
        );
      case CondType.eventMissionClear:
      case CondType.eventMissionAchieve:
        return CondTargetNumDescriptor(
          condType: condType,
          targetNum: 1,
          targetIds: [target],
          missions: missions,
          unknownMsg: unknownMsg,
        ).buildContent(context);
      case CondType.commonRelease:
        return localized(
          jp: null,
          cn: null,
          tw: null,
          na: () => combineToRich(context, 'Common Release', MultiDescriptor.commonRelease(context, [target])),
          kr: null,
        );
      case CondType.weekdays:
        List<String> weekdays = [];
        target;
        for (int day = 1; day <= 7; day++) {
          if (target & (1 << (day % 7 + 1)) != 0) {
            weekdays.add(DateFormat('EEEE').format(DateTime(2000, 1, 2 + day)));
          }
        }
        if (weekdays.isEmpty) break;
        return [TextSpan(text: weekdays.join(' / '))];
      default:
        break;
    }
    if (unknownMsg != null) return text(unknownMsg!);
    return localized(
      jp: () => text('不明な条件(${condType.name}): $value, $target'),
      cn: () => text('未知条件(${condType.name}): $value, $target'),
      tw: null,
      na: () => text('Unknown Cond(${condType.name}): $value, $target'),
      kr: null,
    );
  }
}
