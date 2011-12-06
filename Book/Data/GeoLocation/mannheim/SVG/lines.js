var svgNS = "http://www.w3.org/2000/svg";  /* Used when creating the <g> and <line> elements. */

var lineGroup;  /* The <g> object we create and destroy to hold our dynamically generated lines. */

function showLines(obj, index, accessPoints, signals)
{
    var x, y, x1, y1;

         /* Find the center of the object which we just moused over. */
    var tmp = obj.getBBox();
    x = tmp.x + tmp.width/2;
    y = tmp.y + tmp.height/2;

        /* Now create a new <g> node/element. We'll put the new line elements under this. 
           It makes it easy to discard them all in one go by removing the <g> node.
         */
    lineGroup = document.createElementNS(svgNS, "g");      
    obj.parentNode.appendChild(lineGroup);

        /* Now loop over the access points and draw the lines. This is for the first orientation only. */
    for(i = 0; i < accessPoints.length ; i++) {
	var line = document.createElementNS(svgNS, "line");                     
        var pos_x;
        var pos_y;

	x1 = accessPoints[i][0];
	y1 = accessPoints[i][1];

        alpha = signals[i][index] 
        pos_x = scale(x, x1, alpha, -99, -25);
        pos_y = scale(y, y1, alpha, -99, -25);

	var line = document.createElementNS(svgNS, "line");      
	line.setAttribute('x1', pos_x[0]);
	line.setAttribute('y1', pos_y[0]);
	line.setAttribute('x2', pos_x[1]);
	line.setAttribute('y2', pos_y[1]);

	line.setAttribute('style', "fill: red; stroke: red;");

	line.setAttribute('class', "neighborLine");
	lineGroup.appendChild(line);
    }
}

function scale(a, b, val, min, max)
{
    var p = (val - min)/(max - min);
    return([a, a + p * (b - a)]);
}

function hideLines()
{
    if(typeof lineGroup != "undefined") {
	lineGroup.parentNode.removeChild(lineGroup);
	lineGroup = document.createElementNS(svgNS, "g");      
    }
}



