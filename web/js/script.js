jQuery(document).ready(function () {
    var $ = jQuery;

    /*$("#main-form").submit(function(){

        var $btn = $(this).button('loading');

    });*/

    $('#submit').on('click', function () {
        var $btn = $(this).button('loading')
        // business logic...
        //$btn.button('reset')
    })

});