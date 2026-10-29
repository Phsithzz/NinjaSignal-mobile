import 'package:equatable/equatable.dart';

class CalendarEvent extends Equatable {
  final String country;
  final String title;
  final String impact; // 'high', 'medium', 'low'
  final String timeIct;
  final String? forecast;
  final String? previous;

  const CalendarEvent({
    required this.country,
    required this.title,
    required this.impact,
    required this.timeIct,
    this.forecast,
    this.previous,
  });

  bool get isHighImpact => impact.toLowerCase() == 'high';

  @override
  List<Object?> get props => [country, title, impact, timeIct, forecast, previous];
}

class NewsHeadline extends Equatable {
  final String headline;
  final int tier; // 1 = market moving, 2 = general
  final String action; // 'pause_signals', 'fyi'
  final String time;

  const NewsHeadline({
    required this.headline,
    required this.tier,
    required this.action,
    required this.time,
  });

  bool get isTier1 => tier == 1;

  @override
  List<Object?> get props => [headline, tier, action, time];
}
