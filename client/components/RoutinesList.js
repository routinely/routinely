import React from 'react';
import Routine from 'components/Routine';

export default function RoutinesList({ routines }) {
  return (
    <ol className="routines-list">
      {routines.map(routine =>
        <Routine key={routine.id} {...routine} />
      )}
    </ol>
  );
}

RoutinesList.propTypes = {
  routines: React.PropTypes.array.isRequired,
};
