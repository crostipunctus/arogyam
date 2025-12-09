// app/javascript/show_footer_on_scroll.js

document.addEventListener("DOMContentLoaded", function () {
  const footer = document.querySelector("#footer");

  if (footer) {
    window.addEventListener("scroll", function () {
      if (window.pageYOffset > 0) {
        footer.style.display = "flex";
      }
    });
  }
});
