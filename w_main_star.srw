HA$PBExportHeader$w_main_star.srw
$PBExportComments$Inherited from w_master
forward
global type w_main_star from w_master
end type
type p_star from picture within w_main_star
end type
end forward

global type w_main_star from w_master
string accessiblename = "Stars"
string accessibledescription = "Stars"
integer x = 105
integer y = 0
integer width = 3890
integer height = 1828
string title = "Stars"
p_star p_star
end type
global w_main_star w_main_star

type variables
Long il_Height, il_width, il_x, il_y
end variables

event close;call super::close;m_stars_30.m_file.m_star.checked=false
end event

on w_main_star.create
int iCurrent
call super::create
this.p_star=create p_star
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_star
end on

on w_main_star.destroy
call super::destroy
destroy(this.p_star)
end on

event activate;call super::activate;//Anne-S 11-20-97 STARCARE 367 add code so baltimore bitmap does not
//cover open windows
w_main_star.BringToTop = FALSE
end event

event open;call super::open;//DJP - add variable bitmaps
//	05/28/09	GaryR	GNL.600.5715.002	Update the branding graphics
// 08/01/11 WinacentZ Track Appeon Performance tuning-fix bug

string ls_bitmap
Integer	li_pos

ls_bitmap=ProfileString(gv_ini_path + 'STARS.INI','carrier','bitmap','STARSLogoBig.gif') 
if not fileexists(ls_bitmap) then
	messagebox('Error','Specified background image does not exist.')
	close(this)
	return
end if

p_star.picturename=ls_bitmap
m_stars_30.m_file.m_star.checked=true

// 08/01/11 WinacentZ Track Appeon Performance tuning-fix bug
il_Height = p_star.Height
il_width	 = p_star.Width
il_x		 = p_star.X
il_y 		 = p_star.Y
end event

event resize;// 08/01/11 WinacentZ Track Appeon Performance tuning-fix bug
SetReDraw(False)
p_star.Height = il_Height
p_star.Width  = il_width
p_star.X		  = (This.Width - il_width) / 2
p_star.Y		  = (This.Height - il_Height) / 2 -(This.Height - il_Height) / 20
SetReDraw(True)
end event

type p_star from picture within w_main_star
string accessiblename = "Stars Logo"
string accessibledescription = "Stars Logo"
accessiblerole accessiblerole = graphicrole!
integer x = 645
integer y = 412
integer width = 2610
integer height = 880
boolean originalsize = true
borderstyle borderstyle = StyleBox!
boolean focusrectangle = false
end type

