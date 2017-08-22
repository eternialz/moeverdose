Global = {
    init: function() {
        Global.menu = false;
        Global.mouseOver = false;
        Global.timeOut = setTimeout('', 1);
        $('#menu_label').click(Global.develop_submenu);

        $('nav.menu, nav.menu .submenu').on('mouseover', function () {
            Global.open_submenu();
            Global.mouseOver = true;
        }).on('mouseout', function (e) {
            Global.mouseOver = false;

            if ($(e.target).is('input')) {
                Global.mouseOver = true; // Close only if it's out and not if hovered on browser input autocomplete
            }

            clearTimeout(Global.timeOut); // Remove potential old Timeout
            Global.timeOut = setTimeout(function() { // Close after 2ms if not hovered
                if (!Global.mouseOver) {
                    Global.close_submenu();
                }
            }, 1000)
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
