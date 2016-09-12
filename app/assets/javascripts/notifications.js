Notification = {
  init: function(root) {
    Notification.root = root
  },
  add: function(title, message, type) {
    type = type || "";
    if (message != undefined) {
      message = "<p>" + message + "<p>";
    } else {
      message = ""
    };
    var title = "<h5>" + title + "</h5>";
    var id = $('.notification').length + 1;

    var notification = $("<div id='" + id + "' class='notification " + type + "'><i class='fa fa-close'></i>" + title + message + "</div>");

    Notification.root.prepend( $(notification) );

    notification.find(".fa-close").click( function() {
      notification.remove();
    });

    setTimeout(function() {
      notification.remove();
    }, 10000);
  }
};

$(document).ready(function(){
  Notification.init($('.notifications'));
});
