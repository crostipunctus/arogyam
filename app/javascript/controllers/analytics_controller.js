import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    eventName: String,
    params: Object,
    auto: Boolean
  }

  connect() {
    if (this.autoValue) this.track()
  }

  track() {
    if (typeof window.gtag !== "function" || !this.eventNameValue) return

    window.gtag("event", this.eventNameValue, this.paramsValue)
  }
}
