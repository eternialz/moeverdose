Cookies = {
    init: function() {
        if(!Cookies.readCookie("cookies_disclaimer_closed")) {
            $('#cookies_disclaimer').removeClass('hide');
        }

        $('#cookies_disclaimer i').click(Cookies.closeCookieDisclaimer);
    },
    closeCookieDisclaimer: function() {
        $('#cookies_disclaimer').addClass('hide');
        Cookies.createCookie("cookies_disclaimer_closed", true, 999);
    },
    createCookie: function(name,value,days) {
        var expires = "";
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days*24*60*60*1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + value + expires + "; path=/";
    },
    readCookie: function (name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    },
    eraseCookie: function(name) {
        createCookie(name,"",-1);
    }
};

$(document).on('turbolinks:load', function() {
    Cookies.init();
});
