import 'package:flutter/material.dart';

import 'package:chaldea/app/modules/common/extra_assets_page.dart';
import 'package:chaldea/app/modules/common/filter_group.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/models.dart';

class SvtIllustrationTab extends StatefulWidget {
  final Servant svt;
  const SvtIllustrationTab({super.key, required this.svt});

  @override
  State<SvtIllustrationTab> createState() => _SvtIllustrationTabState();
}

class _SvtIllustrationTabState extends State<SvtIllustrationTab> {
  Servant get svt => widget.svt;
  final filter = FilterRadioData<int>();
  static const int _costumeKey = -1;
  // static const int _aprilKey = -4;
  @override
  Widget build(BuildContext context) {
    final ascensions = svt.extraAssets.faces.ascension?.keys.toList() ?? [];
    final hasCostume = svt.extraAssets.faces.costume?.isNotEmpty == true;
    final List<int> options = [
      ...ascensions,
      if (hasCostume) _costumeKey,
      // if (svt.extra.aprilFoolAssets.isNotEmpty) _aprilKey,
    ];
    return Column(
      children: [
        const SizedBox(height: 4),
        if (options.length > 1)
          FilterGroup<int>(
            options: options,
            values: filter,
            combined: true,
            optionBuilder: (key) {
              if (key == _costumeKey) return Text(S.current.costume);
              // if (key == _aprilKey) return Text(S.current.april_fool);
              return Text('$key');
            },
            onFilterChanged: (v, _) {
              setState(() {});
            },
          ),
        Expanded(
          child: ExtraAssetsPage(
            assets: svt.extraAssets,
            // aprilFoolAssets:
            //     filter.options.isEmpty || filter.options.contains(_aprilKey) ? svt.extra.aprilFoolAssets : [],
            aprilFoolAssets: svt.extra.aprilFoolAssets,
            mcSprites: svt.extra.mcSprites,
            fandomSprites: svt.extra.fandomSprites,
            getUrls: filter.options.isEmpty ? null : getUrls,
            charaGraphPlaceholder: (_, __) => db.getIconImage(svt.classCard),
          ),
        )
      ],
    );
  }

  Iterable<String> getUrls(ExtraAssetsUrl urls) sync* {
    if (urls.ascension != null) {
      yield* urls.ascension!.entries.where((e) => filter.options.contains(e.key)).map((e) => e.value);
    }
    if (urls.costume != null && filter.options.contains(_costumeKey)) {
      yield* urls.costume!.values;
    }
  }
}
