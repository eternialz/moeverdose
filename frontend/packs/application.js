import '@fortawesome/fontawesome-free/css/all.min.css';
import '../stylesheets/application.scss';

import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';
import { NotificationInitializer } from '../initializers/notification-global';

export const application = Application.start();
const context = require.context('components', true, /.js$/);

let initializers = [NotificationInitializer];

document.addEventListener('DOMContentLoaded', () => {
    initializers.forEach(initializer => {
        new initializer().run();
    });
});

application.load(definitionsFromContext(context));
