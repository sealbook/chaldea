import 'dart:convert';

import 'package:chaldea/models/db.dart';
import 'package:chaldea/utils/utils.dart';
import '_helper.dart';
import 'command_code.dart';
import 'servant.dart';

part '../../generated/models/gamedata/toplogin.g.dart';

// ignore: unused_element
int _toInt(dynamic v, [int? k]) {
  if (v == null) {
    if (k != null) return k;
    assert(() {
      throw ArgumentError.notNull('_toInt.v');
    }());
    return 0;
  }
  if (v is int) {
    return v;
  } else if (v is String) {
    return k == null ? int.parse(v) : int.tryParse(v) ?? k;
  } else if (v is double) {
    return v.toInt();
  } else {
    throw ArgumentError('_toInt.v: ${v.runtimeType} $v');
  }
}

int? _toIntNull(dynamic v, [int? k]) {
  if (v == null) return k;
  return _toInt(v, k);
}

List<int> _toIntList(dynamic v, [int? k = 0]) {
  if (v == null) return [];
  if (v is String) {
    if (v.trim().isEmpty) return [];
    v = jsonDecode(v);
  }
  if (v is List) {
    return v.map((e) => _toInt(e, k)).toList();
  }
  throw ArgumentError('${v.runtimeType}: $v cannot be converted to List<int>');
}

@JsonSerializable(createToJson: false)
class FateTopLogin {
  List<FateResponseDetail> response;
  UserMstCache cache;
  String sign;

  UserMstData get mstData => cache.replaced;

  FateTopLogin({this.response = const [], UserMstCache? cache, String? sign})
      : cache = cache ?? UserMstCache(),
        sign = sign ?? '';

  factory FateTopLogin.fromJson(Map<String, dynamic> data) => _$FateTopLoginFromJson(data);

  /// base64 maybe url-encoded
  static FateTopLogin tryBase64(String encoded) {
    encoded = encoded.trim();
    // eyJy
    if (encoded.startsWith('ey')) {
      encoded = utf8.decode(base64Decode(Uri.decodeFull(encoded).trim()));
    }
    return FateTopLogin.fromJson(jsonDecode(encoded));
  }
}

@JsonSerializable(createToJson: false)
class FateResponseDetail {
  String? resCode;
  Map? success;
  Map? fail;
  String? nid;

  int? get code => resCode == null ? null : int.tryParse(resCode!);

  FateResponseDetail({
    this.resCode,
    this.success,
    this.fail,
    this.nid,
  });

  factory FateResponseDetail.fromJson(Map<String, dynamic> data) => _$FateResponseDetailFromJson(data);
}

@JsonSerializable(createToJson: false)
class UserMstCache {
  // deleted: {} // mostly empty
  UserMstData replaced;
  @protected
  UserMstData updated; // all data copied to replaced
  DateTime? serverTime;

  UserMstCache({UserMstData? replaced, UserMstData? updated, int? serverTime})
      : replaced = replaced ?? UserMstData(),
        updated = updated ?? UserMstData(),
        serverTime = serverTime == null ? null : DateTime.fromMillisecondsSinceEpoch(serverTime * 1000);

  factory UserMstCache.fromJson(Map<String, dynamic> data) {
    // some regions' data are in replaced, some are in updated
    final Map replaced = data.putIfAbsent('replaced', () => {});
    final Map updated = data.putIfAbsent('updated', () => {});
    final dupKeys = replaced.keys.toSet().intersection(updated.keys.toSet());
    if (dupKeys.isNotEmpty) {
      print('keys in replaced: [${replaced.keys.join(",")}]');
      print('keys in updated : [${updated.keys.join(",")}]');
      print('keys in both    : [${dupKeys.join(",")}]');
    }
    updated.addAll(replaced);
    replaced.addAll(updated);
    updated.clear();
    return _$UserMstCacheFromJson(data);
  }
}

@JsonSerializable(createToJson: false)
class UserMstData {
  List<UserGame> userGame;
  // svt and ce
  List<UserSvtCollection> userSvtCollection;
  List<UserSvt> userSvt;
  List<UserSvt> userSvtStorage;
  List<UserSvtAppendPassiveSkill> userSvtAppendPassiveSkill;
  List<UserSvtAppendPassiveSkillLv> userSvtAppendPassiveSkillLv;
  // cc
  List<UserCommandCodeCollection> userCommandCodeCollection;
  List<UserCommandCode> userCommandCode;
  List<UserSvtCommandCode> userSvtCommandCode;
  List<UserSvtCommandCard> userSvtCommandCard;
  // items
  List<UserItem> userItem;
  List<UserSvtCoin> userSvtCoin;
  List<UserEquip> userEquip;
  // support deck
  List<UserSupportDeck> userSupportDeck;
  List<UserSvtLeader> userSvtLeader;

  // userEventPoint, userGachaExtraCount,
  // userEventSuperBoss, userSvtVoicePlayed, userQuest
  // userEventMissionFix,userEventMission,
  // userPrivilege
  // userEventMissionConditionDetail, userGachaDrawLog,userQuestRoute,userPresentBox,userNpcSvtRecord,userCoinRoom
  // userEventRaid
  // userDeck; // 10个打本队伍
  // userQuestInfo,,userGacha,userEvent,userSvtCommandCard,
  // beforeBirthDay

  // transformed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<int, UserSvtCoin> coinMap = {};
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<int, UserSvtAppendPassiveSkill> appendSkillMap = {};
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<int, UserSvtAppendPassiveSkillLv> appendSkillLvMap = {};

  UserMstData({
    List<UserGame>? userGame,
    List<UserSvtCollection>? userSvtCollection,
    List<UserSvt>? userSvt,
    List<UserSvt>? userSvtStorage,
    List<UserSvtAppendPassiveSkill>? userSvtAppendPassiveSkill,
    List<UserSvtAppendPassiveSkillLv>? userSvtAppendPassiveSkillLv,
    List<UserCommandCodeCollection>? userCommandCodeCollection,
    List<UserCommandCode>? userCommandCode,
    List<UserSvtCommandCode>? userSvtCommandCode,
    List<UserSvtCommandCard>? userSvtCommandCard,
    List<UserItem>? userItem,
    List<UserSvtCoin>? userSvtCoin,
    List<UserEquip>? userEquip,
    List<UserSupportDeck>? userSupportDeck,
    List<UserSvtLeader>? userSvtLeader,
  })  : userGame = userGame ?? [],
        userSvtCollection = userSvtCollection ?? [],
        userSvt = userSvt ?? [],
        userSvtStorage = userSvtStorage ?? [],
        userSvtAppendPassiveSkill = userSvtAppendPassiveSkill ?? [],
        userSvtAppendPassiveSkillLv = userSvtAppendPassiveSkillLv ?? [],
        userCommandCodeCollection = userCommandCodeCollection ?? [],
        userCommandCode = userCommandCode ?? [],
        userSvtCommandCode = userSvtCommandCode ?? [],
        userSvtCommandCard = userSvtCommandCard ?? [],
        userItem = userItem ?? [],
        userSvtCoin = userSvtCoin ?? [],
        userEquip = userEquip ?? [],
        userSupportDeck = userSupportDeck ?? [],
        userSvtLeader = userSvtLeader ?? [] {
    for (final e in this.userSvtCoin) {
      coinMap[e.svtId] = e;
    }
    for (final e in this.userSvtAppendPassiveSkill) {
      appendSkillMap[e.svtId] = e;
    }
    for (final e in this.userSvtAppendPassiveSkillLv) {
      appendSkillLvMap[e.userSvtId] = e;
    }
  }

  UserGame? get firstUser => userGame.getOrNull(0);

  List<int> getSvtAppendSkillLv(UserSvt svt) {
    final Map<int, int> lvs = Map.fromIterable(appendSkillMap[svt.svtId]?.unlockNums ?? <int>[], value: (_) => 1);
    final appendLv = appendSkillLvMap[svt.id];
    if (appendLv != null) {
      lvs.addAll(Map.fromIterables(appendLv.appendPassiveSkillNums, appendLv.appendPassiveSkillLvs));
    }
    return List.generate(3, (index) => lvs[100 + index] ?? 0);
  }

  factory UserMstData.fromJson(Map<String, dynamic> data) => _$UserMstDataFromJson(data);
}

// Example:
// "userId": "100114639326",
// "itemId": "16",
// "num": "2650",
// "updatedAt": "1504378320",
// "createdAt": "1504378320"
@JsonSerializable(createToJson: false)
class UserItem {
  int itemId;
  int num;

  /// custom defined

  /// name in dataset, not in api response
  // @JsonKey(includeFromJson: false, includeToJson: false)
  // String? indexKey;

  UserItem({
    required dynamic itemId,
    required dynamic num,
  })  : itemId = _toInt(itemId),
        num = _toInt(num);

  factory UserItem.fromJson(Map<String, dynamic> data) => _$UserItemFromJson(data);
}

// Example:
// "id": "389441277",
// "userId": "100114639326",
// "svtId": "100300",
// "limitCount": "4",
// "dispLimitCount": 3,
// "lv": "80",
// "exp": "8532000",
// "adjustHp": "0",
// "adjustAtk": "0",
// "status": "0",
// "condVal": "0",
// "skillLv1": "1",
// "skillLv2": "1",
// "skillLv3": "1",
// "treasureDeviceLv1": "5",
// "treasureDeviceLv2": "1",
// "treasureDeviceLv3": "1",
// "exceedCount": "0",
// "selectTreasureDeviceIdx": "0",
// "equipTargetId1": "0",
// "displayInfo": "{\"img\":4,\"disp\":3,\"cmd\":3,\"icon\":4,\"ptr\":3}",
// "createdAt": "1555501785",
// "updatedAt": "1555501785",
// "isLock": "1",
// "imageLimitCount": 4,
// "commandCardLimitCount": 3,
// "iconLimitCount": 4,
// "portraitLimitCount": 3,
// "battleVoice": 0,
// "randomLimitCount": 0,
// "randomLimitCountSupport": 0,
// "limitCountSupport": 0,
// "hp": 10623,
// "atk": 7726
@JsonSerializable(createToJson: false)
class UserSvt {
  int id; // unique id for every card
  int svtId;

  // 0-unlock, 1-locked
  // 17-party member, -127-Mash
  // public enum UserServantEntity.StatusFlag
  //   LOCK = 1;
  //   EVENT_JOIN = 2;
  //   WITHDRAWAL = 4;
  //   APRIL_FOOL_CANCEL = 8;
  //   CHOICE = 16;
  //   NO_PERIOD = 32;
  //   COND_JOIN = 64;
  //   ADD_FRIENDSHIP_HEROINE = 128;
  int? status;
  int limitCount; // ascension
  // int dispLimitCount;
  int lv;
  int exp;
  int adjustHp; // adjustHp*10=FUFU
  int adjustAtk;
  int skillLv1;
  int skillLv2;
  int skillLv3;
  int treasureDeviceLv1;

  // int treasureDeviceLv2;
  // int treasureDeviceLv3;
  int exceedCount; // grail
  DateTime createdAt;
  DateTime? updatedAt;
  // @protected
  int? isLock; //cn only
  int hp;
  int atk;

  /// custom defined

  /// index key=collection id, in dataset
  // @JsonKey(includeFromJson: false, includeToJson: false)
  // int? indexKey;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool inStorage = false;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<int>? appendLvs;

  bool get locked {
    if (isLock != null) {
      return isLock == 1;
    } else {
      return status != null && status! & 1 != 0;
    }
  }

  UserSvt({
    required dynamic id,
    required dynamic svtId,
    required dynamic status,
    required dynamic limitCount, // ascension
    required dynamic lv,
    required dynamic exp,
    required dynamic adjustHp,
    required dynamic adjustAtk,
    required dynamic skillLv1,
    required dynamic skillLv2,
    required dynamic skillLv3,
    required dynamic treasureDeviceLv1,
    required dynamic exceedCount,
    required dynamic createdAt,
    required dynamic updatedAt,
    required dynamic isLock,
    required this.hp,
    required this.atk,
  })  : assert(status != null || isLock != null),
        id = _toInt(id),
        svtId = _toInt(svtId),
        status = _toInt(status),
        limitCount = _toInt(limitCount),
        lv = _toInt(lv),
        exp = _toInt(exp),
        adjustHp = _toInt(adjustHp),
        adjustAtk = _toInt(adjustAtk),
        skillLv1 = _toInt(skillLv1),
        skillLv2 = _toInt(skillLv2),
        skillLv3 = _toInt(skillLv3),
        treasureDeviceLv1 = _toInt(treasureDeviceLv1),
        exceedCount = _toInt(exceedCount),
        createdAt = DateTime.fromMillisecondsSinceEpoch(_toInt(createdAt) * 1000),
        updatedAt = updatedAt == null ? null : DateTime.fromMillisecondsSinceEpoch(_toInt(updatedAt) * 1000),
        isLock = _toIntNull(isLock);

  factory UserSvt.fromJson(Map<String, dynamic> data) => _$UserSvtFromJson(data);

  Servant? get dbSvt => db.gameData.servantsById[svtId];
  CraftEssence? get dbCE => db.gameData.craftEssencesById[svtId];
}

//  {
//             "userId": "100106535477",
//             "svtId": "103200",
//             "status": "1",
//             "maxLv": "0",
//             "maxHp": "0",
//             "maxAtk": "0",
//             "maxLimitCount": "0",
//             "skillLv1": "1",
//             "skillLv2": "1",
//             "skillLv3": "1",
//             "treasureDeviceLv1": "1",
//             "treasureDeviceLv2": "1",
//             "treasureDeviceLv3": "1",
//             "svtCommonFlag": "0",
//             "flag": "0",
//             "friendship": "0",
//             "friendshipRank": "0",
//             "friendshipExceedCount": "0",
//             "voicePlayed": "0",
//             "voicePlayed2": "0",
//             "tdPlayed": [],
//             "getNum": "0",
//             "costumeIds": [],
//             "updatedAt": "1568449630",
//             "createdAt": "1568449630"
//         },
@JsonSerializable(createToJson: false)
class UserSvtCollection {
  int svtId;

  /// 1-已遭遇, 2-已契约
  int status;
  int friendship;
  int friendshipRank;
  int friendshipExceedCount;

  /// costume: x start from 11, -x when unlock.
  /// maybe out of order, need to sort when parsing
  /// include mash's story costume.
  List<int> costumeIds;

  UserSvtCollection({
    required dynamic svtId,
    required dynamic status,
    required dynamic friendship,
    required dynamic friendshipRank,
    required dynamic friendshipExceedCount,
    required dynamic costumeIds,
    // required List<int> releasedCostumeIds,
  })  : svtId = _toInt(svtId),
        status = _toInt(status),
        friendship = _toInt(friendship),
        friendshipRank = _toInt(friendshipRank),
        friendshipExceedCount = _toInt(friendshipExceedCount),
        costumeIds = _toIntList(costumeIds)..sort((a, b) => a.abs() - b.abs());

  bool get isOwned => status == 2;

  Map<int, int> costumeIdsTo01() {
    Map<int, int> result = {};
    for (final costumeId in costumeIds) {
      final costume =
          db.gameData.servantsById[svtId]?.profile.costume.values.firstWhereOrNull((e) => e.id == costumeId);
      if (costume != null) {
        result[costume.battleCharaId] = 1;
      }
    }
    return result;
  }

  factory UserSvtCollection.fromJson(Map<String, dynamic> data) => _$UserSvtCollectionFromJson(data);
}

@JsonSerializable(createToJson: false)
class UserGame {
  int? id; //cn only
  int userId;

  // String usk;
  String? appname; // username of bili account
  String name;
  DateTime? birthDay;
  int actMax;
  int genderType;
  int lv;
  int exp;
  int qp;
  int costMax;
  String friendCode;

  // int favoriteUserSvtId;
  int freeStone;
  int chargeStone;
  int mana;
  int rarePri;

  // DateTime zerotime;
  DateTime createdAt;
  String message;
  int stone;

  UserGame({
    required dynamic id,
    required dynamic userId,
    required this.appname,
    required this.name,
    required dynamic birthDay,
    required dynamic actMax,
    required dynamic genderType,
    required dynamic lv,
    required dynamic exp,
    required dynamic qp,
    required dynamic costMax,
    required this.friendCode,
    required dynamic freeStone,
    required dynamic chargeStone,
    required dynamic mana,
    required dynamic rarePri,
    required dynamic createdAt,
    required this.message,
    required this.stone,
  })  : id = _toIntNull(id),
        userId = _toInt(userId),
        birthDay = birthDay == null ? null : DateTime.fromMillisecondsSinceEpoch(_toInt(birthDay) * 1000),
        actMax = _toInt(actMax),
        genderType = _toInt(genderType),
        lv = _toInt(lv),
        exp = _toInt(exp),
        qp = _toInt(qp),
        costMax = _toInt(costMax),
        freeStone = _toInt(freeStone),
        chargeStone = _toInt(chargeStone),
        mana = _toInt(mana),
        rarePri = _toInt(rarePri),
        createdAt = DateTime.fromMillisecondsSinceEpoch(_toInt(createdAt) * 1000);

  factory UserGame.fromJson(Map<String, dynamic> data) => _$UserGameFromJson(data);
}

// {
//   "unlockNums": [
//       100,
//       101,
//       102
//   ],
//   "userId": xxxxx,
//   "svtId": 100100
// },
@JsonSerializable(createToJson: false)
class UserSvtAppendPassiveSkill {
  List<int> unlockNums;
  int svtId;

  UserSvtAppendPassiveSkill({
    List<int>? unlockNums,
    dynamic svtId,
  })  : unlockNums = unlockNums ?? [],
        svtId = _toInt(svtId);

  factory UserSvtAppendPassiveSkill.fromJson(Map<String, dynamic> data) => _$UserSvtAppendPassiveSkillFromJson(data);
}

// {
//   "userId": xxxxx,
//   "svtId": 100100,
//   "num": 50,
//   "updatedAt": 1629921881,
//   "createdAt": 1627812677
// }
@JsonSerializable(createToJson: false)
class UserSvtCoin {
  int svtId;
  int num;

  UserSvtCoin({
    dynamic svtId,
    dynamic num,
  })  : svtId = _toInt(svtId),
        num = _toInt(num);

  factory UserSvtCoin.fromJson(Map<String, dynamic> data) => _$UserSvtCoinFromJson(data);
}

// unlock order, only contains svts has unlocked append skill
// {
//   "appendPassiveSkillNums": [
//       101,
//       102,
//       100
//   ],
//   "appendPassiveSkillLvs": [
//       8,
//       7,
//       7
//   ],
//   "userSvtId": 75957046446,
//   "userId": 8634742
// },
@JsonSerializable(createToJson: false)
class UserSvtAppendPassiveSkillLv {
  int userSvtId;
  List<int> appendPassiveSkillNums;
  List<int> appendPassiveSkillLvs;

  UserSvtAppendPassiveSkillLv({
    dynamic userSvtId,
    required this.appendPassiveSkillNums,
    required this.appendPassiveSkillLvs,
  }) : userSvtId = _toInt(userSvtId);

  // List<int> toLvs() {
  //   final lvs =
  //       Map.fromIterables(appendPassiveSkillNums, appendPassiveSkillLvs);
  //   return [
  //     lvs[100] ?? 0,
  //     lvs[101] ?? 0,
  //     lvs[102] ?? 0,
  //   ];
  // }

  factory UserSvtAppendPassiveSkillLv.fromJson(Map<String, dynamic> data) =>
      _$UserSvtAppendPassiveSkillLvFromJson(data);
}

@JsonSerializable(createToJson: false)
class UserEquip {
  int id;
  // int userId;
  int equipId;
  int lv;
  int exp;
  // updatedAt, createdAt
  UserEquip({
    dynamic id,
    dynamic equipId,
    dynamic lv,
    dynamic exp,
  })  : id = _toInt(id),
        equipId = _toInt(equipId),
        lv = _toInt(lv),
        exp = _toInt(exp);

  factory UserEquip.fromJson(Map<String, dynamic> data) => _$UserEquipFromJson(data);
}

@JsonSerializable(createToJson: false)
class UserCommandCodeCollection {
  // int userId;
  int commandCodeId;
  int status; // 0-find, 2-got
  int getNum;
  // updatedAt, createdAt
  UserCommandCodeCollection({
    dynamic commandCodeId,
    dynamic status,
    dynamic getNum,
  })  : commandCodeId = _toInt(commandCodeId),
        status = _toInt(status),
        getNum = _toInt(getNum);
  factory UserCommandCodeCollection.fromJson(Map<String, dynamic> data) => _$UserCommandCodeCollectionFromJson(data);

  CommandCode? get dbCC => db.gameData.commandCodesById[commandCodeId];
}

@JsonSerializable(createToJson: false)
class UserCommandCode {
  int id;
  // int userId;
  int commandCodeId;
  int status; // StatusFlag.LOCK=1,CHOICE=16
  // createdAt, updatedAt
  UserCommandCode({
    dynamic id,
    dynamic commandCodeId,
    dynamic status,
    dynamic svtId,
  })  : id = _toInt(id),
        commandCodeId = _toInt(commandCodeId),
        status = _toInt(status);
  factory UserCommandCode.fromJson(Map<String, dynamic> data) => _$UserCommandCodeFromJson(data);

  CommandCode? get dbCC => db.gameData.commandCodesById[commandCodeId];
}

@JsonSerializable(createToJson: false)
class UserSvtCommandCode {
  // int userId;
  List<int> userCommandCodeIds;
  int svtId;
  // createdAt
  UserSvtCommandCode({
    dynamic userCommandCodeIds,
    dynamic svtId,
  })  : userCommandCodeIds = _toIntList(userCommandCodeIds),
        svtId = _toInt(svtId);
  factory UserSvtCommandCode.fromJson(Map<String, dynamic> data) => _$UserSvtCommandCodeFromJson(data);
}

@JsonSerializable(createToJson: false)
class UserSvtCommandCard {
  // int userId;
  List<int> commandCardParam;
  int svtId;
  // createdAt
  UserSvtCommandCard({
    dynamic commandCardParam,
    dynamic svtId,
  })  : commandCardParam = _toIntList(commandCardParam),
        svtId = _toInt(svtId);
  factory UserSvtCommandCard.fromJson(Map<String, dynamic> data) => _$UserSvtCommandCardFromJson(data);
}

@JsonSerializable(createToJson: false)
class UserSupportDeck {
  // int userId;
  int supportDeckId;
  String name;
  // createdAt, updatedAt
  UserSupportDeck({
    dynamic supportDeckId,
    dynamic name,
  })  : supportDeckId = _toInt(supportDeckId),
        name = name.toString();
  factory UserSupportDeck.fromJson(Map<String, dynamic> data) => _$UserSupportDeckFromJson(data);
}

@JsonSerializable(createToJson: false)
class UserSvtLeader {
  // int userId;
  int supportDeckId;
  int classId;
  int userSvtId;
  int svtId;
  int limitCount;
  int dispLimitCount;
  int lv;
  int exp;
  int hp;
  int atk;
  int adjustHp;
  int adjustAtk;
  int skillId1;
  int skillId2;
  int skillId3;
  int skillLv1;
  int skillLv2;
  int skillLv3;
  List<dynamic> classPassive;
  int treasureDeviceId;
  int treasureDeviceLv;
  int exceedCount;
  SvtLeaderEquipTargetInfo? equipTarget1;
  // Map displayInfo; cn json string
  List<SvtLeaderCommandCodeStatus> commandCode;
  List<int> commandCardParam;
  // int updatedAt;
  // int createdAt; // not in jp
  int imageLimitCount;
  int commandCardLimitCount;
  int iconLimitCount;
  int portraitLimitCount;
  int battleVoice;
  // int randomLimitCountSupport;  //cn
  // List<int?> randomLimitCountTargets; // jp
  List<SvtLeaderAppendSkillStatus> appendPassiveSkill;
  // int eventSvtPoint;
  // Map script;
  // int limitCountSupport;

  UserSvtLeader({
    dynamic supportDeckId,
    dynamic classId,
    dynamic userSvtId,
    dynamic svtId,
    dynamic limitCount,
    dynamic dispLimitCount,
    dynamic lv,
    dynamic exp,
    dynamic hp,
    dynamic atk,
    dynamic adjustHp,
    dynamic adjustAtk,
    dynamic skillId1,
    dynamic skillId2,
    dynamic skillId3,
    dynamic skillLv1,
    dynamic skillLv2,
    dynamic skillLv3,
    dynamic classPassive,
    dynamic treasureDeviceId,
    dynamic treasureDeviceLv,
    dynamic exceedCount,
    this.equipTarget1,
    // dynamic displayInfo,
    List<SvtLeaderCommandCodeStatus>? commandCode,
    dynamic commandCardParam,
    // dynamic updatedAt,
    // dynamic createdAt,
    dynamic imageLimitCount,
    dynamic commandCardLimitCount,
    dynamic iconLimitCount,
    dynamic portraitLimitCount,
    dynamic battleVoice,
    dynamic randomLimitCountSupport,
    // dynamic limitCountSupport,
    List<SvtLeaderAppendSkillStatus>? appendPassiveSkill,
  })  : supportDeckId = _toInt(supportDeckId),
        classId = _toInt(classId),
        userSvtId = _toInt(userSvtId),
        svtId = _toInt(svtId),
        limitCount = _toInt(limitCount),
        dispLimitCount = _toInt(dispLimitCount),
        lv = _toInt(lv),
        exp = _toInt(exp),
        hp = _toInt(hp),
        atk = _toInt(atk),
        adjustHp = _toInt(adjustHp),
        adjustAtk = _toInt(adjustAtk),
        skillId1 = _toInt(skillId1),
        skillId2 = _toInt(skillId2),
        skillId3 = _toInt(skillId3),
        skillLv1 = _toInt(skillLv1),
        skillLv2 = _toInt(skillLv2),
        skillLv3 = _toInt(skillLv3),
        classPassive = _toIntList(classPassive),
        treasureDeviceId = _toInt(treasureDeviceId),
        treasureDeviceLv = _toInt(treasureDeviceLv),
        exceedCount = _toInt(exceedCount),
        // displayInfo=jsonDecode(displayInfo??"{}"),
        commandCode = commandCode ?? [],
        commandCardParam = _toIntList(commandCardParam),
        // updatedAt = _toInt(updatedAt),
        // createdAt = _toInt(createdAt),
        imageLimitCount = _toInt(imageLimitCount),
        commandCardLimitCount = _toInt(commandCardLimitCount),
        iconLimitCount = _toInt(iconLimitCount),
        portraitLimitCount = _toInt(portraitLimitCount),
        battleVoice = _toInt(battleVoice),
        // randomLimitCountSupport=_toInt(randomLimitCountSupport),
        // limitCountSupport=_toInt(limitCountSupport);
        appendPassiveSkill = appendPassiveSkill ?? [];

  factory UserSvtLeader.fromJson(Map<String, dynamic> data) => _$UserSvtLeaderFromJson(data);
}

@JsonSerializable(createToJson: false)
class SvtLeaderEquipTargetInfo {
  // int userId;
  int userSvtId;
  int svtId;
  int limitCount;
  int lv;
  int exp;
  int hp;
  int atk;
  int skillId1;
  int skillLv1;
  int skillId2;
  int skillLv2;
  int skillId3;
  int skillLv3;
  // int updatedAt;
  SvtLeaderEquipTargetInfo({
    dynamic userSvtId,
    dynamic svtId,
    dynamic limitCount,
    dynamic lv,
    dynamic exp,
    dynamic hp,
    dynamic atk,
    dynamic skillId1,
    dynamic skillLv1,
    dynamic skillId2,
    dynamic skillLv2,
    dynamic skillId3,
    dynamic skillLv3,
    // dynamic updatedAt,
  })  : userSvtId = _toInt(userSvtId),
        svtId = _toInt(svtId),
        limitCount = _toInt(limitCount),
        lv = _toInt(lv),
        exp = _toInt(exp),
        hp = _toInt(hp),
        atk = _toInt(atk),
        skillId1 = _toInt(skillId1),
        skillLv1 = _toInt(skillLv1),
        skillId2 = _toInt(skillId2, 0),
        skillLv2 = _toInt(skillLv2, 0),
        skillId3 = _toInt(skillId3, 0),
        skillLv3 = _toInt(skillLv3, 0);

  factory SvtLeaderEquipTargetInfo.fromJson(Map<String, dynamic> data) => _$SvtLeaderEquipTargetInfoFromJson(data);
}

@JsonSerializable(createToJson: false)
class SvtLeaderAppendSkillStatus {
  int skillId;
  int skillLv;
  SvtLeaderAppendSkillStatus({
    dynamic skillId,
    dynamic skillLv,
  })  : skillId = _toInt(skillId),
        skillLv = _toInt(skillLv);

  factory SvtLeaderAppendSkillStatus.fromJson(Map<String, dynamic> data) => _$SvtLeaderAppendSkillStatusFromJson(data);
}

@JsonSerializable(createToJson: false)
class SvtLeaderCommandCodeStatus {
  int idx;
  int commandCodeId;
  int userCommandCodeId;

  SvtLeaderCommandCodeStatus({
    dynamic idx,
    dynamic commandCodeId,
    dynamic userCommandCodeId,
  })  : idx = _toInt(idx),
        commandCodeId = _toInt(commandCodeId),
        userCommandCodeId = _toInt(userCommandCodeId);

  factory SvtLeaderCommandCodeStatus.fromJson(Map<String, dynamic> data) => _$SvtLeaderCommandCodeStatusFromJson(data);
}
