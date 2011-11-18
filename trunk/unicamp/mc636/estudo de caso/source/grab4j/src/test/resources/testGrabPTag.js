var ret = "";

var paragraphs = document.searchElements("html/body/p");
for ( var i = 0; i < paragraphs.length; i++) {
	var text = paragraphs[i].getInnerText();
	ret += "" + text;
}

result = ret;
