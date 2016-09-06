Post = {
  init: function(root) {
    Post.root = root;
    Post.root.find('.overdose').click(Post.overdose);
    Post.root.find('.shortage').click(Post.shortage);
    Post.root.find('#add_to_favorites').click(Post.favorite);
    Post.user = Post.root.data("username");
    Post.overdose = Post.root.find('.overdose_score');
    Post.shortage = Post.root.find('.shortage_score');
  },
  favorite: function() {
    $.ajax({
      url : window.location.pathname + '/favorite',
      type : 'PATCH',
      error : function() {
        console.log("error");
      }
    });
  },
  overdose: function() {
    $.ajax({
      url : window.location.pathname + '/overdose',
      type : 'PATCH',
      success : function() {
        Post.overdose.html(parseInt(Post.overdose.html()) +1);
        Post.percentage();
      },
      error : function() {
        console.log("error");
      }
    });
  },
  shortage: function() {
    $.ajax({
      url : window.location.pathname + '/shortage',
      type : 'PATCH',
      success : function() {
        Post.shortage.html(parseInt(Post.shortage.html()) +1);
        Post.percentage();
      },
      error : function() {
        console.log("error");
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
