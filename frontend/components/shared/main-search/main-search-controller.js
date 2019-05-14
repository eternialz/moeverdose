import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class MainSearchController extends Controller {
    static targets = ['tags', 'input', 'tagIcon'];

    input(event) {
        if (event.keyCode === 32 || event.key === ' ') {
            // If key pressed is space
            event.preventDefault();
            event.target.innerHTML = this.processInput(event.target.innerHTML);
        } else if (event.keyCode === 8 || event.key === 'Backspace') {
            // If key pressed is backspace
            this.removeLastTag(event.target.innerHTML, event);
        } else if (event.keyCode === 13 || event.key === 'Enter') {
            // If key pressed is enter
            event.preventDefault();
        } else if (event.key.length === 1 && !event.ctrlKey) {
            event.preventDefault();
            this.addCharacter(event.key);
        }

        this.moveCursorToEnd(event.target);
    }

    /**
     * Replace string elements by tag, separated by spaces
     * @param html
     */
    processInput(html) {
        let elements = html
            .replace(/\s+/g, ' ')
            .split('&nbsp;')
            .filter(s => s != '');

        elements = elements.map(element => {
            let value = element;

            if (!/<.*>.*<\/.*>/.test(element)) {
                value = '<span class="tag tag-blank" data-content="' + element.toLowerCase() + '"></span>';
            }

            return value;
        });

        return elements.join('&nbsp;') + '&nbsp;';
    }

    /**
     * Remove last elements of query if it is a tag
     * @param html
     * @param event
     */
    removeLastTag(html, event) {
        let elements = html
            .replace(/\s+/g, ' ')
            .split('&nbsp;')
            .filter(s => s != '');

        let last = elements[elements.length - 1];
        if (/<.*>.*<\/.*>/.test(last)) {
            event.preventDefault();
            elements.pop();
            event.target.innerHTML = elements.join('&nbsp;') + '&nbsp;';
        }
    }

    addCharacter(key) {
        this.inputTarget.innerHTML += key;
    }

    moveCursorToEnd() {
        // https://stackoverflow.com/questions/1125292/how-to-move-cursor-to-end-of-contenteditable-entity/3866442#3866442
        var range, selection;
        if (document.createRange) {
            range = document.createRange();
            range.selectNodeContents(this.inputTarget);
            range.collapse(false);
            selection = window.getSelection();
            selection.removeAllRanges();
            selection.addRange(range);
        } else if (document.selection) {
            range = document.body.createTextRange();
            range.moveToElementText(this.inputTarget);
            range.collapse(false);
            range.select();
        }
    }

    toggleTagsPanel() {
        this.tagIconTarget.classList.toggle('fa-chevron-down');
        this.tagIconTarget.classList.toggle('fa-chevron-up');
        this.tagsTarget.classList.toggle('active');
    }

    toggleTag(event) {
        this.addTag(event.target.innerHTML.toLowerCase());
    }

    addTag(tag) {
        this.inputTarget.innerHTML +=
            '&nbsp;<span class="tag tag-blank" data-content="' + tag + '"></span>&nbsp;'.replace(/\./g, '');
    }

    paste(event) {
        event.stopPropagation();
        event.preventDefault();

        let data = (event.clipboardData || window.clipboardData).getData('Text');

        var tmp = document.createElement('div');
        tmp.innerHTML = data.replace(/\s/g, '&nbsp;');

        this.inputTarget.innerHTML += tmp.textContent || tmp.innerText || '';
        this.inputTarget.innerHTML = this.processInput(this.inputTarget.innerHTML);
    }
}
