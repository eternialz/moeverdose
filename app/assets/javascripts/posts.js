Post = {
    init: function(root) {
        Post.root = root;
        Post.root.find('.overdose').click(Post.overdose);
        Post.root.find('.shortage').click(Post.shortage);
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
                    Notifications.add("Favorite removed from your profile");
                }
            },
        });
    },
    overdose: function() {
        $.ajax({
            url : window.location.pathname + '/overdose',
            type : 'PATCH',
            statusCode: {
                200: function() {
                    Post.overdose.html(parseInt(Post.overdose.html()) +1);
                    Post.percentage();
                    Notifications.add("Overdose added","","success")
                },
                202: function() {
                    Post.overdose.html(parseInt(Post.overdose.html()) -1);
                    Post.percentage();
                    Notifications.add("Overdose removed","","success")
                }
            },
            error : function() {
                Notifications.add("Can't add overdose","Did you already add a shortage for this post? If you wan't to change, remove your shortage before adding an overdose by clicking on the shortage button","error")
            }
        });
    },
    shortage: function() {
        $.ajax({
            url : window.location.pathname + '/shortage',
            type : 'PATCH',
            statusCode: {
                200: function() {
                    Post.shortage.html(parseInt(Post.shortage.html()) +1);
                    Post.percentage();
                    Notifications.add("Moe shortage added","","success")
                },
                202: function() {
                    Post.shortage.html(parseInt(Post.shortage.html()) -1);
                    Post.percentage();
                    Notifications.add("Moe shortage removed","","success")
                }
            },
            error : function() {
                Notifications.add("Can't add shortage","Maybe you aren't logged in or you already voted for this post","error")
            }
        });
    },
    percentage: function() {
        var overdose_percentage = 100 * (parseInt(Post.overdose.html()) / (parseInt(Post.overdose.html()) + parseInt(Post.shortage.html())));
        var shortage_percentage = 100 - overdose_percentage;
        if ((Post.overdose.html() == "0") && (Post.shortage.html() == "0"))  {
            overdose_percentage = 50;
            shortage_percentage = 50;
        }
        Post.root.find('.overdose_bar').css("width", overdose_percentage + "%");
        Post.root.find('.shortage_bar').css("width", shortage_percentage + "%");
    },
    comment_char: function() {
        var length = $(this).val().length;
        var max = parseInt($(this).data("length"))
        if (length > max) {
            $('#char_count').text("The comment is too long! Please remove " + ( length - max ) + " character(s)")
        } else {
            $('#char_count').text(max - length + " character(s) left");
        }
    }
};

$(document).ready(function(){
    Post.init($('.posts'));
});
