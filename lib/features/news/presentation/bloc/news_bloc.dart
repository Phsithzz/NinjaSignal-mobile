import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_news_usecase.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;

  NewsBloc({required this.getNewsUseCase}) : super(NewsInitial()) {
    on<LoadNewsEvent>(_onLoadNews);
  }

  Future<void> _onLoadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    final result = await getNewsUseCase();
    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (data) => emit(NewsLoaded(calendar: data.calendar, events: data.events)),
    );
  }
}
