
document.addEventListener("DOMContentLoaded", function () {

  var packageDropdown = document.getElementById("packageSelect");


  packageDropdown.addEventListener("change", function () {

    var selectedValue = packageDropdown.options[packageDropdown.selectedIndex].text;



    var selectedProgramme = document.getElementById("packageNameSelection")

    var yourPackageSelection = "Selected programme: "

    selectedProgramme.textContent = yourPackageSelection + selectedValue

  });
});

