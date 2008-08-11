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
  mirror: null,
  pid: null,
  tab: null,
  //sending: false,
  
  init: function() {
    this.initialized = true;
    this.strings = document.getElementById("mirror-strings");
	gBrowser.removeProgressListener(urlBarListener);
  },

  getCurrentPage: function(){
	//if(mirror.sending == true)
	  //return;
  	var httpRequest = new XMLHttpRequest()
  	httpRequest.open('GET', 'http://72.232.60.54:801/mirrors/'+mirror.mirror, true)
  	httpRequest.send("")
  	httpRequest.onreadystatechange = function(){
  		if(httpRequest.readyState == 4 && httpRequest.status == 200){				
  			if(gBrowser.getBrowserForTab(mirror.tab).contentDocument.location.toString() != httpRequest.responseText){
			    gBrowser.getBrowserForTab(mirror.tab).contentDocument.location = httpRequest.responseText
  			}
  		}
  	}
  },

  sendCurrentPage: function(aURI) {  
	if (aURI.spec == this.oldURL)
      return;
    this.oldURL = aURI.spec;
	if(gBrowser.selectedTab == this.tab && aURI.spec.match(/http.*/)){
		var httpRequest = new XMLHttpRequest()
		httpRequest.open('PUT', 'http://72.232.60.54:801/mirrors/'+this.mirror, true)
		httpRequest.send("<mirror><url>" + aURI.spec + "</url></mirror>")
		httpRequest.onreadystatechange = function(){
			if(httpRequest.readyState == 4 && httpRequest.status == 200){
			}
		}
	}
  },

  enable: function(){
	var prompts = Components.classes["@mozilla.org/embedcomp/prompt-service;1"].getService(Components.interfaces.nsIPromptService);
	var mirrorField = {value: "towski"};
	var check = {value: false};
	var result = prompts.prompt(window, "Title", "Enter the twitter name of the person you would like to follow", mirrorField, null, check);
	if(result){
		this.mirror = mirrorField.value.toString()
		gBrowser.addProgressListener(urlBarListener, Components.interfaces.nsIWebProgress.NOTIFY_STATE_DOCUMENT)
		this.pid = setInterval(this.getCurrentPage, 5000)
		var initialRequest = new XMLHttpRequest()
	  	initialRequest.open('GET', 'http://72.232.60.54:801/mirrors/'+this.mirror, true)
	  	initialRequest.send("")		
	  	initialRequest.onreadystatechange = function(){
	  		if(initialRequest.readyState == 4 && initialRequest.status == 200){
				mirror.tab = gBrowser.addTab(initialRequest.responseText);
				gBrowser.selectedTab = mirror.tab
			}
		}
	}
  },

  disable: function(){
	gBrowser.removeProgressListener(urlBarListener);
	clearInterval(this.pid)
  }
};
window.addEventListener("load", function(e) { mirror.init(e); }, false);
