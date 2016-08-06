document.addEventListener('DOMContentLoaded',function() {
  var searchInput = document.getElementsByClassName('search-post');
  var tags = document.getElementsByClassName('tags-panel');
  var close = document.getElementById('close');
  var token = 0;

  close.addEventListener('click', function(){
    tags[0].className = 'tags-panel';
    token = 0;
  }, false);

  for(var i = 0; i < searchInput.length; i++) {
    searchInput[i].addEventListener('focus', function(){
      if (token == 0) {
        tags[0].className += ' showed';
        token = 1;
      }
    }, false);
  }
}, false);
