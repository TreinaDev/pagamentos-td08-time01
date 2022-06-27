// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as bootstrap from "bootstrap"

import './scripts'

document.addEventListener('DOMContentLoaded', function() {
  var divescription = document.getElementById("divescription");
  if(divescription) {
    document.getElementById("divescription").style.display = 'none';
  }
}, false);
