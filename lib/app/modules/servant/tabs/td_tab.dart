import 'package:flutter/foundation.dart';

import 'package:chaldea/app/app.dart';
import 'package:chaldea/app/descriptors/skill_descriptor.dart';
import 'package:chaldea/app/modules/common/filter_group.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/models.dart';
import 'package:chaldea/packages/bili_player.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:chaldea/widgets/widgets.dart';
import '../../../descriptors/cond_target_value.dart';

class SvtTdTab extends StatelessWidget {
  final Servant svt;

  const SvtTdTab({super.key, required this.svt});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    final status = db.curUser.svtStatusOf(svt.collectionNo).cur;
    final overrideData = OverrideTDData.fromAscensionAdd(svt.ascensionAdd);

    void addOneGroup(int tdNum, List<NiceTd> tds) {
      if (tds.isEmpty) return;
      List<NiceTd> shownTds = [];
      List<OverrideTDData?> overrideTds = [];
      for (final td in tds) {
        if (shownTds.every((e) => e.id != td.id)) {
          // ?
          shownTds.add(td);
          overrideTds.add(null);
        }
      }
      // not secure
      if (overrideData.isNotEmpty && tds.isNotEmpty) {
        for (final oTd in overrideData) {
          shownTds.add(tds.last);
          overrideTds.add(oTd);
        }
      }
      children.add(_buildTds(context, shownTds, status.favorite ? status.npLv : null, overrideTds));
    }

    for (final tdNum in svt.groupedNoblePhantasms.keys) {
      final tds = svt.groupedNoblePhantasms[tdNum]!;
      if (svt.groupedNoblePhantasms.containsKey(1) &&
          tdNum != 1 &&
          tds.any((e) => e.script?.tdTypeChangeIDs?.isNotEmpty != true)) {
        children.add(DividerWithTitle(title: S.current.enemy_only_nps, height: 16));
      }
      if (svt.collectionNo == 312) {
        List<NiceTd> tds1 = [], tds2 = [];
        for (final td in tds) {
          if (td.releaseConditions.any((e) => e.condType == CondType.equipWithTargetCostume)) {
            // if (td.card == CardType.buster) {
            tds2.add(td);
          } else {
            tds1.add(td);
          }
        }
        addOneGroup(tdNum, tds1);
        addOneGroup(tdNum, tds2);
      } else {
        addOneGroup(tdNum, tds);
      }
    }

    if (svt.extra.tdAnimations.isNotEmpty && kDebugMode) {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: ElevatedButton(
          onPressed: () {
            if (!BiliPlayer.isSupport && svt.extra.tdAnimations.length == 1) {
              launch(svt.extra.tdAnimations.first.weburl);
              return;
            }
            router.pushPage(BiliTdAnimations(
              videos: svt.extra.tdAnimations,
              title: '${S.current.td_animation} - ${svt.lName.l}',
            ));
          },
          child: Text(S.current.td_animation),
        ),
      ));
    }

    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  Widget _buildTds(BuildContext context, List<NiceTd> tds, int? level, List<OverrideTDData?> overrideTds) {
    assert(tds.length == overrideTds.length);
    if (tds.length == 1 && tds.first.condQuestId <= 0) {
      return TdDescriptor(
        td: tds.first,
        showEnemy: !svt.isUserSvt,
        level: level,
        overrideData: overrideTds.getOrNull(0),
      );
    }
    NiceTd initTd = _getDefaultTd(tds) ?? tds.last;
    return ValueStatefulBuilder<int>(
      initValue: tds.indexOf(initTd),
      builder: (context, state) {
        final tdIndex = state.value;
        final td = tds[tdIndex];
        final oTdData = overrideTds.getOrNull(tdIndex);

        final toggle = Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: FilterGroup<int>(
                shrinkWrap: true,
                combined: true,
                options: List.generate(tds.length, (index) => index),
                optionBuilder: (v) {
                  String name = overrideTds.getOrNull(v)?.tdName ?? tds[v].name;
                  name = Transl.tdNames(name).l;
                  final rank = overrideTds.getOrNull(v)?.tdRank ?? tds[v].rank;
                  if (!['なし', '无', 'None', '無', '없음'].contains(rank)) {
                    name = '$name $rank';
                  }
                  if (name.trim().isEmpty) name = '???';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Text(name),
                  );
                },
                values: FilterRadioData.nonnull(tdIndex),
                onFilterChanged: (v, _) {
                  state.value = v.radioValue!;
                  state.updateState();
                },
              ),
            ),
            if (td.condQuestId > 0 || oTdData != null)
              IconButton(
                padding: const EdgeInsets.all(2),
                constraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 24,
                ),
                onPressed: () => showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (_) => releaseCondition(svt, td, oTdData),
                ),
                icon: const Icon(Icons.info_outline),
                color: Theme.of(context).hintColor,
                tooltip: S.current.open_condition,
              ),
          ],
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            toggle,
            TdDescriptor(
              td: td,
              showEnemy: !svt.isUserSvt,
              level: level,
              overrideData: overrideTds.getOrNull(tdIndex),
            ),
          ],
        );
      },
    );
  }

  NiceTd? _getDefaultTd(List<NiceTd> tds) {
    tds = tds.where((e) => e.num > 0).toList();
    final priorities = db.gameData.mappingData.tdPriority[svt.id]?.ofRegion(db.curUser.region);
    if (svt.collectionNo == 1) {
      tds = tds.where((e) => priorities?[e.id] != null).toList();
    }
    if (tds.isEmpty) return null;
    if (db.curUser.region == Region.jp) {
      return Maths.findMax<NiceTd, int>(tds, (e) => e.priority);
    } else {
      return Maths.findMax<NiceTd, int>(tds, (e) => priorities?[e.id] ?? -1);
    }
  }

  static Widget releaseCondition(final Servant svt, final NiceTd td, final OverrideTDData? overrideTDData) {
    bool notMain = ['91', '94'].contains(td.condQuestId.toString().padRight(2).substring(0, 2));
    final quest = db.gameData.quests[td.condQuestId];
    final jpTime = quest?.openedAt,
        localTime = db.gameData.mappingData.questRelease[td.condQuestId]?.ofRegion(db.curUser.region);
    final keys = overrideTDData?.keys ?? [];
    List<int> ascensions = [], costumes = [];
    for (final key in keys) {
      key < 10 ? ascensions.add(key) : costumes.add(key);
    }
    return SimpleCancelOkDialog(
      title: Text(td.lName.l),
      hideCancel: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (td.condQuestId > 0)
            CondTargetValueDescriptor(
              condType: notMain ? CondType.questClear : CondType.questClearPhase,
              target: td.condQuestId,
              value: td.condQuestPhase,
            ),
          if (ascensions.isNotEmpty) Text('${S.current.ascension_short} ${ascensions.join('&')}'),
          if (costumes.isNotEmpty)
            Text(['${S.current.costume}:', for (final c in costumes) svt.profile.costume[c]?.lName.l ?? c.toString()]
                .join(' ')),
          if (jpTime != null) Text('JP: ${jpTime.sec2date().toDateString()}'),
          if (db.curUser.region != Region.jp && localTime != null)
            Text('${db.curUser.region.upper}: ${localTime.sec2date().toDateString()}'),
        ],
      ),
    );
  }
}

class BiliTdAnimations extends StatelessWidget {
  final String? title;
  final List<BiliVideo> videos;
  const BiliTdAnimations({super.key, this.title, required this.videos});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int index = 0; index < videos.length; index++) {
      final video = videos[index];
      if (!video.valid) continue;
      if (BiliPlayer.isSupport) {
        children.add(AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(border: Border.fromBorderSide(Divider.createBorderSide(context))),
            child: Center(
              child: BiliPlayer(video: video),
            ),
          ),
        ));
      }
      children.add(Center(
        child: TextButton(
          onPressed: () {
            launch(video.weburl);
          },
          child: Text(videos.length == 1 ? 'Mooncell@bilibili' : '${index + 1} - Mooncell@bilibili'),
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? S.current.td_animation),
      ),
      body: ListView(
        shrinkWrap: true,
        children: children,
      ),
    );
  }
}
