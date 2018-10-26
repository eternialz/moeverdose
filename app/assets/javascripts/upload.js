Upload = {
    init: function(root) {
        Upload.root = root;
        Upload.root.find("#post_post_image").change(function(){
            Upload.readURL(this);
        });
        Upload.widthInput = Upload.root.find("#input-width")[0];
        Upload.heightInput = Upload.root.find("#input-height")[0];
    },
    readURL: function(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            var img = new Image();
            img.src = window.URL.createObjectURL(input.files[0]);

            reader.onload = function (e) {
                $('#file').attr('src', e.target.result);
            }

            img.onload = function() {
                Upload.widthInput.value = img.naturalWidth;
                Upload.heightInput.value = img.naturalHeight;
            }

            reader.readAsDataURL(input.files[0]);
        }
    }
};

$(document).on('turbolinks:load', function() {
    Upload.init($('.upload'));
});
