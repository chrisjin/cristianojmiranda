var ret = "";

/* Obtem o elemeneto zero */
element0 = document.getElement(0);
ret += (element0 == null ? "false:Elemento index zero nao deveria ser nullo."
		: "true: ")

/* Get element by id */
elementbannerRight = document.getElementById('bannerRight');
ret += ","
		+ (elementbannerRight.getElements().length > 0 ? "true: "
				: "false:Elemento bannerRight deveria ter pelo menos um filho.")

/* Obtem a quantidade de elementos */
elementCount = document.getElementCount();

/* Get all elements */
elements = document.getElements();

/* Get elements by attributs */
externalLinks = document.getElementsByAttribute('class', 'externalLink');

/* Obtem elementos por tag */
listElements = document.getElementsByTag('li');

/* Obtem o primeito link */
firstLink = document.searchElement('html/body/div/a');

/* Conta quantidade de paragrafos */
var paragraphs = document.searchElements('html/body/p');

result = ret;
