import { Elm } from "./src/Main.elm"
import initializePages from "elm-pages"


// 🍱

const isHeadless = navigator.userAgent.indexOf("Headless") >= 0



// Dynamic imports
// ===============

function loadLinkIfNeeded(href) {
  if (!document.querySelector(`link[href="${href}"]`)) {
    const n = document.createElement("link")
    n.href = href
    n.rel = "stylesheet"
    document.head.appendChild(n)
  }
}


loadLinkIfNeeded("application.css")
loadLinkIfNeeded("https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i|Work+Sans:500,600,700&display=swap")



// Elm
// ===

initializePages({
  mainElmModule: Elm.Main

}).then(app => {

  // Analytics
  // ---------

  if (!isHeadless) {

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

  }


  // Missive
  // -------

  let isShowingChat = false


  if (!isHeadless) {

    (function(d, w) {
      w.MissiveChatConfig = {
        id: "91a74dc2-1b64-4f99-890f-e90f86e40362",

        // Options
        chat: { hidden: true },
        visitor: { requireEmail: false },

        // Callbacks
        onReady() { isShowingChat && w.MissiveChat.open() },
        onOpen() { isShowingChat = true },
        onClose() { isShowingChat = false },
      }

      var s = d.createElement("script")
      s.async = true
      s.src = "https://webchat.missiveapp.com/" + w.MissiveChatConfig.id + "/missive.js"
      if (d.head) d.head.appendChild(s)
    })(document, window)

  }


  // Ports
  // -----

  app.ports.setFathomGoal.subscribe(({ id, value }) => {
    if (window.fathom) fathom("trackGoal", id, value)
  })


  app.ports.showChat.subscribe(_ => {
    isShowingChat = true
    if (window.MissiveChat) window.MissiveChat.open()
  })

})
