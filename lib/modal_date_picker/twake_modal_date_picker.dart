import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Mode of the date picker: single date or date range.
enum TwakeDatePickerMode { single, range }

/// A modal date picker matching the Linagora / Twake Figma spec.
///
/// Supports both single-date selection and a departure-return range mode.
/// The widget is purely presentational: all business logic is handled via
/// callbacks.
class TwakeModalDatePicker extends StatefulWidget {
  /// Label shown above the headline (e.g. "Select date").
  final String supportingText;

  /// Secondary label used in range mode (e.g. "Depart - Return dates").
  final String supportingTextRange;

  /// Headline for single mode (e.g. "Mon, Aug 17").
  final String headline;

  /// Headline for range mode (e.g. "Aug 17 – Aug 23").
  final String headlineRange;

  /// Whether the picker is in range or single mode.
  final TwakeDatePickerMode mode;

  /// The initially displayed month.
  final DateTime initialMonth;

  /// The currently selected date (single mode).
  final DateTime? selectedDate;

  /// The start of the selected range (range mode).
  final DateTime? rangeStart;

  /// The end of the selected range (range mode).
  final DateTime? rangeEnd;

  /// Called when the user taps a day cell.
  final ValueChanged<DateTime>? onDaySelected;

  /// Called when the user taps the edit (pencil) icon.
  final VoidCallback? onEditTap;

  /// Called when Cancel is tapped.
  final VoidCallback? onCancel;

  /// Called when OK / Save is tapped.
  final VoidCallback? onConfirm;

  const TwakeModalDatePicker({
    Key? key,
    this.supportingText = 'Select date',
    this.supportingTextRange = 'Depart - Return dates',
    this.headline = 'Mon, Aug 17',
    this.headlineRange = 'Aug 17 \u2013 Aug 23',
    this.mode = TwakeDatePickerMode.single,
    DateTime? initialMonth,
    this.selectedDate,
    this.rangeStart,
    this.rangeEnd,
    this.onDaySelected,
    this.onEditTap,
    this.onCancel,
    this.onConfirm,
  })  : initialMonth = initialMonth ?? const _DefaultDate(),
        super(key: key);

  @override
  State<TwakeModalDatePicker> createState() => _TwakeModalDatePickerState();
}

/// Workaround: const default for DateTime.
class _DefaultDate implements DateTime {
  const _DefaultDate();

  @override
  bool operator ==(Object other) =>
      other is DateTime &&
      other.year == 2023 &&
      other.month == 8 &&
      other.day == 1;

  @override
  int get hashCode => DateTime(2023, 8, 1).hashCode;

  // Delegate all members to the real DateTime.
  DateTime get _d => DateTime(2023, 8, 1);

  @override
  DateTime add(Duration duration) => _d.add(duration);
  @override
  DateTime subtract(Duration duration) => _d.subtract(duration);
  @override
  Duration difference(DateTime other) => _d.difference(other);
  @override
  int compareTo(DateTime other) => _d.compareTo(other);
  @override
  bool isAfter(DateTime other) => _d.isAfter(other);
  @override
  bool isBefore(DateTime other) => _d.isBefore(other);
  @override
  bool isAtSameMomentAs(DateTime other) => _d.isAtSameMomentAs(other);
  @override
  DateTime toLocal() => _d.toLocal();
  @override
  DateTime toUtc() => _d.toUtc();
  @override
  String toIso8601String() => _d.toIso8601String();
  @override
  String toString() => _d.toString();
  @override
  int get year => _d.year;
  @override
  int get month => _d.month;
  @override
  int get day => _d.day;
  @override
  int get hour => _d.hour;
  @override
  int get minute => _d.minute;
  @override
  int get second => _d.second;
  @override
  int get millisecond => _d.millisecond;
  @override
  int get microsecond => _d.microsecond;
  @override
  int get weekday => _d.weekday;
  @override
  int get millisecondsSinceEpoch => _d.millisecondsSinceEpoch;
  @override
  int get microsecondsSinceEpoch => _d.microsecondsSinceEpoch;
  @override
  String get timeZoneName => _d.timeZoneName;
  @override
  Duration get timeZoneOffset => _d.timeZoneOffset;
  @override
  bool get isUtc => _d.isUtc;
}

class _TwakeModalDatePickerState extends State<TwakeModalDatePicker> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(
      widget.initialMonth.year,
      widget.initialMonth.month,
    );
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = LinagoraSysColors.material();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surfaceColor =
        isDark ? const Color(0xFF1C1B1F) : Colors.white;
    final Color onSurface =
        isDark ? Colors.white : const Color(0xFF1C1B1F);
    final Color primaryColor = colorScheme.primary;
    final Color headerBg =
        isDark ? const Color(0xFF2B2930) : const Color(0xFFEADDFF);

    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              isDark: isDark,
              headerBg: headerBg,
              onSurface: onSurface,
              primaryColor: primaryColor,
              mode: widget.mode,
              supportingText: widget.supportingText,
              supportingTextRange: widget.supportingTextRange,
              headline: widget.headline,
              headlineRange: widget.headlineRange,
              onEditTap: widget.onEditTap,
            ),
            const SizedBox(height: 8),
            _CalendarBody(
              displayedMonth: _displayedMonth,
              selectedDate: widget.selectedDate,
              rangeStart: widget.rangeStart,
              rangeEnd: widget.rangeEnd,
              mode: widget.mode,
              primaryColor: primaryColor,
              onSurface: onSurface,
              isDark: isDark,
              onPreviousMonth: _previousMonth,
              onNextMonth: _nextMonth,
              onDaySelected: widget.onDaySelected,
            ),
            _Footer(
              onCancel: widget.onCancel,
              onConfirm: widget.onConfirm,
              primaryColor: primaryColor,
              mode: widget.mode,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final bool isDark;
  final Color headerBg;
  final Color onSurface;
  final Color primaryColor;
  final TwakeDatePickerMode mode;
  final String supportingText;
  final String supportingTextRange;
  final String headline;
  final String headlineRange;
  final VoidCallback? onEditTap;

  const _Header({
    required this.isDark,
    required this.headerBg,
    required this.onSurface,
    required this.primaryColor,
    required this.mode,
    required this.supportingText,
    required this.supportingTextRange,
    required this.headline,
    required this.headlineRange,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 12, 12),
      decoration: BoxDecoration(
        color: headerBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mode == TwakeDatePickerMode.range
                ? supportingTextRange
                : supportingText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: onSurface.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  mode == TwakeDatePickerMode.range ? headlineRange : headline,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: onSurface,
                    letterSpacing: 0,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, color: onSurface, size: 22),
                onPressed: onEditTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calendar body
// ---------------------------------------------------------------------------

class _CalendarBody extends StatelessWidget {
  final DateTime displayedMonth;
  final DateTime? selectedDate;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final TwakeDatePickerMode mode;
  final Color primaryColor;
  final Color onSurface;
  final bool isDark;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime>? onDaySelected;

  const _CalendarBody({
    required this.displayedMonth,
    this.selectedDate,
    this.rangeStart,
    this.rangeEnd,
    required this.mode,
    required this.primaryColor,
    required this.onSurface,
    required this.isDark,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.onDaySelected,
  });

  static const List<String> _weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  List<DateTime?> _buildDayCells() {
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastDay = DateTime(displayedMonth.year, displayedMonth.month + 1, 0);
    // Sunday = 7 in DateTime.weekday, 1=Mon ... 7=Sun
    final startOffset = firstDay.weekday % 7; // 0=Sun, 1=Mon ...
    final cells = <DateTime?>[];
    for (int i = 0; i < startOffset; i++) {
      cells.add(null);
    }
    for (int d = 1; d <= lastDay.day; d++) {
      cells.add(DateTime(displayedMonth.year, displayedMonth.month, d));
    }
    return cells;
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isInRange(DateTime day) {
    if (rangeStart == null || rangeEnd == null) return false;
    return day.isAfter(rangeStart!) && day.isBefore(rangeEnd!);
  }

  @override
  Widget build(BuildContext context) {
    final cells = _buildDayCells();
    final monthLabel =
        '${_months[displayedMonth.month - 1]} ${displayedMonth.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // Month navigation row
          Row(
            children: [
              TextButton.icon(
                onPressed: null,
                icon: const SizedBox.shrink(),
                label: Text(
                  monthLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.chevron_left, color: onSurface),
                onPressed: onPreviousMonth,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: onSurface),
                onPressed: onNextMonth,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          // Weekday header
          Row(
            children: _weekDays.map((d) {
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          // Day grid
          _DayGrid(
            cells: cells,
            selectedDate: selectedDate,
            rangeStart: rangeStart,
            rangeEnd: rangeEnd,
            mode: mode,
            primaryColor: primaryColor,
            onSurface: onSurface,
            isDark: isDark,
            onDaySelected: onDaySelected,
            isSameDay: _isSameDay,
            isInRange: _isInRange,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Day Grid
// ---------------------------------------------------------------------------

class _DayGrid extends StatelessWidget {
  final List<DateTime?> cells;
  final DateTime? selectedDate;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final TwakeDatePickerMode mode;
  final Color primaryColor;
  final Color onSurface;
  final bool isDark;
  final ValueChanged<DateTime>? onDaySelected;
  final bool Function(DateTime?, DateTime?) isSameDay;
  final bool Function(DateTime) isInRange;

  const _DayGrid({
    required this.cells,
    this.selectedDate,
    this.rangeStart,
    this.rangeEnd,
    required this.mode,
    required this.primaryColor,
    required this.onSurface,
    required this.isDark,
    this.onDaySelected,
    required this.isSameDay,
    required this.isInRange,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    int i = 0;
    while (i < cells.length) {
      final rowCells = cells.sublist(i, (i + 7).clamp(0, cells.length));
      // Pad last row to 7
      while (rowCells.length < 7) {
        rowCells.add(null);
      }
      rows.add(_DayRow(
        cells: rowCells,
        selectedDate: selectedDate,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
        mode: mode,
        primaryColor: primaryColor,
        onSurface: onSurface,
        isDark: isDark,
        onDaySelected: onDaySelected,
        isSameDay: isSameDay,
        isInRange: isInRange,
      ));
      i += 7;
    }
    return Column(children: rows);
  }
}

class _DayRow extends StatelessWidget {
  final List<DateTime?> cells;
  final DateTime? selectedDate;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final TwakeDatePickerMode mode;
  final Color primaryColor;
  final Color onSurface;
  final bool isDark;
  final ValueChanged<DateTime>? onDaySelected;
  final bool Function(DateTime?, DateTime?) isSameDay;
  final bool Function(DateTime) isInRange;

  const _DayRow({
    required this.cells,
    this.selectedDate,
    this.rangeStart,
    this.rangeEnd,
    required this.mode,
    required this.primaryColor,
    required this.onSurface,
    required this.isDark,
    this.onDaySelected,
    required this.isSameDay,
    required this.isInRange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: cells.map((day) {
        if (day == null) return const Expanded(child: SizedBox(height: 40));
        final isSelected = mode == TwakeDatePickerMode.single
            ? isSameDay(day, selectedDate)
            : (isSameDay(day, rangeStart) || isSameDay(day, rangeEnd));
        final inRange = mode == TwakeDatePickerMode.range && isInRange(day);
        final isToday = isSameDay(day, DateTime.now());

        return Expanded(
          child: _DayCell(
            day: day,
            isSelected: isSelected,
            inRange: inRange,
            isToday: isToday,
            primaryColor: primaryColor,
            onSurface: onSurface,
            isDark: isDark,
            onTap: onDaySelected != null ? () => onDaySelected!(day) : null,
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Day Cell
// ---------------------------------------------------------------------------

class _DayCell extends StatefulWidget {
  final DateTime day;
  final bool isSelected;
  final bool inRange;
  final bool isToday;
  final Color primaryColor;
  final Color onSurface;
  final bool isDark;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.inRange,
    required this.isToday,
    required this.primaryColor,
    required this.onSurface,
    required this.isDark,
    this.onTap,
  });

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = widget.isSelected
        ? widget.primaryColor
        : widget.inRange
            ? widget.primaryColor.withOpacity(0.2)
            : _hovered
                ? widget.onSurface.withOpacity(0.08)
                : Colors.transparent;

    final Color textColor = widget.isSelected
        ? Colors.white
        : widget.isToday
            ? widget.primaryColor
            : widget.onSurface;

    final FontWeight fontWeight =
        widget.isToday ? FontWeight.w700 : FontWeight.w400;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${widget.day.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------

class _Footer extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Color primaryColor;
  final TwakeDatePickerMode mode;

  const _Footer({
    this.onCancel,
    this.onConfirm,
    required this.primaryColor,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onConfirm,
            child: Text(
              mode == TwakeDatePickerMode.range ? 'Save' : 'OK',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
