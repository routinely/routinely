import React from 'react';
import moment from 'moment';
import classNames from 'classnames';
import Listener from 'components/Listener';
import Callback from 'components/Callback';

export default function Routine({
  id,
  name,
  description,
  startsAt,
  endsAt,
  repeatsAt,
  active,
  listeners,
  callbacks,
  users,
}) {
  return (
    <li className="routine">
      <h2 className="routine__header">
        <a href={`/routines/${id}`}>{name}</a>
        <small>{repeatsAt}</small>
        <small>{moment(startsAt).format('HH:mm')} – {moment(endsAt).format('HH:mm')}</small>
        <button className="routine__status">{active ? 'Enabled' : 'Disabled'}</button>
      </h2>
      <p className="routine__description">{description}</p>
      <div className="routine__on-triggers">
        {listeners.map(listener =>
          <Listener key={listener.id} {...listener} />
        )}
      </div>
      <i className="divider glyphicon glyphicon-triangle-right" />
      <div className="routine__callbacks">
        {callbacks.filter(callback => callback.condition === 'OnTrigger').map(callback =>
          <Callback key={callback.id} {...callback} />
        )}
      </div>
    </li>
  );
}

Routine.propTypes = {
  id: React.PropTypes.number.isRequired,
  name: React.PropTypes.string.isRequired,
  description: React.PropTypes.string.isRequired,
  startsAt: React.PropTypes.string.isRequired,
  endsAt: React.PropTypes.string.isRequired,
  repeatsAt: React.PropTypes.string.isRequired,
  active: React.PropTypes.bool.isRequired,
  listeners: React.PropTypes.array.isRequired,
  callbacks: React.PropTypes.array.isRequired,
  users: React.PropTypes.array.isRequired,
};
