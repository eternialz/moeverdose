Useredit = {
    init: function(root) {
        Useredit.root = root;
        Useredit.root.find('#user_avatar').change(function(){Useredit.update_image(Useredit.root.find('#avatar-img'),this)});
        Useredit.root.find('#user_banner').change(function(){Useredit.update_image(Useredit.root.find('#banner_img'),this)});
        Useredit.root.find('input').change(function(){Useredit.display_save()})
        Useredit.root.find('input, textarea').on("input", function(){Useredit.display_save()})
    },
    update_image: function(image,input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                image.css("background-image", "url(" + e.target.result + ")");
            }

            reader.readAsDataURL(input.files[0]);
        }
    },
    display_save: function() {
        Useredit.root.find('#edit-title').addClass("modified");
    }
};

$(document).ready(function(){
    Useredit.init($('.userprofile'));
});
