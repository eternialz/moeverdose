import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MainMenuController extends Controller {
    static targets = ['submenu', 'email', 'password'];

    connect() {
        this.lock = false;
    }

    open() {
        this.submenuTarget.classList.add('active');
    }

    close() {
        if (!this.lock) {
            this.submenuTarget.classList.remove('active');
        }
    }

    focusToggle() {
        this.open();
        this.lock = !this.lock;
        console.log(this.lock);
    }
}
