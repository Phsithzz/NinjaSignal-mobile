import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/news_models.dart';

abstract class NewsRemoteDataSource {
  Future<({List<CalendarEventModel> calendar, List<NewsHeadlineModel> events})> getNews();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient client;

  NewsRemoteDataSourceImpl({required this.client});

  @override
  Future<({List<CalendarEventModel> calendar, List<NewsHeadlineModel> events})> getNews() async {
    final response = await client.get(ApiConstants.news);
    final calendarRaw = (response['calendar'] as List<dynamic>?) ?? [];
    final eventsRaw = (response['events'] as List<dynamic>?) ?? [];

    final calendar = calendarRaw
        .map((e) => CalendarEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final events = eventsRaw
        .map((e) => NewsHeadlineModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return (calendar: calendar, events: events);
  }
}
