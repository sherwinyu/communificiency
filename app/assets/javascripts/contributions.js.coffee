# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))

  stripe$ = $('#payStripe')
  stripe$.find('input.stripe').removeAttr('name')
  stripe$.find('.card-number').val('4242424242424242')
  stripe$.find('.card-cvc').val('123')
  stripe$.find('.card-expiry-month').val('12')
  stripe$.find('.card-expiry-year').val('2013')

  $('#stripePayButton').click (event) ->
    event.preventDefault()
    $('#transactionProvider').val('STRIPE')
    # $('#new_contribution').attr('action', '/projects/1/contributions/1/new_stripe')
    console.log '#payButtonOnClick'
    console.log $('#new_contribution').attr('action')
    ret = stripeGeneratePayment()

  stripeGeneratePayment = ->
    $('.stripePayButton').attr("disabled", "disabled");


    stripeObj = 
        number: $('.card-number').val(),
        cvc: $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val()

    console.log "stripeObj is", stripeObj
    Stripe.createToken(stripeObj, stripeCB);
    console.log "tokenCreated"

  stripeCB = (status, response) ->
    if response.error 
        console.log response.error.message
        $("#payStripe .error").text(response.error.message);
        $(".submit-button").removeAttr("disabled");
    else 
        console.log "stripeCB response:"
        console.log response
        form$ = $("#new_contribution");
        # // token contains id, last4, and card type
        token = response['id'];
        # // insert the token into the form so it gets submitted to the server
        form$.find("#payStripe").append("<input type='hidden' name='stripeToken' value='" + token + "'/>");
        console.log "transActionProviderVal: ", $('#transactionProvider').val()
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
