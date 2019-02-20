import { RegisterController } from '../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class FormController extends Controller {
    connect() {
        // For all input with errors that are contained in the controller's element,
        Array.from(this.element.querySelectorAll('.form-input-error') || []).forEach(input => {
            // When the user change the content
            input.addEventListener('input', () => {
                // Check if it is valid
                if (input.checkValidity()) {
                    // If it is valid, remove error class to hide error message and remove error coloring
                    input.classList.remove('form-input-error');
                }
            });
        });
    }
}
