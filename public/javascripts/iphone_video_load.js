jQuery.noConflict();
j$ = jQuery;

var throbber;
function throbber_init() {
  throbber = new ThrobberA({size: 64});
  throbber.show(document.getElementById("throbber"));
}

function add_video_tag(id, path) {
  var video = j$("<video>").attr("id", "video-" + id).attr("width", 480).attr("height", 320).attr("controls", "controls").attr("src", path);
  j$("#video").append(video);
}

function check_m3u8(id, path, count) {
  count = count + 1;
  if (count > 10) {
    alert("Video Loading Failed");
    return false;
  }
  j$.ajax({
    type: "HEAD",
    url: path,
    success: function(){
      add_video_tag(id, path);
      throbber.hide();
    },
    error: function(){
      setTimeout(function(){check_m3u8(id, path, count)}, 3000);
    }
  })
}

j$(document).ready(function() {
  throbber_init();
  check_m3u8(<%= @pasokara.id %>, "<%= @movie_path %>", 0);
});
