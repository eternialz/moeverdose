import { RegisterController } from '../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class ModalController extends Controller {
    static targets = ['close'];

    close() {
        this.element.classList.toggle('active');
    }
}
