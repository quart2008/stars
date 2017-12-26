HA$PBExportHeader$w_state_sel.srw
$PBExportComments$Inherited from w_master
forward
global type w_state_sel from w_master
end type
type st_1 from statictext within w_state_sel
end type
type cb_cancel from u_cb within w_state_sel
end type
type cb_map from u_cb within w_state_sel
end type
type lb_states from listbox within w_state_sel
end type
end forward

global type w_state_sel from w_master
string accessiblename = "State Selection Window"
string accessibledescription = "State Selection Window"
integer x = 873
integer y = 480
integer width = 1161
integer height = 964
string title = "State Selection"
windowtype windowtype = response!
st_1 st_1
cb_cancel cb_cancel
cb_map cb_map
lb_states lb_states
end type
global w_state_sel w_state_sel

type variables
// Message.DoubleParm
Long	il_num_states
end variables

event open;call super::open;integer li_x
string lv_state


//fx_set_window_colors(w_state_sel)		// FDG 05/22/96

for li_x=1 to il_num_states
	lv_state = ProfileString(gv_ini_path+"stars.ini","MAP","State"+string(li_x),"")
	//  05/24/2011  limin Track Appeon Performance Tuning
//	if trim(lv_state)<>'' then lb_states.additem(lv_state)
	if trim(lv_state)<>'' AND NOT ISNULL(lv_state)   then lb_states.additem(lv_state)
next

end event

on w_state_sel.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_map=create cb_map
this.lb_states=create lb_states
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_map
this.Control[iCurrent+4]=this.lb_states
end on

on w_state_sel.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_map)
destroy(this.lb_states)
end on

event ue_preopen;call super::ue_preopen;il_num_states=message.doubleparm
SetNull (Message.DoubleParm)

end event

type st_1 from statictext within w_state_sel
string accessiblename = "Please select a state to map"
string accessibledescription = "Please select a state to map"
accessiblerole accessiblerole = statictextrole!
integer x = 128
integer y = 36
integer width = 873
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
long textcolor = 134217741
long backcolor = 67108864
boolean enabled = false
string text = "Please select a state to map:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from u_cb within w_state_sel
string accessiblename = "Cancel"
string accessibledescription = "Cancel"
integer x = 681
integer y = 728
integer width = 306
integer height = 108
integer taborder = 20
string text = "&Cancel"
end type

on clicked;closewithreturn(parent,'cancel')
end on

type cb_map from u_cb within w_state_sel
string accessiblename = "Map"
string accessibledescription = "Map"
integer x = 155
integer y = 728
integer width = 306
integer height = 108
integer taborder = 30
string text = "&Map"
boolean default = true
end type

event clicked;//  05/24/2011  limin Track Appeon Performance Tuning
string lv_state

lv_state=left(lb_states.selecteditem(),2)
//  05/24/2011  limin Track Appeon Performance Tuning
//if trim(lv_state)<>'' then
if trim(lv_state)<>'' AND NOT ISNULL(lv_state)  then
	closewithreturn(parent,lv_state)
else
	messagebox('Error','Please select a state')
end if
end event

type lb_states from listbox within w_state_sel
string accessiblename = "States List"
string accessibledescription = "States List"
accessiblerole accessiblerole = listrole!
integer x = 91
integer y = 128
integer width = 951
integer height = 528
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

on doubleclicked;cb_map.postevent(clicked!)
end on

