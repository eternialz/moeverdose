export const LightboxService = {
    display() {
        let lightbox = document.querySelector('#lightbox');
        lightbox.classList.toggle('active');
        document.querySelector('body').classList.toggle('disable-scroll');
    },
};
