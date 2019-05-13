import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MainSearchController extends Controller {
    static targets = ['tags', 'input', 'tagButton', 'searchButton'];

    // Get the saved values from the current session
    connect() {
        this.inputTarget.value = sessionStorage.getItem('tags') || '';
    }

    // Display tags dropdown panel when clicking tags button next to search input
    toggleTagsPanel(event) {
        event.preventDefault();
        this.tagButtonTarget.classList.toggle('fa-chevron-down');
        this.tagButtonTarget.classList.toggle('fa-chevron-up');
        this.tagsTarget.classList.toggle('active');
    }

    // Click on a tag in the tag dropdown from the search bar
    toggleTag(event) {
        let tag = event.target.innerHTML;
        let query = this.inputTarget.value.split(' ');
        let index = query.indexOf(tag);

        if (index == -1) query.push(tag);
        else query.splice(index, 1);

        this.inputTarget.value = query.join(' ');
    }

    // Click on the search button
    search() {
        sessionStorage.setItem('tags', this.inputTarget.value);
    }
}
