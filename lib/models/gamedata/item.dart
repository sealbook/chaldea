import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/db.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:chaldea/widgets/widgets.dart';
import '../../app/app.dart';
import '_helper.dart';
import 'common.dart';
import 'game_card.dart';
import 'mappings.dart';
import 'quest.dart';
import 'servant.dart';

part '../../generated/models/gamedata/item.g.dart';

enum ItemCategory {
  normal,
  ascension,
  skill,
  special,
  eventAscension,
  event,
  coin,
  other,
}

@JsonSerializable()
class Item {
  int id;
  String name;
  ItemType type;
  List<ItemUse> uses;
  String detail;
  List<NiceTrait> individuality;
  String icon;
  ItemBGType background;
  int priority;
  int dropPriority;
  List<ItemSelect> itemSelects;

  Item({
    required this.id,
    required this.name,
    this.type = ItemType.none,
    this.uses = const [],
    required this.detail,
    this.individuality = const [],
    required this.icon,
    required this.background,
    required this.priority,
    required this.dropPriority,
    this.itemSelects = const [],
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  int get rarity => background == ItemBGType.questClearQPReward ? 0 : background.index;

  String get borderedIcon {
    if (type == ItemType.svtCoin || id == Items.grailToCrystalId) return icon;
    return icon.replaceFirst(RegExp(r'.png$'), '_bordered.png');
  }

  ItemCategory get category {
    // if (type == ItemType.tdLvUp) return SkillUpItemType.ascension;
    // if (type != ItemType.skillLvUp) return SkillUpItemType.none;
    if (Items.specialItems.contains(id)) return ItemCategory.special;
    if (id >= 6000 && id < 6300) return ItemCategory.skill;
    if (id >= 6500 && id < 7000) return ItemCategory.normal;
    if (id >= 7000 && id < 7200) return ItemCategory.ascension;
    if (type == ItemType.eventItem) {
      return uses.contains(ItemUse.ascension) ? ItemCategory.eventAscension : ItemCategory.event;
    }
    if (type == ItemType.eventPoint) return ItemCategory.event;
    if (type == ItemType.svtCoin) return ItemCategory.coin;
    return ItemCategory.other;
  }

  static Widget iconBuilder({
    required BuildContext context,
    required Item? item,
    int? itemId,
    String? icon,
    double? width = 32,
    double? height,
    double? aspectRatio = 132 / 144,
    String? text,
    EdgeInsets? padding,
    VoidCallback? onTap,
    ImageWithTextOption? option,
    bool jumpToDetail = true,
    bool popDetail = false,
    String? name,
    bool showName = false,
  }) {
    int? _itemId = item?.id ?? itemId;
    item ??= db.gameData.items[itemId];
    icon ??= item?.borderedIcon;
    if (icon == null && itemId != null) {
      icon ??= getIcon(itemId);
    }
    name ??= Item.getName(item?.id ?? itemId ?? -1);
    if (onTap == null && jumpToDetail && _itemId != null) {
      if (_itemId == Items.grailToCrystalId) {
        onTap = () {
          showDialog(
            context: context,
            useRootNavigator: false,
            builder: (context) {
              return SimpleDialog(
                title: Text(S.current.item_grail2crystal, maxLines: 1),
                children: [
                  ListTile(
                    leading: db.getIconImage(item?.icon),
                    title: Text(item?.lName.l ?? "Grail to Lore"),
                    onTap: () {
                      Navigator.pop(context);
                      router.popDetailAndPush(
                        url: Routes.itemI(Items.grailToCrystalId),
                        popDetail: popDetail,
                        detail: true,
                      );
                    },
                  ),
                  ListTile(
                    leading: db.getIconImage(Items.grail?.borderedIcon),
                    title: Text(Items.grail?.lName.l ?? "Grail"),
                    onTap: () {
                      Navigator.pop(context);
                      router.popDetailAndPush(
                        url: Routes.itemI(Items.grailId),
                        popDetail: popDetail,
                        detail: true,
                      );
                    },
                  ),
                  ListTile(
                    leading: db.getIconImage(Items.crystal?.borderedIcon),
                    title: Text(Items.crystal?.lName.l ?? "Lore"),
                    onTap: () {
                      Navigator.pop(context);
                      router.popDetailAndPush(
                        url: Routes.itemI(Items.crystalId),
                        popDetail: popDetail,
                        detail: true,
                      );
                    },
                  )
                ],
              );
            },
          );
        };
      } else {
        onTap = () {
          router.popDetailAndPush(
            url: Routes.itemI(_itemId),
            popDetail: popDetail,
            detail: true,
          );
        };
      }
    }
    return GameCardMixin.cardIconBuilder(
      context: context,
      icon: icon,
      width: width,
      height: height,
      aspectRatio: aspectRatio,
      text: text,
      padding: padding,
      onTap: onTap,
      name: showName ? name : null,
      option: option,
    );
  }

  Transl<String, String> get lName => Transl.itemNames(name);

  String get route => Routes.itemI(id);

  void routeTo() => router.push(url: Routes.itemI(id));

  // include special items(entity)
  static String getName(int id) {
    return db.gameData.items[id]?.lName.l ?? db.gameData.entities[id]?.lName.l ?? 'Item $id';
  }

  static String? getIcon(int id, {bool bordered = true}) {
    if (bordered) {
      return db.gameData.items[id]?.borderedIcon ?? db.gameData.entities[id]?.borderedIcon;
    } else {
      return db.gameData.items[id]?.icon ?? db.gameData.entities[id]?.icon;
    }
  }

  static int compare(int itemA, int itemB) {
    final a = db.gameData.items[itemA]?.priority, b = db.gameData.items[itemB]?.priority;
    if (a != null && b != null) return a - b;
    if (a == null && b == null) return 0;
    return a == null ? -1 : 1;
  }

  static int _getType(int a) {
    if (db.gameData.craftEssencesById.containsKey(a)) return 1;
    if (db.gameData.items.containsKey(a)) return 2;
    if (db.gameData.entities[a]?.type == SvtType.combineMaterial) {
      return 3;
    }
    return 0; // unknown
  }

  static int _getPriority(int a) {
    return -(db.gameData.items[a]?.priority ?? db.gameData.craftEssencesById[a]?.collectionNo ?? a);
  }

  // item/ce/svt
  static int compare2(int id1, int id2, [bool reversed = false]) {
    // priority越大越金
    // ce3->item2->ember1
    return ListX.compareByList(id1, id2, (v) => <int>[_getType(v), _getPriority(v)], reversed);
  }

  static Map<int, int> sortMapByPriority(
    Map<int, int> items, {
    bool qpFirst = true,
    bool reversed = false,
    bool category = false,
    bool removeZero = true,
  }) {
    int _getPriority(int id) {
      if (id == Items.qpId && !qpFirst) return 9999999;
      final item = db.gameData.items[id];
      if (item == null) return id;
      if (category) return item.category.index * 10000 + item.priority;
      return item.priority;
    }

    return {
      for (final k in items.keys.toList()..sort2(_getPriority, reversed: reversed))
        if (items[k]! > 0 || !removeZero) k: items[k]!
    };
  }

  static Map<ItemCategory, Map<int, int>> groupItems(Map<int, int> items) {
    Map<ItemCategory, Map<int, int>> result = {
      for (final type in ItemCategory.values) type: {},
    };
    for (int itemId in items.keys) {
      ItemCategory? type = db.gameData.items[itemId]?.category;
      if (type == null && Items.specialSvtMat.contains(itemId)) {
        type = ItemCategory.special;
      }
      type ??= ItemCategory.other;
      result[type]![itemId] = items[itemId]!;
    }

    return {
      for (final type in ItemCategory.values) type: sortMapByPriority(result[type]!),
    };
  }

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

class Items {
  const Items._();

  // for own use, no a exact id
  static const int expPointId = -10;
  static const int bondPointId = -11;

  static Map<int, Item> get _items => db.gameData.items;

  static const int qpId = 1;
  static const int stoneId = 2;
  static const int manaPrismId = 3;
  static const int friendPointId = 4;
  static const int quartzFragmentId = 16;
  static const int purePrismId = 46;
  static const int rarePrismId = 18;
  static const int grailToCrystalId = 19;
  static const int summonTicketId = 4001;
  static const int goldAppleId = 100;
  static const int silverAppleId = 101;
  static const int bronzeAppleId = 102;
  static const int blueSaplingId = 103;
  static const int blueAppleId = 104;
  static const int crystalId = 6999;
  static const int grailFragId = 7998;
  static const int grailId = 7999;
  static const int lanternId = 1000;

  // not item, icon only
  static const int costumeIconId = 23;
  static const int npRankUpIconId = 8;

  static Item? get qp => _items[qpId];

  static Item? get stone => _items[stoneId];

  static Item? get manaPrism => _items[manaPrismId];

  static Item? get friendPoint => _items[friendPointId];

  static Item? get purePrism => _items[purePrismId];

  static Item? get rarePrism => _items[rarePrismId];

  static Item? get summonTicket => _items[summonTicketId];

  static Item? get bronzeApple => _items[bronzeAppleId];

  static Item? get silverApple => _items[silverAppleId];

  static Item? get goldApple => _items[goldAppleId];

  static Item? get crystal => _items[crystalId];

  static Item? get grailFrag => _items[grailFragId];

  static Item? get grail => _items[grailId];

  static Item? get lantern => _items[lanternId];

  static const List<int> specialItems = [
    //
    qpId, stoneId, quartzFragmentId, manaPrismId, purePrismId, rarePrismId,
    summonTicketId, goldAppleId, silverAppleId, bronzeAppleId, blueSaplingId,
    blueAppleId, grailFragId, grailId, grailToCrystalId, lanternId,
  ];
  static const List<int> specialSvtMat = [
    hpFou3,
    atkFou3,
    hpFou4,
    atkFou4,
    ember5,
    ember4,
    ember3,
  ];
  static const fous = [hpFou3, hpFou4, atkFou3, atkFou4];
  static const int hpFou3 = 9570300;
  static const int hpFou4 = 9570400;
  static const int atkFou3 = 9670300;
  static const int atkFou4 = 9670400;

  static const embers = [ember3, ember4, ember5];
  static const int ember3 = 9770300;
  static const int ember4 = 9770400;
  static const int ember5 = 9770500;

  @Deprecated('to be evaluated')
  static bool isStatItem(int itemId) {
    final item = _items[itemId];
    if (item != null && item.category != ItemCategory.other) {
      return true;
    }
    if (specialSvtMat.contains(itemId)) return true;
    return false;
  }
}

@JsonSerializable()
class ItemSelect {
  int idx;
  List<Gift> gifts;
  int requireNum;
  // String detail;
  ItemSelect({
    required this.idx,
    this.gifts = const [],
    this.requireNum = 1,
    // required this.detail,
  });
  factory ItemSelect.fromJson(Map<String, dynamic> json) => _$ItemSelectFromJson(json);

  Map<String, dynamic> toJson() => _$ItemSelectToJson(this);
}

@JsonSerializable()
class ItemAmount {
  int itemId;
  int amount;
  Item? _item;

  ItemAmount({
    Item? item,
    int? itemId,
    required this.amount,
  })  : assert(item != null || itemId != null),
        _item = item,
        itemId = item?.id ?? itemId ?? 0;

  Item? get item => _item ?? db.gameData.items[itemId];

  factory ItemAmount.fromJson(Map<String, dynamic> json) => _$ItemAmountFromJson(json);

  Map<String, dynamic> toJson() => _$ItemAmountToJson(this);
}

@JsonSerializable()
class LvlUpMaterial {
  List<ItemAmount> items;
  int qp;

  LvlUpMaterial({
    required this.items,
    required this.qp,
  });

  factory LvlUpMaterial.fromJson(Map<String, dynamic> json) => _$LvlUpMaterialFromJson(json);

  Map<int, int> toItemDict() {
    return {
      for (final item in items) item.itemId: item.amount,
      Items.qpId: qp,
    };
  }

  Map<String, dynamic> toJson() => _$LvlUpMaterialToJson(this);
}

enum ItemUse {
  skill,
  appendSkill,
  ascension,
  costume,
}

enum ItemType {
  none, // custom
  qp,
  stone,
  apRecover,
  apAdd,
  mana,
  key,
  gachaClass,
  gachaRelic,
  gachaTicket,
  limit,
  skillLvUp,
  tdLvUp,
  friendPoint,
  eventPoint,
  eventItem,
  questRewardQp,
  chargeStone,
  rpAdd,
  boostItem,
  stoneFragments,
  anonymous,
  rarePri,
  costumeRelease,
  itemSelect,
  commandCardPrmUp,
  dice,
  continueItem,
  euqipSkillUseItem,
  svtCoin,
  friendshipUpItem,
  pp,
  tradeAp,
  ri,
}

enum ItemBGType {
  zero,
  bronze,
  silver,
  gold,
  questClearQPReward,
}

abstract class ItemIconId {
  static const stoneGrey = 0;
  static const boxCopper = 1;
  static const boxSilver = 2;
  static const boxGold = 3;
  static const qp = 5;
  static const stone = 6;
  static const mana = 7;
  static const tdUpgrade = 8;
  static const skillUpgrade = 9;
  static const friendPoint = 12;
  static const anonymous = 17;
  static const rareMana = 18;
  static const grailToCrystal = 19;
  static const costume = 23;
  static const pureMana = 46;
  static const ap = 47;
  static const interlude = 40; // 灵基解放关卡
  static const unknown = 99;
  static const appleGold = 100;
  static const appleSilver = 101;
  static const appleCopper = 102;
  static const blueSapling = 103;
  static const appleBlue = 104;
  static const lanternOfChaldea = 1000;
  static const beastFootprint = 2000;
  static const summonTicket = 4000;
  static const exchangeTicket = 10000;
}
