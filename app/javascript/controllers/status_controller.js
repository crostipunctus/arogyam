import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["edit", "status", "editMode", "statusSelect"];
  static values = { id: Number, endpoint: String };

  connect() { }

  toggleEditMode(event) {
    event.preventDefault();
    this.editModeTarget.style.display = this.editModeTarget.style.display === "none" ? "block" : "none";
  }

  async save(event) {
    event.preventDefault();

    const csrfToken = document.querySelector("[name=csrf-token]").content;
    const endpoint = this.endpointValue;

    const formData = new FormData();

    let statusParamName;
    if (endpoint.includes("vishraam_registration")) {
      statusParamName = "vishraam_registration[status]";
    } else if (endpoint.includes("online_consultation")) {
      statusParamName = "online_consultation[status]";
    } else {
      statusParamName = "registration[status]";
    }

    formData.append(statusParamName, this.statusSelectTarget.value);

    const response = await fetch(endpoint, {
      method: "PUT",
      headers: {
        "X-CSRF-Token": csrfToken,
      },
      body: formData,
    });

    if (!response.ok) {
      console.error("Failed to update status:", response);
    } else {
      this.statusTarget.textContent = this.statusSelectTarget.value;
      this.toggleEditMode(event);
    }
  }

  cancel(event) {
    event.preventDefault();
    this.toggleEditMode(event);
  }
}
