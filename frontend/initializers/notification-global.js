export class NotificationInitializer {
    run() {
        this.container = document.querySelector('#notification-container');
        Array.from(this.container.children).forEach(notif => {
            setTimeout(() => {
                notif.classList.add('notification-disappear');
                setTimeout(() => notif.remove(), 100);
            }, 8000);
        });
    }
}
