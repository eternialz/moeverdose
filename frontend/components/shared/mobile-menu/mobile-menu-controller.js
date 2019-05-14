import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MobileMenuController extends Controller {
    static targets = ['menu'];

    toggle() {
        // Display mobile menu
        this.menuTarget.classList.toggle('active');
    }

    toggleSubnav(event) {
        if (event.target.parentElement.classList.contains('active')) {
            // Close the clicked menu
            event.target.parentElement.classList.remove('active');
        } else {
            // Close all other submenu and display the clicked one
            this.closeAllSubnav();
            event.target.parentElement.classList.add('active');
        }
    }

    closeAllSubnav() {
        Array.from(this.menuTarget.querySelectorAll('.mobile-menu-subnav-container')).forEach(el => {
            el.classList.remove('active');
        });
    }
}
