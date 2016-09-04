Useredit = {
  init: function(root) {
    Useredit.root = root;
    console.log(Useredit.root);
    Useredit.root.find('#user_avatar').change(function(){Useredit.update_image(Useredit.root.find('#avatar_im'),this)});
    Useredit.root.find('#user_banner').change(function(){Useredit.update_image(Useredit.root.find('#banner'),this)});
  },
  update_image: function(image,input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        image.attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }
};

$(document).ready(function(){
  Useredit.init($('.userprofile'));
});
