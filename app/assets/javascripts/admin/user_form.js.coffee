$(document).on 'page:change', ->
  $('form.edit_user').on 'click', '#enable-password-field', ->
    $('#enable-password-field').hide()
    $('#disable-password-field').show()
    $('#user_password').removeAttr('disabled')
    $('label[for=user_password]').addClass('required')
  $('form.edit_user').on 'click', '#disable-password-field', ->
    $('#disable-password-field').hide()
    $('#enable-password-field').show()
    $('#user_password').attr('disabled', 'disabled')
    $('label[for=user_password]').removeClass('required')
