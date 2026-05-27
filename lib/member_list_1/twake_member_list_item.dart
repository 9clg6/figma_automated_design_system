import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Enum representing the role of a member in a list.
enum MemberRole { owner, admin, member }

/// Enum representing the display/interaction type of the member list item.
enum MemberListItemType { defaultType, unselect, selected, addContact, disabledContact }

/// A list item widget that displays member information including avatar,
/// name, role, status, and optional matrix/email identifiers.
///
/// Matches the Figma "Member list 1" component set.
class TwakeMemberListItem extends StatelessWidget {
  // --- Identity ---
  final String name;
  final String? statusText;
  final ImageProvider<Object>? avatarImage;

  // --- Role ---
  final MemberRole role;

  // --- Type/Interaction ---
  final MemberListItemType type;

  // --- Optional fields ---
  final bool showLastSeen;
  final String? lastSeenTime;
  final bool showMatrixId;
  final String? matrixId;
  final bool showEmail;
  final String? email;

  // --- Callbacks ---
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;

  // --- Theme override ---
  final Color? backgroundColor;
  final Color? textColor;

  const TwakeMemberListItem({
    Key? key,
    required this.name,
    this.statusText,
    this.avatarImage,
    this.role = MemberRole.member,
    this.type = MemberListItemType.defaultType,
    this.showLastSeen = false,
    this.lastSeenTime,
    this.showMatrixId = false,
    this.matrixId,
    this.showEmail = false,
    this.email,
    this.onTap,
    this.onCheckboxChanged,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  bool get _hasCheckbox =>
      type == MemberListItemType.unselect ||
      type == MemberListItemType.selected;

  bool get _isSelected => type == MemberListItemType.selected;

  bool get _isAddContact => type == MemberListItemType.addContact;

  bool get _isDisabledContact => type == MemberListItemType.disabledContact;

  String get _roleLabel {
    switch (role) {
      case MemberRole.owner:
        return 'Owner';
      case MemberRole.admin:
        return 'Admin';
      case MemberRole.member:
        return '';
    }
  }

  bool get _showRole => role != MemberRole.member;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color resolvedBackground;
    if (backgroundColor != null) {
      resolvedBackground = backgroundColor!;
    } else if (_isSelected) {
      resolvedBackground = isDark
          ? const Color(0xFF3A3A3C)
          : LinagoraSysColors.material().secondaryContainer;
    } else {
      resolvedBackground = Colors.transparent;
    }

    final Color nameColor = textColor ?? (isDark ? Colors.white : const Color(0xFF1C1B1F));
    final Color subtitleColor = textColor != null
        ? textColor!.withOpacity(0.7)
        : (isDark ? Colors.white70 : const Color(0xFF49454F));
    final Color onlineColor = const Color(0xFF4CAF50);
    final Color roleColor = isDark ? Colors.white70 : const Color(0xFF49454F);

    double itemHeight;
    if (showMatrixId && showEmail) {
      itemHeight = 80.0;
    } else if (showLastSeen || showMatrixId || showEmail) {
      itemHeight = 72.0;
    } else {
      itemHeight = 72.0;
    }

    return InkWell(
      onTap: (_isDisabledContact) ? null : onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: itemHeight),
        color: resolvedBackground,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_hasCheckbox) ...
              [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isSelected,
                    onChanged: _isDisabledContact ? null : onCheckboxChanged,
                    activeColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            // Avatar
            _MemberAvatar(
              name: name,
              imageProvider: avatarImage,
              isDisabled: _isDisabledContact,
            ),
            const SizedBox(width: 12),
            // Name + info
            Expanded(
              child: _MemberInfo(
                name: name,
                statusText: statusText,
                showLastSeen: showLastSeen,
                lastSeenTime: lastSeenTime,
                showMatrixId: showMatrixId,
                matrixId: matrixId,
                showEmail: showEmail,
                email: email,
                nameColor: nameColor,
                subtitleColor: subtitleColor,
                onlineColor: onlineColor,
                isDisabled: _isDisabledContact,
              ),
            ),
            // Role label or action icon
            if (_showRole && !_isAddContact && !_isDisabledContact)
              Text(
                _roleLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: roleColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            if (_isAddContact)
              Icon(
                Icons.person_add_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
            if (_isDisabledContact)
              Icon(
                Icons.person_off_outlined,
                size: 20,
                color: subtitleColor,
              ),
          ],
        ),
      ),
    );
  }
}

/// Private widget for the circular avatar.
class _MemberAvatar extends StatelessWidget {
  final String name;
  final ImageProvider<Object>? imageProvider;
  final bool isDisabled;

  const _MemberAvatar({
    required this.name,
    this.imageProvider,
    this.isDisabled = false,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Color avatarBg = isDisabled
        ? Colors.grey.shade400
        : const Color(0xFF8B6A9B);

    return CircleAvatar(
      radius: 20,
      backgroundColor: avatarBg,
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}

/// Private widget for member text info.
class _MemberInfo extends StatelessWidget {
  final String name;
  final String? statusText;
  final bool showLastSeen;
  final String? lastSeenTime;
  final bool showMatrixId;
  final String? matrixId;
  final bool showEmail;
  final String? email;
  final Color nameColor;
  final Color subtitleColor;
  final Color onlineColor;
  final bool isDisabled;

  const _MemberInfo({
    required this.name,
    this.statusText,
    this.showLastSeen = false,
    this.lastSeenTime,
    this.showMatrixId = false,
    this.matrixId,
    this.showEmail = false,
    this.email,
    required this.nameColor,
    required this.subtitleColor,
    required this.onlineColor,
    this.isDisabled = false,
  });

  bool get _isOnline => statusText?.toLowerCase() == 'online';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDisabled ? subtitleColor : nameColor,
            height: 1.4,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Status / Online
        if (statusText != null && !showLastSeen) ...
          [
            const SizedBox(height: 2),
            Text(
              statusText!,
              style: TextStyle(
                fontSize: 12,
                color: _isOnline ? onlineColor : subtitleColor,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        // Last seen
        if (showLastSeen && lastSeenTime != null) ...
          [
            const SizedBox(height: 2),
            Text(
              'Last seen at $lastSeenTime',
              style: TextStyle(
                fontSize: 12,
                color: subtitleColor,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        // Matrix ID
        if (showMatrixId && matrixId != null) ...
          [
            const SizedBox(height: 2),
            Text(
              matrixId!,
              style: TextStyle(
                fontSize: 11,
                color: subtitleColor,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        // Email
        if (showEmail && email != null) ...
          [
            const SizedBox(height: 2),
            Text(
              email!,
              style: TextStyle(
                fontSize: 11,
                color: subtitleColor,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
      ],
    );
  }
}
