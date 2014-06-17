/* Contructor which wraps the logic for constructing and executing an AJAX 
 * request. Accepts a JSON object of parameters:
 *  url      URL for which request will be made, parameters can be supplied 
 *           in the execute method
 *  success  Function which will be called upon a successful request. Response 
 *           text will be passed to the execution.
 *  method   Method used in the request, GET or POST
 *  [error]  Optional function which will be called upon any 
 *           non-200 response status.
 *  [aynch]  Boolean, whether AJAX request is asyncrhonous (default: true)
 */
function AjaxRequest(args) {
  // Validate some paramaters
  this.checkParam(args["url"], [undefined], [], "Request URL must be specified");
  this.checkParam(args["success"], [undefined], [], "Warning: No success action!");
  this.checkParam(args["method"], [undefined], ["POST", "GET", "post", "get"], 
                  "Invalid method");
  
  this.url     = args["url"];
  this.method  = args["method"].toUpperCase();
  this.success = args["success"];
  this.error   = args["error"];
  this.async   = args["async"] == undefined ? true : args["async"];
}

// Makes request to this instance's URL and method, with the specified paramater 
// string
AjaxRequest.prototype.execute = function(paramString) {
  // Make request
  var fullURL = this.url;
  if (paramString != undefined) {
    fullURL = this.url + "?" + paramString;
  }   
  var xhr = new XMLHttpRequest();
  xhr.open(this.method, fullURL, this.async);
  xhr.send();

  // Assign response handler
  var error   = this.error;
  var success = this.success;
  xhr.onreadystatechange = function() {
    if (this.readyState != 4) { 
      return;
    }
    if (this.status != 200) { // error
      if (error != undefined) {
        error(this.responseText);
      } else {
        console.log("Error: " + this.responseText);
      }
    } else { // success
      success(this.responseText);    
    }
  }
}

// Helper which throws the specified error if the input paramater is not allowed
// unacceptable and acceptable should both be arrays of values
AjaxRequest.prototype.checkParam = function (input, unacceptable, acceptable, error) {
  for (val in unacceptable) {
    if (input == unacceptable[val]) {
      alert(error);
    }
  }
  for (val in acceptable) {
    if (input == acceptable[val]) {
     return;
    }
  }
  if (acceptable.length > 0) {
    alert(error);
  }
}
