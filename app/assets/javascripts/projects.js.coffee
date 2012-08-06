jQuery ->
  # alert rewardsURL
  # alert $('#rewards').data('url')
  # console.log $('#rewards').data( "url" )

  $("#inputContributionAmount").change (event)->
    updateDropDown()

  $('#contribution_reward_id').change (event)->
    # alert('Handler for .change() called' + event.data)
    id =  parseInt $('#contribution_reward_id').val()
    console.log id
    reward = (reward for reward in rewards when reward.id == id)[0]
    updateRewardDescription(reward)
    # $('#reward .reward-header').text(reward.name)
    # $('#reward-minimum-contribution .reward-display').text(reward.minimum_contribution_dollars)
    # $('#reward-short-description .reward-display').text(reward.short_description)
    # $('#reward-extimated-delivery .reward-display').text(reward.short_description)
    console.log reward

  updateRewardDescription = (reward) ->
    unless reward?
      $('#reward').hide()
      $('#steptwo .instructions').text("You haven’t chosen a reward yet. Use the dropdown menu below to find a reward you like. Or, if you don't want a reward, just go on step 3.")
      return;

    $('#reward-name').text(reward.name)
    $('#reward-minimum-contribution .reward-display').text(reward.minimum_contribution_dollars)
    $('#reward-short-description .reward-display').text(reward.short_description)
    $('#reward-extimated-delivery .reward-display').text(reward.short_description)
    current = parseInt $("#inputContributionAmount").val()
    console.log "current: " + current
    console.log "min: " + reward.minimum_contribution
    instructions = ""
    if (current < reward.minimum_contribution) # invalid
      instructions = "You’ve selected this reward, but your contribution doesn’t meet the minimum. Please select another reward or increase your contribution."
      $('#reward').addClass('error')
    else # valid
      instructions = "Make sure this is the reward you want, and move on to step 3! If you want to select another reward, just use the dropdown menu."
      $('#reward').removeClass('error')
    console.log instructions
    $('#steptwo .instructions').text(instructions)
    $('#reward').show()

  updateDropDown = ->
    console.log "updateDropDown"
    current = parseInt $("#inputContributionAmount").val()
    updateDropDownOption = (reward) ->
      option = $("#steptwo option[value=\"#{reward.id}\"]")
      if (current < reward.minimum_contribution) # invalid
        option.addClass('invalid') 
      else
        option.removeClass('invalid')
      option.text("#{reward.name} (#{reward.minimum_contribution_dollars})")
      console.log option
    updateDropDownOption(reward) for reward in rewards

  updateDropDown()
  updateRewardDescription(reward)


