// Taken from the fann documentation - Fast Artificial Neural Network.
//
//  Tooltips
// ____________________________________________________________________________

    browserType = "Netscape";

var browserType = "Netscape";
var browserVer;
var tooltipTimer = 0;

function ShowTip(event, tooltipID, linkID)
    {
    if (tooltipTimer)
        {  clearTimeout(tooltipTimer);  };

    var docX = event.clientX + window.pageXOffset;
    var docY = event.clientY + window.pageYOffset;

    var showCommand = "ReallyShowTip('" + tooltipID + "', '" + linkID + "', " + docX + ", " + docY + ")";

    // KHTML cant handle showing on a timer right now.

    if (browserType != "KHTML")
        {  tooltipTimer = setTimeout(showCommand, 1000);  }
    else
        {  eval(showCommand);  };
    }

function ReallyShowTip(tooltipID, linkID, docX, docY)
    {
    tooltipTimer = 0;

    var tooltip;
    var link;

    if (document.getElementById)
        {
        tooltip = document.getElementById(tooltipID);
        link = document.getElementById(linkID);
        }
    else if (document.all)
        {
        tooltip = eval("document.all['" + tooltipID + "']");
        link = eval("document.all['" + linkID + "']");
        }


    if (tooltip)
        {
        var left = 0;
        var top = 0;

        // Not everything supports offsetTop/Left/Width, and some, like Konqueror and Opera 5, think they do but do it badly.

        if (link && link.offsetWidth != null && browserType != "KHTML" && browserVer != "Opera5")
            {
            var item = link;
            while (item != document.body)
                {
                left += item.offsetLeft;
                item = item.offsetParent;
                }

            item = link;
            while (item != document.body)
                {
                top += item.offsetTop;
                item = item.offsetParent;
                }
            top += link.offsetHeight;
            }

        // The fallback method is to use the mouse X and Y relative to the document.  We use a separate if and test if its a number
        // in case some browser snuck through the above if statement but didn't support everything.

        if (!isFinite(top) || top == 0)
            {
            left = docX;
            top = docY;
            }

        // Some spacing to get it out from under the cursor.

        top += 10;

        // Make sure the tooltip doesnt get smushed by being too close to the edge, or in some browsers, go off the edge of the
        // page.  We do it here because Konqueror does get offsetWidth right even if it doesnt get the positioning right.

        if (tooltip.offsetWidth != null)
            {
            var width = tooltip.offsetWidth;
            var docWidth = document.body.clientWidth;

            if (left + width > docWidth)
                {  left = docWidth - width - 1;  }
            }

        // Opera 5 chokes on the px extension, so it can use the Microsoft one instead.

        if (tooltip.style.left != null && browserVer != "Opera5")
            {
            tooltip.style.left = left + "px";
            tooltip.style.top = top + "px";
            }
        else if (tooltip.style.pixelLeft != null)
            {
            tooltip.style.pixelLeft = left;
            tooltip.style.pixelTop = top;
            }

        tooltip.style.visibility = "visible";
        }
    }

function HideTip(tooltipID)
    {
    if (tooltipTimer)
        {
        clearTimeout(tooltipTimer);
        tooltipTimer = 0;
        }

    var tooltip;

    if (document.getElementById)
        {  tooltip = document.getElementById(tooltipID); }
    else if (document.all)
        {  tooltip = eval("document.all['" + tooltipID + "']");  }

    if (tooltip)
        {  tooltip.style.visibility = "hidden";  }
    }
