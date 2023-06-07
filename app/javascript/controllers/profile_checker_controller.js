import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-checker"
export default class extends Controller {
  static targets = ["link"]
  connect() {
    this.hasProfile = this.data.has("hasProfile") && this.data.get("hasProfile") === "true";
    if (!this.hasProfile) {
      this.linkTargets.forEach(el => el.classList.add("disabled"));
    }
  }

  checkProfile(event) {
    if (!this.hasProfile) {
      event.preventDefault();
      // Optionally, show a message to the user here
      alert('You need to create a profile first.');
    }
  }
}
