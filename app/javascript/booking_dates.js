// app/javascript/booking_dates.js

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.block-button').forEach(button => {
    button.addEventListener('click', event => {
      event.preventDefault();

      let bookingId = event.target.dataset.id;
      let url = `/booking_dates/${bookingId}`;

      fetch(url, {
        method: 'PATCH',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          booking_date: { available: false, status: 'BLOCKED' }
        })
      })
        .then(response => response.json())
        .then(data => {
          if (data.status === 'BLOCKED') {
            let liElement = event.target.parentElement;
            liElement.classList.add('strikethrough');
            event.target.remove();  // remove the button from the DOM
          } else {
            alert('Error blocking the booking date.');
          }
        });
    });
  });
});
