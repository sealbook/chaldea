import 'dart:io';
import 'dart:typed_data';

// import 'package:chaldea/components/components.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/basic.dart';
import 'package:chaldea/models/db.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../components/config.dart' show db;
import '../../packages/packages.dart';
import '../custom_dialogs.dart';

class ImageActions {
  static Future showSaveShare({
    required BuildContext context,
    Uint8List? data,
    String? srcFp,
    //
    bool gallery = true,
    String? destFp,
    bool share = true,
    String? shareText,
  }) {
    assert(srcFp != null || data != null);
    if (srcFp == null && data == null) return Future.value();
    return showMaterialModalBottomSheet(
      context: context,
      duration: const Duration(milliseconds: 250),
      builder: (context) {
        List<Widget> children = [];
        if (gallery && PlatformU.isMobile) {
          children.add(ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(S.current.save_to_photos),
            onTap: () async {
              Navigator.pop(context);
              if (PlatformU.isAndroid && await Permission.storage.isDenied) {
                await Permission.storage.request();
              }
              dynamic result;
              if (data != null) {
                result = await ImageGallerySaver.saveImage(data);
              } else if (srcFp != null) {
                result = await ImageGallerySaver.saveFile(srcFp);
              }
              if (result is Map && result['isSuccess'] == true) {
                EasyLoading.showSuccess(S.current.saved);
              } else {
                String? msg;
                if (result is Map) {
                  msg = result['errorMessage'];
                }
                EasyLoading.showError(msg ?? result.toString());
              }
            },
          ));
        }
        if (!PlatformU.isWeb && destFp != null) {
          children.add(ListTile(
            leading: const Icon(Icons.save),
            title: Text(S.current.save),
            onTap: () {
              Navigator.pop(context);
              final bytes = data ?? File(srcFp!).readAsBytesSync();
              File(destFp)
                ..createSync(recursive: true)
                ..writeAsBytesSync(bytes);
              SimpleCancelOkDialog(
                hideCancel: true,
                title: Text(S.current.saved),
                content: Text(runChaldeaNext
                    ? db2.paths.convertIosPath(destFp)
                    : db.paths.convertIosPath(destFp)),
                actions: [
                  if (PlatformU.isDesktop)
                    TextButton(
                      onPressed: () {
                        OpenFile.open(dirname(destFp));
                      },
                      child: Text(S.current.open),
                    ),
                ],
              ).showDialog(context);
            },
          ));
        }
        if (share && PlatformU.isMobile) {
          children.add(ListTile(
            leading: const Icon(Icons.share),
            title: Text(S.current.share),
            onTap: () async {
              Navigator.pop(context);
              if (srcFp != null) {
                await Share.shareFiles([srcFp], text: shareText);
              } else if (data != null) {
                // Although, it may not be PNG
                String fn = const Uuid()
                        .v5(Uuid.NAMESPACE_URL, data.hashCode.toString()) +
                    '.png';
                String tmpFp = join(db2.paths.tempDir, fn);
                File(tmpFp)
                  ..createSync(recursive: true)
                  ..writeAsBytesSync(data);
                await Share.shareFiles([tmpFp], text: shareText);
              }
            },
          ));
        }
        children.addAll([
          Material(
            color: Colors.grey.withOpacity(0.1),
            child: const SizedBox(height: 6),
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: Text(S.current.cancel),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ]);
        return ListView.separated(
          shrinkWrap: true,
          controller: ModalScrollController.of(context),
          itemBuilder: (context, index) => children[index],
          separatorBuilder: (_, __) =>
              const Divider(height: 0.5, thickness: 0.5),
          itemCount: children.length,
        );
      },
    );
  }
}
