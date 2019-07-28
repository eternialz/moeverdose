import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MainMenuController extends Controller {
    static targets = ['submenu', 'menu'];

    connect() {
        document.addEventListener('turbolinks:before-cache', function() {
            this.close();
        });
    }

    open() {
        if ('activeElement' in document) document.activeElement.blur();
        this.submenuTarget.classList.add('active');

        // Prevent displaying submenu items without background when js hasn't been executed
        this.menuTarget.classList.remove('overflow-hidden');
    }

    close() {
        this.submenuTarget.classList.remove('active');
    }
}
