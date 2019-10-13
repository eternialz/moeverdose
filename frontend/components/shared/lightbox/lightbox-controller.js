import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';
import { LightboxService } from '../../../services/lightbox-service';

@RegisterController
class LightboxController extends Controller {
    closeLightbox() {
        LightboxService.toggle();
    }
}
