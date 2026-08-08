import { Controller } from "@hotwired/stimulus"
import { recaptchaToken } from "../lib/recaptcha"

export default class extends Controller {
  static values = {
    siteKey: String,
    actionName: String
  }

  connect() {
    this.verified = false
  }

  async submit(event) {
    if (this.verified) return

    event.preventDefault()
    this.hideError()
    this.setSubmitting(true)

    try {
      const token = await this.recaptchaToken()
      this.appendToken(token)
      this.verified = true
      this.element.requestSubmit()
    } catch (_error) {
      this.setSubmitting(false)
      this.showError()
    }
  }

  recaptchaToken() {
    return recaptchaToken(this.siteKeyValue, this.actionNameValue)
  }

  appendToken(token) {
    this.element.querySelector('input[name="recaptcha_token"]')?.remove()

    const input = document.createElement("input")
    input.type = "hidden"
    input.name = "recaptcha_token"
    input.value = token
    this.element.appendChild(input)
  }

  setSubmitting(isSubmitting) {
    const submitButton = this.element.querySelector('[type="submit"]')
    if (!submitButton) return

    if (!submitButton.dataset.originalLabel) {
      submitButton.dataset.originalLabel = submitButton.value || submitButton.textContent
    }

    submitButton.disabled = isSubmitting
    const label = isSubmitting ? "Verifying…" : submitButton.dataset.originalLabel

    if (submitButton.tagName === "INPUT") {
      submitButton.value = label
    } else {
      submitButton.textContent = label
    }
  }

  showError() {
    this.errorElement.hidden = false
  }

  hideError() {
    const error = this.element.querySelector("[data-recaptcha-form-error]")
    if (error) error.hidden = true
  }

  get errorElement() {
    let error = this.element.querySelector("[data-recaptcha-form-error]")
    if (error) return error

    error = document.createElement("div")
    error.className = "alert alert-danger mt-3"
    error.dataset.recaptchaFormError = "true"
    error.setAttribute("role", "alert")
    error.textContent = "We could not verify your request. Please refresh the page and try again."
    this.element.appendChild(error)
    return error
  }
}
