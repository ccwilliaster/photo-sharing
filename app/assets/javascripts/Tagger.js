// Tagger library cs142
// @author ccwilliams
// @date   2014-05 
//
// Implementation of a Tagger class used for creating (e.g., photo) tags by 
// modifying a specified div within a specified container. Instances expect 
// to modify the values of specified hidden form elements
//
// Also includes static method for displaying a tag within a specified 
// container.

function Tagger(tagContainerID, tagID, tagXID, tagYID, tagWidthID, tagHeightID) {
  var obj           = this;
  this.isTagMade    = false;
  this.isMouseDown  = false;
  this.tag          = document.getElementById(tagID);
  this.tagContainer = document.getElementById(tagContainerID);
  this.tagX         = document.getElementById(tagXID);
  this.tagY         = document.getElementById(tagYID);
  this.tagWidth     = document.getElementById(tagWidthID);
  this.tagHeight    = document.getElementById(tagHeightID);

  // Determine the limits for the tag coordinates
  var containerRect = this.tagContainer.getBoundingClientRect();
  this.minX         = containerRect.left;
  this.maxX         = containerRect.right;
  this.minY         = containerRect.top;
  this.maxY         = containerRect.bottom;

  // Create association between container and this Tagger instance
  this.tagContainer.onmousedown = function(event) {
    obj.mouseDown(event);
  }
}

// Function which initializes the tagger region and assigns event handlers
Tagger.prototype.mouseDown = function(event) {
  if (this.isTagMade) { // Can only make a tag once without reseting
    return;
  }
  
  // Save existing handlers for restoration later
  this.oldMoveHandler = document.body.onmousemove;
  this.oldUpHandler   = document.body.onmouseup;

  // Define new handlers associated with this object
  var obj = this;
  document.body.onmousemove = function(event) {
    obj.mouseMove(event);
  }
  document.body.onmouseup   = function(event) {
    obj.mouseUp(event);
  }
  
  // Store initial coordinates
  this.originX     = event.clientX - this.minX; // store relative coords
  this.originY     = event.clientY - this.minY;
  this.initialX    = this.originX;              // store initial coords seperately
  this.initialY    = this.originY;
  this.width       = 0;
  this.height      = 0;
  this.isMouseDown = true;
}

// During tag creation, constrains the user's mouse position
// within the tagContainer coordinates and updates the tag display
Tagger.prototype.mouseMove = function(event) {
  if (!this.isMouseDown) {
    return;
  }
  var currX = this.constrainCoord(event.clientX, this.minX, this.maxX);
  var currY = this.constrainCoord(event.clientY, this.minY, this.maxY);
  this.updateTag(currX, currY);
}

// Function which handles making a tag by assigning form values, and
// sets up the Tagger instance so mouse events have no effect without a reset
Tagger.prototype.mouseUp = function(event) {
  // Set form attributes
  this.makeTag();  
  
  // Restore old mouse handlers
  document.body.onmousemove = this.oldMoveHandler;
  document.body.onmouseup   = this.oldUpHandler;
  this.isTagMade   = true;
  this.isMouseDown = false;
}

// Helper function to update the origin, width, and height values
// of a Tagger instance's form
Tagger.prototype.makeTag = function() {
  this.tagX.value      = this.originX;
  this.tagY.value      = this.originY;
  this.tagWidth.value  = this.width;
  this.tagHeight.value = this.height;
}

// Helper function to constrain mouse coordinates within the parent frame
// and also make them relative to the parent frame
Tagger.prototype.constrainCoord = function(currCoord, min, max) {
  if (currCoord > min)  { 
    return currCoord < max ? (currCoord - min) : (max - min);
  } 
  return 0;
}

// Helper function to update the tag element
Tagger.prototype.updateTag = function(currX, currY) {
  // Update x-axis
  if (currX > this.initialX) {
    this.width   = currX - this.initialX;
  } else { 
    this.originX = currX;
    this.width   = this.initialX - this.originX;
  }

  // Update y-axis
  if (currY > this.initialY) {
    this.height = currY - this.initialY; 
  } else {
    this.originY = currY; 
    this.height  = this.initialY - this.originY;
  }
  
  this.tag.style.width  = this.width   + "px";
  this.tag.style.height = this.height  + "px"; 
  this.tag.style.left   = this.originX + "px";
  this.tag.style.top    = this.originY + "px";
}

Tagger.prototype.reset = function() {
  // Reset the tag for 
  this.tag.style.width  = "0px";
  this.tag.style.height = "0px";
  this.isTagMade = false;
}

// Simply makes a tag by creating a "tag" div with the provided dimensions,
// within the element with the passed ID
Tagger.showTag = function(parentID, originX, originY, width, height, text) {
  // create new tag div
  var newTag       = document.createElement("div");
  newTag.className = "tag";             // proper styles
  newTag.style.left   = originX + "px"; // proper size/location
  newTag.style.top    = originY + "px";
  newTag.style.width  = width   + "px";
  newTag.style.height = height  + "px";

  // add it to the parent element
  var parentElem = document.getElementById(parentID);
  parentElem.appendChild(newTag);  

  // create tag label
  var tagLabel     = document.createElement("div");
  tagLabel.className = "tag-label";
  tagLabel.appendChild( document.createTextNode(text) );

  // add as mouse-over text
  newTag.onmouseover = function(event) {
    newTag.appendChild( tagLabel );
  }
  newTag.onmouseout  = function(event) {
    newTag.innerHTML = "";
  }

}
