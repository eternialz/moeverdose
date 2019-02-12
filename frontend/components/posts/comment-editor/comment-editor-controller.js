import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class CommentEditorController extends Controller {
    static targets = ['input', 'length'];

    connect() {
        this.input();
    }

    input() {
        let length = this.inputTarget.value.length;
        this.lengthTarget.innerHTML = length;
        if (length > parseInt(this.lengthTarget.getAttribute('data-maxlength'), 10)) {
            this.lengthTarget.classList.add('color-red');
        } else {
            this.lengthTarget.classList.remove('color-red');
        }
    }
}
