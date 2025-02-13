# TODO

## Battles

### High Priority

- [ ] quest phase cache logic
- [x] catch error for user interaction (skill/attack)
- [x] show loading toast when fetch api
- [x] `Map<TargetId, bool> lastFuncSuccess` is a map
- [x] build team: disable event
- [ ] battle delegate
- [ ] menu skills
  - [ ] forceInstantDeath: rn or delayed for 1 target
  - [ ] reset active skill CD for 1 target.
  - [ ] Skip turn! add to popup menu
- [X] add a flag for `final bool BattleServantData.isPlayer`, DO NOT depend on niceSvt/niceEnemy
  - [X] ensure init niceSvt/niceEnemy **_in constructor_**
- [ ] active/passiveList make private, filter out actor died buffs, INDIV
- [ ] gainNp/gainHp/gainHpPer related funcs: check DataVals.Unaffected

### Recorder

- [ ] BattleServantActionHistory.TYPE: HPLOSS,INSTANT_DEATH,REDUCE_HP,DAMAGE_REFLECTION,DAMAGE_VALUE

### Ally Function Logic:

- [x] After 7th anni, donotAct will not stop first card from contributing to FirstCardType
- [ ] Unify buff execution, eliminate unnecessary calls to buff.shouldApply and switch to buff.shouldActivate to check
      for buff useRate
- [x] disable NP if NP has no functions
- [ ] BuffScript should only be checked when buffType matches
- [x] Move all checkTrait logic into battle and remove individual checkTrait methods in models
- [x] There is a bug that will reset other enemies' accumulation damage when deathEffect is triggered,
      ~~not verified for gutsEffect~~ Verified for gutsEffect as well, need to add that
- [ ] FuncType damageNpCounter
- [ ] FuncType damageNpRare Target == 0 is target, verify if Target ==1 is activator?
- [ ] FuncType gainHpPer figure out if Percentage heal benefits from healGrant buff
- [ ] FuncType gainHp/NpFromTargets & moveState can probably be implemented in the dependedFunc with an additional
      receiver argument to receive what's lost from absorbTargets
- [ ] DataVals AddLinkageTargetIndividualty & BehaveAsFamilyBuff & UnSubStateWhileLinkedToOthers
- [ ] DataVals CounterId CounterLv CounterOc SkillReaction UseTreasureDevice
- [ ] DataVals TriggeredFuncPosition ignored, only checking previous function success for now
- [ ] Group npDamageIndividualSum & buff ParamAddCount's counting logic together?
- [ ] BuffType doNotGainNp & upGiveNp & DataVals Unaffected
- [ ] BuffType doNotRecovery interacts with maxHp? Treating as no interaction for now & DataVals Unaffected
- [ ] BuffType doNotActCommandType
- [ ] BuffType doNotSelectCommandCard
- [x] BuffType tdTypeChange: if there are multiple instances of this buff, the last one dominates
  - [x] the max addOrder, should be safe to use the last effective one
- [x] BuffType overwriteClassRelation, atkSide first or defSide first? When two overwriteForce type interact, is it
      based on buff order? E.g. Kama skill3 & Reinis NP vs alterego attacker, is the final relation 500 or 1000 or depends
      on which buff comes last?
  - Def side takes priority.
  - For the same servant, first applied overwrite buff takes priority.
  - In conclusion, first applied defender side buff takes priority. Therefore, evaluation order goes from attacker to
    defender, from most recent buff to lease recent buff.
- [ ] BuffType preventDeathByDamage works if Van Gogh has both curse and burn?
- [ ] BuffType reflectionFunction
- [ ] BuffType skillRankUp has a maxRate of 0, so it's probably not a ValuedBuff? Currently only counting by buffTrait
- [ ] INDIVIDUALITIE seen on fields, buffTraits, servantId, are other traits included as well?
- [x] update INDIVIDUALITIE to only check its state in certain situations, perhaps in checkBuffStatus()?
- [ ] includeIgnoredTrait only adds NP card traits for now
- [ ] more sample on convertBuff's scripts
  - [ ] BuffConvert is converting a buff list to another buff list, (or trait list to another buff list, not used yet)
- [ ] prepare a dummy BattleServantData as Master
- [ ] Figure out how to write reasonable test cases for UI required effects like randomEffect & changeTdType
- [ ] funcSuccess for some wired function types
- [ ] Enemy shift target may not exist
- [x] cardDetail.damageRate/tdRate (U-Olga Marie buster/extra attack on all enemies)
- [x] dispBreakShift(need clamp)
- [x] Stage.script.NoEntryIds+Func.updateEntryPositions (DataVals.OnPositions+OffPositions)
- [ ] shiftGuts(Ratio)
- [x] QuestFlag.enemyImmediateAppear
- [x] Damage should remove buff with buffScript field damageRelease: 1
- [x] FuncType transformServant may need a local copy of Hyde data
- [x] `DataVals.ProcPassive` will add buff to passive list, even if it's called from an active skill. Same for `ProcActive`

#### Unknowns:

- [ ] DataVals ProgressSelfTurn
- [ ] DataVals CheckDuplicate

### Team setup

- [ ] svt/enemy: edit indivs, ~~skills, tds~~

### Common Simulation

- [ ] manually remove/add buff
- [ ] manually apply skill(custom activator/target)
- [ ] Transform: what if skill/td has upgrades or disabled?
  - Currently matching id for upgrades.
- [ ] add ce event skill on/off
- [x] Let user choose event point buff(s) and save to battle global params, used for addState.upDamageEventPoint,
      buff.parma=vals.Value+pointBuff.value
- [ ] Custom skill! (passive or active)
- [ ] Player side `allyTargetIndex` could be null or -1, let user to choose manually
- [x] skill cd/sealed/cond hint: sealed(×)>cd(n)>cond(\*, only shown when cd=0&not sealed)
- [x] Servant/Enemy without TD:
  - [x] tdId=0
- [x] Servant skill.num=1 means Skill 1, don't use index in list. `groupedActiveSkill[1/2/3]`
- [x] change `groupedActiveSkill` from list to dict
- [x] Auto select extraPassive (event bonus)
- [x] SkillRankUp: get skill from api if not in db, make init async
- [x] add svt.extraPassive on/off

### NPC Simulation

- [ ] Account for NP disabled NPCs (they don't gain any NP)

### Enemy Simulation

- [ ] build enemy active skills & cards & NP
- [x] BuffType upNpturnval & downNpturnval
- [ ] TargetType ptSelfAnotherRandom for svt 251 skill 3
- [ ] TargetType enemyOneNoTargetNoAction for svt 311 skill 3
- [ ] FuncType transformServant on enemies
- [x] Check Atlas for enemy trigger functions

## Misc

- [ ] CSV template: coin, rarity
- [ ] Extra Mission descriptor
- [ ] Integrate Sentry
- [ ] Adding crash log review
- [ ] command card: add svt assets
- [ ] userdata: make all constructor params nullable, catch error when converting token
- [ ] remember svt tabs
- [ ] logger.level
- [ ] filter_group_data: default value
- [ ] svt icon: custom image
- [ ] plan_tab: append/active/all
- [ ] cards: weak/strength
- [ ] func/buff/skill/td: factory fromJson(json,{cached=true})
- [ ] routeTo: add this as argument
- [ ] generate skill/np in one image
- [ ] trait: dynamic tabs(fixed some tabs), items
- [ ] list view: pull to show outdated
- [ ] class icon+name
- [ ] breaking change: FixedDrop
- [ ] filter_group: add onReset
- [ ] separate cn proxy
- [ ] free quest drop table
- [ ] parser: check summon prob correct
- [ ] summon: add wiki prob edit util
- [ ] add daily quests' enemy traits for missions
- [ ] improve audio player
- [ ] desktop: exit may not work, system_tray?
- [ ] home buttons: update, upload, download
- [ ] svt lv
- [ ] sort by svt lv/nplv, ce lv
- [ ] ce: chara on illust + related chara
- [ ] shop: another pay type (api)
- [x] android: external SD card

## Servant

- [ ] Plan:
  - [ ] support TextField input
- [x] Duplicated servant support
- [x] skill/np/quest/voice/profile condition

## Adding more pages

- [x] Summon list and detail page
  - [ ] summon plan: ?
- [x] Saint Quartz estimate
  - [ ] poor performance
- [ ] Buff/Function reversing with remote data
- [ ] Support Party generation

## Server side

- [x] item/skill recognition
- [x] account system: server or cloudflare?
  - [ ] ~~auto-backup user data~~: must manually backup
- [ ] recognizer: invalid image error

## Translation

Hey! These files need to be translated:

- [https://github.com/chaldea-center/chaldea-data/tree/main/mappings](https://github.com/chaldea-center/chaldea-data/tree/main/mappings)
- [https://github.com/chaldea-center/chaldea/tree/main/lib/l10n](https://github.com/chaldea-center/chaldea/tree/main/lib/l10n)
