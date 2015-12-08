// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
  // about supported directives.
  //
  //= require jquery
  //= require jquery_ujs
  //= require turbolinks
  //= require bootstrap
  //= require_tree .
  //= require jquery.turbolinks
  
  // Returns preview image before upload
  
  $(function() {
    $("#upload-img").on("change", function()
    {
      var files = !!this.files ? this.files : [];
      if (!files.length || !window.FileReader) return; // no file selected, or no FileReader support

      if (/^image/.test( files[0].type)){ // only image file
        var reader = new FileReader(); // instance of the FileReader
        reader.readAsDataURL(files[0]); // read the local file

        reader.onloadend = function(e){ // set image data as background of div
    
          $("#img-preview-block").css({'background-image': 'url('+e.target.result +')', "background-size": "cover"});
        }
      }
    });
  });

  
  // Footer
  
  $(function() {
    // Read the size of the window and reposition the footer at the bottom.
    var stickyFooter = function(){
      var pageHeight = $('html').height();
      var windowHeight = $(window).height();
      var footerHeight = $('footer').outerHeight();

      // A footer with 'fixed-bottom' has the CSS attribute "position: absolute",
      // and thus is outside of its container and counted in $('html').height().
      var totalHeight = $('footer').hasClass('fixed-bottom') ?
      pageHeight + footerHeight : pageHeight;
      
      $('body').css( { "margin-bottom" : footerHeight } );
      
      // If the window is larger than the content, fix the footer at the bottom.
      if (windowHeight >= totalHeight) {
        return $('footer').addClass('fixed-bottom');
      } else {
        // If the page content is larger than the window, the footer must move.
        return $('footer').removeClass('fixed-bottom');
      }
    };

    // Call when document is ready.
    $(document).ready(function () {
      stickyFooter();
    });
    
    // Call again when the window is resized.
    $(window).resize(function() {
      stickyFooter();
    });
  });