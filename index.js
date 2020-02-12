const { Elm } = require("./src/Main.elm")
const initializePages = require("elm-pages")
const isIpns = location.pathname.startsWith("/ipns/")


!isIpns && initializePages({
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
    })(document, window, "//cdn.usefathom.com/tracker.js", "fathom")
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
