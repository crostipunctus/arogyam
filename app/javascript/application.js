// Entry point for the build script in your package.json

//= require swiper
//= require jquery
//= require fancybox

import { Application } from "@hotwired/stimulus"
import NotificationController from "./controllers/notification_controller"


window.Stimulus = Application.start()

Stimulus.register("notification", NotificationController)
Stimulus.register("status", StatusController)
Stimulus.register("profile-checker", ProfileCheckerController)

import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "trix"
import "@rails/actiontext"
import './show_footer_on_scroll'
import './collection_select'
import './swiper'
import './date_picker'
import "./theme"
import "./booking_dates"
import "./duration"



import "trix"
import "@rails/actiontext"


import "./fancybox"

