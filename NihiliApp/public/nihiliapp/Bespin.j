@import <AppKit/CPView.j>

// (function(){
// 	var elem=document.createElement('script');
// 	elem.setAttribute('src','https://bespin.mozillalabs.com/bookmarklet/bookmarklet.js');
// 	document.body.appendChild(elem);
// })();

	// mainscript = document.createElement("script");
	// mainscript.setAttribute("src", "test.js");
	// document.getElementsByTagName("head")[0].appendChild(mainscript);

@implementation Bespin : CPView
{
	id _timeout;
}

- (id)init
{
	if(self = [super init])
	{          
		// console.log(typeof(window) === "undefined",'typeof(window) === "undefined"');
		/*
			TODO: Uzależnić element od include path
		*/ 


		// var edit = document.createElement('div');      
		// 	edit.setAttribute('class','bespin');
		// 	edit.setAttribute('style','width:500px; height:200px;');
		// 
	
		// _DOMElement.appendChild(edit);
        // window.bespin.useBespin(_DOMElement);
 		//window.bespin.useBespin(edit);
// window.setTimeout(function() {
	
	
	// var mainscript = document.createElement("script");
	//     mainscript.setAttribute("src", "BespinEmbedded.uncompressed.js");
	
// 	
// 	// var mainscript2 = document.createElement("script");
// 	// 	mainscript2.setAttribute("src", "Bespin/BespinMain.uncompressed.js"); 
// 	// Podstawowe położenie Bespin'a, wymagane by załączyć dodatkowe pliki
// 	var base = document.createElement('link');
// 		base.id = "bespin_base";
// 		base.href = "Bespin/";
// 		
// 	// var testScript = document.createElement("script");
// 	// 	    testScript.setAttribute("src", "Bespin/test.js");  
// 	
//     var head = document.getElementsByTagName("head")[0];     
// 		head.appendChild(base);
// 	    head.appendChild(mainscript); 
// 		// head.appendChild(mainscript2); 
// 		// head.appendChild(testScript);        	
// 
// 	
// 	// 				
// 	// 	// Styl Bespin
// 	// 	var style = document.createElement('link');
// 	// 		style.rel = "stylesheet";
// 	// 		style.href = "Bespin/BespinEmbedded.css";
// 	// 		style.type = "text/css";
// 	// 		style.media = "screen"; 
// 
// 	// var bespinEmbedded = document.createElement("script");
// 	// 	// bespinEmbedded.setAttribute("type", "text/javascript");
// 	// 	bespinEmbedded.setAttribute("src", 'Bespin/BespinEmbedded.uncompressed.js');
// 			                                                           
// 	// var bespinMain = document.createElement('script');
// 	// 	bespinMain.type = 'text/javascript';
// 	// 	bespinMain.src = "Bespin/BespinMain.js"
// 			
// 	// Wczytanie wszystkich styli
// 	// var head = document.getElementsByTagName('head')[0];
// 		// head.appendChild(base);
// 		// head.appendChild(style);
// 		// head.appendChild(bespinEmbedded);
// 		// head.appendChild(bespinWorker);
// 		// head.appendChild(bespinMain);
// }, 3000);
		                                        
		
		// var request = [CPURLRequest requestWithURL:@"Bespin/BespinEmbedded.js"];
		// 		[CPURLConnection connectionWithRequest:request delegate:self];	    	
		
		//[self setTheme:[CPTheme themeNamed:@"bespin"]]
        // _DOMElement.class = "bespin"; 
		// _DOMElement.setAttribute('class','bespin');
		// _DOMElement.setAttribute('id','edit');
// console.log(_DOMElement);
		// DOMElementPrototype.class = "bespin"; 
		// [self setNeedsDisplay:NO];
		
	    // document.onBespinLoad = function() {
	    //   			alert('bespin load');
	    //   		};
	}
	return self;
}                            

-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
	// console.log('didFailWithError', error);	
}

-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
	// console.log('didReceiveResponse', response);
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	// console.log('conneciton', data);
	eval(data);
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
	// console.log('connectionDidFinishLoading');
}

// - (void)drawRect:(CPRect)aRect
// // - (void)viewWillDraw
// {   
// 	console.log('drawRet');
// 	// var // edit = document.getElementById("edit");
// 	//     // Get the environmentvariable.
// 	//     var env = edit.bespin; 
// 	// console.log(env);
// 
// 	//console.log(this);
// 	if (window.bespin == undefined) {
// 		if (!_timeout) {
// 			_timeout = window.setTimeout(function() { [self setNeedsDisplay:YES]; }, 200);
// 		}
// 		
// 		return;
// 	} 
// 	
// 	if (window.bespin.useBespin == undefined) {
// 		window.bespin.useBespin = function(element, options) {
// 		    var util = window.bespin.tiki.require('bespin:util/util');
// 
// 		    var baseConfig = {};
// 		    var baseSettings = baseConfig.settings;
// 		    options = options || {};
// 		    for (var key in options) {
// 		        baseConfig[key] = options[key];
// 		    }
// 
// 		    // we need to separately merge the configured settings
// 		    var configSettings = baseConfig.settings;
// 		    if (baseSettings !== undefined) {
// 		        for (key in baseSettings) {
// 		            if (configSettings[key] === undefined) {
// 		                baseConfig.settings[key] = baseSettings[key];
// 		            }
// 		        }
// 		    }
// 
// 		    var Promise = window.bespin.tiki.require('bespin:promise').Promise;
// 		    var prEnv = null;
// 		    var pr = new Promise();
// 
// 		    window.bespin.tiki.require.ensurePackage("::appconfig", function() {
// 		        var appconfig = bespin.tiki.require("appconfig");
// 		        if (util.isString(element)) {
// 		            element = document.getElementById(element);
// 		        }
// 
// 		        if (util.none(baseConfig.initialContent)) {
// 		            baseConfig.initialContent = element.value || element.innerHTML;
// 		        }
// 
// 		        element.innerHTML = '';
// 		        
// 	            baseConfig.element = element;
// 
// 		        appconfig.launch(baseConfig).then(function(env) {
// 		            prEnv = env;
// 		            pr.resolve(env);
// 		        });
// 		    });
// 
// 		    return pr;
// 		};
// 	}
// 
// 	console.log("1",_DOMElement);        
// 	window.bespin.useBespin(_DOMElement);
// }   

@end