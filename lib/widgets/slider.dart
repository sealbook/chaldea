import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

class SliderWithTitle extends StatelessWidget {
  final String leadingText;
  final int min;
  final int max;
  final int value;
  final String label;
  final ValueChanged<double> onChange;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const SliderWithTitle({
    super.key,
    required this.leadingText,
    required this.min,
    required this.max,
    required this.value,
    required this.label,
    required this.onChange,
    this.padding = const EdgeInsets.only(top: 8),
    this.maxWidth = 360,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: Text('$leadingText: $label'),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 24,
            maxWidth: maxWidth,
          ),
          child: Slider(
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max > min ? max - min : null,
            value: value.toDouble(),
            label: label,
            onChanged: (v) {
              onChange(v);
            },
          ),
        )
      ],
    );
  }
}

class SliderWithPrefix extends StatelessWidget {
  final String label;
  final String? valueText;
  final int min;
  final int max;
  final int value;
  final ValueChanged<double> onChange;
  final double leadingWidth;
  final double endOffset;

  const SliderWithPrefix({
    super.key,
    required this.label,
    this.valueText,
    required this.min,
    required this.max,
    required this.value,
    required this.onChange,
    this.leadingWidth = 48,
    this.endOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8)),
      child: Slider(
        min: min.toDouble(),
        max: max.toDouble(),
        divisions: max > min ? max - min : null,
        value: value.toDouble(),
        label: valueText ?? value.toString(),
        onChanged: (v) {
          onChange(v);
        },
      ),
    );
    return Row(
      children: [
        SizedBox(
          width: leadingWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AutoSizeText(
                label,
                maxLines: 1,
                minFontSize: 10,
                maxFontSize: 16,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (valueText != null)
                AutoSizeText(
                  valueText!,
                  maxLines: 1,
                  minFontSize: 10,
                  maxFontSize: 14,
                ),
            ],
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320, maxHeight: 24),
            child: Stack(
              children: [
                PositionedDirectional(
                  start: -16,
                  end: endOffset,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 24),
                    child: slider,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
