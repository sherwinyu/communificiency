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


//TODO(syu): Definitely don't want this



$(document).ready(function(){




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



