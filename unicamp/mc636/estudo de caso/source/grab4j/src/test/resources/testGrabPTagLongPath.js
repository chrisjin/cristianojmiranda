var ret = "";

var paragraphs = document
		.searchElements("html/body/table/tr/td/table/tr/td/center/div/span/div/span/div/span/p");
for ( var i = 0; i < paragraphs.length; i++) {
	var text = paragraphs[i].getInnerText();
	ret += "" + text;
}

result = ret;
