$(document).on 'page:change', ->
  if $('#number-of-unread-comments').length
    setInterval(update_number_of_unread_comments, 1000 * 60)

update_number_of_unread_comments = ->
  $.get window.paths.number_of_unread_comments, (data) ->
    $('#number-of-unread-comments').text "(#{data})"
