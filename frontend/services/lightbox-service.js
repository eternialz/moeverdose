export const LightboxService = {
    toggle() {
        let lightbox = document.querySelector('#lightbox');
        lightbox.classList.toggle('active');
        document.querySelector('body').classList.toggle('disable-scroll');
    },

    close() {
        if (document.querySelector('#lightbox').classList.contains('active')) {
            this.toggle();
        }
    },
};
