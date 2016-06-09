import React from 'react';

export default function Listener({
  name,
  kind,
  gt,
  lt,
  icon,
}) {
  return (
    <div className="listener">
      <img className="listener__icon" src={icon} alt={name} />
      <span className="listener__name">{name}</span>
      {kind === 'digital' &&
        <span className="listener__condition">{gt}~{lt}</span>
      }
    </div>
  );
}

Listener.propTypes = {
  name: React.PropTypes.string.isRequired,
  kind: React.PropTypes.string.isRequired,
  gt: React.PropTypes.number,
  lt: React.PropTypes.number,
  icon: React.PropTypes.string.isRequired,
};
