Post = {
  init: function(root) {
    Post.root = root;
    Post.root.find('.overdose').click(Post.overdose);
    Post.root.find('.shortage').click(Post.shortage);
    Post.root.find('#add_to_favorites').click(Post.favorite);
    Post.overdose = Post.root.find('.overdose_score');
    Post.shortage = Post.root.find('.shortage_score');
  },
  favorite: function() {
    $.ajax({
      url : window.location.pathname + '/favorite',
      type : 'PATCH',
      statusCode: {
        200: function() {
          Notification.add("Favorite added to your profile", "", "success");
        },
        202: function() {
          Notification.add("Favorite removed from your profile");
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
          Notification.add("Overdose added","","success")
        },
        202: function() {
          Post.overdose.html(parseInt(Post.overdose.html()) -1);
          Post.percentage();
          Notification.add("Overdose removed","","success")
        }
      },
      error : function() {
        Notification.add("Can't add overdose","Did you already add a shortage for this post? If you wan't to change, remove your shortage before adding an overdose by clicking on the shortage button","error")
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
          Notification.add("Moe shortage added","","success")
        },
        202: function() {
          Post.shortage.html(parseInt(Post.shortage.html()) -1);
          Post.percentage();
          Notification.add("Moe shortage removed","","success")
        }
      },
      error : function() {
        Notification.add("Can't add shortage","Did you already add an overdose for this post? If you wan't to change, remove your overdose before adding a shortage by clicking on the overdose button","error")
      }
    });
  },
  percentage: function() {
    var overdose_percentage = 100 * (parseInt(Post.overdose.html()) / (parseInt(Post.overdose.html()) + parseInt(Post.shortage.html())));
    var shortage_percentage = 100 - overdose_percentage;
    Post.root.find('.overdose_bar').css("width", overdose_percentage + "%");
    Post.root.find('.shortage_bar').css("width", shortage_percentage + "%");
  }
};

$(document).ready(function(){
  Post.init($('.post-container'));
});
