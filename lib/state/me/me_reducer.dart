import 'package:minimalist/state/me/me_actions.dart';
import 'package:redux/redux.dart';

import 'me_state.dart';

Reducer<MeState> meReducer = combineReducers([
  new TypedReducer<MeState, SetMyDisplayName>(setMyDisplayName),
]);

MeState setMyDisplayName(MeState state, SetMyDisplayName action) {
  return state.copyWith(user: state.user.copyWith(displayName: action.name));
}
