Global = {
    init: function() {
        Global.menu = false;
        $('#menu_label').click(Global.develop_submenu);
        $('.submenu input').focus(Global.develop_submenu_focus);
    },
    develop_submenu: function() {
        if (Global.menu == false) {
            $(this).addClass('open');
            $('.submenu').addClass('develop');
            Global.menu = true;
        } else {
            $(this).removeClass('open');
            $('.submenu').removeClass('develop');
            Global.menu = false;
        };
    },
    develop_submenu_focus: function() {
        if (Global.menu == false) {
            $('#menu_label').addClass('open');
            $('.submenu').addClass('develop');
            Global.menu = true;
        };
    }
};

$(document).ready(function(){
    Global.init();
});
