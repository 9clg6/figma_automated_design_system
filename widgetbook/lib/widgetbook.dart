import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart' hide AlignmentAddon;
import 'package:widgetbook_workspace/components/avatar_component/avatar_use_case.dart';
import 'package:widgetbook_workspace/components/badge_component/badge_use_case.dart';
import 'package:widgetbook_workspace/components/bar_logo_web_component/bar_logo_web_use_case.dart';
import 'package:widgetbook_workspace/components/bottom_navigation_component/bottom_navigation_use_case.dart';
import 'package:widgetbook_workspace/components/bottom_sheet_component/bottom_sheet_use_case.dart';
import 'package:widgetbook_workspace/components/bubble_message_component/bubble_message_use_case.dart';
import 'package:widgetbook_workspace/components/button_component/button_use_case.dart';
import 'package:widgetbook_workspace/components/checkbox_component/checkbox_use_case.dart';
import 'package:widgetbook_workspace/components/contact_component/matrix_contact_use_case.dart';
import 'package:widgetbook_workspace/components/contact_component/phonebook_contact_use_case.dart';
import 'package:widgetbook_workspace/components/date_picker_component/date_picker_use_case.dart';
import 'package:widgetbook_workspace/components/dialog2_component/dialog2_use_case.dart';
import 'package:widgetbook_workspace/components/dialog_component/confirmation_dialog_use_case.dart';
import 'package:widgetbook_workspace/components/dialog_component/options_dialog_use_case.dart';
import 'package:widgetbook_workspace/components/divider_component/divider_use_case.dart';
import 'package:widgetbook_workspace/components/file_component/file_use_case.dart';
import 'package:widgetbook_workspace/components/hover_style_component/hover_style_use_case.dart';
import 'package:widgetbook_workspace/components/icon_button_web_component/icon_button_web_use_case.dart';
import 'package:widgetbook_workspace/components/input_chip_component/input_chip_use_case.dart';
import 'package:widgetbook_workspace/components/label_component/label_use_case.dart';
import 'package:widgetbook_workspace/components/linear_progress_indicator_component/linear_progress_indicator_use_case.dart';
import 'package:widgetbook_workspace/components/list_item_component/list_item_use_case.dart';
import 'package:widgetbook_workspace/components/member_list_item_component/member_list_item_use_case.dart';
import 'package:widgetbook_workspace/components/menu_with_text_field_component/menu_with_text_field_use_case.dart';
import 'package:widgetbook_workspace/components/message_list_item_component/message_list_item_use_case.dart';
import 'package:widgetbook_workspace/components/message_context_menu_component/message_context_menu_use_case.dart';
import 'package:widgetbook_workspace/components/message_counter_component/message_counter_use_case.dart';
import 'package:widgetbook_workspace/components/message_type_icon_component/message_type_icon_use_case.dart';
import 'package:widgetbook_workspace/components/pin_event_component/pin_event_use_case.dart';
import 'package:widgetbook_workspace/components/reaction_component/reaction_use_case.dart';
import 'package:widgetbook_workspace/components/search_tab_component/search_tab_use_case.dart';
import 'package:widgetbook_workspace/components/setting_profile_component/setting_profile_use_case.dart';
import 'package:widgetbook_workspace/components/side_sheet_component/side_sheet_use_case.dart';
import 'package:widgetbook_workspace/components/slider_component/slider_use_case.dart';
import 'package:widgetbook_workspace/components/small_fab_component/small_fab_use_case.dart';
import 'package:widgetbook_workspace/components/snackbar_component/snackbar_use_case.dart';
import 'package:widgetbook_workspace/components/stacked_card_component/stacked_card_use_case.dart';
import 'package:widgetbook_workspace/components/switch_component/switch_use_case.dart';
import 'package:widgetbook_workspace/components/text_field_component/text_field_use_case.dart';
import 'package:widgetbook_workspace/components/threads_bubble_component/threads_bubble_use_case.dart';
import 'package:widgetbook_workspace/components/timestamp_component/timestamp_use_case.dart';
import 'package:widgetbook_workspace/components/tooltip_component/tooltip_use_case.dart';
import 'package:widgetbook_workspace/components/typing_bar_component/typing_bar_use_case.dart';
import 'package:widgetbook_workspace/components/welcome_screen_component/welcome_screen_use_case.dart';
import 'package:widgetbook_workspace/custom/github_addon.dart';
import 'package:widgetbook_workspace/theme/theme_data.dart';

import 'custom/alignment_addon.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.light(),
      addons: [
        GitHubAddon('widgetbook'),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.ios.iPad,
          ],
          initialDevice: Devices.ios.iPhone13,
        ),
        InspectorAddon(),
        ThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: TwakeThemes.buildTheme(
                context,
                Brightness.light,
                LinagoraSysColors.material().onPrimary,
              ),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: TwakeThemes.buildTheme(
                context,
                Brightness.dark,
                LinagoraSysColors.material().onPrimary,
              ),
            ),
          ],
          themeBuilder: (context, theme, child) => ColoredBox(
            color: LinagoraSysColors.material().onPrimary,
            child: DefaultTextStyle(
              style: theme.textTheme.bodyLarge ?? const TextStyle(),
              child: AppTheme(
                data: theme,
                child: child,
              ),
            ),
          ),
        ),
        AlignmentAddon(),
        BuilderAddon(
          name: 'SafeArea',
          builder: (_, child) => SafeArea(
            child: child,
          ),
        ),
      ],
      directories: [
        WidgetbookFolder(
          name: 'Components',
          children: [
            // ── Avatar ──────────────────────────────────
            WidgetbookComponent(
              name: 'Avatar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Monogram',
                  builder: (context) => avatarMonogramUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'All sizes',
                  builder: (context) => avatarSizesUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Gradient colors',
                  builder: (context) => avatarGradientsUseCase(context),
                ),
              ],
            ),

            // ── Badge ───────────────────────────────────
            WidgetbookComponent(
              name: 'Badge',
              useCases: [
                WidgetbookUseCase(
                  name: 'Small dot',
                  builder: (context) => badgeSmallUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Single digit',
                  builder: (context) => badgeSingleDigitUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Multiple digits',
                  builder: (context) => badgeMultipleDigitsUseCase(context),
                ),
              ],
            ),

            // ── Bar Logo Web ────────────────────────────
            WidgetbookComponent(
              name: 'Bar Logo Web',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => barLogoWebDefaultUseCase(context),
                ),
              ],
            ),

            // ── Bottom Navigation ───────────────────────
            WidgetbookComponent(
              name: 'Bottom Navigation',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      bottomNavigationDefaultUseCase(context),
                ),
              ],
            ),

            // ── Bottom Sheet ────────────────────────────
            WidgetbookComponent(
              name: 'Bottom Sheet',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      bottomSheetDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Modal',
                  builder: (context) => bottomSheetModalUseCase(context),
                ),
              ],
            ),

            // ── Bubble Message ──────────────────────────
            WidgetbookComponent(
              name: 'Bubble Message',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      bubbleMessageDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Sender',
                  builder: (context) =>
                      bubbleMessageSenderUseCase(context),
                ),
              ],
            ),

            // ── Button ──────────────────────────────────
            WidgetbookComponent(
              name: 'Button',
              useCases: [
                WidgetbookUseCase(
                  name: 'Filled',
                  builder: (context) => buttonFilledUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'All types',
                  builder: (context) => buttonAllTypesUseCase(context),
                ),
              ],
            ),

            // ── Checkbox ────────────────────────────────
            WidgetbookComponent(
              name: 'Checkbox',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => checkboxDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'All types',
                  builder: (context) => checkboxAllTypesUseCase(context),
                ),
              ],
            ),

            // ── Dialog ──────────────────────────────────
            WidgetbookComponent(
              name: 'Confirmation Dialog',
              useCases: [
                WidgetbookUseCase(
                  name: 'Basic',
                  builder: (context) => dialogBasicUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Vertical actions',
                  builder: (context) => dialogVerticalUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'With close button',
                  builder: (context) => dialogCloseButtonUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Options Dialog',
              useCases: [
                WidgetbookUseCase(
                  name: 'Basic',
                  builder: (context) => optionsDialogBasicUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'With description',
                  builder: (context) =>
                      optionsDialogDescriptionUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'With icons',
                  builder: (context) => optionsDialogIconsUseCase(context),
                ),
              ],
            ),

            // ── Dialog 2 ────────────────────────────────
            WidgetbookComponent(
              name: 'Dialog 2',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => dialog2DefaultUseCase(context),
                ),
              ],
            ),

            // ── Date Picker ─────────────────────────────
            WidgetbookComponent(
              name: 'Date Picker',
              useCases: [
                WidgetbookUseCase(
                  name: 'Single date',
                  builder: (context) => datePickerSingleUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Date range',
                  builder: (context) => datePickerRangeUseCase(context),
                ),
              ],
            ),

            // ── Divider ─────────────────────────────────
            WidgetbookComponent(
              name: 'Divider',
              useCases: [
                WidgetbookUseCase(
                  name: 'Horizontal',
                  builder: (context) => dividerHorizontalUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'In a list',
                  builder: (context) => dividerInListUseCase(context),
                ),
              ],
            ),

            // ── File ────────────────────────────────────
            WidgetbookComponent(
              name: 'File',
              useCases: [
                WidgetbookUseCase(
                  name: 'Preview',
                  builder: (context) => filePreviewUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Media',
                  builder: (context) => fileMediaUseCase(context),
                ),
              ],
            ),

            // ── Hover Style ─────────────────────────────
            WidgetbookComponent(
              name: 'Hover Style',
              useCases: [
                WidgetbookUseCase(
                  name: 'Style properties',
                  builder: (context) => hoverStylePropertiesUseCase(context),
                ),
              ],
            ),

            // ── Icon Button Web ─────────────────────────
            WidgetbookComponent(
              name: 'Icon Button Web',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      iconButtonWebDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'All configurations',
                  builder: (context) =>
                      iconButtonWebAllConfigsUseCase(context),
                ),
              ],
            ),

            // ── Input Chip ──────────────────────────────
            WidgetbookComponent(
              name: 'Input Chip',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => inputChipDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Selected with trailing icon',
                  builder: (context) => inputChipSelectedUseCase(context),
                ),
              ],
            ),

            // ── Label ───────────────────────────────────
            WidgetbookComponent(
              name: 'Label',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => labelDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'All variants',
                  builder: (context) => labelAllVariantsUseCase(context),
                ),
              ],
            ),

            // ── Linear Progress Indicator ───────────────
            WidgetbookComponent(
              name: 'Linear Progress Indicator',
              useCases: [
                WidgetbookUseCase(
                  name: 'Determinate',
                  builder: (context) =>
                      linearProgressDeterminateUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Indeterminate',
                  builder: (context) =>
                      linearProgressIndeterminateUseCase(context),
                ),
              ],
            ),

            // ── List Item ───────────────────────────────
            WidgetbookComponent(
              name: 'List Item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Line variants',
                  builder: (context) => listItemVariantsUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Leading & trailing',
                  builder: (context) =>
                      listItemLeadingTrailingUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'InkWell states',
                  builder: (context) => inkwellStatesUseCase(context),
                ),
              ],
            ),

            // ── Member List Item ────────────────────────
            WidgetbookComponent(
              name: 'Member List Item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      memberListItemDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Admin with details',
                  builder: (context) =>
                      memberListItemAdminUseCase(context),
                ),
              ],
            ),

            // ── Menu With Text Field ────────────────────
            WidgetbookComponent(
              name: 'Menu With Text Field',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      menuWithTextFieldDefaultUseCase(context),
                ),
              ],
            ),

            // ── Message Context Menu ────────────────────
            WidgetbookComponent(
              name: 'Message Context Menu',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      messageContextMenuDefaultUseCase(context),
                ),
              ],
            ),

            // ── Message Counter ─────────────────────────
            WidgetbookComponent(
              name: 'Message Counter',
              useCases: [
                WidgetbookUseCase(
                  name: 'Single digit',
                  builder: (context) =>
                      messageCounterSingleUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Multiple digits with mention',
                  builder: (context) =>
                      messageCounterMultipleUseCase(context),
                ),
              ],
            ),

            // ── Message List Item ───────────────────────
            WidgetbookComponent(
              name: 'Message List Item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      messageListItemDefaultUseCase(context),
                ),
              ],
            ),

            // ── Message Type Icon ───────────────────────
            WidgetbookComponent(
              name: 'Message Type Icon',
              useCases: [
                WidgetbookUseCase(
                  name: 'All types',
                  builder: (context) =>
                      messageTypeIconAllUseCase(context),
                ),
              ],
            ),

            // ── Pin Event ───────────────────────────────
            WidgetbookComponent(
              name: 'Pin Event',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => pinEventDefaultUseCase(context),
                ),
              ],
            ),

            // ── Reaction ────────────────────────────────
            WidgetbookComponent(
              name: 'Reaction Picker',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      reactionPickerDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Custom size',
                  builder: (context) =>
                      reactionPickerCustomUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'With my reaction',
                  builder: (context) =>
                      reactionPickerMyReactionUseCase(context),
                ),
              ],
            ),

            // ── Search Tab ──────────────────────────────
            WidgetbookComponent(
              name: 'Search Tab',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => searchTabDefaultUseCase(context),
                ),
              ],
            ),

            // ── Setting Profile ─────────────────────────
            WidgetbookComponent(
              name: 'Setting Profile',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      settingProfileDefaultUseCase(context),
                ),
              ],
            ),

            // ── Side Sheet ──────────────────────────────
            WidgetbookComponent(
              name: 'Side Sheet',
              useCases: [
                WidgetbookUseCase(
                  name: 'Standard',
                  builder: (context) =>
                      sideSheetStandardUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Modal',
                  builder: (context) => sideSheetModalUseCase(context),
                ),
              ],
            ),

            // ── Slider ──────────────────────────────────
            WidgetbookComponent(
              name: 'Slider',
              useCases: [
                WidgetbookUseCase(
                  name: 'Continuous',
                  builder: (context) =>
                      sliderContinuousUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Discrete',
                  builder: (context) => sliderDiscreteUseCase(context),
                ),
              ],
            ),

            // ── Small FAB ───────────────────────────────
            WidgetbookComponent(
              name: 'Small FAB',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => smallFabDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'All configurations',
                  builder: (context) =>
                      smallFabAllConfigsUseCase(context),
                ),
              ],
            ),

            // ── Snackbar ────────────────────────────────
            WidgetbookComponent(
              name: 'Snackbar',
              useCases: [
                WidgetbookUseCase(
                  name: 'One line',
                  builder: (context) => snackbarOneLineUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'With action and close',
                  builder: (context) =>
                      snackbarWithActionUseCase(context),
                ),
              ],
            ),

            // ── Stacked Card ────────────────────────────
            WidgetbookComponent(
              name: 'Stacked Card',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      stackedCardDefaultUseCase(context),
                ),
              ],
            ),

            // ── Switch ──────────────────────────────────
            WidgetbookComponent(
              name: 'Switch',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => switchDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Selected with icon',
                  builder: (context) => switchSelectedUseCase(context),
                ),
              ],
            ),

            // ── Text Field ──────────────────────────────
            WidgetbookComponent(
              name: 'Text Field',
              useCases: [
                WidgetbookUseCase(
                  name: 'Filled',
                  builder: (context) => textFieldFilledUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Outline',
                  builder: (context) => textFieldOutlineUseCase(context),
                ),
              ],
            ),

            // ── Threads Bubble ──────────────────────────
            WidgetbookComponent(
              name: 'Threads Bubble',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      threadsBubbleDefaultUseCase(context),
                ),
              ],
            ),

            // ── Timestamp ───────────────────────────────
            WidgetbookComponent(
              name: 'Timestamp',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => timestampDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'On scrolling pill',
                  builder: (context) =>
                      timestampScrollingUseCase(context),
                ),
              ],
            ),

            // ── Tooltip ─────────────────────────────────
            WidgetbookComponent(
              name: 'Tooltip',
              useCases: [
                WidgetbookUseCase(
                  name: 'Plain',
                  builder: (context) => tooltipPlainUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Rich',
                  builder: (context) => tooltipRichUseCase(context),
                ),
              ],
            ),

            // ── Typing Bar ──────────────────────────────
            WidgetbookComponent(
              name: 'Typing Bar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => typingBarDefaultUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Reply mode',
                  builder: (context) => typingBarReplyUseCase(context),
                ),
              ],
            ),

            // ── Contact Item ────────────────────────────
            WidgetbookComponent(
              name: 'Contact Item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Phonebook contact',
                  builder: (context) => phonebookContactUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Matrix contact',
                  builder: (context) => matrixContactUseCase(context),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Screens',
          children: [
            // ── Welcome Screen ──────────────────────────
            WidgetbookComponent(
              name: 'Welcome Screen',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => welcomeScreenUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Homeserver Button',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => homeserverButtonUseCase(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
