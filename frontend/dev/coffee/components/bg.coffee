
app.bg =
	init: ->

		$(".bg").each ->

			bg  = $(this)
			src = bg.find("img").attr("src")

			bg.css
				'background-image': 'url('+src+')'

			img = new Image()
			img.src = src
			img.onload = ->
				bg.addClass("bg-loaded")