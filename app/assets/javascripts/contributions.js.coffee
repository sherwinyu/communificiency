# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))

  stripe$ = $('#payStripe')
  stripe$.find('input').removeAttr('name')

  $('#stripePayButton').click (event) ->
    # event.preventDefault()
    $('#new_contribution').attr('action', '/contributions/new_stripe')
    console.log '#payButtonOnClick'
    console.log $('#new_contribution').attr('action')
    ret = stripeGeneratePayment()

  stripeGeneratePayment = ->
    $('.stripePayButton').attr("disabled", "disabled");

    Stripe.createToken({
        number: $('.card-number').val(),
        cvc: $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val()
    }, stripeCB);

  stripeCB = (status, response) ->
    if response.error 
        $("#payStripe .error").text(response.error.message);
        $(".submit-button").removeAttr("disabled");
    else 
        form$ = $("#payment-form");
        # // token contains id, last4, and card type
        token = response['id'];
        # // insert the token into the form so it gets submitted to the server
        form$.append("<input type='hidden' name='stripeToken' value='" + token + "'/>");
        // and submit
        form$.get(0).submit();
    




    ###
$(document).ready(function() {
  $("#payment-form").submit(function(event) {
    // disable the submit button to prevent repeated clicks
    $('.submit-button').attr("disabled", "disabled");

    Stripe.createToken({
        number: $('.card-number').val(),
        cvc: $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val()
    }, stripeResponseHandler);

    // prevent the form from submitting with the default action
    return false;
  });
});
###
