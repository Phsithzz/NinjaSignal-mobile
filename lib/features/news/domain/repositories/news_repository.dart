import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/news_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure, ({List<CalendarEvent> calendar, List<NewsHeadline> events})>> getNews();
}
