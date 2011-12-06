/*
  Plot the data for the specified index at the (x, y) coordinates
  for obj as a starplot.
  We have our starplot data arranged as an array in Javascript indexed by
  the points. Each entry is a simple array made up of 
      signal signal signal signal
  and the first numOrientations are for a give MAC address and the 
  next set is for a different base station and so on. And so we draw
  the first numAccessPoints in one color as a series of lines. We'll use
  a CSS name for the styling.

  We could draw our starplot axes just once and then move them around.
*/
function showStarPlot(obj, index)
{
    var x, y, x1, y1;

    var tmp = obj.getBBox();
    x = tmp.x + tmp.width/2;
    y = tmp.y + tmp.height/2;

    lineGroup = document.createElementNS(svgNS, "g");      
    obj.parentNode.appendChild(lineGroup);

    var i, j;

    for(j = 0; j < numOrientations; j++) {
	var line = document.createElementNS(svgNS, "line");        
	x + Math.cos()
	line.setAttribute('x1', pos_x[0]);
	line.setAttribute('y1', pos_y[0]);
	line.setAttribute('x2', pos_x[1]);
	line.setAttribute('y2', pos_y[1]);
    }

    for(i = 0; i < numAccessPoints ; i++) {
        for(j = 0; j < numOrientations; j++) {
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
}