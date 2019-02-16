import { HttpService } from '../services/http-service';

export class CustomMethodLinkInitializer {
    run() {
        let elements = document.querySelectorAll('a[data-method]');
        Array.from(elements).forEach(el => {
            el.addEventListener('click', event => {
                event.preventDefault();
                let confirmMessage = el.getAttribute('data-confirm');

                if ((confirmMessage && confirm(confirmMessage)) || !confirmMessage) {
                    HttpService.makeRequest({
                        method: el.getAttribute('data-method').toUpperCase(),
                        url: el.getAttribute('href') || el.getAttribute('data-url'),
                    });
                }
            });
        });
    }
}
