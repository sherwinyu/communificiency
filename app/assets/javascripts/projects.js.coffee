jQuery ->
  # filepicker.setKey('AoihJ1shDSAWocXhG7tOHz')

  ###filepicker.getFile('image/*', 
    multiple: true,
    container: 'window',
    services: [filepicker.SERVICES.COMPUTER]
  , ->
    $('#multiResult').html(JSON.stringify(response))
  )
  ###

  # alert rewardsURL
  # alert $('#rewards').data('url')
  # console.log $('#rewards').data( "url" )
  # TODO (syu) on inputContribution change, update SELECTED tag

  $(".collapse").collapse('hide')

  $('#sharrre').sharrre
    share: 
      facebook: true,
      twitter: true
      googlePlus: true,
    enableHover: false,
    enableCounter: false,
    enableTracking: true
    buttons: {
        googlePlus: {size: 'tall'},
        facebook: {layout: 'box_count'},
        twitter: {count: 'vertical', via: 'communificiency'},
        digg: {type: 'DiggMedium'},
        delicious: {size: 'tall'},
      }

  if rewards?
    $("#inputContributionAmount").change (event)->
      updateDropDown()
      id = parseInt $('#contribution_reward_id').val()
      reward = (reward for reward in rewards when reward.id == id)[0]
      updateRewardDescription(reward)

    $('#contribution_reward_id').change (event)->
      # alert('Handler for .change() called' + event.data)
      id =  parseInt $('#contribution_reward_id').val()
      console.log id
      reward = (reward for reward in rewards when reward.id == id)[0]
      updateRewardDescription(reward)
      console.log reward

    updateRewardDescription = (reward) ->
      unless reward?
        $('#reward').hide()
        $('#steptwo .instructions').text("You haven’t chosen a reward yet. Use the dropdown menu below to find a reward you like. Or, if you don't want a reward, just go on step 3.")
        $('.step1 .control-group').removeClass('error');
        return;

      $('#reward-name').text(reward.name)
      $('#reward-minimum-contribution .reward-display').text(reward.minimum_contribution_dollars)
      $('#reward-short-description .reward-display').text(reward.long_description)
      $('#reward-extimated-delivery .reward-display').text(reward.long_description)
      current = parseInt $("#inputContributionAmount").val()
      current = 0 if isNaN(current)
      console.log "current: " + current
      console.log "min: " + reward.minimum_contribution
      instructions = ""
      if (current < reward.minimum_contribution) # invalid
        instructions = "You’ve selected this reward, but your contribution doesn’t meet the minimum. Please select another reward or increase your contribution."
        $('#reward').addClass('error')
        $('.step1 .control-group').addClass('error');
      else # valid
        instructions = "Make sure this is the reward you want, and move on to step 3! If you want to select another reward, just use the dropdown menu."
        $('#reward').removeClass('error')
        $('.step1 .control-group').removeClass('error');
      console.log instructions
      $('#steptwo .instructions').text(instructions)
      $('#reward').show()

    updateDropDown = ->
      console.log "updateDropDown"
      current = parseInt $("#inputContributionAmount").val()
      current = 0 if isNaN(current)
      console.log current
      updateDropDownOption = (reward) ->
        option = $("#steptwo option[value=\"#{reward.id}\"]")
        if (current < reward.minimum_contribution) # invalid
          option.addClass('invalid') 
        else
          option.removeClass('invalid')
        option.text("#{reward.name} (#{reward.minimum_contribution_dollars})")
        console.log option
      updateDropDownOption(reward) for reward in rewards
      console.log rewards
      unavailableRewards = (reward for reward in rewards when reward["limited_quantity?"]  && reward.quantity_remaining == 0)
      console.log unavailableRewards
      console.log 'unavail rewards: ', unavailableRewards #, unavailableRewards.length
      for reward in unavailableRewards 
        console.log reward, "disabled"
        $("#steptwo option[value=\"#{reward.id}\"]").attr('disabled', 'disabled')
        $("#steptwo option[value=\"#{reward.id}\"]").addClass('unavailable')
      console.log 'unavail rewards: ', unavailableRewards


    updateDropDown()
    updateRewardDescription(reward)
