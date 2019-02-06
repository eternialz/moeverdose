import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class AnchorController extends Controller {
    static targets = ['name'];

    copy() {
        navigator.permissions.query({ name: 'clipboard-write' }).then(result => {
            if (result.state == 'granted' || result.state == 'prompt') {
                let location = window.location.toString().split('#')[0];
                navigator.clipboard.writeText(location + '#' + this.nameTarget.getAttribute('data-name'));
            } else {
                alert('Copy failed');
            }
        });
    }
}
