import { Controller } from "@hotwired/stimulus"

// Submits the form when a field changes.
// Usage: data-controller="form" data-action="change->form#submit"
export default class extends Controller {
  submit() {
    this.element.requestSubmit()
  }
}
