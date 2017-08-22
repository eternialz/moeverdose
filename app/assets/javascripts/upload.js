Upload = {
    init: function(root) {
        Upload.root = root;
        Upload.root.find("#post_post_image").change(function(){
            Upload.readURL(this);
        });
    },
    readURL: function(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#file').attr('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]);
        }
    }
};

$(document).on('turbolinks:load', function() {
    Upload.init($('.upload'));
});
