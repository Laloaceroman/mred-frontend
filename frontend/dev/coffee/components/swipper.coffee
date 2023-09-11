app.swiper =
	init: ->
		swiper = new Swiper('.swiper-products',
			loop: true,
			speed: 1000,
			autoplay: 
				enabled: true,
				delay: 3000,
			
			breakpoints:
				0:
					slidesPerView: 1
					spaceBetween: 10
					slidesPerGroup: 1

				800:
					slidesPerView: 2
					spaceBetween: 10
					slidesPerGroup: 1
				1200:
					slidesPerView: 3
					spaceBetween: 10
					slidesPerGroup: 1)

