Global = {
    init: function() {
        Global.menu = false;
        Global.mouseOver = false;
        Global.timeout_close = setTimeout('', 1);
        Global.timeout_open = setTimeout('', 1);
        $('#menu_label').click(Global.develop_submenu);

        $('nav.menu .container, nav.menu .submenu').on('mouseover', function () {
            Global.timeout_open = setTimeout(function() { // Close after 2ms if not hovered
                Global.open_submenu();
            }, 100)
            Global.mouseOver = true;
        }).on('mouseout', function (e) {
            clearTimeout(Global.timeout_open);
            Global.mouseOver = false;

            if ($(e.target).is('input')) {
                Global.mouseOver = true; // Close only if it's out and not if hovered on browser input autocomplete
            }

            clearTimeout(Global.timeout_close); // Remove potential old Timeout
            Global.timeout_close = setTimeout(function() { // Close after 2ms if not hovered
                if (!Global.mouseOver) {
                    Global.close_submenu();
                }
            }, 350)
        });
    },
    develop_submenu: function() {
        if (Global.menu === false) {
            Global.open_submenu();
            Global.menu = true;
        } else {
            Global.close_submenu();
            Global.menu = false;
        }
    },
    open_submenu: function() {
        $("#menu_label").addClass('open');
        $('.submenu').addClass('develop');
    },
    close_submenu: function() {
        $("#menu_label").removeClass('open');
        $('.submenu').removeClass('develop');
    },
};

$(document).on('turbolinks:load', function() {
    Global.init();
});
