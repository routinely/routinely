import React from 'react';
import { connect } from 'react-redux';
import Routine from 'components/Routine';
import { fetchRoutines } from 'actions';

class App extends React.Component {
  componentDidMount() {
    this.props.fetchRoutines();
  }

  render() {
    const { routines } = this.props;

    return (
      <div>
        <h1 className="header">
          Listing routines
          <a className="btn btn-primary btn-lg pull-right" href="/routines/new">New Routine</a>
        </h1>
        <table className="table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Sensors</th>
              <th>Users</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {routines.map(routine =>
              <Routine key={routine.id} {...routine} />
            )}
          </tbody>
        </table>
        <h2>Orphaned routines</h2>
        <table className="table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Sensors</th>
              <th>Users</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { routines = [] } = state.routines;

  return {
    routines,
  };
}

export default connect(mapStateToProps, { fetchRoutines })(App)
