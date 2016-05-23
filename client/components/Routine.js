import React from 'react';
import moment from 'moment';
import classNames from 'classnames';

export default function Routine({
  id,
  name,
  description,
  startsAt,
  endsAt,
  repeatsAt,
  sensors,
  actors,
  users,
}) {
  return (
    <tr>
      <td className=".col-md-3">
        <p className="lead">
          <a href={`/routines/${id}`}>{name}</a>
        </p>
        <p>{moment(startsAt).format('hh:mm')} – {moment(endsAt).format('hh:mm')}</p>
        <p>
          {Object.keys(repeatsAt).map(day =>
            <span className={classNames('repeats-at', { on: repeatsAt[day] })}>
              {day.charAt(0)}
            </span>
          )}
        </p>
        <p>{description}</p>
      </td>
      <td className=".col-md-4">
        {sensors.map(sensor =>
          <img className="sensor-icon" src={sensor.icon} alt={sensor.name} />
        )}
        <i className="glyphicon glyphicon-triangle-right" />
        {actors.map(actor =>
          <img className="actor-icon" src={actor.icon} alt={actor.name} />
        )}
      </td>
      <td className=".col-md-4">
        {users.map(user => user.name).join(', ')}
      </td>
      <td className=".col-md-1"></td>
    </tr>
  );
}

Routine.propTypes = {
  id: React.PropTypes.number.isRequired,
  name: React.PropTypes.string.isRequired,
  description: React.PropTypes.string.isRequired,
  startsAt: React.PropTypes.string.isRequired,
  endsAt: React.PropTypes.string.isRequired,
  repeatsAt: React.PropTypes.object.isRequired,
  sensors: React.PropTypes.array.isRequired,
  actors: React.PropTypes.array.isRequired,
  users: React.PropTypes.array.isRequired,
};
