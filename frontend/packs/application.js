import 'normalize.css/normalize.css';
import '../stylesheets/application.scss';

import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

export const application = Application.start();
const context = require.context('components', true, /.js$/);

application.load(definitionsFromContext(context));
