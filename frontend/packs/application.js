import '@fortawesome/fontawesome-free/css/all.min.css';
import '../stylesheets/application.scss';

import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';
import { NotificationInitializer } from '../initializers/notification-global';
import Turbolinks from 'turbolinks';
import Rails from 'rails-ujs';

export const application = Application.start();
const context = require.context('components', true, /.js$/);

// Start Turbolinks for seamless navigations
Turbolinks.start();
Turbolinks.setProgressBarDelay(0);

// Start RailsUJS for front-end helpers
Rails.start();

let initializers = [NotificationInitializer];

document.addEventListener('DOMContentLoaded', () => {
    initializers.forEach(initializer => {
        new initializer().run();
    });
});

application.load(definitionsFromContext(context));
