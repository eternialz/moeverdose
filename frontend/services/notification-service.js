export const NotificationService = {
    notificationContainer: function() {
        return document.querySelector('#notification-container');
    },

    newNotification: function(message, type) {
        let container = this.notificationContainer();

        let notif = document.createElement('div');
        notif.setAttribute('data-action', 'click->notification#close');
        notif.classList.add('notification', 'notification-' + type);
        notif.innerHTML = message;

        container.appendChild(notif);

        setTimeout(() => {
            this.removeNotificationElement(notif);
        }, 8000);
    },

    removeNotificationElement: function(el) {
        el.classList.add('notification-disappear');
        setTimeout(() => el.remove(), 100);
    },
};
