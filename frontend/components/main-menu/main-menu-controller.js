import { RegisterController } from '../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MainMenuController extends Controller {
    static targets = ['submenu'];

    connect() {
        this.submenuTarget.classList.remove('active');
    }

    hoverSwitch() {
        this.submenuTarget.classList.toggle('active');
    }
}
