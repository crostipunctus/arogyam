// app/javascript/date_picker.js
document.addEventListener("turbo:load", function () {
  var dateInput = document.getElementById("date_input");
  if (dateInput) {
    var today = new Date().toISOString().split("T")[0];
    dateInput.setAttribute("min", today);
  }
});
