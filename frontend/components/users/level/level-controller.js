import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';
import { PostService } from '../../../services/post-service';
import { RouteService } from '../../../services/route-service';
import { NotificationService } from '../../../services/notification-service';

@RegisterController
class LevelController extends Controller {
    static targets = ['bar'];

    connect() {
        // Compute initial sizes
        this.computeRank();
    }

    /**
     * Compute current exp and set score bar sizes
     */
    computeRank() {
        let max = this.barTarget.getAttribute('data-max');
        let current = this.barTarget.getAttribute('data-current');

        let size = (current / max) * 100;
        this.barTarget.style.width = size.toString() + '%';
    }
}
