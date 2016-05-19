import "babel-polyfill";
import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { Router, browserHistory } from 'react-router';
import { syncHistoryWithStore } from 'react-router-redux';
import configureStore from 'store/configureStore';
import routes from 'routes/routes';

export default (() => {
  const store = configureStore();
  const history = syncHistoryWithStore(browserHistory, store);

  render(
    <Provider store={store}>
      <Router routes={routes} history={history} />
    </Provider>,
    document.getElementById('application')
  );
})();
