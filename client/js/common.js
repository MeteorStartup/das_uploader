//$(function(){
//	$(".nano").nanoScroller({ alwaysVisible: true });
//	$(".sub_con .side_menu").width(70);
//	$(".sub_con .side_menu .menu_list > li").wrapInner("<div class='sub_box'></div>").css("opacity","0.9");
//	$(".sub_con .side_menu .menu_list .sub_box").append("<span class='bul'></span>");
//
//	$(".sub_con .side_menu .menu_list > li").mouseenter(function(){
//		$(".side_menu .menu_list").width(260);
//		$(".side_menu .menu_list > li").removeClass("on");
//		$(this).addClass("on");
//	});
//	$(".sub_con .side_menu").mouseleave(function(){
//		$(".side_menu .menu_list").width(70);
//		$(".side_menu .menu_list > li").removeClass("on");
//	})
//
//	if($("body").outerHeight() >= $(window).outerHeight() ){
//		$("#footer").removeClass("over");
//	}else{
//		$("#footer").addClass("");
//	};
//	$(window).resize(function(){
//		if($("body").outerHeight() >= $(window).outerHeight() ){
//			$("#footer").removeClass("over");
//			console.log("over")
//		}else{
//			$("#footer").addClass("over");
//			console.log("not")
//		};
//	});
//});
