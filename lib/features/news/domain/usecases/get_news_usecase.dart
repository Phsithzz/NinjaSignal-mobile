import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/news_entity.dart';
import '../repositories/news_repository.dart';

class GetNewsUseCase {
  final NewsRepository repository;
  GetNewsUseCase(this.repository);

  Future<Either<Failure, ({List<CalendarEvent> calendar, List<NewsHeadline> events})>> call() {
    return repository.getNews();
  }
}
