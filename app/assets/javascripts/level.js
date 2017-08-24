
Level = {
    init: function(root) {
        Level.root = root;
        Level.percentage();
    },
    percentage: function() {
        var progress = Level.root.find("#level_progress");

        var count = parseInt(progress.data("count"));
        var max = parseInt(progress.data("max"));

        if (count != 0) {
            var percentage = (count / max * 100).toFixed(1).toString();
        } else {
            var percentage = "0";
        }

        if(percentage > 100) { percentage = 100 };

        progress.css("width", percentage + "%");
    }
};

$(document).on('turbolinks:load', function() {
    Level.init($('.progress_bar'));
});
