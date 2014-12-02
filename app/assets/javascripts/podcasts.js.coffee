# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



ready = ->  
  $('.sn-dropdown').click ->
      shownotes = $(this).next('.shownotes')
      fieldset =  $(this).parent('fieldset')
      if shownotes.css('display') == 'none'
        fieldset.css('border', '1px solid #c0c0c0')
        shownotes.slideDown()
      else
        fieldset.css('border', 'none')
        shownotes.slideUp()
$(document).ready(ready)
$(document).on('page:load', ready)