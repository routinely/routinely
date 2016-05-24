import React from 'react';

export default function Listener({
  name,
  kind,
  gt,
  lt,
  icon,
}) {
  return (
    <span className="listener">
      <img className="sensor-icon" src={icon} alt={name} />
      {kind === 'digital' &&
        <span>{gt}~{lt}</span>
      }
    </span>
  );
}

Listener.propTypes = {
  name: React.PropTypes.string.isRequired,
  kind: React.PropTypes.string.isRequired,
  gt: React.PropTypes.number,
  lt: React.PropTypes.number,
  icon: React.PropTypes.string.isRequired,
};
