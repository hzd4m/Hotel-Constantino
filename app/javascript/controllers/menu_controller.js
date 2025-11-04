import { Controller } from "@hotwired/stimulus"

// Controller responsável por abrir/fechar o menu hambúrguer e o drawer mobile.
export default class extends Controller {
  static targets = ["hamburger", "backdrop", "drawer"]

  toggle(event) {
    event?.preventDefault()

    if (this.drawerTarget.classList.contains("is-open")) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.drawerTarget.classList.add("is-open")
    this.backdropTarget.classList.add("is-open")
    this.hamburgerTargets.forEach((button) => {
      button.classList.add("is-open")
      button.setAttribute("aria-expanded", "true")
    })
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.drawerTarget.classList.remove("is-open")
    this.backdropTarget.classList.remove("is-open")
    this.hamburgerTargets.forEach((button) => {
      button.classList.remove("is-open")
      button.setAttribute("aria-expanded", "false")
    })
    document.body.classList.remove("overflow-hidden")
  }

  // Fecha o menu ao apertar ESC
  connect() {
    this.escapeHandler = (event) => {
      if (event.key === "Escape") {
        this.close()
      }
    }
    document.addEventListener("keydown", this.escapeHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.escapeHandler)
  }
}
