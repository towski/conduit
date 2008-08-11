var urlBarListener = {
  QueryInterface: function(aIID){
   if (aIID.equals(Components.interfaces.nsIWebProgressListener) ||
       aIID.equals(Components.interfaces.nsISupportsWeakReference) ||
       aIID.equals(Components.interfaces.nsISupports))
     return this;
   throw Components.results.NS_NOINTERFACE;
  },

  onLocationChange: function(aProgress, aRequest, aURI){
    mirror.sendCurrentPage(aURI);
  },

  onStateChange: function() {},
  onProgressChange: function() {},
  onStatusChange: function() {},
  onSecurityChange: function() {},
  onLinkIconAvailable: function() {}
};


var mirror = {
  oldURL: null,
  
  init: function() {
    this.initialized = true;
    this.strings = document.getElementById("mirror-strings");

    gBrowser.addProgressListener(urlBarListener,
        Components.interfaces.nsIWebProgress.NOTIFY_STATE_DOCUMENT);

	var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
	                   .getService(Components.interfaces.nsIWindowMediator);
	var newWindow = wm.getMostRecentWindow("navigator:browser");
	
    var promptService = Components.classes["@mozilla.org/embedcomp/prompt-service;1"]
                                  .getService(Components.interfaces.nsIPromptService);

	var getCurrentPage = function(){
		var httpRequest = new XMLHttpRequest()
		httpRequest.open('GET', 'http://72.232.60.54:801/mirrors/1', true)
		httpRequest.send("")
		httpRequest.onreadystatechange = function(){
			if(httpRequest.readyState == 4 && httpRequest.status == 200){				
				//alert(content.document.location.toString() + ":" + httpRequest.responseText)
				if(content.document.location.toString() != httpRequest.responseText){
					content.document.location = httpRequest.responseText
				}
			}
		}
	}
	setInterval(getCurrentPage, 2000);
  },

  sendCurrentPage: function(aURI) {  
	if (aURI.spec == this.oldURL)
      return;
    
    this.oldURL = aURI.spec;
	if(aURI.spec.match(/http.*/)){
		var httpRequest = new XMLHttpRequest()
		httpRequest.open('PUT', 'http://72.232.60.54:801/mirrors/1', true)
		httpRequest.send("<mirror><url>" + aURI.spec + "</url></mirror>")
		httpRequest.onreadystatechange = function(){
			if(httpRequest.readyState == 4 && httpRequest.status == 200){
				//alert("done");
			}
		}
	}
  },
};
window.addEventListener("load", function(e) { mirror.init(e); }, false);
