import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["causeButton", "causeName", "amountButton", "amountInput", "amountSummary"]

  selectCause(event) {
    this.causeButtonTargets.forEach((button) => {
      const isSelected = button === event.currentTarget
      button.classList.toggle("is-selected", isSelected)
      button.setAttribute("aria-pressed", isSelected.toString())
    })

    this.causeNameTarget.textContent = event.currentTarget.dataset.donationCauseName
  }

  selectAmount(event) {
    this.amountInputTarget.value = ""
    this.markSelectedAmount(event.currentTarget)
    this.updateAmountSummary(event.currentTarget.dataset.donationAmountValue)
  }

  enterCustomAmount() {
    this.markSelectedAmount(null)
    this.updateAmountSummary(this.amountInputTarget.value)
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
}
