import 'package:chaldea/components/components.dart';

import '../servant_detail_page.dart';
import 'svt_tab_base.dart';

class SvtIllustTab extends SvtTabBaseWidget {
  SvtIllustTab({
    Key? key,
    ServantDetailPageState? parent,
    Servant? svt,
    ServantStatus? status,
  }) : super(key: key, parent: parent, svt: svt, status: status);

  @override
  _SvtIllustTabState createState() =>
      _SvtIllustTabState(parent: parent, svt: svt, plan: status);
}

class _SvtIllustTabState extends SvtTabBaseState<SvtIllustTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  _SvtIllustTabState(
      {ServantDetailPageState? parent, Servant? svt, ServantStatus? plan})
      : super(parent: parent, svt: svt, status: plan);

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: svt.info.illustrations.length, vsync: this);
  }

  Widget placeholder(BuildContext context, String? url) {
    final _colors = ['黑', '铜', '铜', '银', '金', '金'];
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    String key = '${capitalize(svt.info.className)}'
        '${_colors[svt.info.rarity]}卡背';
    if (svt.no == 285) {
      // 泳装杀生院
      key += '2';
    } else if (svt.no == 1) {
      //玛修
      key = '普通金卡背';
    } else if (svt.info.className.toLowerCase().startsWith('beast')) {
      key = '普通黑卡背';
    }
    return db.getIconImage(key);
  }

  String _localize(String s) {
    return s.replaceFirstMapped(RegExp(r'第(.)阶段'), (match) {
      final n = match.group(1);
      return LocalizedText(chs: '第$n阶段', jpn: '第$n段階 ', eng: 'Stage $n')
          .localized;
    }).replaceFirst(
      '愚人节',
      LocalizedText(chs: '愚人节', jpn: 'エイプリルフール', eng: "April Fools' Day")
          .localized,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = svt.info.illustrations.values.toList();
    return Column(
      children: <Widget>[
        TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: svt.info.illustrations.keys
                .map((e) => Tab(
                    child: Text(_localize(e),
                        style: TextStyle(color: Colors.black87))))
                .toList()),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(svt.info.illustrations.length, (index) {
              return GestureDetector(
                onTap: () async {
                  int? newIndex =
                      await Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    fullscreenDialog: true,
                    pageBuilder: (context, _, __) => FullScreenImageSlider(
                      imgUrls: imageUrls,
                      initialPage: index,
                      connectivity: db.connectivity,
                      placeholder: placeholder,
                    ),
                  ));
                  if (newIndex != null) {
                    _tabController.animateTo(newIndex);
                  }
                },
                child: CachedImage(
                  imageUrl: imageUrls[index],
                  placeholder: placeholder,
                  connectivity: db.connectivity,
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
