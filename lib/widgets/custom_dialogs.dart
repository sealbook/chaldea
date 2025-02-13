import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/utils/utils.dart';

class InputCancelOkDialog extends StatefulWidget {
  final String? title;
  final String? text;
  final String? hintText;
  final String? errorText;
  final bool Function(String s)? validate;
  final ValueChanged<String>? onSubmit;
  final TextInputType? keyboardType;

  const InputCancelOkDialog({
    super.key,
    this.title,
    this.text,
    this.hintText,
    this.errorText,
    this.validate,
    this.onSubmit,
    this.keyboardType,
  });

  @override
  State<StatefulWidget> createState() => _InputCancelOkDialogState();
}

/// debug warnings:
/// W/IInputConnectionWrapper(31507): beginBatchEdit on inactive InputConnection
/// W/IInputConnectionWrapper(31507): getTextBeforeCursor on inactive InputConnection
/// W/IInputConnectionWrapper(31507): getTextAfterCursor on inactive InputConnection
/// W/IInputConnectionWrapper(31507): getSelectedText on inactive InputConnection
/// W/IInputConnectionWrapper(31507): endBatchEdit on inactive InputConnection
class _InputCancelOkDialogState extends State<InputCancelOkDialog> {
  TextEditingController? _controller;
  bool validation = true;

  bool _validate(String v) {
    if (widget.validate != null) {
      return widget.validate!(v);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validation = _validate(_controller!.text);
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title!),
      content: TextFormField(
        controller: _controller,
        autofocus: true,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(hintText: widget.hintText, errorText: validation ? null : S.current.invalid_input),
        onChanged: (v) {
          if (widget.validate != null) {
            setState(() {
              validation = _validate(v);
            });
          }
        },
        onFieldSubmitted: (v) {
          if (!_validate(v)) {
            return;
          }
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          if (widget.onSubmit != null) {
            widget.onSubmit!(v);
          }
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text(S.current.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          onPressed: validation
              ? () {
                  String _value = _controller!.text;
                  validation = _validate(_value);
                  setState(() {
                    if (validation) {
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(_value);
                      }
                      Navigator.pop(context);
                    }
                  });
                }
              : null,
          child: Text(S.current.ok),
        )
      ],
    );
  }
}

class SimpleCancelOkDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final EdgeInsetsGeometry contentPadding;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onTapOk;
  final VoidCallback? onTapCancel;

  /// ignore if onTapCancel is not null
  final bool hideOk;
  final bool hideCancel;
  final List<Widget> actions;
  final bool scrollable;
  final bool wrapActionsInRow;
  final EdgeInsets insetPadding;

  const SimpleCancelOkDialog({
    super.key,
    this.title,
    this.content,
    this.contentPadding = const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 24.0),
    this.confirmText,
    this.cancelText,
    this.onTapOk,
    this.onTapCancel,
    this.hideOk = false,
    this.hideCancel = false,
    this.actions = const [],
    this.scrollable = false,
    this.wrapActionsInRow = false,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      if (!hideCancel)
        TextButton(
          child: Text(cancelText ?? S.current.cancel),
          onPressed: () {
            Navigator.of(context).pop(false);
            if (onTapCancel != null) {
              onTapCancel!();
            }
          },
        ),
      ...actions,
      if (!hideOk)
        TextButton(
          child: Text(confirmText ?? S.current.confirm),
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onTapOk != null) {
              onTapOk!();
            }
          },
        ),
    ];
    if (wrapActionsInRow) {
      children = [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: children,
          ),
        ),
      ];
    }
    return AlertDialog(
      title: title,
      content: content,
      contentPadding: contentPadding,
      scrollable: scrollable,
      actions: children,
      insetPadding: insetPadding,
    );
  }
}

Future<void> jumpToExternalLinkAlert({required String url, String? name, String? content}) async {
  String shownLink = url;
  String? safeLink = Uri.tryParse(url)?.toString();
  if (safeLink != null) {
    shownLink = UriX.tryDecodeFull(safeLink) ?? safeLink;
  }
  safeLink ??= url;

  bool valid = await canLaunch(safeLink);

  return showDialog(
    context: kAppKey.currentContext!,
    useRootNavigator: false,
    builder: (context) => SimpleCancelOkDialog(
      title: Text(S.current.jump_to(name ?? S.current.link)),
      content: Text.rich(TextSpan(children: [
        if (content != null) TextSpan(text: '$content\n\n'),
        TextSpan(
          text: shownLink,
          style: const TextStyle(decoration: TextDecoration.underline),
        )
      ])),
      hideOk: !valid,
      onTapOk: () async {
        String link = safeLink ?? url;
        if (await canLaunch(link)) {
          launch(link);
        } else {
          EasyLoading.showToast('Could not launch url:\n$link');
        }
      },
    ),
  );
}
