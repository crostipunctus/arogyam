import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["programme", "dateInput", "dateLabel", "fixedDetails", "fixedDate", "programmeDates"]

  connect() {
    this.update()
  }

  update() {
    const programme = this.programmeTarget.selectedOptions[0]
    const fixedDate = programme?.dataset.fixedStartDate
    const fixed = Boolean(fixedDate)
    const wasFixed = this.dateInputTarget.type === "hidden"

    this.dateInputTarget.type = fixed ? "hidden" : "date"
    if (fixed) {
      this.dateInputTarget.value = fixedDate
    } else if (wasFixed) {
      this.dateInputTarget.value = ""
    }

    this.dateLabelTarget.hidden = fixed
    this.fixedDetailsTarget.hidden = !fixed
    this.fixedDateTarget.textContent = programme?.dataset.fixedStartDateLabel || ""
    this.programmeDatesTarget.textContent = fixed ? programme.dataset.programmeDates || "" : ""
  }
}
