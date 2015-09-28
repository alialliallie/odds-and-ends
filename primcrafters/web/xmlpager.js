var xsltProc;
var xmlDoc;
var xmlDOM;
var xmlHttpReq;

var current_offset = 0;
var current_count = 10;

function getMore()
{
	xmlHttpReq.open("GET","xml/bydate.php?limit=" + current_count + "&offset=" + current_offset,false);
	xmlHttpReq.send(null);

	xmlDoc = xmlHttpReq.responseXML;

	var tmpXml = document.implementation.createDocument("","span",null);
	var someHtml = document.getElementById("last_5_sales");

	var fragment = xsltProc.transformToFragment(xmlDoc, document);

	while(someHtml.hasChildNodes())
	{
		someHtml.removeChild(someHtml.firstChild);
	}
	someHtml.appendChild(fragment);
}

function init()
{
	xsltProc = new XSLTProcessor();

	xmlHttpReq = new XMLHttpRequest();
	xmlHttpReq.open("GET", "bydate2.xsl", false);
	xmlHttpReq.send(null);

	var xslRef = xmlHttpReq.responseXML;

	try
	{
		xsltProc.importStylesheet(xslRef);
	}
	catch (e)
	{
		alert(e);
	}

	getMore();

	if (current_offset == 0)
	{
		document.getElementById("control_previous").style.display = 'none';
	}
}

function control_next()
{
	current_offset += current_count;
	getMore();
	if (current_offset > 0)
	{
		document.getElementById("control_previous").style.display = 'inline';
	}
	var diff = TOTAL_SALES - current_offset;
	if (diff < current_count)
	{
		document.getElementById("control_next").style.display = 'none';
	}
}

function control_previous()
{
	current_offset -= current_count;
	getMore();
	if (current_offset == 0)
	{
		document.getElementById("control_previous").style.display = 'none';
	}
	var diff = TOTAL_SALES - current_offset;
	if (diff > current_count)
	{
		document.getElementById("control_next").style.display = 'inline';
	}
}

function control_first()
{
	current_offset = 0;
	getMore();
	document.getElementById("control_previous").style.display = 'none';
	document.getElementById("control_next").style.display = 'inline';
}

function control_last()
{
	var diff = TOTAL_SALES % current_count;
	current_offset = TOTAL_SALES - diff;
	getMore();
	document.getElementById("control_previous").style.display = 'inline';
	document.getElementById("control_next").style.display = 'none';
}

window.onload = init;
