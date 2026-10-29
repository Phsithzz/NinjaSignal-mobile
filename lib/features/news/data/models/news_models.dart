import '../../domain/entities/news_entity.dart';

class CalendarEventModel extends CalendarEvent {
  const CalendarEventModel({
    required super.country,
    required super.title,
    required super.impact,
    required super.timeIct,
    super.forecast,
    super.previous,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      country: json['country']?.toString() ?? 'USD',
      title: json['title']?.toString() ?? '',
      impact: json['impact']?.toString().toLowerCase() ?? 'medium',
      timeIct: json['time_ict']?.toString() ?? '',
      forecast: json['forecast']?.toString(),
      previous: json['previous']?.toString(),
    );
  }
}

class NewsHeadlineModel extends NewsHeadline {
  const NewsHeadlineModel({
    required super.headline,
    required super.tier,
    required super.action,
    required super.time,
  });

  factory NewsHeadlineModel.fromJson(Map<String, dynamic> json) {
    return NewsHeadlineModel(
      headline: json['headline']?.toString() ?? '',
      tier: (json['tier'] as num?)?.toInt() ?? 2,
      action: json['action']?.toString() ?? 'fyi',
      time: json['time']?.toString() ?? '',
    );
  }
}
