// app/javascript/show_footer_on_scroll.js

// app/javascript/show_footer_on_scroll.js

const footer = document.querySelector("#footer");

window.addEventListener("scroll", function () {
  if (window.pageYOffset > 0) {
    footer.style.display = "flex";
  }
});
