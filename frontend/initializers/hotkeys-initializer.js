import { HotkeysService } from '../services/hotkeys-service';

export class HotkeysInitializer {
    run() {
        // Init keys binding for all scopes
        HotkeysService.init();

        // Set used scope on page change
        window.addEventListener('turbolinks:load', function() {
            HotkeysService.setActiveScope();
        });
    }
}
