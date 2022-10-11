// Entry point for the build script in your package.json

//= require swiper

Turbo.session.drive = false

import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "trix"
import "@rails/actiontext"


import "./theme"
import "./customizer"
// import "./lightgallery.js"
import "./swiper-bundle"
// import "./postinstall"
// import "./main.js"
// import "./locales-all.js"

const swiper = new Swiper('.swiper', {
  // Optional parameters
  direction: 'vertical',
  loop: true,

  // If we need pagination
  pagination: {
    el: '.swiper-pagination',
  },

  // Navigation arrows
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },

  // And if we need scrollbar
  scrollbar: {
    el: '.swiper-scrollbar',
  },
}); import "trix"
import "@rails/actiontext"
