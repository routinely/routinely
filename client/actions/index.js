import axios from 'axios';
import camelize from 'camelize';

export const REQUEST_ROUTINES = 'REQUEST_ROUTINES';
export const RECEIVE_ROUTINES = 'RECEIVE_ROUTINES';

function requestRoutines() {
  return {
    type: REQUEST_ROUTINES,
  };
}

function receiveRoutines(json) {
  return {
    type: RECEIVE_ROUTINES,
    routines: json,
  };
}

export function fetchRoutines() {
  return (dispatch) => {
    dispatch(requestRoutines());

    return axios.get('/api/routines')
      .then(response => camelize(response.data))
      .then(json => dispatch(receiveRoutines(json)));
  };
}
