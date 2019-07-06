import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class SortController extends Controller {
    static targets = ['sort', 'sortName', 'selected'];

    connect() {}

    selected(event) {
        this.sortTarget.value = event.target.dataset.direction;
        this.sortTarget.name = event.target.dataset.sort;

        this.sortNameTarget.value = event.target.textContent;

        this.selectedTarget.innerHTML = event.target.innerHTML;

        this.element.submit();
    }
}
