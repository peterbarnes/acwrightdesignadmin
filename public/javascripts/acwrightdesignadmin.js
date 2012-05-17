/*
 * Javascript for admin.acwrightdesign.com
 */

var acwrightdesignadmin = {

  run : function(){
    
    // Initialize menus
    acwrightdesign.initNav();
    
  },

  initNav: function(section){
    if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)) || (navigator.userAgent.match(/iPad/i))) {
      $('header ul li > a').bind('click', function(event) {});
    }
  }
  
};