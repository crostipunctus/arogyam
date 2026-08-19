import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner", "acceptButton"]
  static values = {
    storageKey: { type: String, default: "arogyam_cookie_consent_v1" }
  }

  connect() {
    if (!this.preference) this.showBanner()
  }

  accept() {
    this.savePreference("accepted")
    window.setArogyaMAnalyticsConsent?.(true)
    this.hideBanner()
  }

  reject() {
    this.savePreference("rejected")
    window.setArogyaMAnalyticsConsent?.(false)
    this.removeAnalyticsCookies()
    this.hideBanner()
  }

  open(event) {
    this.showBanner()
    if (event) this.acceptButtonTarget.focus()
  }

  showBanner() {
    this.bannerTarget.hidden = false
  }

  hideBanner() {
    this.bannerTarget.hidden = true
  }

  get preference() {
    try {
      return window.localStorage.getItem(this.storageKeyValue)
    } catch (_error) {
      return null
    }
  }

  savePreference(preference) {
    try {
      window.localStorage.setItem(this.storageKeyValue, preference)
    } catch (_error) {
      // Consent still applies to the current page when storage is unavailable.
    }
  }

  removeAnalyticsCookies() {
    const analyticsCookieNames = document.cookie
      .split(";")
      .map((cookie) => cookie.trim().split("=")[0])
      .filter((name) => name === "_ga" || name.startsWith("_ga_"))

    analyticsCookieNames.forEach((name) => {
      document.cookie = `${name}=; Max-Age=0; path=/; SameSite=Lax`
      document.cookie = `${name}=; Max-Age=0; path=/; domain=${window.location.hostname}; SameSite=Lax`
      document.cookie = `${name}=; Max-Age=0; path=/; domain=.${window.location.hostname}; SameSite=Lax`
    })
  }
}
