<script type="text/javascript">

/*********************
//* jQuery Multi Level CSS Menu #2- By Dynamic Drive: http://www.dynamicdrive.com/
//* Last update: Nov 7th, 08': Limit # of queued animations to minmize animation stuttering
//* Menu avaiable at DD CSS Library: http://www.dynamicdrive.com/style/
*********************/

//Update: April 12th, 10: Fixed compat issue with jquery 1.4x

//Specify full URL to down and right arrow images (23 is padding-right to add to top level LIs with drop downs):
var arrowimages={down:['downarrowclass', '${root}${HTML_IMG_DIR}/down.png', 23], right:['rightarrowclass', '${root}${HTML_IMG_DIR}/right.png']};
var navName = '';

var jqueryslidemenu={

	animateduration: {over: 200, out: 100}, //duration of slide in/ out animation, in milliseconds
	
	buildmenu:function(menuid, arrowsvar){
		jQuery(document).ready(function(){
			$('#'+menuid+' a').click(function(){
				navName = $(this).attr('alt');
				$('.subUl').hide();
		//		if (menuid == 'slidemenu02' || menuid == 'slidemenu03') {
		//			setMyPageTeamTopMenu();
	//			} else {
					iniTopMenu();
		//		}
			});
			
			function iniTopMenu(){
				$('.topmenu').each(function(){
					if($(this).attr('alt') == navName) {
						$(this).addClass('topMenuBG');
					//	$(this).css('color', '#0c388b');
					///	$(this).attr("style","border:0px");
					} else {
						$(this).removeClass('topMenuBG');
						//$(this).css('color', '#0c388b');
					//	$(this).attr("style","border:0px");
					}
				});
			}
			
			// [My page][Team]메뉴가 클릭 됐을때 , 이미지 설정
			function setMyPageTeamTopMenu(){
				$('.mypageTeamMenu').each(function(){
					if($(this).attr('alt') == navName) {
						$(this).addClass('mypageTeamMenuBG');
					//	$(this).css('color', '#0c388b');
					} else {
						$(this).removeClass('mypageTeamMenuBG');
				//		$(this).css('color', '#0c388b');
					}
				});
			}
			
			var $mainmenu=$("#"+menuid+">ul");
			var $headers=$mainmenu.find("ul").parent();
			$headers.each(function(i){
				var $curobj=$(this);
				var $subul=$(this).find('ul:eq(0)');
				//alert(this.offsetWidth);
				this._dimensions={w:this.offsetWidth, h:this.offsetHeight, subulw:$subul.outerWidth(), subulh:$subul.outerHeight()};
				this.istopheader=$curobj.parents("ul").length==1? true : false;
				$subul.css({top:this.istopheader? this._dimensions.h+"px" : 0});
				$curobj.children("a:eq(0)").css(this.istopheader? {paddingRight: arrowsvar.down[2]} : {}).append(
					'<img src="'+ (this.istopheader? arrowsvar.down[1] : arrowsvar.right[1])
					//'<img '
					+'" class="' + (this.istopheader? arrowsvar.down[0] : arrowsvar.right[0])
					+ '" style="border:0;" />'
				);
				$curobj.hover(
					function(e){
						var $targetul=$(this).children("ul:eq(0)");
						this._offsets={left:$(this).offset().left, top:$(this).offset().top};
						var menuleft_=this.istopheader? 0 : this._dimensions.w;
						var menuleft=(this._offsets.left+menuleft_+this._dimensions.subulw>$(window).width())? (this.istopheader? -this._dimensions.subulw+this._dimensions.w : -this._dimensions.w) : menuleft_;
						//alert('1:'+$curobj.parents("ul").length+':'+this.istopheader+':'+menuleft_+':'+menuleft);
						if ($targetul.queue().length<=1) //if 1 or less queued animations
							$targetul.css({left:menuleft+"px", width:this._dimensions.subulw+'px'}).slideDown(jqueryslidemenu.animateduration.over);
					},
					function(e){
						var $targetul=$(this).children("ul:eq(0)");
						$targetul.slideUp(jqueryslidemenu.animateduration.out);
					}
				); //end hover
				$curobj.click(function(){
					$(this).children("ul:eq(0)").hide();
				});
			}); //end $headers.each()
			$mainmenu.find("ul").css({display:'none', visibility:'visible'});
		}); //end document.ready
	}
};

//build menu with ID="myslidemenu" on page:
//jqueryslidemenu.buildmenu("slidemenu", arrowimages);
//jqueryslidemenu.buildmenu("slidemenu02", arrowimages);
</script>
