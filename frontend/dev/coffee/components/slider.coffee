
app.slider =
	init: ->


		$(".slider").each ->

			# Create elements: nav, bullets
			app.slider.createElements $(this)

			# Events
			app.slider.events $(this)

			# Set first slide
			app.slider.go $(this), 0

			# Autoplay
			app.slider.autoplay $(this)


	events: (slider) ->

		slider.hammer().bind "swipeleft", (e) ->
			app.slider.next slider

		slider.hammer().bind "swiperight", (e) ->
			app.slider.prev slider

		slider.find(".slider-nav-left").click ->
			app.slider.prev slider

		slider.find(".slider-nav-right").click ->
			app.slider.next slider

		slider.find(".slider-bullet").click ->
			app.slider.go slider, $(this).index()


	create: (data) ->

		# Create new slider from some data
		slides = ""
		for d in data
			slides += "<div class='slide'>"+d+"</div>"

		slider = "<div class='slider slider--cover'>"+slides+"</div>"

		return slider


	createElements: (slider) ->

		# Generate slider elements

		if !slider.find("slider-slides").length
			slider.find(".slide").wrapAll("<div class='slider-slides' />")

		if slider.find(".slide").length > 1
			html = ""
			html += "<div class='slider-navigation'>"
			html += "<div class='slider-nav slider-nav-left'><span class='fa fa-angle-left'></span></div>"
			html += "<div class='slider-nav slider-nav-right'><span class='fa fa-angle-right'></span></div>"
			html += "</div>"
			html += "<div class='slider-bullets'><div class='slider-bullets-limit'></div></div>"
			slider.append html
			slider.find(".slide").each ->
				slider.find(".slider-bullets .slider-bullets-limit").append("<div class='slider-bullet'></div>")



	next: (slider) ->
		current = slider.find(".slide.slide-current").index()
		goto    = current + 1
		goto    = 0 if goto >= slider.find(".slide").length
		app.slider.go slider, goto, "right"


	prev: (slider) ->
		current = slider.find(".slide.slide-current").index()
		goto    = current - 1
		goto    = slider.find(".slide").length - 1 if goto < 0
		app.slider.go slider, goto, "left"


	go: (slider,goto,dir=false) ->

		current = slider.find(".slide.slide-current").index()

		if !slider.hasClass("slider-animate") && current!=goto

			if !dir && current>=0
				dir = if current < goto then "right" else "left"

			sliderGoto = slider.find(".slide").eq(goto)

			slider.removeClass("slider-dir-left slider-dir-right")
			slider.addClass "slider-animate"
			slider.addClass "slider-dir-"+dir if dir

			slider.find(".slide.slide-current").addClass("slide-out").removeClass("slide-current")
			sliderGoto.addClass("slide-current")

			slider.find(".slider-bullet")
				.removeClass("slider-bullet-current")
				.eq(goto).addClass("slider-bullet-current")

			setTimeout ->
				slider.find(".slide-out [slider-video]").html ""
				slider.find(".slide-out").removeClass("slide-out")
				slider.removeClass("slider-animate")
			,500

			# Load video
			sliderVideo = sliderGoto.find("[slider-video]")
			sliderVideo.append app.video.createPlayer(sliderVideo.attr("slider-video"), sliderVideo.attr("slider-video-poster")) if sliderVideo.length

			# Load bg
			app.bg.init()


	autoplay: (slider) ->

		play_timeout = false

		slider.on "mouseenter", ->
			clearTimeout(play_timeout)

		slider.on "mouseleave", ->
			play()

		play = ->
			clearTimeout(play_timeout)
			play_timeout = setTimeout ->
				#if app.isMobile()
				slider.each ->
					app.slider.next $(this)
				play()
			,6000

		play()




((factory) ->
	if typeof define == 'function' and define.amd
		define [
			'jquery'
			'hammerjs'
		], factory
	else if typeof exports == 'object'
		factory require('jquery'), require('hammerjs')
	else
		factory jQuery, Hammer
	return
) ($, Hammer) ->

	hammerify = (el, options) ->
		$el = $(el)
		if !$el.data('hammer')
			$el.data 'hammer', new Hammer($el[0], options)
		return

	$.fn.hammer = (options) ->
		@each ->
			hammerify this, options
			return

	# extend the emit method to also trigger jQuery events
	Hammer.Manager::emit = ((originalEmit) ->
		(type, data) ->
			originalEmit.call this, type, data
			$(@element).trigger
				type: type
				gesture: data
			return
	)(Hammer.Manager::emit)
	return




