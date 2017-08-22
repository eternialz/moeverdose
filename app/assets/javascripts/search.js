
Search = {
    init: function(root) {
        Search.root = root;
        Search.input = Search.root.find('#tags');
        Search.root.find('.tag').click( function() { Search.addRemoveTag($(this).text())});
    },
    addRemoveTag: function(choice) {
        Search.addSpaceEnd();

        // if the <li> with the word was allready clicked, then remove its "selected" class
        Search.input.val(function(_, val) {
            if (val.indexOf(choice + ' ') >= 0) {
                var text = val;
                var re = new RegExp(choice + ' ', "g"); // all occurence of choice
                text = text.replace(re, ' '); // remove all occurence of choice
                text = text.replace(/  /g, ' '); // change all double space to one space

                return text;
            } else {
                return val.replace(/  /g, ' ') + choice + ' '; // add
            }
        });
    },
    addSpaceEnd: function() {
        if (Search.input.val().substr(Search.input.val().length - 1) !== ' ') {
            Search.input.val(Search.input.val() + " ");
        };
    }
};

$(document).on('turbolinks:load', function(event) {
    Search.init($('.tags-form'));
});
