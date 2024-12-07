import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'place_search_state.dart';

class PlaceSearchCubit extends Cubit<PlaceSearchState> {
  PlaceSearchCubit() : super(PlaceSearchInitial());
}
