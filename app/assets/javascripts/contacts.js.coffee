$(document).on 'page:change', ->
  if $('#number-of-unprocessed-comments').length
    setInterval(update_number_of_unprocessed_comments, 1000 * 60)

update_number_of_unprocessed_comments = ->
  $.get window.paths.number_of_unprocessed_comments, (data) ->
    $('#number-of-unprocessed-comments').text "(#{data})"
