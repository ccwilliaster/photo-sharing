// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.

// This function toggles which css style applies to the header
toggleHeader = function() {
  var head = document.getElementById("header");
    
  if (head.className == "plaid-1") {
    head.className = "plaid-2";
    document.getElementById("toggle-div").className = "plaid-2";
    
  } else if (head.className == "plaid-2") {
    head.className = "plaid-3";
    document.getElementById("toggle-div").className = "plaid-3";

  } else {
    head.className = "plaid-1";
    document.getElementById("toggle-div").className = "plaid-1";
      
  }
  return false; // ensure link does nothing
}
