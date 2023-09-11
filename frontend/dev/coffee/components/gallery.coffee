
app.gallery =

	init: ->

		$("[gallery-description]").each ->
			if $(this).find(".article__description")
				$(this).attr("gallery-description",$(this).find(".article__description").html())

		app.gallery.events()
		$('.idzoom').zoom()


	events: ->

		$(document).on "click", "[gallery]", ->
				
			group = $(this).attr("gallery")

			start = $(this).index()

			start = $(this).parent().index() if $(this).parent().parent().is(".cols")
			if $(this).hasClass("article--gallery-video")
				start = 0
			else
				start = start + 1
	
			if $(this).parent().hasClass("col--planes")
				start = start - 1
				
			console.log group
			console.log start
			app.gallery.create(group,start)
			$('.idzoom').zoom()

		$(document).on "click", "[next]", ->

			console.log "hola 2"
			index = $(this).parent(".col-xs-3").index()
			start = index
			start = start + 1
			console.log start
			group = $(this).parent(".col-xs-3").siblings(".col-xs-3").find(".article--gallery").attr("gallery")
			#start = $(this).parent().index() if $(this).parent().parent().is(".cols")
			app.gallery.create(group,start)
			console.log start
			#if $(this).hasClass("article--gallery-arrow") == true
				#start = start + 1	

		$(document).on "click", ".gallery__back", ->
			console.log "close ok"
			app.gallery.remove $(this).closest(".gallery")
			$("body").css('overflow', 'auto')

		$(document).on "click", ".gallery__close", ->
			console.log "close ok"
			app.gallery.remove $(this).closest(".gallery")
			$("body").css('overflow', 'auto')

		$(document).keyup (e) ->
			#console.log e, e.key

			if $(".gallery").length

				if e.key == "Escape"
					app.gallery.remove $(".gallery").eq(-1)

				if e.key == "ArrowRight"
					app.slider.next $(".gallery").eq(-1).find(".slider")

				if e.key == "ArrowLeft"
					app.slider.prev $(".gallery").eq(-1).find(".slider")


	create: (group,start) ->

		# Get elements

		elements = $("[gallery='"+group+"']")
		slides   = []

		elements.each ->

			image = $(this).attr("gallery-image")
			video = $(this).attr("gallery-video")
			desc  = $(this).attr("gallery-description")

			slide = "<div class='gallery__img'><img src='"+image+"' /></div><div class='gallery__back'></div>"
			slide = "<div slider-video='"+video+"' slider-video-poster='"+image+"'></div><div class='gallery__back'>" if video
			slide += "<div class='gallery__description'>"+desc+"</div>" if desc && desc!=""

			slides.push slide

		html  = "<div class='gallery gallery--"+group+"'>"
		html += "	<div class='gallery__slider'></div>"
		html += "	<div class='gallery__close'><span class='fa fa-times'></span></div>"
		html += "</div>"

		$("body").append html

		# Create slider

		$(".gallery__slider").append app.slider.create(slides)

		g = $(".gallery__slider .slider")

		app.slider.createElements g
		app.slider.go g, start
		app.slider.events g

		$('.idzoom').zoom()
		$("body").css('overflow', 'hidden')



	remove: (gallery) ->
		gallery.addClass("gallery--out")
		setTimeout ->
			gallery.remove()
		,500


