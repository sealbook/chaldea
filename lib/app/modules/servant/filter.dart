import 'dart:math';

import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/gamedata/effect.dart';
import 'package:chaldea/models/models.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:chaldea/widgets/widgets.dart';
import '../common/filter_group.dart';
import '../common/filter_page_base.dart';
import '../effect_search/util.dart';

class ServantFilterPage extends FilterPage<SvtFilterData> {
  final bool planMode;
  final bool showSort;

  const ServantFilterPage({
    super.key,
    required super.filterData,
    super.onChanged,
    required this.planMode,
    this.showSort = true,
  });

  @override
  _ServantFilterPageState createState() => _ServantFilterPageState();

  static bool filter(SvtFilterData filterData, Servant svt, {bool planMode = false}) {
    final svtStat = db.curUser.svtStatusOf(svt.collectionNo);
    final svtPlan = db.curUser.svtPlanOf(svt.collectionNo);
    final favoriteState = planMode ? filterData.planFavorite : filterData.favorite;
    if (!favoriteState.check(svtStat.cur.favorite)) {
      return false;
    }

    if (filterData.planCompletion.options.isNotEmpty) {
      if (!svtStat.favorite) return false;
      final planCompletion = <SvtPlanScope>[
        if (svtPlan.ascension > svtStat.cur.ascension) SvtPlanScope.ascension,
        if ([for (var i = 0; i < 3; i++) svtPlan.skills[i] > svtStat.cur.skills[i]].any((e) => e)) SvtPlanScope.active,
        if ([for (var i = 0; i < 3; i++) svtPlan.appendSkills[i] > svtStat.cur.appendSkills[i]].any((e) => e))
          SvtPlanScope.append,
        if ([
          for (var costume in svt.profile.costume.values)
            (svtPlan.costumes[costume.battleCharaId] ?? 0) > (svtStat.cur.costumes[costume.battleCharaId] ?? 0)
        ].any((e) => e))
          SvtPlanScope.costume,
        if ([
          svtPlan.grail > svtStat.cur.grail,
          svtPlan.fouHp > svtStat.cur.fouHp,
          svtPlan.fouAtk > svtStat.cur.fouAtk,
          svtPlan.fouHp3 > svtStat.cur.fouHp3,
          svtPlan.fouAtk3 > svtStat.cur.fouAtk3,
          svtPlan.bondLimit > svtStat.cur.bondLimit,
        ].any((e) => e))
          SvtPlanScope.misc,
      ];
      if (!filterData.planCompletion.matchAny(planCompletion)) return false;
    }
    // svt data filter
    // skill level
    if (filterData.activeSkillLevel.options.isNotEmpty) {
      if (!svtStat.favorite) return false;
      int lowestSkill = svtStat.cur.skills.reduce((a, b) => min(a, b));
      final skillState = lowestSkill == 10
          ? SvtSkillLevelState.max10
          : lowestSkill == 9
              ? SvtSkillLevelState.max9
              : SvtSkillLevelState.normal;
      if (!filterData.activeSkillLevel.matchOne(skillState)) {
        return false;
      }
    }
    if (!filterData.svtDuplicated.matchOne(svt.collectionNo != svt.originalCollectionNo)) {
      return false;
    }
    if (!filterData.bond.matchOne(svtStat.bond < 5 ? 1 : (svtStat.bond < 10 ? 2 : 3))) {
      return false;
    }

    // class name
    if (!filterData.svtClass.matchOne(svt.className, compare: SvtClassX.match)) {
      return false;
    }
    if (!filterData.rarity.matchOne(svt.rarity)) {
      return false;
    }

    if (filterData.npColor.options.isNotEmpty && filterData.npType.options.isNotEmpty) {
      if (!svt.noblePhantasms
          .any((np) => filterData.npColor.contain(np.card) && filterData.npType.contain(np.damageType))) {
        return false;
      }
    } else {
      if (!filterData.npColor.matchAny(svt.noblePhantasms.map((e) => e.card).toList())) {
        return false;
      }
      if (!filterData.npType.matchAny(svt.noblePhantasms.map((e) => e.damageType))) {
        return false;
      }
    }

    // plan status
    if (!filterData.priority.matchOne(svtStat.priority)) {
      return false;
    }
    // end plan status

    final region = filterData.region.radioValue;
    if (region != null && region != Region.jp) {
      final released = db.gameData.mappingData.svtRelease.ofRegion(region);
      if (released?.contains(svt.collectionNo) == false) {
        return false;
      }
    }

    if (!filterData.obtain.matchAny(svt.extra.obtains)) {
      return false;
    }

    if (!filterData.attribute.matchOne(svt.attribute)) {
      return false;
    }
    if (!filterData.policy.matchOne(svt.profile.stats?.policy ?? ServantPolicy.none)) {
      return false;
    }
    if (!filterData.personality.matchOne(svt.profile.stats?.personality ?? ServantPersonality.none)) {
      return false;
    }
    if (!filterData.gender.matchOne(svt.gender)) {
      return false;
    }
    if (!filterData.trait.matchAny(svt.traitsAll.map((e) => kTraitIdMapping[e] ?? Trait.unknown))) {
      return false;
    }
    if (filterData.effectType.isNotEmpty || filterData.targetTrait.isNotEmpty || filterData.effectTarget.isNotEmpty) {
      List<BaseFunction> funcs = [
        if (filterData.effectScope.contain(SvtEffectScope.active))
          for (final skill in svt.skills) ...skill.filteredFunction(includeTrigger: true),
        if (filterData.effectScope.contain(SvtEffectScope.passive))
          for (final skill in svt.classPassive) ...skill.filteredFunction(includeTrigger: true),
        if (filterData.effectScope.contain(SvtEffectScope.passive))
          for (final skill in svt.extraPassive)
            if (skill.extraPassive.any((e) => e.eventId == 0)) ...skill.filteredFunction(includeTrigger: true),
        if (filterData.effectScope.contain(SvtEffectScope.append))
          for (final skill in svt.appendPassive) ...skill.skill.filteredFunction(includeTrigger: true),
        if (filterData.effectScope.contain(SvtEffectScope.td))
          for (final td in svt.noblePhantasms) ...td.filteredFunction(includeTrigger: true),
      ];
      if (filterData.effectTarget.isNotEmpty) {
        funcs.retainWhere((func) {
          return filterData.effectTarget.matchOne(EffectTarget.fromFunc(func.funcTargetType));
        });
      }
      if (filterData.targetTrait.isNotEmpty) {
        funcs.retainWhere((func) => EffectFilterUtil.checkFuncTraits(func, filterData.targetTrait));
      }
      if (funcs.isEmpty) return false;
      if (filterData.effectType.options.isEmpty) return true;
      if (filterData.effectType.matchAll) {
        if (!filterData.effectType.options.every((effect) => funcs.any((func) => effect.match(func)))) {
          return false;
        }
      } else {
        if (!filterData.effectType.options.any((effect) => funcs.any((func) => effect.match(func)))) {
          return false;
        }
      }
    }
    return true;
  }
}

class _ServantFilterPageState extends FilterPageState<SvtFilterData, ServantFilterPage> {
  int _lastResetTime = 0;

  @override
  Widget build(BuildContext context) {
    return buildAdaptive(
      title: Text(S.current.filter, textScaleFactor: 0.8),
      actions: getDefaultActions(onTapReset: () {
        filterData.reset();
        final now = DateTime.now().timestamp;
        if (now - _lastResetTime < 2) {
          filterData.favorite = FavoriteState.all;
        }
        _lastResetTime = now;
        update();
      }),
      content: getListViewBody(restorationId: 'svt_list_filter', children: [
        getGroup(
          header: S.current.filter_shown_type,
          children: [
            FilterGroup.display(
              useGrid: filterData.useGrid,
              onChanged: (v) {
                if (v != null) filterData.useGrid = v;
                update();
              },
            ),
            FilterGroup<FavoriteState>(
              options: FavoriteState.values,
              combined: true,
              values: FilterRadioData.nonnull(widget.planMode ? filterData.planFavorite : filterData.favorite),
              padding: EdgeInsets.zero,
              optionBuilder: (v) {
                return Text.rich(TextSpan(children: [
                  CenterWidgetSpan(child: Icon(v.icon, size: 16)),
                  TextSpan(text: v.shownName),
                ]));
              },
              onFilterChanged: (v, _) {
                if (widget.planMode) {
                  filterData.planFavorite = v.radioValue!;
                } else {
                  filterData.favorite = v.radioValue!;
                }
                update();
              },
            ),
          ],
        ),
        if (widget.showSort)
          getGroup(header: S.current.filter_sort, children: [
            for (int i = 0; i < min(4, filterData.sortKeys.length); i++)
              getSortButton<SvtCompare>(
                prefix: '${i + 1}',
                value: filterData.sortKeys[i],
                items: {for (final e in SvtCompare.values) e: e.showName},
                onSortAttr: (key) {
                  filterData.sortKeys[i] = key ?? filterData.sortKeys[i];
                  update();
                },
                reversed: filterData.sortReversed[i],
                onSortDirectional: (reversed) {
                  filterData.sortReversed[i] = reversed;
                  update();
                },
              ),
          ]),
        buildClassFilter(filterData.svtClass),
        FilterGroup<int>(
          title: Text(S.current.filter_sort_rarity, style: textStyle),
          options: const [0, 1, 2, 3, 4, 5],
          values: filterData.rarity,
          optionBuilder: (v) => Text('$v$kStarChar'),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<CardType>(
          title: Text(S.current.noble_phantasm, style: textStyle),
          options: const [CardType.arts, CardType.buster, CardType.quick],
          values: filterData.npColor,
          optionBuilder: (v) => Text(v.name.toTitle()),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<TdEffectFlag>(
          values: filterData.npType,
          options: TdEffectFlag.values,
          optionBuilder: (v) => Text(Transl.enums(v, (enums) => enums.tdEffectFlag).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        buildGroupDivider(text: S.current.plan),
        FilterGroup<int>(
          title: Text('${S.current.priority} (${S.current.display_setting} - ${S.current.setting_priority_tagging})',
              style: textStyle),
          options: const [1, 2, 3, 4, 5],
          values: filterData.priority,
          optionBuilder: (value) {
            String text = value.toString();
            final tag = db.settings.priorityTags[value];
            if (tag != null && tag.isNotEmpty) {
              text += ' $tag';
            }
            return Text(text);
          },
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<SvtPlanScope>(
          title: Text(S.current.filter_plan_not_reached, style: textStyle),
          options: SvtPlanScope.values,
          values: filterData.planCompletion,
          showMatchAll: true,
          optionBuilder: (v) {
            String text;
            switch (v) {
              case SvtPlanScope.all:
                text = '(${S.current.general_all})';
                break;
              case SvtPlanScope.ascension:
                text = S.current.ascension_short;
                break;
              case SvtPlanScope.active:
                text = S.current.active_skill_short;
                break;
              case SvtPlanScope.append:
                text = S.current.append_skill_short;
                break;
              case SvtPlanScope.costume:
                text = S.current.costume;
                break;
              case SvtPlanScope.misc:
                text = S.current.general_others;
                break;
            }
            return Text(text);
          },
          onFilterChanged: (value, lastChanged) {
            if (lastChanged == SvtPlanScope.all) {
              if (value.contain(SvtPlanScope.all)) {
                value.options = SvtPlanScope.values.toSet();
              } else {
                value.options.clear();
              }
            } else if (lastChanged != null) {
              value.options.remove(SvtPlanScope.all);
            }
            update();
          },
        ),
        FilterGroup<SvtSkillLevelState>(
          title: Text(S.current.active_skill),
          options: SvtSkillLevelState.values,
          values: filterData.activeSkillLevel,
          optionBuilder: (v) {
            switch (v) {
              case SvtSkillLevelState.normal:
                return const Text('<999');
              case SvtSkillLevelState.max9:
                return const Text('999');
              case SvtSkillLevelState.max10:
                return const Text('10/10/10');
            }
          },
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<bool>(
          title: Text(S.current.duplicated_servant),
          options: const [false, true],
          values: filterData.svtDuplicated,
          optionBuilder: (v) =>
              Text(v ? S.current.duplicated_servant_duplicated : S.current.duplicated_servant_primary),
          onFilterChanged: (v, _) {
            setState(() {
              update();
            });
          },
        ),
        FilterGroup<int>(
          title: Text(S.current.bond),
          options: const [1, 2, 3],
          values: filterData.bond,
          optionBuilder: (v) {
            String text = (v * 5).toString();
            text = (v == 3 ? '≤' : '<') + text;
            return Text(text);
          },
          onFilterChanged: (v, _) {
            setState(() {
              update();
            });
          },
        ),
        buildGroupDivider(text: S.current.gamedata),
        FilterGroup<Region>(
          title: Text(S.current.game_server, style: textStyle),
          options: Region.values,
          values: filterData.region,
          optionBuilder: (v) => Text(v.localName),
          onFilterChanged: (v, _) {
            update();
          },
        ),
        FilterGroup<SvtObtain>(
          title: Text(S.current.filter_obtain, style: textStyle),
          options: SvtObtain.values,
          values: filterData.obtain,
          optionBuilder: (v) => Text(Transl.svtObtain(v).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<Attribute>(
          title: Text(S.current.filter_attribute, style: textStyle),
          options: Attribute.values.sublist(0, 5),
          values: filterData.attribute,
          optionBuilder: (v) => Text(Transl.svtAttribute(v).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<ServantPolicy>(
          title: Text(S.current.info_alignment, style: textStyle),
          options: ServantPolicy.values.sublist(1, ServantPolicy.values.length - 1),
          values: filterData.policy,
          optionBuilder: (v) => Text(Transl.servantPolicy(v).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<ServantPersonality>(
          values: filterData.personality,
          options: ServantPersonality.values.sublist(1, ServantPersonality.values.length - 1),
          optionBuilder: (v) => Text(Transl.servantPersonality(v).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<Gender>(
          title: Text(S.current.gender, style: textStyle),
          options: Gender.values.toList(),
          values: filterData.gender,
          optionBuilder: (v) => Text(Transl.gender(v).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<Trait>(
          title: Text(S.current.trait, style: textStyle),
          options: _traitsForFilter,
          values: filterData.trait,
          optionBuilder: (v) => Text(Transl.trait(v.id).l),
          showMatchAll: true,
          showInvert: true,
          onFilterChanged: (value, _) {
            update();
          },
        ),
        buildGroupDivider(text: S.current.effect_search),
        FilterGroup<SvtEffectScope>(
          title: Text(S.current.effect_scope),
          options: SvtEffectScope.values,
          values: filterData.effectScope,
          optionBuilder: (v) => Text(v.shownName),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<EffectTarget>(
          title: Text(S.current.effect_target),
          options: EffectTarget.values,
          values: filterData.effectTarget,
          optionBuilder: (v) => Text(v.shownName),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        EffectFilterUtil.buildTraitFilter(context, filterData.targetTrait, update),
        FilterGroup<SkillEffect>(
          title: Text(S.current.effect_type),
          options: _getValidEffects(SkillEffect.kAttack),
          values: filterData.effectType,
          showMatchAll: true,
          showInvert: false,
          optionBuilder: (v) => Text(v.lName),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        const SizedBox(height: 4),
        FilterGroup<SkillEffect>(
          options: _getValidEffects(SkillEffect.kDefence),
          values: filterData.effectType,
          optionBuilder: (v) => Text(v.lName),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        const SizedBox(height: 4),
        FilterGroup<SkillEffect>(
          options: _getValidEffects(SkillEffect.kDebuffRelated),
          values: filterData.effectType,
          optionBuilder: (v) => Text(v.lName),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        const SizedBox(height: 4),
        FilterGroup<SkillEffect>(
          options: _getValidEffects(SkillEffect.kOthers),
          values: filterData.effectType,
          optionBuilder: (v) => Text(v.lName),
          onFilterChanged: (value, _) {
            update();
          },
        ),
      ]),
    );
  }

  List<SkillEffect> _getValidEffects(List<SkillEffect> effects) {
    return effects.where((v) => !SkillEffect.svtIgnores.contains(v)).toList();
  }
}

const _traitsForFilter = <Trait>[
  Trait.dragon,
  Trait.riding,
  Trait.divine,
  Trait.humanoid, //?
  Trait.demonBeast,
  Trait.king,
  Trait.roman,
  Trait.arthur,
  Trait.saberface,
  Trait.weakToEnumaElish,
  Trait.brynhildsBeloved,
  Trait.greekMythologyMales,
  Trait.threatToHumanity,
  Trait.demonic,
  Trait.giant,
  Trait.superGiant,
  Trait.skyOrEarthExceptPseudoAndDemiServant,
  Trait.hominidaeServant,
  Trait.demonicBeastServant, // 魔兽型
  Trait.livingHuman,
  Trait.childServant,
  Trait.existenceOutsideTheDomain,
  Trait.oni,
  Trait.genji,
  Trait.mechanical,
  Trait.fae,
  Trait.knightsOfTheRound,
  Trait.fairyTaleServant,
  Trait.divineSpirit,
  Trait.hasCostume,
  Trait.havingAnimalsCharacteristics, // 兽科
  Trait.summerModeServant,
  Trait.immuneToPigify,
];
