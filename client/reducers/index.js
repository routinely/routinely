import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import routines from 'reducers/routines';

const rootReducer = combineReducers({
  routines,
  routing: routerReducer,
});

export default rootReducer;
