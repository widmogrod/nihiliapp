(function() {
	var mainscript = document.createElement("script");
	    mainscript.setAttribute("src", "Bespin/BespinEmbedded.uncompressed.js");
		mainscript.setAttribute("onload", "alert(bespin);");

	// var mainscript2 = document.createElement("script");
	// 	mainscript2.setAttribute("src", "Bespin/BespinMain.uncompressed.js"); 
	// Podstawowe położenie Bespin'a, wymagane by załączyć dodatkowe pliki
	var base = document.createElement('link');
		base.id = "bespin_base";
		base.href = "Bespin/";

	// var testScript = document.createElement("script");
	// 	    testScript.setAttribute("src", "Bespin/test.js");  

    var head = document.getElementsByTagName("head")[0];     
		head.appendChild(base);
	    head.appendChild(mainscript);
})();