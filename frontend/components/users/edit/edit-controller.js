import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class UserEditController extends Controller {
    static targets = ['input', 'file', 'alert'];

    connect() {
        let inputs = Array.from(this.element.querySelectorAll('input, textarea'));
        inputs.forEach(e => {
            var self = this;
            e.addEventListener('input', function(event) {
                self.popAlert();
            });
        });
    }

    input() {
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

    popAlert() {
        this.alertTarget.classList.add('active');
    }
}
