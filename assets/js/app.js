// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"
// import "../node_modules/pretty-print-json/pretty-print-json.js";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"
import "../node_modules/daterangepicker/moment.min.js"
import "../node_modules/daterangepicker/daterangepicker.js"

import $ from 'jquery'
window.jQuery = $
window.$ = $

var library = {};

library.json = {
  replacer: function (match, pIndent, pKey, pVal, pEnd) {
    var key = '<span class=json-key>';
    var val = '<span class=json-value>';
    var str = '<span class=json-string>';
    var r = pIndent || '';
    if (pKey)
      r = r + key + pKey.replace(/[": ]/g, '') + '</span>: ';
    if (pVal)
      r = r + (pVal[0] == '"' ? str : val) + pVal + '</span>';
    return r + (pEnd || '');
  },
  prettyPrint: function (obj) {
    var jsonLine = /^( *)("[\w]+": )?("[^"]*"|[\w.+-]*)?([,[{])?$/mg;
    return JSON.stringify(obj, null, 3)
      .replace(/&/g, '&amp;').replace(/\\"/g, '&quot;')
      .replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(jsonLine, library.json.replacer);
  }
};


let beautify_json_payloads = () => {
  $(".json_payload").each(function () {
    try {
      let pretty_json = library.json.prettyPrint(JSON.parse($(this).html()));
      $(this).html($.parseHTML(pretty_json));
    } catch (e) {
      // Ignore error
    }
  });
};

// Create a hook such that whenever a new log comes in it will be formatted
let Hooks = {}
Hooks.JsonBeautify = {
  mounted() {
    beautify_json_payloads()
  },
  updated() {
    beautify_json_payloads()
  }
};


Hooks.updateDateTimeRange = {
  mounted() {
    $('.daterange').on('hide.daterangepicker', (ev, picker) => {
      this.pushEvent("search", { date_range: $('.daterange').val() })
    });
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// Attach a date range picker to the date range input
$(function () {
  $('.daterange').daterangepicker({
    "timePicker": true,
    "timePicker24Hour": true,
    "locale": {
      "format": 'YYYY-MM-DD hh:mm:00'
    }
  });
});
