var altTabWidgets = {};

function setAltApproach(name)
{
    for(i in altTabWidgets) {
	var tabV = altTabWidgets[i];
	setTabToAlt(tabV, name);
    }
}

function addAltApproachTab(name, id)
{
    var a = altTabWidgets[name];
    if(!a) {
	altTabWidgets[name] = a = new Array();
    }
    a.push(id);
}

function setTabToAlt(tab, to)
{

    var tabs = tab.get("tabs");
    var len = tabs.length;
    var stmp = "";
    to = "#tab_" + to;

    for(i = 0; i < len ; i++) {
	var tmp = tabs[i];
	var label = tmp.get('label');
	label = tmp.get('href');
	if(label == to) {
	    tab.set('activeIndex', i);
	    return(true);
	}
	stmp += " " + tmp + " " + label;
    }

//    alert("couldn't find tab for " + to + ", possible: " + stmp);
}

function showAltTabs()
{
    var txt = "<showAltTabs> " + altTabWidgets + "\n";
    for(var i in altTabWidgets) {
        txt +=  i + " ";
    }
    alert(txt);
}
