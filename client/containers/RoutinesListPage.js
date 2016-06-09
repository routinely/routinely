import React from 'react';
import { connect } from 'react-redux';
import RoutinesList from 'components/RoutinesList';
import { fetchRoutines } from 'actions';

class RoutinesListPage extends React.Component {
  static propTypes = {
    routines: React.PropTypes.array.isRequired,
    fetchRoutines: React.PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetchRoutines();
  }

  render() {
    const { routines } = this.props;

    return (
      <div>
        <h1 className="header">
          Routines
          <a className="btn btn-primary btn-lg pull-right" href="/routines/new">New Routine</a>
        </h1>
        <RoutinesList routines={routines} />
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { routines = [] } = state.routines;

  return {
    routines,
  };
};

export default connect(mapStateToProps, { fetchRoutines })(RoutinesListPage);
