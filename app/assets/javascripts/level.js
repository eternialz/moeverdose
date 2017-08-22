
Level = {
    init: function(root) {
        Level.root = root;
        Level.percentage();
    },
    percentage: function(choice) {
        var progress = Level.root.find("#level_progress");

        var count = parseInt(progress.data("count"));
        var max = parseInt(progress.data("max"));

        if (count != 0) {
            var percentage = (count / max * 100).toFixed(1).toString();
        } else {
            var percentage = "0";
        }

        progress.css("width", percentage + "%");
        progress.html(percentage + "%");
    }
};

$(document).on('turbolinks:load', function(event) {
    Level.init($('.progress_bar'));
});
