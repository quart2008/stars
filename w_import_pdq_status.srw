HA$PBExportHeader$w_import_pdq_status.srw
$PBExportComments$Displays the status of each level when importing a PDQ
forward
global type w_import_pdq_status from w_master
end type
type st_1 from statictext within w_import_pdq_status
end type
type dw_status from u_dw within w_import_pdq_status
end type
type cb_close from u_cb within w_import_pdq_status
end type
type dw_errors from u_dw within w_import_pdq_status
end type
type st_2 from statictext within w_import_pdq_status
end type
type cb_print from u_cb within w_import_pdq_status
end type
type mle_comment from u_mle within w_import_pdq_status
end type
end forward

global type w_import_pdq_status from w_master
string accessiblename = "Import Pre Defined Query Status"
string accessibledescription = "Import Pre Defined Query Status"
integer width = 2446
integer height = 1392
string title = "PDQ Import Errors"
event ue_filter_errors ( )
st_1 st_1
dw_status dw_status
cb_close cb_close
dw_errors dw_errors
st_2 st_2
cb_print cb_print
mle_comment mle_comment
end type
global w_import_pdq_status w_import_pdq_status

type variables
sx_import_pdq_status 	istr_import_pdq_status
n_ds			ids_import_errors 
end variables

event ue_filter_errors();//*********************************************************************************
// Script Name:	ue_filter_errors	
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	Filter errors dw to show detail for row selected in status dw
//		
//
//*********************************************************************************
//	
// 12/03/99	AJS	Stars 4.5.	Created
// 05/06/11 WinacentZ Track Appeon Performance tuning
//
//*********************************************************************************

//need to filter ids_import_errors by level number
long ll_current_row, ll_level_num
ll_current_row = dw_status.GetRow()
// 05/06/11 WinacentZ Track Appeon Performance tuning
//ll_level_num = dw_status.object.level_num[ll_current_row]
ll_level_num = dw_status.GetItemNumber(ll_current_row, "level_num")

dw_errors.SetFilter("")
dw_errors.Filter()
dw_errors.SetFilter("level_num = " + String(ll_level_num))
dw_errors.Filter()


end event

on w_import_pdq_status.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_status=create dw_status
this.cb_close=create cb_close
this.dw_errors=create dw_errors
this.st_2=create st_2
this.cb_print=create cb_print
this.mle_comment=create mle_comment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_status
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.dw_errors
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_print
this.Control[iCurrent+7]=this.mle_comment
end on

on w_import_pdq_status.destroy
call super::destroy
destroy(this.st_1)
destroy(this.dw_status)
destroy(this.cb_close)
destroy(this.dw_errors)
destroy(this.st_2)
destroy(this.cb_print)
destroy(this.mle_comment)
end on

event ue_preopen;//*********************************************************************************
// Script Name:	ue_open	
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	Place passed message in structure
//		
//
//*********************************************************************************
//	
// 12/03/99	AJS	Stars 4.5.	Created
//
//*********************************************************************************

istr_import_pdq_status  =  Message.PowerObjectParm
SetNull (Message.PowerObjectParm)

end event

event open;call super::open;//*********************************************************************************
// Script Name:	open	
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	Populate dw_status and dw_errors with first error row
//		
//
//*********************************************************************************
//	
// 12/03/99	AJS	Stars 4.5.	Created
// 05/06/11 WinacentZ Track Appeon Performance tuning
//
//*********************************************************************************

long ll_found

//Populate error datawindow
dw_errors.object.data  =  istr_import_pdq_status.ds_import_errors.object.data

//Populate status datawindow and scroll to first error
mle_comment.text = istr_import_pdq_status.comments
dw_status.object.data  =  istr_import_pdq_status.ds_import_pdq_status.object.data
// 05/06/11 WinacentZ Track Appeon Performance tuning
//dw_status.Object.DataWindow.ReadOnly = 'Yes'
dw_status.Modify("DataWindow.ReadOnly = 'Yes'")
ll_found = dw_status.Find("criteria_errors = 'Y' or column_errors = 'Y'", 1, dw_errors.RowCount())
dw_status.ScrollToRow(ll_found)
dw_status.SelectRow(ll_found, TRUE)
end event

type st_1 from statictext within w_import_pdq_status
string accessiblename = "Comments"
string accessibledescription = "Comments"
accessiblerole accessiblerole = statictextrole!
integer x = 1275
integer y = 20
integer width = 347
integer height = 76
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
string text = "Comments:"
boolean focusrectangle = false
end type

type dw_status from u_dw within w_import_pdq_status
string accessiblename = "Import Status"
string accessibledescription = "Import Status"
integer x = 27
integer y = 104
integer width = 1221
integer height = 488
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_import_pdq_status"
boolean vscrollbar = true
end type

event constructor;call super::constructor;//*********************************************************************************
// Script Name:	dw_status.constructor	
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	Turn single row select on for dw.
//		
//
//*********************************************************************************
//	
// 12/03/99	AJS	Stars 4.5.	Created
//
//*********************************************************************************

This.of_SingleSelect (TRUE)
end event

event clicked;call super::clicked;//*********************************************************************************
// Script Name:	dw_status.clicked
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	Trigger the filter error event to displat detail in dw_errors dw.
//		
//
//*********************************************************************************
//	
// 12/03/99	AJS	Stars 4.5.	Created
//
//*********************************************************************************

Parent.Event ue_filter_errors()
end event

event rowfocuschanged;call super::rowfocuschanged;//*********************************************************************************
// Script Name:	dw_status.rowfocuschanged	
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	Trigger the filter error event to displat detail in dw_errors dw.
//		
//
//*********************************************************************************
//	
// 12/03/99	AJS	Stars 4.5.	Created
//
//*********************************************************************************

Parent.Event ue_filter_errors()
end event

type cb_close from u_cb within w_import_pdq_status
string accessiblename = "Close"
string accessibledescription = "Close"
integer x = 1335
integer y = 1184
integer taborder = 50
boolean bringtotop = true
string text = "&Close"
boolean default = true
end type

event clicked;//*********************************************************************************
// Script Name:	cb_close.clicked	
//
//	Arguments:		N/A
//						
//
// Returns:			N/A
//
//	Description:	close to parent window
//		
//
//*********************************************************************************
//	
// 12/03/99	AJS	Stars 4.5.	Created
//
//*********************************************************************************

Close (Parent)
end event

type dw_errors from u_dw within w_import_pdq_status
string tag = "COLORFIXED"
string accessiblename = "Errors"
string accessibledescription = "Errors"
integer x = 32
integer y = 620
integer width = 2345
integer height = 536
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_import_errors"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type st_2 from statictext within w_import_pdq_status
string accessiblename = "PDQ Import Status"
string accessibledescription = "PDQ Import Status"
accessiblerole accessiblerole = statictextrole!
integer x = 27
integer y = 20
integer width = 576
integer height = 76
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
string text = "PDQ Import Status:"
boolean focusrectangle = false
end type

type cb_print from u_cb within w_import_pdq_status
string accessiblename = "Print"
string accessibledescription = "Print"
integer x = 544
integer y = 1184
integer taborder = 20
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
//	Description:	Print the contents of the errors datawindow.
//		
//
//*********************************************************************************
//	
// 12/03/99	AJS	Stars 4.5.	Created
// 04/30/11 AndyG Track Appeon UFA Work around print
//
//*********************************************************************************

Long	ll_Job

SetPointer (HourGlass!)

ll_Job	=	PrintOpen( )

// 04/30/11 AndyG Track Appeon UFA
//w_import_pdq_status.Print(ll_Job, 500,1000)
PrintScreen(ll_Job, Parent.x, Parent.y, Parent.width, Parent.height)

PrintClose(ll_Job)


end event

type mle_comment from u_mle within w_import_pdq_status
string accessiblename = "Import Comments"
string accessibledescription = "Import Comments"
integer x = 1275
integer y = 100
integer width = 1093
integer height = 492
integer taborder = 30
boolean bringtotop = true
string facename = "System"
boolean vscrollbar = true
boolean autovscroll = true
integer limit = 255
boolean displayonly = true
borderstyle borderstyle = styleraised!
end type

