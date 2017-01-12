 $(document).ready(function() 
 {
    $('ul.language-selector li').click(function(e) 
    { 
    	var lang = $(this).find("span.lang-lbl").attr('lang');
    	console.log(lang);
    	setCookie("locale",lang,10);
    	location.reload();
    });
 });