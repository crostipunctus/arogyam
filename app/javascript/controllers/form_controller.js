import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  connect() {
    this.element.addEventListener('change', () => this.submit())

    console.log("Hello, Stimulus!", this.element);
  }

  submit() {
    this.element.requestSubmit();
  }
}
