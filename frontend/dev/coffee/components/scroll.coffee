

app.scroll =

	init: ->

		#if $(window).width()>=960

		app.scroll.trigger()
		app.scroll.checkGoto()

		setInterval ->
			app.scroll.trigger()
		,500

		$(window).scroll ->
			app.scroll.trigger()
			app.scroll.checkGoto()


		#Reduce height header scroll
		window.addEventListener 'scroll', ->
			if window.scrollY > 50
				$('header').addClass("header--min")
				$('header').addClass("header--color")

			else
				$('header').removeClass("header--min")	
				$('header').removeClass("header--color")


		#else
		#	$(".dscroll").addClass("dscroll--in")

		# Go to

		$("[data-goto]").click (e) ->
			e.preventDefault()
			app.scroll.goto $(this).attr("data-goto")
			console.log "data"


		hash = window.location.hash.replace("#","")
		if hash != ""
			app.scroll.goto $(".section--"+hash)


	trigger: ->
		app.scroll.dscroll()
		app.scroll.parallax()
		app.scroll.sticky()
		


	dscroll: ->

		scroll = $(window).scrollTop()

		# Mostrar en scroll

		if $(".dscroll").length
			element_top_prev  = 0
			element_top_delay = 0

			$(".dscroll:visible").each ->
				element = $(this)
				element_top = element.offset().top

				if scroll + $(window).height() > element_top
					element.addClass "dscroll--in"

					if element_top >= element_top_prev - 25 && element_top <= element_top_prev + 25
						element_top_delay++
						delay = element_top_delay*0.2
						element.css
							'-webkit-animation-delay': delay+"s"
							'animation-delay': delay+"s"
					else
						element_top_delay=0

					element_top_prev = element_top

				if scroll + $(window).height() <= element_top
					element.removeClass "dscroll--in"

	parallax: ->

		scroll = $(window).scrollTop()

		if $("[parallax]").length

			$("[parallax]").each ->

				vals = $(this).attr("parallax").split(",")
				x    = parseFloat vals[0]
				y    = parseFloat vals[1]
				valX = scroll * x
				valY = scroll * y

				$(this).css
					"-webkit-transform": "translate("+valX+"px,"+valY+"px)"
					"-ms-transform": "translate("+valX+"px,"+valY+"px)"
					"transform": "translate("+valX+"px,"+valY+"px)"

	sticky: ->
		scroll = $(window).scrollTop()
		

		if $("[sticky]").length

			$("[sticky]").each ->

				sticky_top  = scroll + $("header").height() + 60

				element     = $(this)
				element_top = element.offset().top

				if sticky_top > element_top
					element.addClass("sticked")
				else
					element.removeClass("sticked")




	goto: (to,add=0,seconds=1000) ->

		from   = $("[data-goto='"+to+"']")

		if !add
			add = $("header").height() + 80
			add += from.closest("[sticky]").height() if from.closest("[sticky]").length

		if $(to).length
			
			top = $(to).offset().top - add

			$("body,html").animate
				scrollTop: top
			,seconds


	checkGoto: ->
		
		scroll = $(window).scrollTop()
		$index = -1

		$("[data-goto]").each ->

			from = $(this)
			to   = $( $(this).attr("data-goto") )

			add = $("header").height() + 120
			add += from.closest("[sticky]").height() if from.closest("[sticky]").length

			if to.length
				
				if scroll + add + 2 >= to.offset().top
					$("[data-goto].contener__tag--current").removeClass("contener__tag--current")
					from.addClass("contener__tag--current")
					$index = to.index()
		

		if $index > 2
			$(".contener__nav__sticky").scrollLeft(500)

		else
			$(".contener__nav__sticky").scrollLeft(0)




