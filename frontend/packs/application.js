import '@fortawesome/fontawesome-free/css/all.min.css';
import '../stylesheets/application.scss';

import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';
import { NotificationInitializer } from '../initializers/notification-global';
import { CustomMethodLinkInitializer } from '../initializers/custom-method-link';

export const application = Application.start();
const context = require.context('components', true, /.js$/);

let initializers = [NotificationInitializer, CustomMethodLinkInitializer];

document.addEventListener('DOMContentLoaded', () => {
    initializers.forEach(initializer => {
        new initializer().run();
    });
});

application.load(definitionsFromContext(context));
