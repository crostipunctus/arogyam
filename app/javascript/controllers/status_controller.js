import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["edit", "status"];
  static values = { editing: Boolean, id: Number };

  connect() {
    this.editingValue = false;
  }

  toggleEditMode(event) {
    event.preventDefault();
    this.editingValue = !this.editingValue;
    this.updateView();
  }

  updateView() {
    const textareaId = `status-textarea-${this.idValue}`;
    let textarea = document.getElementById(textareaId);

    if (this.editingValue) {
      if (!textarea) {
        textarea = document.createElement("textarea");
        textarea.id = textareaId;
        textarea.classList.add("form-control");
        textarea.classList.add("textarea-bottom-margin");
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
        this.saveStatus(textarea.value); // Save the updated status value to the database
      }
      this.statusTarget.style.display = "inline";
      this.editTarget.textContent = "Edit";
    }
  }

  async saveStatus(status) {
    const csrfToken = document.querySelector("[name=csrf-token]").content;
    const endpoint = this.element.dataset.endpoint;

    let body = {};

    if (endpoint.includes("vishraam_registration")) {
      body = { vishraam_registration: { status } };
    } else {
      body = { registration: { status } };
    }

    const response = await fetch(endpoint, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      console.error("Failed to update status:", response);
    }
  }
}
