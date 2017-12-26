$PBExportHeader$w_qe_filter_list.srw
$PBExportComments$(Inherited from w_master)
forward
global type w_qe_filter_list from w_master
end type
type dw_filter_list from u_dw within w_qe_filter_list
end type
type cb_cancel from u_cb within w_qe_filter_list
end type
type cb_use from u_cb within w_qe_filter_list
end type
type cb_filter from u_cb within w_qe_filter_list
end type
end forward

global type w_qe_filter_list from w_master
string accessiblename = "Filter List Window"
string accessibledescription = "Filter List Window"
integer width = 2857
string title = "Filter List"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_filter_list dw_filter_list
cb_cancel cb_cancel
cb_use cb_use
cb_filter cb_filter
end type
global w_qe_filter_list w_qe_filter_list

type variables
PRIVATE:

sx_all_filter_info  isx_all_filter_info
Integer               il_filter_count 
end variables

on w_qe_filter_list.create
int iCurrent
call super::create
this.dw_filter_list=create dw_filter_list
this.cb_cancel=create cb_cancel
this.cb_use=create cb_use
this.cb_filter=create cb_filter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_filter_list
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_use
this.Control[iCurrent+4]=this.cb_filter
end on

on w_qe_filter_list.destroy
call super::destroy
destroy(this.dw_filter_list)
destroy(this.cb_cancel)
destroy(this.cb_use)
destroy(this.cb_filter)
end on

event ue_postopen;call super::ue_postopen;/////////////////////////////////////////////////////////////////////////////
// Event/Function								Object				
//	--------------								------				
//	ue_PostOpen									w_qe_filter_list
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
// Load dw_filter_list with the filter information passed to the window.
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument		Datatype				Description
//		---------	--------		--------				-----------
//		None.
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value			Description
//		--------		-----			-----------
//		None.		
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author	Date		Description
// ------	----		-----------
//	J.Mattis	01/07/98	Created.
//
//	FDG		03/24/98	Track 154.  Change i to li_idx.  Change col_name to
//							col_desc in dw_filter_list.
// 04/27/11 limin Track Appeon Performance tuning
//
/////////////////////////////////////////////////////////////////////////////

SetPointer(HourGlass!)
Integer li_idx, il_Row

il_filter_count = upperbound(isx_all_filter_info.filters)

for li_idx = 1 to il_filter_count
	il_Row = dw_filter_list.insertrow(0)
	// 04/27/11 limin Track Appeon Performance tuning
//	dw_filter_list.object.level_num[il_Row] = isx_all_filter_info.filters[li_idx].level_num
//	dw_filter_list.object.filter_id[il_Row] = isx_all_filter_info.filters[li_idx].filter_id
//	dw_filter_list.object.col_desc[il_Row] = isx_all_filter_info.filters[li_idx].col_name		// FDG 03/25/98
//	dw_filter_list.object.data_type[il_Row] = isx_all_filter_info.filters[li_idx].data_type
	dw_filter_list.SetItem(il_Row,"level_num", isx_all_filter_info.filters[li_idx].level_num)
	dw_filter_list.SetItem(il_Row,"filter_id", isx_all_filter_info.filters[li_idx].filter_id)
	dw_filter_list.SetItem(il_Row,"col_desc", isx_all_filter_info.filters[li_idx].col_name)		// FDG 03/25/98
	dw_filter_list.SetItem(il_Row,"data_type", isx_all_filter_info.filters[li_idx].data_type)
next

end event

event ue_preopen;call super::ue_preopen;// get the parm into this window
isx_all_filter_info = message.Powerobjectparm

end event

type dw_filter_list from u_dw within w_qe_filter_list
string accessiblename = "Filter List"
string accessibledescription = "Filter List"
integer x = 32
integer y = 32
integer width = 2798
integer height = 1028
integer taborder = 10
string dataobject = "d_all_filter_list"
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.SetTransObject(stars2ca)
this.of_SetUpdateable(FALSE)
this.of_SingleSelect(TRUE)
end event

type cb_cancel from u_cb within w_qe_filter_list
event clicked pbm_bnclicked
string accessiblename = "Cancel"
string accessibledescription = "Cancel"
integer x = 1623
integer y = 1128
integer taborder = 40
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;/////////////////////////////////////////////////////////////////////////////
// Event/Function								Object				
//	--------------								------				
//	clicked										cb_Cancel
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
// Set level number to -1 so that w_query_engine knows not to continue.
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument		Datatype				Description
//		---------	--------		--------				-----------
//		None.
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value			Description
//		--------		-----			-----------
//		None.		
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	J.Mattis			01/07/98		Created.
//
/////////////////////////////////////////////////////////////////////////////

SetPointer(HourGlass!)

// Set level number to -1 so that w_query_engine knows not to continue.

isx_all_filter_info.filters[1].level_num = -1
closewithreturn(parent,isx_all_filter_info)
end event

type cb_use from u_cb within w_qe_filter_list
string accessiblename = "Use"
string accessibledescription = "Use"
integer x = 1266
integer y = 1128
integer taborder = 30
string text = "&Use"
end type

event clicked;call super::clicked;/////////////////////////////////////////////////////////////////////////////
// Event/Function								Object				
//	--------------								------				
//	clicked										cb_Use
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
// Get selected filter id and return it with the close.
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument		Datatype				Description
//		---------	--------		--------				-----------
//		None.
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value			Description
//		--------		-----			-----------
//		None.		
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author	Date			Description
// ------	----			-----------
//	J.Mattis	01/07/98		Created.
//
//	FDG		03/17/98		Track 117.  Because w_filter_list set gv_active_filter,
//								this window must do the same.
// 05/06/11 WinacentZ Track Appeon Performance tuning
//
/////////////////////////////////////////////////////////////////////////////

SetPointer(HourGlass!)

Long ll_selected_row
String ls_filterId

ll_selected_row = dw_filter_list.GetSelectedRow(0) /* selected row in dw_filter_list */

If ll_Selected_Row > 0 Then
	// 05/06/11 WinacentZ Track Appeon Performance tuning
//	ls_FilterId = dw_filter_list.object.filter_id[ll_selected_row]
	ls_FilterId = dw_filter_list.GetItemString(ll_selected_row, "filter_id")
	gv_active_filter		=	ls_filterId				// FDG 03/17/98
End If

closewithreturn(parent,ls_FilterId)
end event

type cb_filter from u_cb within w_qe_filter_list
string accessiblename = "Filter"
string accessibledescription = "Filter"
integer x = 910
integer y = 1128
integer taborder = 20
boolean bringtotop = true
string text = "&Filter"
boolean default = true
end type

event clicked;call super::clicked;/////////////////////////////////////////////////////////////////////////////
// Event/Function								Object				
//	--------------								------				
//	clicked										cb_Filter
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
// Load the structure needed by the Filter List window, then open the window.
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument		Datatype				Description
//		---------	--------		--------				-----------
//		None.
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value			Description
//		--------		-----			-----------
//		None.		
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	J.Mattis			01/07/98		Created.
//
/////////////////////////////////////////////////////////////////////////////

SetPointer(HourGlass!)

Window w_Null
CommandButton cb_Null

SetNull(w_Null)
SetNull(cb_Null)

sx_filter_data lsx_filter_data /* stfilter.pbl */

lsx_filter_data.sx_window = w_Null
lsx_filter_data.sx_entry_mode = "USE"
lsx_filter_data.sx_col_name = isx_all_filter_info.filters[1].data_type
lsx_filter_data.sx_button = cb_Null
opensheetwithparm(w_filter_list, lsx_filter_data, mdi_main_frame, &
	help_menu_position, Layered!)
closewithreturn(parent,message.Powerobjectparm)
end event

