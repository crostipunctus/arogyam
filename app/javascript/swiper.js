import Swiper from 'swiper/bundle';

const swiper = new Swiper('.swiper', {

  breakpoints: {

    640: {
      slidesPerView: 2,
      spaceBetween: 50,
    },
    855: {
      slidesPerView: 3,
      spaceBetween: 50,
    },
    2000: {
      slidesPerView: 4,
      spaceBetween: 50,
    }
  },
  // Optional parameters
  direction: 'horizontal',
  loop: true,


  // Navigation arrows
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },

  // And if we need scrollbar
  scrollbar: {
    el: '.swiper-scrollbar',
  },
});