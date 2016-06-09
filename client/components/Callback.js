import React from 'react';

export default function Callback({
  name,
  type,
  icon,
}) {
  return (
    <div className="callback">
      {type === 'Actor' ?
        <img className="callback__icon" src={icon} alt={name} />
      : null }
      <span className="callback__name">{name}</span>
    </div>
  );
}

Callback.propTypes = {
  name: React.PropTypes.string.isRequired,
  type: React.PropTypes.string.isRequired,
  icon: React.PropTypes.string,
};
