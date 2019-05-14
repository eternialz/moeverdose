import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class PostNewController extends Controller {
    static targets = ['input', 'file'];

    input() {
        if (this.inputTarget.files && this.inputTarget.files[0]) {
            let reader = new FileReader();
            let fileTarget = this.fileTarget;

            reader.onload = function(e) {
                fileTarget.setAttribute('src', e.target.result);
            };

            reader.readAsDataURL(this.inputTarget.files[0]);
        }
    }

    reset() {}
}
