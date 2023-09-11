
app.header =

	init: ->
		app.header.nav.events()
		$(".header__icon--hamburger").click ->
			if !$("header").hasClass("header--nav-in")
				$("header").addClass("header--nav-in")
				$("header").addClass("header--color")
		
			else
				$("header").removeClass("header--nav-in")
				$("header").addClass("header-nav-out")
				setTimeout ->
					$("header").removeClass("header--nav-in header-nav-out")
				,200


	onScroll: (scroll) ->

		if scroll > 10
			$("header").addClass("header--color")
		else
			if !$("header").hasClass("header--nav-in")

				$("header").removeClass("header--color")


	nav:

		events: ->

			# Nav ham

			$('.header__ham').on 'click', (e) ->
				app.header.nav.toggle()

			$(".header__nav__close, .header__nav__bg").on 'click', ->
				app.header.nav.out()


			# Nav childrens

			$(".header__nav__nav li").each ->
				if $(this).find("ul").length || $(this).is("[supernav]")
					#$(this).append("<span class='fa fa-angle-right'></span>")
					$(this).children("a").append("<span class='fa fa-angle-right'></span>")

			$(".header__nav__nav a").on 'click', (e) ->
				app.header.nav.enterLvl($(this), e)

			# Back

			$(".header__nav__back").on "click", ->
				app.header.nav.backLvl()



		toggle: ->
			if !$("header").is(".header--nav-in")
				this.in()
			else
				this.out()

		in: ->
			if !$("header").hasClass("header--nav-out")
				$("header").addClass("header--nav-in")

		out: ->
			if !$("header").hasClass("header--nav-out")
				$("header").addClass("header--nav-out")
				setTimeout ->
					$("header").removeClass("header--nav-out")
					$("header").removeClass("header--nav-in")
					app.header.nav.backLvl()
				,500

		enterLvl: (el,e) ->
			if el.siblings("ul").length && $(window).width() < 1090
				e.preventDefault()
				el.siblings("ul").addClass("ul--in")
				$(".header__nav").addClass("header__nav--ul-in")

		backLvl: ->
			if $(".header__nav--ul-in").length
				$(".header__nav").removeClass("header__nav--ul-in")
				$(".header__nav__nav ul.ul--in").addClass("ul--out")
				setTimeout ->
					$(".header__nav__nav ul.ul--in").removeClass("ul--in ul--out")
				,500
