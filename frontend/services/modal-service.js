export const ModalService = {
    toggle(modal_id) {
        let modal = this.getModal(modal_id);
        modal.classList.toggle('active');
        return modal;
    },

    getModal(modal_id) {
        return document.querySelector(`#modal-${modal_id}`);
    },

    closeAllModals() {
        document.querySelectorAll("[id^='modal-'].active").forEach(modal => modal.classList.remove('active'));
    },
};
