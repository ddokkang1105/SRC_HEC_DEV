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
				if (menuid == 'slidemenu02' || menuid == 'slidemenu03') {
					setMyPageTeamTopMenu();
				} else {
					iniTopMenu();
				}
			});
			
			function iniTopMenu(){
				$('.topmenu').each(function(){
					if($(this).attr('alt') == navName) {
						$(this).addClass('topMenuBG');
						$(this).css('color', '#0c388b');
						$(this).attr("style","border:3px");
					} else {
						$(this).removeClass('topMenuBG');
						$(this).css('color', '#0c388b');
						$(this).attr("style","border:0px");
					}
					
					if($(this).children().hasClass("downarrowclass")===true) {
						$(this).css('padding-right','23px');
					}

				});
			}
			
			// [My page][Team]•
			function setMyPageTeamTopMenu(){
				$('.mypageTeamMenu').each(function(){
					if($(this).attr('alt') == navName) {
						$(this).addClass('mypageTeamMenuBG');
						$(this).css('color', '#0c388b');
					} else {
						$(this).removeClass('mypageTeamMenuBG');
						$(this).css('color', '#0c388b');
					}
				});
			}
			
			var $mainmenu=$("#"+menuid+">ul"); // slidemenu0TMPL002 ul
			//var $headers=$mainmenu.find("ul").parent(); // Master data / Sales / Service
			var $headers=$("#"+menuid+">ul>li")
			$headers.each(function(i){
				var $curobj=$(this); 
				var $subul=$(this).find('ul:eq(0)'); 
				this._dimensions={w:this.offsetWidth, h:this.offsetHeight, subulw:$subul.outerWidth(), subulh:$subul.outerHeight()};
				this.istopheader=$curobj.parents("ul").length==1? true : false;
				$subul.css({top:this.istopheader? this._dimensions.h+"px" : 0});
				$curobj.hover(
					function(e){
						$mainmenu.find("ul").not($subul).slideUp(jqueryslidemenu.animateduration.out);
						var $targetul=$(this).children("ul:eq(0)");
						this._offsets={left:$(this).offset().left, top:$(this).offset().top};
						var menuleft_=this.istopheader? 0 : this._dimensions.w;
						var menuleft=(this._offsets.left+menuleft_+this._dimensions.subulw>$(window).width())? (this.istopheader? -this._dimensions.subulw+this._dimensions.w : -this._dimensions.w) : menuleft_;
						if ($targetul.queue() && $targetul.queue().length<=1) //if 1 or less queued animations
							$targetul.css({left:menuleft+"px", width:this._dimensions.subulw+'px'}).slideDown(jqueryslidemenu.animateduration.over);
					},
					function(e){
						//var $targetul=$(this).children("ul:eq(0)");
						//$targetul.slideUp(jqueryslidemenu.animateduration.out);
					}
				); //end hover
				$curobj.click(function(){
					if($subul.length<1){$headers.find('ul li a').css('font-weight','normal');}
				})
				$subul.find('a').click(function(){
					$headers.find('ul li a').css('font-weight','normal');
					$(this).css('font-weight','bold');
				});
			}); //end $headers.each()
			$mainmenu.find("ul").css({display:'none', visibility:'visible'});
			$(".logo").click(function(){
				$headers.find('ul li a').css('font-weight','normal');
			})
		}); //end document.ready
	}
};

//build menu with ID="myslidemenu" on page:
//jqueryslidemenu.buildmenu("slidemenu", arrowimages);
//jqueryslidemenu.buildmenu("slidemenu02", arrowimages);
</script>
