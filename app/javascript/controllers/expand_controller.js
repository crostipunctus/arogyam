import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expand"
export default class extends Controller {
  static targets = ["content"];

  expand() {
    const fullContent = this.contentTarget.getAttribute("data-full");
    this.contentTarget.innerText = fullContent;
    this.element.querySelector(".expand-btn").remove();
  }
}
