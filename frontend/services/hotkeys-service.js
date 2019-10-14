import { RouteService } from './route-service';
import { ModalService } from './modal-service';
import { LightboxService } from './lightbox-service';
import { application } from '../packs/application';
import hotkeys from 'hotkeys-js';

export const HotkeysService = {
    scopes: { post: 'h,t,r,esc,left,right,f,o,s,e,l,c', global: 'h,t,r,esc' },

    init: function() {
        for (let [scope, keys] of Object.entries(this.scopes)) {
            hotkeys(keys, scope, function(event, handler) {
                event.preventDefault();
                HotkeysService[handler.key]();
            });
        }
    },

    // Change the scope to switch the used set of keys
    setActiveScope: function() {
        hotkeys.setScope(RouteService.currentRouteMatch(/posts\/[0-9]*?($|\/$)/gim) ? 'post' : 'global');
    },

    // Toggle help screen
    h: function() {
        ModalService.toggle('keyboard-help');
    },

    // Toggle search bar
    t: function() {
        let modal = ModalService.toggle('global-search')
            .querySelector('input')
            .focus();
    },

    // Random post
    r: function() {
        Turbolinks.visit(`/random`);
    },

    // Close modals
    esc: function() {
        ModalService.closeAllModals();
        LightboxService.close();
    },

    // Go to previous post
    left: function() {
        Turbolinks.visit(`/posts/${parseInt(this.getPostId()) + 1}`);
    },

    // Go to next post
    right: function() {
        Turbolinks.visit(`/posts/${parseInt(this.getPostId()) - 1}`);
    },

    // Toggle favorite
    f: function() {
        let showElement = document.querySelector('[data-controller="post-show"]');
        let showController = application.getControllerForElementAndIdentifier(showElement, 'post-show');
        showController.addFavorite();
    },

    // Toggle overdose
    o: function() {
        let scoreElement = document.querySelector('[data-controller="post-score"]');
        let scoreController = application.getControllerForElementAndIdentifier(scoreElement, 'post-score');
        scoreController.overdose();
    },

    // Toggle shortage
    s: function() {
        let scoreElement = document.querySelector('[data-controller="post-score"]');
        let scoreController = application.getControllerForElementAndIdentifier(scoreElement, 'post-score');
        scoreController.shortage();
    },

    // Edit post
    e: function() {
        Turbolinks.visit(window.location.pathname + '/edit');
    },

    // Toggle lightbox
    l: function() {
        LightboxService.toggle();
    },

    // Focus in comment form
    c: function() {
        console.log('c');
    },

    getPostId() {
        return RouteService.getParamsFromCurrentRoute('/posts/:id').id;
    },
};
