Notifications = {
    init: function(root) {
        Notifications.root = root;
        Notifications.counter = 0;
    },
    add: function(title, message, type) {
        type = type || "";
        if (message != undefined) {
            message = "<p>" + message + "<p>";
        } else {
            message = ""
        }
        title = "<h5>" + title + "</h5>";
        var id = $('.notification').length + 1;

        var notification = $("<div id='" + id + "' class='notification " + type + "'><i class='fa fa-close'></i>" + title + message + "</div>");



        Notifications.counter += 1;
        Notifications.root.find($('.notifications_container')).append( $(notification) );

        notification.click( function() {
            notification.remove();
        });

        setTimeout(function() {
            notification.remove();
        }, 6000);
    }
};

$(document).ready(function(){
    Notifications.init($('.notifications'));
});
