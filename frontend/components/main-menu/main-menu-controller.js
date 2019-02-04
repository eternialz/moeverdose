import { RegisterController } from '../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MainMenuController extends Controller {
    static targets = ['submenu'];

    over() {
        this.submenuTarget.classList.add('active');
    }

    out() {
        this.submenuTarget.classList.remove('active');
    }
}
