import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];
  static values = { type: String };

  connect() {
    this.boundMaybeShow = this.maybeShow.bind(this);
    this.maybeShow();
    // Re-check after Turbo Drive navigations
    document.addEventListener("turbo:load", this.boundMaybeShow);
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.boundMaybeShow);
  }

  maybeShow() {
    // A page may render the same flash inline (e.g. the auth forms). Don't
    // duplicate it as a toast in that case.
    if (document.querySelector("[data-inline-flash]")) return;
    if (this.messageTarget.textContent.trim() === "") return;

    this.showNotification();
  }

  showNotification() {
    this.element.classList.remove("success", "error");

    // Style by flash type (notice => success, alert => error) instead of
    // guessing from the message text, so no message is ever silently dropped.
    const type = this.typeValue === "success" ? "success" : "error";
    this.element.classList.add(type, "visible");

    // Auto-dismiss success toasts quickly; leave errors up longer so the user
    // has time to read and act on them.
    const timeout = type === "success" ? 5000 : 10000;
    setTimeout(() => {
      this.element.classList.remove("visible");
    }, timeout);
  }
}
