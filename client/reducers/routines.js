import {
  REQUEST_ROUTINES,
  RECEIVE_ROUTINES,
} from 'actions';

export default function routines(state = {}, action) {
  switch (action.type) {
  case REQUEST_ROUTINES:
    return {
      ...state,
      isFetching: true,
    };
  case RECEIVE_ROUTINES:
    return {
      isFetching: false,
      routines: action.routines,
    }
  default:
    return state;
  }
}
