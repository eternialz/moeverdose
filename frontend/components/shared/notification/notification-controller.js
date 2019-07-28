import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';
import { NotificationService } from '../../../services/notification-service';

@RegisterController
class NotificationController extends Controller {
    close(event) {
        NotificationService.removeNotificationElement(event.target);
    }
}
