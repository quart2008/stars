HA$PBExportHeader$w_claim_rpt_no_data.srw
$PBExportComments$Inherited from w_master
forward
global type w_claim_rpt_no_data from w_master
end type
type cb_cancel from u_cb within w_claim_rpt_no_data
end type
type dw_1 from u_dw within w_claim_rpt_no_data
end type
end forward

global type w_claim_rpt_no_data from w_master
string accessiblename = "NO DATA"
string accessibledescription = "NO DATA"
accessiblerole accessiblerole = windowrole!
integer x = 439
integer y = 132
integer width = 2039
integer height = 1584
string title = "NO DATA"
long backcolor = 67108864
cb_cancel cb_cancel
dw_1 dw_1
end type
global w_claim_rpt_no_data w_claim_rpt_no_data

type variables
// Parm to window
String is_parm

end variables

forward prototypes
public subroutine wf_goto_the_end (string ls_array[])
end prototypes

public subroutine wf_goto_the_end (string ls_array[]);//***********************************************************************
//	Script:	wf_goto_the_end
//
//	Arguments:	string		ls_array[]
//
//	Returns:		None
//
//	Description:
//		This function is called in open event, and then go to the_end label.
//
//***********************************************************************
//   Date   Init               Description of Changes Made                
// -------- ----	-------------------------------------------------------- 
// 04/24/11 AndyG Track Appeon UFA Work around GOTO.
//
//***********************************************************************

Date current_date

current_date = gnv_app.of_get_server_date()		//ts2020c NLG 12-15-99

//the_end:

this.x = 200
this.y = 100
dw_1.insertrow(0)
dw_1.SetItem(1,1,ls_array[1])
dw_1.SetItem(1,2,ls_array[2])
dw_1.SetItem(1,3,ls_array[3])
dw_1.SetItem(1,4,ls_array[4])
dw_1.SetItem(1,5,ls_array[5])
dw_1.SetItem(1,8,ls_array[6])
dw_1.SetItem(1,9,ls_array[7])
dw_1.SetItem(1,10,ls_array[8])
dw_1.SetItem(1,11,ls_array[9])
dw_1.SetItem(1,12,ls_array[10])
dw_1.SetItem(1,13,ls_array[11])
dw_1.SetItem(1,14,ls_array[12])
dw_1.SetItem(1,15,ls_array[13])
dw_1.SetItem(1,16,ls_array[14])
dw_1.SetItem(1,17,ls_array[15])
dw_1.SetItem(1,18,ls_array[16])
dw_1.SetItem(1,19,ls_array[17])
dw_1.SetItem(1,20,ls_array[18])
dw_1.SetItem(1,21,ls_array[19])
dw_1.SetItem(1,22,ls_array[20])
dw_1.SetItem(1,23,ls_array[21])
dw_1.SetItem(1,6,current_date)
dw_1.SetItem(1,7,'No match for provided criteria!')

end subroutine

event open;call super::open;//------------------------------------------------------------------
// OPEN SCRIPT FOR w_claim_rpt_no_data
// AUTHOR:    Randy Sprouse
// COPYRIGHT: VIPS Inc., MAY 1994
//
// DKG  04/11/96  Added function to set window colors. PROB 856
//                STARCARE disk.
// 04/24/11 AndyG Track Appeon UFA Work around GOTO
//------------------------------------------------------------------

Date current_date
String crit0, crit1, crit2, crit3, crit4, temp, lv_search
String crit5, crit6, crit7, crit8, crit9
String crit10, crit11, crit12, crit13, crit14
String crit15, crit16, crit17, crit18, crit19
String lv_fmt_where1, lv_fmt_where2, lv_title
Int crit_cnt, lv_position
crit_cnt = 0
Int bet_loc
boolean temp1
Int lv_dap

String lv_holding
String ls_array[21] // 04/24/11 AndyG Track Appeon UFA

//DKG 04/11/96 BEGIN
//fx_set_window_colors(w_claim_rpt_no_data)
//DKG 04/11/96 END

IF (match(is_parm,"@@") = TRUE) THEN
   lv_dap = pos(is_parm,"@@") - 1
   lv_holding = left(is_parm,lv_dap)
   lv_dap = lv_dap + 3
   lv_title = mid(is_parm,lv_dap)
   is_parm = lv_holding
ELSE
   lv_title = 'CLAIM REPORT'   
END IF
// 04/24/11 AndyG Track Appeon UFA
ls_array[1] = lv_title

is_parm = upper(is_parm)

//current_date = today()								//ts2020c replace pc with server date
current_date = gnv_app.of_get_server_date()		//ts2020c NLG 12-15-99

lv_position = pos(is_parm,'  ')

// This DO-WHILE loop is looking for any double 'blank' spaces
// within the where condition. If any are found, they are 
// changed to just one blank.

do while lv_position <> 0 
  lv_position = lv_position - 1
  lv_fmt_where1 = left(is_parm,lv_position)
  lv_position = lv_position + 2
  lv_fmt_where2 = mid(is_parm,lv_position)
  is_parm = lv_fmt_where1 + lv_fmt_where2
  lv_position = pos(is_parm,'  ')
loop

//messagebox('SQL',is_parm)

lv_search = ' AND '


temp1 = match(is_parm,'BETWEEN')

IF (temp1 = true) Then
   bet_loc = Pos(is_parm,'BETWEEN')
ELSE
   bet_loc = 3000
END IF  

//MessageBox('test','Between at ' + String(bet_loc))

//------CRIT0----------------------------
lv_position = pos(is_parm,lv_search) 

crit0 = left(is_parm,lv_position)
// 04/24/11 AndyG Track Appeon UFA
ls_array[2] = crit0

//------CRIT1----------------------------
bet_loc = bet_loc - (lv_position + 5)
lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)
lv_position = pos(is_parm,lv_search)
IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit1 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[3] = crit1
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit1 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[3] = crit1
END IF

//------CRIT2----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit2 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[4] = crit2
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit2 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[4] = crit2
END IF

//------CRIT3----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit3 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[5] = crit3
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit3 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[5] = crit3
END IF

//------CRIT4----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit4 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[6] = crit4
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit4 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[6] = crit4
END IF

//------CRIT5----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit5 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[7] = crit5
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit5 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[7] = crit5
END IF

//------CRIT6----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit6 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[8] = crit6
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit6 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[8] = crit6
END IF

//------CRIT7----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit7 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[9] = crit7
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit7 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[9] = crit7
END IF

//------CRIT8----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit8 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[10] = crit8
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit8 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[10] = crit8
END IF

//------CRIT9----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit9 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[11] = crit9
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit9 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[11] = crit9  
END IF

//------CRIT10---------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit10 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[12] = crit10
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit10 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[12] = crit10
END IF

//------CRIT11---------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit11 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[13] = crit11
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit11 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[13] = crit11
END IF

//------CRIT12----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit12 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[14] = crit12
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit12 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[14] = crit12
END IF

//------CRIT13----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit13 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[15] = crit13
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit13 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[15] = crit13 
END IF

//------CRIT14----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit14 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[16] = crit14
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit14 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[16] = crit14
END IF

//------CRIT15----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit15 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[17] = crit15
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit15 = left(is_parm,lv_position)
 	// 04/24/11 AndyG Track Appeon UFA
	ls_array[17] = crit15
END IF

//------CRIT16---------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit16 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[18] = crit16
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit16 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[18] = crit16
END IF

//------CRIT17----------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit17 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[19] = crit17
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit17 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[19] = crit17
END IF

//------CRIT18---------------------------
bet_loc = bet_loc - (lv_position + 5)

lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)

IF (bet_loc < lv_position) THEN
   lv_position = Pos(is_parm,lv_search,lv_position+5)
END IF

IF lv_position = 0 THEN
  crit18 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[20] = crit18
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit18 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[20] = crit18
END IF

//------CRIT19---------------------------
lv_position = lv_position + 5
is_parm = mid(is_parm,lv_position)

lv_position = pos(is_parm,lv_search)
IF lv_position = 0 THEN
  crit19 = is_parm  
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[21] = crit19
//  goto the_end
	wf_goto_the_end(ls_array)
	Return
ELSE
  crit19 = left(is_parm,lv_position)
	// 04/24/11 AndyG Track Appeon UFA
	ls_array[21] = crit19
END IF

// 04/24/11 AndyG Track Appeon UFA
//the_end:
//
//this.x = 200
//this.y = 100
//dw_1.insertrow(0)
//dw_1.SetItem(1,1,lv_title)
//dw_1.SetItem(1,2,crit0)
//dw_1.SetItem(1,3,crit1)
//dw_1.SetItem(1,4,crit2)
//dw_1.SetItem(1,5,crit3)
//dw_1.SetItem(1,8,crit4)
//dw_1.SetItem(1,9,crit5)
//dw_1.SetItem(1,10,crit6)
//dw_1.SetItem(1,11,crit7)
//dw_1.SetItem(1,12,crit8)
//dw_1.SetItem(1,13,crit9)
//dw_1.SetItem(1,14,crit10)
//dw_1.SetItem(1,15,crit11)
//dw_1.SetItem(1,16,crit12)
//dw_1.SetItem(1,17,crit13)
//dw_1.SetItem(1,18,crit14)
//dw_1.SetItem(1,19,crit15)
//dw_1.SetItem(1,20,crit16)
//dw_1.SetItem(1,21,crit17)
//dw_1.SetItem(1,22,crit18)
//dw_1.SetItem(1,23,crit19)
//dw_1.SetItem(1,6,current_date)
//dw_1.SetItem(1,7,'No match for provided criteria!')

// 04/24/11 AndyG Track Appeon UFA
wf_goto_the_end(ls_array)
Return

// END CODE ...
end event

on w_claim_rpt_no_data.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.dw_1
end on

on w_claim_rpt_no_data.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.dw_1)
end on

event ue_preopen;call super::ue_preopen;
is_parm = message.stringparm
//KMM Clear out message parm (PB Bug)
SetNull(message.stringparm)

end event

type cb_cancel from u_cb within w_claim_rpt_no_data
string accessiblename = "Close"
string accessibledescription = "Close"
accessiblerole accessiblerole = pushbuttonrole!
integer x = 1509
integer y = 1316
integer width = 338
integer height = 108
integer taborder = 20
string text = "&Close"
boolean default = true
end type

on clicked;SetPointer(Hourglass!)
close(parent)
end on

type dw_1 from u_dw within w_claim_rpt_no_data
string accessiblename = "No Data Message"
string accessibledescription = "No Data Message"
accessiblerole accessiblerole = clientrole!
integer x = 165
integer y = 128
integer width = 1682
integer height = 1136
integer taborder = 10
string dataobject = "d_claim_rpt_no_data"
boolean hscrollbar = true
boolean vscrollbar = true
end type

