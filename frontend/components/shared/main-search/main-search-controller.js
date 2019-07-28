import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MainSearchController extends Controller {
    static targets = ['tags', 'input', 'tagButton', 'restoreButton', 'form'];

    // Set the input as restorable if there is a saved value from sessionStorage
    connect() {
        if (sessionStorage.getItem('tags') && !this.inputTarget.value) {
            this.element.classList.add('main-search-restorable');
        }
    }

    // Display tags dropdown panel when clicking tags button next to search input
    toggleTagsPanel(event) {
        event.preventDefault(); // Prevent submit of form
        this.tagButtonTarget.classList.toggle('fa-chevron-down');
        this.tagButtonTarget.classList.toggle('fa-chevron-up');
        this.tagsTarget.classList.toggle('active');
    }

    // Click on a tag in the tag dropdown from the search bar
    toggleTag(event) {
        let tag = event.target.innerHTML;
        let query = this.inputTarget.value ? this.inputTarget.value.split(' ') : [];
        let index = query.indexOf(tag);

        if (index == -1) query.push(tag);
        else query.splice(index, 1);

        this.inputTarget.value = query.join(' ');
        this.closeRestore();
    }

    // Click on the search button
    search(event) {
        event.preventDefault();
        sessionStorage.setItem('tags', this.inputTarget.value);
        this.formTarget.submit();
    }

    // Restore stored value from sessionStorage
    restore(event) {
        event.preventDefault(); // Prevent submit of form

        // Set restored value
        this.inputTarget.value = sessionStorage.getItem('tags');
        this.inputTarget.focus();

        this.closeRestore();
    }

    // Make the restoration button disappear
    closeRestore(event) {
        // key pressed is enter, prevent opening/closing of tags panel and search instead
        if (event && event.key === 'Enter') {
            this.search(event);
        }

        // Make button disappear
        this.restoreButtonTarget.classList.add('disappear');
    }
}
