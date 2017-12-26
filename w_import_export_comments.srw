HA$PBExportHeader$w_import_export_comments.srw
$PBExportComments$Enter/display comments for importing/exporting
forward
global type w_import_export_comments from w_master
end type
type mle_1 from u_mle within w_import_export_comments
end type
type cb_ok from u_cb within w_import_export_comments
end type
type cb_print from u_cb within w_import_export_comments
end type
type st_heading from statictext within w_import_export_comments
end type
type cb_cancel from commandbutton within w_import_export_comments
end type
end forward

global type w_import_export_comments from w_master
string accessiblename = "Import Export Comments Window"
string accessibledescription = "Import Export Comments Window"
integer width = 2011
integer height = 1012
string title = "Import/Export Comments"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
mle_1 mle_1
cb_ok cb_ok
cb_print cb_print
st_heading st_heading
cb_cancel cb_cancel
end type
global w_import_export_comments w_import_export_comments

on w_import_export_comments.create
int iCurrent
call super::create
this.mle_1=create mle_1
this.cb_ok=create cb_ok
this.cb_print=create cb_print
this.st_heading=create st_heading
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_print
this.Control[iCurrent+4]=this.st_heading
this.Control[iCurrent+5]=this.cb_cancel
end on

on w_import_export_comments.destroy
call super::destroy
destroy(this.mle_1)
destroy(this.cb_ok)
destroy(this.cb_print)
destroy(this.st_heading)
destroy(this.cb_cancel)
end on

event open;call super::open;//*********************************************************************************
// Script Name:	Open	
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	If a string was sent to this window, move it to mle_1.
//		
//
//*********************************************************************************
//	
// 10/13/99	FDG	Stars 4.5.	Created
//
//	01/21/00	FDG	Stars 4.5.	Remove the disabling of mle_1.  This will allow
//						a default comment to be sent to this window.
//
//*********************************************************************************

String	ls_message

ls_message	=	Message.StringParm
SetNull (Message.StringParm)

IF	Len (ls_message)	>	0		THEN
	// Display message from the import file
	mle_1.text			=	ls_message
//	mle_1.enabled		=	FALSE
//	st_heading.text	=	"Comments previously entered for this exported file"
//ELSE
//	// Window used for entering comments regarding the export.
//	st_heading.text	=	"Please enter comments regarding this export"
END IF



end event

type mle_1 from u_mle within w_import_export_comments
string accessiblename = "Import Export Comments Text"
string accessibledescription = "Import Export Comments Text"
integer x = 41
integer y = 92
integer width = 1888
integer height = 716
boolean bringtotop = true
string facename = "System"
boolean autovscroll = true
integer limit = 255
end type

type cb_ok from u_cb within w_import_export_comments
string accessiblename = "OK"
string accessibledescription = "OK"
integer x = 110
integer y = 820
integer taborder = 20
boolean bringtotop = true
string text = "&OK"
boolean default = true
end type

event clicked;CloseWithReturn (Parent, mle_1.text)

end event

type cb_print from u_cb within w_import_export_comments
string accessiblename = "Print"
string accessibledescription = "Print"
integer x = 782
integer y = 820
integer taborder = 30
boolean bringtotop = true
string text = "&Print"
end type

event clicked;//*********************************************************************************
// Script Name:	cb_print.clicked	
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	Print the contents of the MLE.
//		
//
//*********************************************************************************
//	
// 10/13/99	FDG	Stars 4.5.	Created
// 04/30/11 AndyG Track Appeon UFA Work around print
//
//*********************************************************************************

Long	ll_Job

SetPointer (HourGlass!)

ll_Job	=	PrintOpen( )

// 04/30/11 AndyG Track Appeon UFA
//mle_1.Print(ll_Job, 500,1000)
PrintScreen(ll_Job, Parent.x + mle_1.x, Parent.y + mle_1.y, mle_1.width, mle_1.Height)

PrintClose(ll_Job)


end event

type st_heading from statictext within w_import_export_comments
string accessiblename = "Heading"
string accessibledescription = "Heading"
accessiblerole accessiblerole = statictextrole!
integer x = 41
integer y = 8
integer width = 1888
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Please enter comments regarding this export"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_import_export_comments
string accessiblename = "Cancel"
string accessibledescription = "Cancel"
accessiblerole accessiblerole = pushbuttonrole!
integer x = 1403
integer y = 820
integer width = 315
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
string text = "&Cancel"
end type

event clicked;CloseWithReturn (Parent, 'CANCEL')
end event

