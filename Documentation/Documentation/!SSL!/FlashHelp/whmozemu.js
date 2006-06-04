//	WebHelp 5.10.001
if (! window.gbIE4 && window.gbNav6 && !document.childNodes[0].insertAdjacentHTML){

HTMLElement.prototype.insertAdjacentElement = function(where,parsedNode)
{
	switch (where){
	case 'beforeBegin':
		this.parentNode.insertBefore(parsedNode,this)
		break;
	case 'afterBegin':
		this.insertBefore(parsedNode,this.firstChild);
		break;
	case 'beforeEnd':
		this.appendChild(parsedNode);
		break;
	case 'afterEnd':
		if (this.nextSibling){
		this.parentNode.insertBefore
(parsedNode,this.nextSibling);
		} else {
		this.parentNode.appendChild(parsedNode)
		}
		break;
	}
}

HTMLElement.prototype.insertAdjacentHTML = function(where,htmlStr){

	var r = this.ownerDocument.createRange();
	r.setStartBefore(this);
	var parsedHTML = r.createContextualFragment(htmlStr);
	this.insertAdjacentElement(where,parsedHTML)
}


HTMLElement.prototype.insertAdjacentText = function(where,txtStr){

	var parsedText = document.createTextNode(txtStr)
	this.insertAdjacentElement(where,parsedText)
}
}

function testScroll() {
	// Initialize scrollbar cache if necessary
	if (window._pageXOffset==null) {
		window._pageXOffset = window.pageXOffset
		window._pageYOffset = window.pageYOffset
	}
	// Expose Internet Explorer compatible object model
	document.body.scrollTop = window.pageYOffset
	document.body.scrollLeft = window.pageXOffset
	window.document.body.scrollHeight = document.height
	window.document.body.scrollWidth = document.width
	window.document.body.clientWidth = window.innerWidth;
	window.document.body.clientHeight = window.innerHeight;

	// If cache!=current values, call the onscroll event
	if (((window.pageXOffset!=window._pageXOffset) || 
			(window.pageYOffset!=window._pageYOffset)) && (window.onscroll)) 
		window.onscroll()
	// Cache new values
	window._pageXOffset = window.pageXOffset
	window._pageYOffset = window.pageYOffset
	}

// Create compatibility layer for Netscape
if (window.gbNav6) {
	setInterval("testScroll()",50)
}