# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  loadRound()
  

loadRound = ->
  hash = $("#hash")[0].value
  target = document.getElementById('spinner')
  spinner = new Spinner().spin(target)
  $(".choice").removeClass('success')
  $(".choice").removeClass('alert')
  $.ajax(url: "/play/new?id="+hash).done (data) ->
    video = $("#video")[0]
    video.pause()
    video.src = data["video_url"]
    video.load()
    spinner.stop()
    video.play()

    $(".choice").each (idx) ->
      $(this).text(data["choices"][idx])

  $(".choice").click ->
    link = $(this)
    answer = link.attr('id')
    $.ajax(url: "/play/validate?id="+hash+"&answer="+answer).done (data) ->
      if data["result"]
        link.addClass('success')
      else
        link.addClass('alert')
        $($(".choice")[data["answer"]]).addClass('success')
      setTimeout ->
        loadRound spinner, hash
      , 2000
