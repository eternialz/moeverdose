Useredit = {
    init: function(root) {
        Useredit.root = root;
        Useredit.root.find('#user_avatar').change(function(){Useredit.update_image(Useredit.root.find('#avatar_img'),this)});
        Useredit.root.find('#user_banner').change(function(){Useredit.update_image(Useredit.root.find('#banner_img'),this)});
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
