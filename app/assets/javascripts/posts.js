Post = {
    init: function(root) {
        Post.root = root;
        Post.root.find('.dose').click(Post.dose);
        Post.root.find('#add_to_favorites').click(Post.favorite);
        Post.root.find('.post img').click( function() {
            $('#zoom_post').prop('checked',true);
        });
        Post.overdose = Post.root.find('.overdose_score');
        Post.shortage = Post.root.find('.shortage_score');
        $('#add_comment').bind('input propertychange', Post.comment_char);

        Post.percentage();
    },
    favorite: function() {
        $.ajax({
            url : window.location.pathname + '/favorite',
            type : 'PATCH',
            statusCode: {
                200: function() {
                    Notifications.add("Favorite added to your profile", "", "success");
                },
                202: function() {
                    Notifications.add("Favorite removed from your profile", "", "info");
                },
                403: function() {
                    Notifications.add("You need to be logged in to add a favorite", "", "error");
                }
            }
        });
    },
    dose: function(args) {
        var button = $(this);

        var dose = args.dose || button.data('dose');

        button.prop("disabled", true);

        $.ajax({
            url : window.location.pathname + "/dose/" + dose,
            type : 'PATCH',
            dataType: "json",
            success: function(data) {
                Post.overdose.html(parseInt(data.overdose, 10));
                Post.shortage.html(parseInt(data.shortage, 10));
                Post.percentage();

                if(dose === "overdose") {
                    if(data.removed === true) {
                        Notifications.add("Overdose removed", "", "info");
                    } else {
                        Notifications.add("Overdose added", "", "success");
                    }
                } else {
                    if(data.removed === true) {
                        Notifications.add("Shortage removed", "","info");
                    } else {
                        Notifications.add("Shortage added", "", "success");
                    }
                }

                button.prop("disabled", false);
            },
            error: function() {
                Notifications.add("Can't add overdose","You need to be logged in to add an " + dose,"error")
            }
        });
    },
    percentage: function() {
        var overdose_percentage = 100 * (parseInt(Post.overdose.html(), 10) / (parseInt(Post.overdose.html(), 10) + parseInt(Post.shortage.html(), 10)));
        var shortage_percentage = 100 - overdose_percentage;
        if ((Post.overdose.html() === "0") && (Post.shortage.html() === "0"))  {
            overdose_percentage = 50;
            shortage_percentage = 50;
        }
        Post.root.find('.overdose_bar').css("width", overdose_percentage + "%");
        Post.root.find('.shortage_bar').css("width", shortage_percentage + "%");
    },
    comment_char: function() {
        var length = $(this).val().length;
        var max = parseInt($(this).data("length"), 10)
        if (length > max) {
            $('#char_count').text("The comment is too long! Please remove " + ( length - max ) + " character(s)")
        } else {
            $('#char_count').text(max - length + " character(s) left");
        }
    }
};

$(document).on('turbolinks:load', function() {
    Post.init($('.posts'));
});
