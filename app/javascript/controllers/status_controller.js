import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["edit", "status"];
  static values = { editing: Boolean };

  connect() {
    this.editingValue = false;
  }

  toggleEditMode(event) {
    event.preventDefault();
    this.editingValue = !this.editingValue;
    this.updateView();
  }

  updateView() {
    const textareaId = `status-textarea-${this.element.dataset.editStatusIdValue}`;
    let textarea = document.getElementById(textareaId);

    if (this.editingValue) {
      if (!textarea) {
        textarea = document.createElement("textarea");
        textarea.id = textareaId;
        textarea.classList.add("form-control");
        textarea.value = this.statusTarget.textContent.trim();
        this.statusTarget.insertAdjacentElement("afterend", textarea);
      }
      this.statusTarget.style.display = "none";
      textarea.style.display = "block";
      this.editTarget.textContent = "Save";
    } else {
      if (textarea) {
        this.statusTarget.textContent = textarea.value;
        textarea.style.display = "none";
      }
      this.statusTarget.style.display = "inline";
      this.editTarget.textContent = "Edit";
    }
  }
}