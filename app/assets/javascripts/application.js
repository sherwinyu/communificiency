// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//
//= require bootstrap
//= require jquery_autogrowtextarea/
//= require rails.validations
//= require rails.validations.simple_form
//
//= require cocoon
//




//TODO(syu): Definitely don't want this



$(document).ready(function() {


  $("#helpDiv").modal({ show: false });


  $(".autogrow").autoGrow();





  $("#add_reward").click( function() {
    $(".autogrow").autoGrow();
  });





  $(".collapse").collapse();









  // This is just for project # show to convert the contribute button links to also post the contribution_amount input
  $('a.remote').each( function(a) {

    $(this).click(function(a){

      // alert('true');
      var href= $(this).attr('href');
      var url = href.split('?')[0];
      var data =  $(this).attr('data-submit');

      // we only want to override the default value when contribution_amount is nonempty
      if ($(data).val() === "")
      return true;
    var params = $(data).serialize();
    var glyph = href.indexOf('?') != -1 ? '&' : '+'
      href = href + glyph + params
      $(this).attr('href', href);
    // alert($(this).attr('href'))
    });



  });






});




(function() {
  $(document).ready(function() {
    /*
    return $("div.control-group").focusout(function() {
      if (!$("div.control-group").hasClass("error")) {
        return $(this).addClass("success");
      }
    });
    */
  });
}).call(this);

ClientSideValidations.formBuilders['SimpleForm::FormBuilder'] = {
  add: function(element, settings, message) {
         var errorElement, wrapper;

         settings.wrapper_tag = ".control-group";
         settings.error_tag = "span";
         settings.error_class = "help-inline";
         settings.wrapper_error_class = "error";
         // settings.wrapper_success = "success";

         if (element.data('valid') !== false) {
           wrapper = element.closest(settings.wrapper_tag);
           // wrapper.removeClass(settings.wrapper_success);
           wrapper.addClass(settings.wrapper_error_class);
           errorElement = $("<" + settings.error_tag + "/>", {
             "class": settings.error_class,
                        text: message
           });
           return wrapper.find(".controls").append(errorElement);
         } else {
           wrapper = element.closest(settings.wrapper_tag);
           wrapper.addClass(settings.wrapper_error_class);
           return element.parent().find("" + settings.error_tag + "." + settings.error_class).text(message);
         }
       },
  remove: function(element, settings) {
            var errorElement, wrapper;

            settings.wrapper_tag = ".control-group";
            settings.error_tag = "span";
            settings.error_class = "help-inline";
            settings.wrapper_error_class = "error";
            // settings.wrapper_success = "success";

            wrapper = element.closest("" + settings.wrapper_tag + "." + settings.wrapper_error_class);
            wrapper.removeClass(settings.wrapper_error_class);
            // wrapper.addClass(settings.wrapper_success);
            errorElement = wrapper.find("" + settings.error_tag + "." + settings.error_class);
            return errorElement.remove();
          }
};



