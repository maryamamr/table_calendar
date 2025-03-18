// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
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
  final Widget?d7k;

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
    this.dowHeight, this.d7k,
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
            child: SingleChildScrollView(
              child: Table(
                border: tableBorder,
                children: [
                  if (dowVisible) _buildDaysOfWeek(context),
               if(d7k!=null)   ..._buildCalendarDays(context),
                ],
              ),
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
  final rowAmount = visibleDays.length ~/ 7;
  final rows = <TableRow>[];

  for (int index = 0; index < rowAmount; index++) {
    // Add the calendar day row
    rows.add(
      TableRow(
        decoration: rowDecoration,
        children: List.generate(
          7,
          (id) => dayBuilder(context, visibleDays[index * 7 + id]),
        ),
      ),
    );

    // Add the full-width d7k row
    rows.add(
      TableRow(
        children: [
          // First cell spans all 7 columns via Expanded
          TableCell(
            child: Row(
              children: [
                Expanded(child: d7k!), // Use Expanded here
              ],
            ),
          ),
          // Add 6 empty cells to fulfill the 7-column requirement
          ...List.generate(6, (i) => const TableCell(child: SizedBox())),
        ],
      ),
    );
  }

  return rows;
}

}
