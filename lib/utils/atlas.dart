import '../app/api/hosts.dart';
import '../models/models.dart';

class Atlas {
  Atlas._();

  static String get assetHost => Hosts.atlasAssetHost;
  static const String appHost = 'https://apps.atlasacademy.io/db/';
  static const String _dbAssetHost =
      'https://cdn.jsdelivr.net/gh/atlasacademy/apps/packages/db/src/Assets/';

  static bool isAtlasAsset(String url) {
    return url.startsWith(Hosts.kAtlasAssetHostGlobal) ||
        url.startsWith(Hosts.kAtlasAssetHostCN);
  }

  static String proxyAssetUrl(String url) {
    return Hosts.cn && url.startsWith(Hosts.kAtlasAssetHostGlobal)
        ? url.replaceFirst(Hosts.kAtlasAssetHostGlobal, Hosts.kAtlasAssetHostCN)
        : url;
  }

  /// db link
  static String dbUrl(String path, int id, [Region region = Region.jp]) {
    return '$appHost${region.upper}/$path/$id';
  }

  static String dbServant(int id, [Region region = Region.jp]) {
    return dbUrl('servant', id, region);
  }

  static String dbCraftEssence(int id, [Region region = Region.jp]) {
    return dbUrl('craft-essence', id, region);
  }

  static String dbCommandCode(int id, [Region region = Region.jp]) {
    return dbUrl('command-code', id, region);
  }

  static String dbEvent(int id, [Region region = Region.jp]) {
    return dbUrl('event', id, region);
  }

  static String dbWar(int id, [Region region = Region.jp]) {
    return dbUrl('war', id, region);
  }

  static String dbSkill(int id, [Region region = Region.jp]) {
    return dbUrl('skill', id, region);
  }

  static String dbTd(int id, [Region region = Region.jp]) {
    return dbUrl('noble-phantasm', id, region);
  }

  static String dbFunc(int id, [Region region = Region.jp]) {
    return dbUrl('func', id, region);
  }

  static String dbBuff(int id, [Region region = Region.jp]) {
    return dbUrl('buff', id, region);
  }

  static String dbQuest(int id, [int? phase, Region region = Region.jp]) {
    String url = dbUrl('quest', id, region);
    if (phase != null) {
      url += '/$phase';
    }
    return url;
  }

  static String ai(
    int id,
    bool isSvt, {
    Region region = Region.jp,
    int skillId1 = 0,
    int skillId2 = 0,
    int skillId3 = 0,
  }) {
    String url = dbUrl(isSvt ? 'ai/svt' : 'ai/field', id, region);
    Map<String, String> query = {
      if (skillId1 != 0) 'skillId1': skillId1.toString(),
      if (skillId2 != 0) 'skillId2': skillId2.toString(),
      if (skillId3 != 0) 'skillId3': skillId3.toString(),
    };
    if (query.isEmpty) return url;
    return Uri.parse(url).replace(queryParameters: query).toString();
  }

  static String asset(String path, [Region region = Region.jp]) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    return '$assetHost/${region.upper}/$path';
  }

  static String assetItem(int id, [Region region = Region.jp]) {
    return '$assetHost/${region.upper}/Items/$id.png';
  }

  static String dbAsset(String path) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    return '$_dbAssetHost$path';
  }
}

class AssetURL {
  static const baseUrl = 'https://static.atlasacademy.io';
  static final AssetURL i = AssetURL();

  final String region;
  AssetURL([Region region = Region.jp]) : region = region.upper;

  String pad(int id, [int width = 5]) => id.toString().padLeft(width, '0');

  String back(dynamic bgId, bool fullscreen) =>
      "$baseUrl/$region/Back/back$bgId${fullscreen ? "_1344_626" : ""}.png";
  String charaGraph(int ascension, int itemId) =>
      {
        1: "$baseUrl/$region/CharaGraph/$itemId/${itemId}a@1.png",
        2: "$baseUrl/$region/CharaGraph/$itemId/${itemId}a@2.png",
        3: "$baseUrl/$region/CharaGraph/$itemId/${itemId}b@1.png",
        4: "$baseUrl/$region/CharaGraph/$itemId/${itemId}b@2.png",
      }[ascension] ??
      "";
  String charaGraphChange(int ascension, int itemId, String suffix) =>
      {
        0: "$baseUrl/$region/CharaGraph/$itemId/$itemId$suffix@1.png",
        1: "$baseUrl/$region/CharaGraph/$itemId/$itemId$suffix@2.png",
        3: "$baseUrl/$region/CharaGraph/$itemId/$itemId$suffix@1.png",
        4: "$baseUrl/$region/CharaGraph/$itemId/$itemId$suffix@2.png",
      }[ascension] ??
      "";
  String charaGraphEx(int ascension, int itemId) =>
      {
        1: "$baseUrl/$region/CharaGraph/CharaGraphEx/$itemId/${itemId}a@1.png",
        2: "$baseUrl/$region/CharaGraph/CharaGraphEx/$itemId/${itemId}a@2.png",
        3: "$baseUrl/$region/CharaGraph/CharaGraphEx/$itemId/${itemId}b@1.png",
        4: "$baseUrl/$region/CharaGraph/CharaGraphEx/$itemId/${itemId}b@2.png",
      }[ascension] ??
      '';
  String charaGraphExCostume(int itemId) =>
      ("$baseUrl/$region/CharaGraph/CharaGraphEx/$itemId/${itemId}a.png");
  String commands(int itemId, int i) =>
      "$baseUrl/$region/Servants/Commands/$itemId/card_servant_$i.png";
  String commandFile(int itemId, String fileName) =>
      "$baseUrl/$region/Servants/Commands/$itemId/$fileName.png";
  String status(int itemId, int i) =>
      "$baseUrl/$region/Servants/Status/$itemId/status_servant_$i.png";
  String charaGraphDefault(dynamic itemId) =>
      "$baseUrl/$region/CharaGraph/$itemId/${itemId}a.png";
  String charaGraphName(int itemId, int i) =>
      "$baseUrl/$region/CharaGraph/$itemId/${itemId}name@$i.png";
  String charaFigure(int itemId, int i) =>
      "$baseUrl/$region/CharaFigure/$itemId$i/$itemId${i}_merged.png";
  String charaFigureId(dynamic figureId) =>
      ("$baseUrl/$region/CharaFigure/$figureId/${figureId}_merged.png");
  String charaFigureForm(int formId, int svtScriptId) =>
      "$baseUrl/$region/CharaFigure/Form/$formId/$svtScriptId/${svtScriptId}_merged.png";
  String narrowFigure(int ascension, int itemId) =>
      {
        1: "$baseUrl/$region/NarrowFigure/$itemId/$itemId@0.png",
        2: "$baseUrl/$region/NarrowFigure/$itemId/$itemId@1.png",
        3: "$baseUrl/$region/NarrowFigure/$itemId/$itemId@2.png",
        4: "$baseUrl/$region/NarrowFigure/$itemId/${itemId}_2@0.png",
      }[ascension] ??
      "";
  String narrowFigureChange(int ascension, int itemId, String suffix) =>
      {
        0: "$baseUrl/$region/NarrowFigure/$itemId/$itemId$suffix@0.png",
        1: "$baseUrl/$region/NarrowFigure/$itemId/$itemId$suffix@1.png",
        3: "$baseUrl/$region/NarrowFigure/$itemId/$itemId$suffix@2.png",
        4: "$baseUrl/$region/NarrowFigure/$itemId/${itemId}_2$suffix@0.png",
      }[ascension] ??
      "";
  String image(String image) => "$baseUrl/$region/Image/$image/$image.png";
  String narrowFigureDefault(int itemId) =>
      "$baseUrl/$region/NarrowFigure/$itemId/$itemId@0.png";
  String skillIcon(int itemId) =>
      "$baseUrl/$region/SkillIcons/skill_${pad(itemId)}.png";
  String buffIcon(int itemId) =>
      "$baseUrl/$region/BuffIcons/bufficon_$itemId.png";
  String items(int itemId) => "$baseUrl/$region/Items/$itemId.png";
  String coins(int itemId) => "$baseUrl/$region/Coins/$itemId.png";
  String face(int itemId, int i) => "$baseUrl/$region/Faces/f_$itemId$i.png";
  String faceChange(int itemId, int i, String suffix) =>
      "$baseUrl/$region/Faces/f_$itemId$i$suffix.png";
  String equipFace(int itemId, int i) =>
      "$baseUrl/$region/EquipFaces/f_$itemId$i.png";
  String enemy(int itemId, int i) => "$baseUrl/$region/Enemys/$itemId$i.png";
  String mcitem(int itemId) =>
      "$baseUrl/$region/Items/masterequip${pad(itemId)}.png";
  String masterFace(int itemId) =>
      "$baseUrl/$region/MasterFace/equip${pad(itemId)}.png";
  String masterFaceImage(int itemId) =>
      "$baseUrl/$region/MasterFace/image${pad(itemId)}.png";
  String masterFigure(int itemId) =>
      "$baseUrl/$region/MasterFigure/equip${pad(itemId)}.png";
  String commandCode(int itemId) =>
      "$baseUrl/$region/CommandCodes/c_$itemId.png";
  String commandGraph(int itemId) =>
      "$baseUrl/$region/CommandGraph/${itemId}a.png";
  String audio(String folder, String id) =>
      "$baseUrl/$region/Audio/$folder/$id.mp3";
  String banner(String banner) => "$baseUrl/$region/Banner/$banner.png";
  String eventUi(String event) => "$baseUrl/$region/EventUI/$event.png";
  String eventReward(String fname) => "$baseUrl/$region/EventReward/$fname.png";
  String mapImg(int mapId) =>
      "$baseUrl/$region/Terminal/MapImgs/img_questmap_${pad(mapId, 6)}/img_questmap_${pad(mapId, 6)}.png";
  String mapGimmickImg(int warAssetId, int gimmickId) =>
      "$baseUrl/$region/Terminal/QuestMap/Capter${pad(warAssetId, 6)}/QMap_Cap${pad(warAssetId, 6)}_Atlas/gimmick_${pad(gimmickId, 6)}.png";
  String spotImg(int warAssetId, int spotId) =>
      "$baseUrl/$region/Terminal/QuestMap/Capter${pad(warAssetId, 6)}/QMap_Cap${pad(warAssetId, 6)}_Atlas/spot_${pad(spotId, 6)}.png";
  String spotRoadImg(int warAssetId, int spotId) =>
      "$baseUrl/$region/Terminal/QuestMap/Capter${pad(warAssetId, 6)}/QMap_Cap${pad(warAssetId, 6)}_Atlas/img_road${pad(warAssetId, 6)}_00.png";
  String script(String scriptPath) => "$baseUrl/$region/Script/$scriptPath.txt";
  String bgmLogo(int logoId) =>
      "$baseUrl/$region/MyRoomSound/soundlogo_${pad(logoId, 3)}.png";
  String servantModel(int itemId) =>
      "$baseUrl/$region/Servants/$itemId/manifest.json";
  String movie(String itemId) => "$baseUrl/$region/Movie/$itemId.mp4";
  String marks(String itemId) => "$baseUrl/$region/Marks/$itemId.png";
}
