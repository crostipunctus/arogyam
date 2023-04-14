import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];

  connect() {
    if (this.messageTarget.textContent.trim() !== "") {
      this.showNotification();
    }
  }

  showNotification() {
    // Remove previous classes (if any) before adding new ones
    this.element.classList.remove("success", "error");

    // Convert the message content to lower case for easier comparison
    const messageContent = this.messageTarget.textContent.toLowerCase();

    // Add classes based on the type of notification
    if (
      messageContent.includes("success") ||
      messageContent.includes("successfully") ||
      messageContent.includes("registration cancelled") ||
      messageContent.includes("batch deleted") ||
      messageContent.includes("confirmation link") ||
      messageContent.includes("password reset") ||
      messageContent.includes("password changed") ||
      messageContent.includes("message has been sent")
    ) {
      this.element.classList.add("success");
    } else if (
      messageContent.includes("error") ||
      messageContent.includes("invalid") ||
      messageContent.includes("sign in") ||
      messageContent.includes("sign up") ||
      messageContent.includes("please complete your profile")
    ) {
      this.element.classList.add("error");
    } else {
      // If the message doesn't include any of the keywords, don't display anything
      return;
    }

    this.element.classList.add("visible");
    setTimeout(() => {
      this.element.classList.remove("visible");
    }, 3000);
  }
}
