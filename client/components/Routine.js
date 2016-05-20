import React from 'react';

export default function Routine({ name, description }) {
  return (
    <tr>
      <td className=".col-md-3">
        <p className="lead">{name}</p>
        <p>{description}</p>
      </td>
      <td className=".col-md-4"></td>
      <td className=".col-md-4"></td>
      <td className=".col-md-1"></td>
    </tr>
  );
}
