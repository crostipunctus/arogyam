import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["programme", "vishraamFields", "shamanamFields"]

  connect() {
    this.update()
  }

  update() {
    const programmeName = this.programmeTarget.selectedOptions[0]?.text.trim()

    this.toggleFields(this.vishraamFieldsTarget, programmeName === "VishraM")
    this.toggleFields(this.shamanamFieldsTarget, programmeName === "ShamanaM")
  }

  toggleFields(container, visible) {
    container.hidden = !visible
    container.querySelectorAll("select").forEach((select) => {
      select.disabled = !visible
    })
  }
}
