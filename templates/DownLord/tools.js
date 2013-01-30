function openPopup(url, width, height)
{
    window.open(url, '_blank', 'width='+width+',height='+height);
}

function toggleElementVisibility(el)
{
    if (el.style.display != 'block') {
        showElement(el);
    } else {
        hideElement(el);
    }
}

function hideElement(el)
{
	el.style.display = 'none';
}

function showElement(el)
{
	el.style.display = 'block';
}

function findPosX(obj)
{
	var curleft = 0;
	if (obj.offsetParent)
	{
		while (obj.offsetParent)
		{
			curleft += obj.offsetLeft
			obj = obj.offsetParent;
		}
	}
	else if (obj.x)
		curleft += obj.x;
	return curleft;
}

function findPosY(obj)
{
	var curtop = 0;
	if (obj.offsetParent)
	{
		while (obj.offsetParent)
		{
			curtop += obj.offsetTop
			obj = obj.offsetParent;
		}
	}
	else if (obj.y)
		curtop += obj.y;
	return curtop;
}




/** Magic Dropdowns **/

var magicdropdowns = new Array();
var magicdropdownButtonHandled = false;

function magicdropdownButtonClick(tag)
{
	magicdropdownButtonHandled = true;
	// TODO: hide other dropdowns

	// show requested dropdown
	el = magicdropdowns[tag];
	toggleElementVisibility(el);
}

function magicdropdownOptionClick(tag, optionValue, optionText)
{
	// change text
	var textEl = document.getElementById('magicdropdown-text-'+tag);
	textEl.innerHTML = optionText;
	textEl.style.color = '#000000';

	// TODO: change hidden form value to optionValue

	// hide dropdown
	hideElement(magicdropdowns[tag]);
}

function magicdropdownClickHandler(event)
{
	if (!magicdropdownButtonHandled) {
	// TODO: hide all dropdowns
	}

	magicdropdownButtonHandled = false;
}

function magicdropdownInit()
{
	document.onclick = magicdropdownClickHandler;
	magicdropdowns = new Array();
}

function magicdropdownRegister(tag)
{
	magicdropdowns[tag] = document.getElementById('magicdropdown-dropdown-'+tag);
}
