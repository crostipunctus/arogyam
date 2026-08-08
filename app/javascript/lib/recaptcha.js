const RECAPTCHA_TIMEOUT = 10_000

export function recaptchaToken(siteKey, actionName) {
  if (!siteKey || !actionName || !window.grecaptcha?.execute) {
    return Promise.reject(new Error("reCAPTCHA unavailable"))
  }

  const verification = new Promise((resolve, reject) => {
    window.grecaptcha.ready(() => {
      window.grecaptcha.execute(siteKey, { action: actionName }).then(resolve).catch(reject)
    })
  })

  return withTimeout(verification, RECAPTCHA_TIMEOUT)
}

function withTimeout(promise, timeout) {
  return new Promise((resolve, reject) => {
    const timer = window.setTimeout(() => reject(new Error("reCAPTCHA timed out")), timeout)

    promise.then((value) => {
      window.clearTimeout(timer)
      resolve(value)
    }).catch((error) => {
      window.clearTimeout(timer)
      reject(error)
    })
  })
}
