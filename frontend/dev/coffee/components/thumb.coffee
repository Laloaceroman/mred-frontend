
app.thumbs =

	init: ->

		app.thumbs.go 0

		$(".section__gallery__thumb").click ->
			app.thumbs.go $(this).index()


	go: (index) ->
		console.log index

		$(".section__gallery__thumb")
			.removeClass("current")
			.eq(index)
			.addClass("current")

		app.slider.go $(".section__gallery__slider .slider"), index

