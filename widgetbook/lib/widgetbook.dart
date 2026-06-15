import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart' hide AlignmentAddon;
import 'package:widgetbook_workspace/components/avatar_component/avatar_use_case.dart';
import 'package:widgetbook_workspace/components/badges_component/badges_use_case.dart';
import 'package:widgetbook_workspace/components/bottom_sheets_component/bottom_sheets_use_case.dart';
import 'package:widgetbook_workspace/components/box_text_component/box_text_use_case.dart';
import 'package:widgetbook_workspace/components/bubble_media_component/bubble_media_use_case.dart';
import 'package:widgetbook_workspace/components/bubble_message_component/bubble_message_use_case.dart';
import 'package:widgetbook_workspace/components/bubble_thread_component/bubble_thread_use_case.dart';
import 'package:widgetbook_workspace/components/buttons_component/buttons_use_case.dart';
import 'package:widgetbook_workspace/components/cards_component/cards_use_case.dart';
import 'package:widgetbook_workspace/components/chat_message_component/chat_message_use_case.dart';
import 'package:widgetbook_workspace/components/checkboxes_component/checkboxes_use_case.dart';
import 'package:widgetbook_workspace/components/chips_component/chips_use_case.dart';
import 'package:widgetbook_workspace/components/date_pickers_component/date_pickers_use_case.dart';
import 'package:widgetbook_workspace/components/dialog_modal_component/dialog_modal_use_case.dart';
import 'package:widgetbook_workspace/components/floating_action_buttons_fab_component/floating_action_buttons_fab_use_case.dart';
import 'package:widgetbook_workspace/components/headers_component/headers_use_case.dart';
import 'package:widgetbook_workspace/components/icon_button_component/icon_button_use_case.dart';
import 'package:widgetbook_workspace/components/input_field_component/input_field_use_case.dart';
import 'package:widgetbook_workspace/components/label_component/label_use_case.dart';
import 'package:widgetbook_workspace/components/lists_component/lists_use_case.dart';
import 'package:widgetbook_workspace/components/members_list_component/members_list_use_case.dart';
import 'package:widgetbook_workspace/components/menu_new_desktop_mobile_component/menu_new_desktop_mobile_use_case.dart';
import 'package:widgetbook_workspace/components/menus_component/menus_use_case.dart';
import 'package:widgetbook_workspace/components/message_counter_component/message_counter_use_case.dart';
import 'package:widgetbook_workspace/components/message_type_icon_component/message_type_icon_use_case.dart';
import 'package:widgetbook_workspace/components/navigation_rail_component/navigation_rail_use_case.dart';
import 'package:widgetbook_workspace/components/pin_events_component/pin_events_use_case.dart';
import 'package:widgetbook_workspace/components/radio_buttons_component/radio_buttons_use_case.dart';
import 'package:widgetbook_workspace/components/reaction_chat_component/reaction_chat_use_case.dart';
import 'package:widgetbook_workspace/components/settings_component/settings_use_case.dart';
import 'package:widgetbook_workspace/components/side_sheets_component/side_sheets_use_case.dart';
import 'package:widgetbook_workspace/components/sliders_component/sliders_use_case.dart';
import 'package:widgetbook_workspace/components/snackbars_component/snackbars_use_case.dart';
import 'package:widgetbook_workspace/components/switch_component/switch_use_case.dart';
import 'package:widgetbook_workspace/components/tabs_component/tabs_use_case.dart';
import 'package:widgetbook_workspace/components/timestamp_component/timestamp_use_case.dart';
import 'package:widgetbook_workspace/components/tooltips_component/tooltips_use_case.dart';
import 'package:widgetbook_workspace/components/typing_bar_component/typing_bar_use_case.dart';
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
            WidgetbookComponent(
              name: 'Avatar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => avatarDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Badges',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => badgesDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Bottom sheets',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => bottomsheetsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Box text',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => boxtextDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Bubble media',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => bubblemediaDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Bubble message',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => bubblemessageDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Bubble thread',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => bubblethreadDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Buttons',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => buttonsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Cards',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => cardsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Chat message',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => chatmessageDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Checkboxes',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => checkboxesDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Chips',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => chipsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Date pickers',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => datepickersDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Dialog modal',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => dialogmodalDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Floating action buttons (FAB)',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => floatingactionbuttonsfabDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Headers',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => headersDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Icon button',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => iconbuttonDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Input field',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => inputfieldDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Label',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => labelDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Lists',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => listsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Members list',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => memberslistDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'menu new (desktop+mobile)',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => menunewdesktopmobileDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Menus',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => menusDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Message counter',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => messagecounterDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Message type icon',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => messagetypeiconDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Navigation rail',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => navigationrailDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Pin events',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => pineventsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Radio buttons',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => radiobuttonsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Reaction chat',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => reactionchatDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Settings',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => settingsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Side sheets',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => sidesheetsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Sliders',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => slidersDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Snackbars',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => snackbarsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Switch',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => switchDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Tabs',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => tabsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Timestamp',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => timestampDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Tooltips',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => tooltipsDefaultUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Typing bar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => typingbarDefaultUseCase(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
