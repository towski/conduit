var mirror = {
  onLoad: function() {
	alert("here")
    // initialization code
	alert("here")
    this.initialized = true;
    this.strings = document.getElementById("mirror-strings");

	var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
	                   .getService(Components.interfaces.nsIWindowMediator);
	var newWindow = wm.getMostRecentWindow("navigator:browser");
	
    var promptService = Components.classes["@mozilla.org/embedcomp/prompt-service;1"]
                                  .getService(Components.interfaces.nsIPromptService);
	var sendTargetPage = function(the_event){
		var target = the_event.target.toString()
		if(target.match(/http.*/)){
			var httpRequest = new XMLHttpRequest()
			httpRequest.open('PUT', 'http://72.232.60.54:801/mirrors/1', true)
			httpRequest.send("<mirror><url>" + target + "</url></mirror>")
			httpRequest.onreadystatechange = function(){
				if(httpRequest.readyState == 4 && httpRequest.status == 200){
					//alert("done");
				}
			}
		}
	}
	newWindow.addEventListener("click", sendTargetPage, false);
	var getCurrentPage = function(){
		var httpRequest = new XMLHttpRequest()
		httpRequest.open('GET', 'http://72.232.60.54:801/mirrors/1', true)
		httpRequest.send("")
		httpRequest.onreadystatechange = function(){
			if(httpRequest.readyState == 4 && httpRequest.status == 200){				
				if(content.document.location.toString() != httpRequest.responseText){
					content.document.location = httpRequest.responseText
				}
			}
		}
	}
	setInterval(getCurrentPage, 2000);
  },
  onMenuItemCommand: function(e) {
  },
};
window.addEventListener("load", function(e) { mirror.onLoad(e); }, false);
