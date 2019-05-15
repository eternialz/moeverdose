import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MainMenuController extends Controller {
    static targets = ['submenu'];

    open() {
        if ('activeElement' in document) document.activeElement.blur();
        this.submenuTarget.classList.add('active');
    }

    close() {
        this.submenuTarget.classList.remove('active');
    }
}
