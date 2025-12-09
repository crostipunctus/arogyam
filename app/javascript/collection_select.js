
document.addEventListener("DOMContentLoaded", function () {

  var packageDropdown = document.getElementById("packageSelect");

  // Only add event listener if the elements exist
  if (packageDropdown) {
    var selectedProgramme = document.getElementById("packageNameSelection");
    
    if (selectedProgramme) {
      packageDropdown.addEventListener("change", function () {
        var selectedValue = packageDropdown.options[packageDropdown.selectedIndex].text;
        var yourPackageSelection = "Selected programme: ";
        selectedProgramme.textContent = yourPackageSelection + selectedValue;
      });
    }
  }
});

