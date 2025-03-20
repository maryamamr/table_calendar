// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalendarPage extends StatefulWidget {
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
  final Widget?eventWidget;
  final int weekIndex;

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
    this.dowHeight, this.eventWidget,  this.weekIndex=0,
  })  : assert(!dowVisible || (dowHeight != null && dowBuilder != null)),
        assert(!weekNumberVisible || weekNumberBuilder != null);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.tablePadding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.weekNumberVisible) _buildWeekNumbers(context),
          Column(
          
            children: [
              if (widget.dowVisible) _buildDaysOfWeek(context),
             const SizedBox(height: 10,),
            ..._buildCalendarDays(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNumbers(BuildContext context) {
    final rowAmount = widget.visibleDays.length ~/ 7;
setState(() {
  
});
    return Column(
      children: [
        if (widget.dowVisible) SizedBox(height: widget.dowHeight ?? 0),
        ...List.generate(
          rowAmount,
          (index) => Expanded(
            child: widget.weekNumberBuilder!(context, widget.visibleDays[index * 7]),
          ),
        ),
      ],
    );
  }

  Row _buildDaysOfWeek(BuildContext context) {
    return Row(

      children: List.generate(
        7,
        (index) => Flexible(child: Padding(
           padding: const EdgeInsetsDirectional.only(end: 2),
          child: widget.dowBuilder!(context, widget.visibleDays[index]),
        )),
      ),
    );
  }

List<Row> _buildCalendarDays(BuildContext context) {
  final rowAmount = widget.visibleDays.length ~/ 7;
  final rows = <Row>[];

  for (int index = 0; index < rowAmount; index++) {
    // Add the calendar day row
    rows.add(
      Row(
        children: List.generate(
          7,
          (id) => Flexible(child: widget.dayBuilder(context, widget.visibleDays[index * 7 + id])),
        ),
      ),
    );

    // Add the full-width d7k row
    if(index==widget.weekIndex && widget.eventWidget!=null){
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Use Expanded to ensure the widget takes full width
            Expanded(
              child: widget.eventWidget!,
            ),
          ],
        ),
      );
    }
  }

  return rows;
}
}
