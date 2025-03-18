// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';

class CalendarPage extends StatelessWidget {
  final Widget Function(BuildContext context, DateTime day)? dowBuilder;
  final Widget Function(BuildContext context, DateTime day) dayBuilder;
  final Widget Function(BuildContext context, DateTime day)? weekNumberBuilder;
  final List<DateTime> visibleDays;
  final Decoration? dowDecoration;
  final Decoration? rowDecoration;
  final TableBorder? tableBorder;
  final EdgeInsets? tablePadding;
  final bool dowVisible;
  final bool weekNumberVisible;
  final double? dowHeight;
  final Widget? d7k;

  const CalendarPage({
    super.key,
    required this.visibleDays,
    this.dowBuilder,
    required this.dayBuilder,
    this.weekNumberBuilder,
    this.dowDecoration,
    this.rowDecoration,
    this.tableBorder,
    this.tablePadding,
    this.dowVisible = true,
    this.weekNumberVisible = false,
    this.d7k,
    this.dowHeight,
  })  : assert(!dowVisible || (dowHeight != null && dowBuilder != null)),
        assert(!weekNumberVisible || weekNumberBuilder != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tablePadding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (weekNumberVisible) _buildWeekNumbers(context),
          Expanded(
            child: Table(
              border: tableBorder,
              children: [
                if (dowVisible) _buildDaysOfWeek(context),
                ..._buildCalendarDays(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNumbers(BuildContext context) {
    final rowAmount = visibleDays.length ~/ 7;

    return Column(
      children: [
        if (dowVisible) SizedBox(height: dowHeight ?? 0),
        ...List.generate(
          rowAmount,
          (index) => Expanded(
            child: weekNumberBuilder!(context, visibleDays[index * 7]),
          ),
        ),
      ],
    );
  }

  TableRow _buildDaysOfWeek(BuildContext context) {
    return TableRow(
      decoration: dowDecoration,
      children: List.generate(
        7,
        (index) => dowBuilder!(context, visibleDays[index]),
      ),
    );
  }

 List<TableRow> _buildCalendarDays(BuildContext context) {
  List<TableRow> rows = [];

 for (int weekIndex = 0; weekIndex < visibleDays.length ~/ 7; weekIndex++) {
  rows.add(
    TableRow(
      decoration: rowDecoration,
      children: List.generate(
        7,
        (id) => dayBuilder(context, visibleDays[weekIndex * 7 + id]),
    ),
  ));

  if (_shouldShowExtraWidget(weekIndex)) {
    rows.add(
      TableRow(
        children: [
          d7k ?? const SizedBox(),
          for (int i = 1; i < 7; i++) const SizedBox(),
        ],
      ),
    );
  }
}

  return rows;
}



bool _shouldShowExtraWidget(int weekIndex) {
  // Example: Show after the first row (weekIndex == 0)
  // Change the logic based on your condition.
  return weekIndex == 0; 
}
}
