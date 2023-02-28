import Swiper from 'swiper/bundle';

const swiper = new Swiper('.swiper', {
  slidesPerView: 2,
  spaceBetween: 10,
  breakpoints: {
    480: {
      slidesPerView: 4,
      spaceBetween: 40,
    },
    640: {
      slidesPerView: 5,
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