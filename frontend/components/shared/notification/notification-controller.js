import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class NotificationController extends Controller {
    close(event) {
        event.target.classList.add('notification-disappear');
        setTimeout(() => event.target.remove(), 100);
    }
}
