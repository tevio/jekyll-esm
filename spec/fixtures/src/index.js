const logMessage = "ES6, Stimulus & Turbolinks with Jekyll Esm";

import * as Turbo from "@hotwired/turbo"
Turbo.start();

import { Application, Controller } from "https://cdn.skypack.dev/stimulus"

const application = Application.start()
application.register("hello", class extends Controller {
  greet() {
    console.log(`Hello, ${this.name}!`)
  }

  get name() {
    return this.targets.find("name").value
  }
})

document.addEventListener('turbo:load', function() {
  console.log('!!turbo!!')
});

document.addEventListener( 'turbo:before-visit', function(e) {
  console.log('!!turbo before-visit!!')
});
