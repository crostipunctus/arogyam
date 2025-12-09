document.addEventListener("DOMContentLoaded", function () {
  const packageSelect = document.getElementById('package-select');
  const vishramDays = document.getElementById('vishram-days');
  const shamanamDays = document.getElementById('shamanam-days');
  
  // Only add event listener if the elements exist
  if (packageSelect && vishramDays && shamanamDays) {
    packageSelect.addEventListener('change', function () {
      const selectedPackage = packageSelect.options[packageSelect.selectedIndex].text;

      if (selectedPackage === 'VishraM') {
        vishramDays.style.display = 'block';
        shamanamDays.style.display = 'none';
      } else if (selectedPackage === 'ShamanaM') {
        shamanamDays.style.display = 'block';
        vishramDays.style.display = 'none';
      } else {
        vishramDays.style.display = 'none';
        shamanamDays.style.display = 'none';
      }
    });
  }
});
