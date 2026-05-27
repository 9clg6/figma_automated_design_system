import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_key_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';

class LinagoraDialogOption<T> extends Equatable {
  const LinagoraDialogOption({
    required this.name,
    required this.value,
    this.trailingIcon,
  });

  final String name;
  final T value;
  final Widget? trailingIcon;

  @override
  List<Object?> get props => [name, value, trailingIcon];
}

class OptionsDialog<T> extends StatelessWidget {
  const OptionsDialog({
    super.key,
    required this.title,
    required this.availableOptions,
    required this.onSelected,
    this.description,
    this.isBottomSheet = false,
  });

  final String title;
  final String? description;
  final List<LinagoraDialogOption<T>> availableOptions;
  final void Function(LinagoraDialogOption<T> selected) onSelected;
  final bool isBottomSheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Widget? descriptionWidget;

    // Close button width is 48px (4px padding + 40px IconButton)
    const double closeButtonWidth = 48.0;

    final closeButton = Padding(
      padding: const EdgeInsets.all(4),
      child: IconButton(
        onPressed: Navigator.of(context).pop,
        icon: Icon(
          Icons.close,
          color: LinagoraRefColors.material().neutral[10],
        ),
      ),
    );

    // Use headlineSmall from theme for both variants without hardcoded fontSize/height
    final titleWidget = Text(
      title,
      textAlign: TextAlign.center,
      style: isBottomSheet
          ? textTheme.headlineSmall?.copyWith(
              color: LinagoraRefColors.material().neutral[10],
            )
          : textTheme.headlineSmall?.copyWith(
              color: LinagoraRefColors.material().neutral[10],
            ),
    );

    // separator border color: use theme primary color at 0.16 alpha via colorScheme
    final separatorColor = theme.colorScheme.primary.withAlpha(41); // 0.16 * 255 ≈ 41

    final items = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: availableOptions.map(
          (option) {
            return Column(
              children: [
                if (option != availableOptions.first)
                  Container(
                    height: 1,
                    color: separatorColor,
                  ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                vertical: 4,
                              ),
                              child: Text(
                                option.name,
                                // Use bodyMedium from theme without explicit fontSize/height/letterSpacing override
                                style: textTheme.bodyMedium?.copyWith(
                                  color:
                                      LinagoraRefColors.material().neutral[10],
                                ),
                              ),
                            ),
                          ),
                          if (option.trailingIcon != null)
                            Container(
                              width: 24,
                              height: 24,
                              margin:
                                  const EdgeInsetsDirectional.only(start: 8),
                              child: option.trailingIcon,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );

    if (description != null) {
      final descriptionTextStyle = isBottomSheet
          ? textTheme.headlineSmall?.copyWith(
              color: LinagoraRefColors.material().neutral[10],
            )
          : textTheme.titleSmall?.copyWith(
              color: LinagoraRefColors.material().neutral[10],
            );

      descriptionWidget = Padding(
        padding: const EdgeInsetsDirectional.all(8),
        child: Text(
          description!,
          style: descriptionTextStyle,
        ),
      );
    }

    if (isBottomSheet) {
      return Dialog(
        backgroundColor: const Color(0xFFFFFFFF),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 312,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: closeButtonWidth),
                      Expanded(
                        child: titleWidget,
                      ),
                      closeButton,
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (descriptionWidget != null)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(bottom: 8),
                            child: descriptionWidget,
                          ),
                        Flexible(child: items),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 312),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: closeButtonWidth),
                Expanded(child: titleWidget),
                closeButton,
              ],
            ),
            if (descriptionWidget != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8),
                child: descriptionWidget,
              ),
            Flexible(child: items),
          ],
        ),
      ),
    );
  }
}
