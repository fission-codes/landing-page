import { Elm } from "./src/Main.elm"
import initializePages from "elm-pages"


// Stylesheets
// ===========

let n

n = document.createElement("link")
n.href = "application.css"
n.rel = "stylesheet"
document.head.appendChild(n)

n = document.createElement("link")
n.href = "https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i|Work+Sans:500,600,700&display=swap"
n.rel = "stylesheet"
document.head.appendChild(n)



// Elm
// ===

initializePages({
  mainElmModule: Elm.Main

}).then(app => {

  // Analytics
  // ---------

  try {

    (function(f, a, t, h, o, m) {
        a[h] = a[h] || function() {
          (a[h].q = a[h].q || []).push(arguments)
        };
      o = f.createElement("script"),
      m = document.head;
      o.async = 1; o.src = t; o.id = "fathom-script";
      m.appendChild(o)
    })(document, window, "https://cdn.usefathom.com/tracker.js", "fathom")
    fathom("set", "siteId", "asdvqpoi")
    fathom("set", "spa", "pushstate")
    fathom("trackPageview")

  } catch (_) {}


  // Ports
  // -----

  app.ports.setFathomGoal.subscribe(({ id, value }) => {
    if (window.fathom) fathom("trackGoal", id, value)
  })

})
