function toggle(id) {
  var item = document.getElementById(id);
  if (item) {
    item.className = (item.className == 'hidden') ? 'unhidden' : 'hidden';
  } else
      alert("couldn't find an element with id " + id);
}

/* User of this code is expected to have a variable named ids in which 
   the unique ids are contained. */
function toggleAll(ids) {
    for(i in ids) {
	toggle(ids[i]);
    }
}

function setAll(to, doc, ids) {
    for(i =0 ; i < ids.length; i++) {
	var id = ids[i];
	var item = doc.getElementById(id);
	if (item) {
	    item.className = (to == 'hidden') ? 'hidden' : 'unhidden';
	}
    }
}
