import { RegisterController } from '../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class FormController extends Controller {
    connect() {
        // For all input with errors that controller's element contains,
        Array.from(this.element.querySelectorAll('.form-input-error') || []).forEach(input => {
            // When the user change the content
            input.addEventListener('input', () => {
                // Check if it is or become valid
                if (input.checkValidity()) {
                    // If it is remove error class
                    input.classList.remove('form-input-error');
                }
            });
        });
    }
}
