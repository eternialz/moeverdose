Post = {
  init: function(root) {
    Post.root = root
    Post.root.find('.overdose').click(Post.overdose);
    Post.root.find('.shortage').click(Post.shortage);
    Post.user = Post.root.data("username");
  },
  overdose: function() {
    $.ajax({
       url : window.location.pathname + '/overdose',
       type : 'PATCH',
       data : '&username=' + Post.user
    });
  },
  shortage: function() {
    console.log("troll");
    $.ajax({
       url : window.location.pathname + '/shortage',
       type : 'PATCH',
       data : '&username=' + Post.user
    });
  }
};

$(document).ready(function(){
  Post.init($('.post-container'));
});
