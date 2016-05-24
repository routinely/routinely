import React from 'react';
import moment from 'moment';
import classNames from 'classnames';
import Listener from 'components/Listener';

export default function Routine({
  id,
  name,
  description,
  startsAt,
  endsAt,
  repeatsAt,
  listeners,
  callbacks,
  users,
}) {
  return (
    <tbody>
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
          {listeners.map(listener =>
            <Listener key={listener.id} {...listener} />
          )}
          <i className="glyphicon glyphicon-triangle-right" />
          {callbacks.filter(callback => callback.condition === 'OnTrigger' && callback.type === 'Actor').map(actor =>
            <img className="actor-icon" src={actor.icon} alt={actor.name} />
          )}
        </td>
        <td className=".col-md-4">
          {users.map(user => user.name).join(', ')}
        </td>
      </tr>
    </tbody>
  );
}

Routine.propTypes = {
  id: React.PropTypes.number.isRequired,
  name: React.PropTypes.string.isRequired,
  description: React.PropTypes.string.isRequired,
  startsAt: React.PropTypes.string.isRequired,
  endsAt: React.PropTypes.string.isRequired,
  repeatsAt: React.PropTypes.object.isRequired,
  listeners: React.PropTypes.array.isRequired,
  callbacks: React.PropTypes.array.isRequired,
  users: React.PropTypes.array.isRequired,
};
