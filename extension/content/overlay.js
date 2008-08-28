var railsServer = 'http://72.232.60.54'
//var railsServer = 'http://localhost:3000'
var urlBarListener = {
  QueryInterface: function(aIID){
   if (aIID.equals(Components.interfaces.nsIWebProgressListener) ||
       aIID.equals(Components.interfaces.nsISupportsWeakReference) ||
       aIID.equals(Components.interfaces.nsISupports))
     return this
   throw Components.results.NS_NOINTERFACE
  },

  onLocationChange: function(aProgress, aRequest, aURI){
	conduit.sending = true
    conduit.sendCurrentPage(aURI)
  },

  onStateChange: function() {},
  onProgressChange: function() {},
  onStatusChange: function() {},
  onSecurityChange: function() {},
  onLinkIconAvailable: function() {}
}

var conduit = {
  oldURL: null,
  key: null,
  pid: null,
  tab: null,
  sending: false,
  
  init: function() {
    this.initialized = true
    this.strings = document.getElementById("mirror-strings")
	gBrowser.removeProgressListener(urlBarListener)
  },

  getCurrentPage: function(){
	if(conduit.sending == true){
	  return
	}
  	var httpRequest = new XMLHttpRequest()
  	httpRequest.open('GET', railsServer + '/conduits/'+conduit.key+'.json', true)
  	httpRequest.send("")
  	httpRequest.onreadystatechange = function(){
  		if(httpRequest.readyState == 4 && httpRequest.status == 200){
			if(conduit.sending == false){				
	  			if(gBrowser.getBrowserForTab(conduit.tab).contentDocument.location.toString() != httpRequest.responseText){
				    gBrowser.getBrowserForTab(conduit.tab).contentDocument.location = httpRequest.responseText
	  			}
			}
  		}
  	}
  },

  sendCurrentPage: function(aURI) {  
	if (aURI.spec == this.oldURL){
	  this.sending = false
      return
	}
    this.oldURL = aURI.spec
	if(gBrowser.selectedTab == this.tab && aURI.spec.match(/http.*/)){
		var httpRequest = new XMLHttpRequest()
		httpRequest.open('PUT', railsServer + '/conduits/'+this.key, true)
		httpRequest.send("<conduit><url>" + aURI.spec + "</url></conduit>")
		httpRequest.onreadystatechange = function(){
			if(httpRequest.readyState == 4 && httpRequest.status == 200){
				conduit.sending = false
			}
		}
	}
  },

  enable: function(key){
	if(this.key){
		alert("Sorry, only one conduit at a time (for the time being)")
		return
	}
		this.key = key
		gBrowser.addProgressListener(urlBarListener, Components.interfaces.nsIWebProgress.NOTIFY_STATE_DOCUMENT)
		this.pid = setInterval(this.getCurrentPage, 2000)
		var initialRequest = new XMLHttpRequest()
	  	initialRequest.open('GET', railsServer + '/conduits/'+this.key+'.json', true)
	  	initialRequest.send("")		
	  	initialRequest.onreadystatechange = function(){
	  		if(initialRequest.readyState == 4 && initialRequest.status == 200){
				conduit.tab = gBrowser.addTab(initialRequest.responseText)
				gBrowser.selectedTab = conduit.tab
				conduit.tab.addEventListener("TabClose", function(){ conduit.disable() }, false)
			}
		}
  },

  disable: function(){
	this.key = null
	gBrowser.removeProgressListener(urlBarListener)
	clearInterval(this.pid)
  }
}
window.addEventListener("load", function(e) { conduit.init(e) }, false)
document.addEventListener("activateConduit", function(e) { conduit.enable(e.target.getAttribute("conduit")) }, false, true)
document.addEventListener("showConduits", function(e) { e.target.setAttribute("style", 'display: block;') }, false, true)
