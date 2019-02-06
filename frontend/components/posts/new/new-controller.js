import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';
import { PostService } from '../../../services/post-service';
import { RouteService } from '../../../services/route-service';
import { NotificationService } from '../../../services/notification-service';

@RegisterController
class PostNewController extends Controller {
    static targets = ['input', 'file'];

    input() {
        console.log('a');
        if (this.inputTarget.files && this.inputTarget.files[0]) {
            let reader = new FileReader();
            let img = new Image();
            img.src = window.URL.createObjectURL(this.inputTarget.files[0]);

            let target = this.fileTarget;
            reader.onload = function(e) {
                target.setAttribute('src', e.target.result);
            };

            img.onload = function() {
                target.setAttribute('width', img.naturalWidth);
                target.setAttribute('height', img.naturalHeight);
            };

            reader.readAsDataURL(this.inputTarget.files[0]);
        }
    }
}
