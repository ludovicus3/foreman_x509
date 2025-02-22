import React from 'react';
import WelcomePage from './WelcomePage';

const routes = [
  {
    path: '/foreman_x509/welcome',
    exact: true,
    render: (props) => <WelcomePage {...props} />,
  },
];

export default routes;
