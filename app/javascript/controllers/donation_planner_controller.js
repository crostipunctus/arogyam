import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "causeButton",
    "causeInput",
    "causeName",
    "amountButton",
    "amountInput",
    "amountField",
    "amountSummary",
    "panInput",
    "panNotice",
    "recaptchaError",
    "submitButton"
  ]

  static values = {
    siteKey: String,
    panThreshold: Number
  }

  connect() {
    this.recaptchaVerified = false
    this.updatePanRequirement(this.amountFieldTarget.value)
  }

  selectCause(event) {
    this.causeButtonTargets.forEach((button) => {
      const isSelected = button === event.currentTarget
      button.classList.toggle("is-selected", isSelected)
      button.setAttribute("aria-pressed", isSelected.toString())
    })

    this.causeInputTarget.value = event.currentTarget.dataset.donationCauseKey
    this.causeNameTarget.textContent = event.currentTarget.dataset.donationCauseName
  }

  selectAmount(event) {
    this.amountInputTarget.value = ""
    this.markSelectedAmount(event.currentTarget)
    this.setAmount(event.currentTarget.dataset.donationAmountValue)
  }

  enterCustomAmount() {
    this.markSelectedAmount(null)
    this.setAmount(this.amountInputTarget.value)
  }

  async submit(event) {
    if (this.recaptchaVerified) return

    event.preventDefault()
    this.hideRecaptchaError()
    this.setSubmitting(true)

    try {
      const token = await this.recaptchaToken()
      this.appendRecaptchaToken(token)
      this.recaptchaVerified = true
      this.element.requestSubmit()
    } catch (_error) {
      this.setSubmitting(false)
      this.showRecaptchaError()
    }
  }

  markSelectedAmount(selectedButton) {
    this.amountButtonTargets.forEach((button) => {
      const isSelected = button === selectedButton
      button.classList.toggle("is-selected", isSelected)
      button.setAttribute("aria-pressed", isSelected.toString())
    })
  }

  updateAmountSummary(value) {
    const amount = Number.parseInt(value, 10)

    this.amountSummaryTarget.textContent = Number.isFinite(amount) && amount > 0
      ? new Intl.NumberFormat("en-IN", {
          style: "currency",
          currency: "INR",
          maximumFractionDigits: 0
        }).format(amount)
      : "Choose an amount"
  }

  setAmount(value) {
    this.amountFieldTarget.value = value
    this.updateAmountSummary(value)
    this.updatePanRequirement(value)
  }

  updatePanRequirement(value) {
    const amount = Number.parseInt(value, 10) || 0
    const panRequired = amount >= this.panThresholdValue

    this.panInputTarget.required = panRequired
    this.panNoticeTarget.textContent = panRequired
      ? "PAN is mandatory for donations of ₹2,000 or more."
      : "PAN is optional for donations below ₹2,000."
  }

  recaptchaToken() {
    if (!this.siteKeyValue || !window.grecaptcha) return Promise.reject(new Error("reCAPTCHA unavailable"))

    return new Promise((resolve, reject) => {
      window.grecaptcha.ready(() => {
        window.grecaptcha.execute(this.siteKeyValue, { action: "donation" }).then(resolve).catch(reject)
      })
    })
  }

  appendRecaptchaToken(token) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = "recaptcha_token"
    input.value = token
    this.element.appendChild(input)
  }

  setSubmitting(isSubmitting) {
    if (!this.hasSubmitButtonTarget) return

    this.submitButtonTarget.disabled = isSubmitting
    this.submitButtonTarget.value = isSubmitting ? "Connecting securely…" : "Continue to secure payment"
  }

  showRecaptchaError() {
    if (this.hasRecaptchaErrorTarget) this.recaptchaErrorTarget.hidden = false
  }

  hideRecaptchaError() {
    if (this.hasRecaptchaErrorTarget) this.recaptchaErrorTarget.hidden = true
  }
}
