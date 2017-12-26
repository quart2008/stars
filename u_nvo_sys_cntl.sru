HA$PBExportHeader$u_nvo_sys_cntl.sru
$PBExportComments$(inherited from n_base) <logic>
forward
global type u_nvo_sys_cntl from n_base
end type
end forward

global type u_nvo_sys_cntl from n_base
end type
global u_nvo_sys_cntl u_nvo_sys_cntl

type variables
n_ds      ids_sys_cntl
long       il_sys_cntl_row   
string     is_cntl_id

end variables

forward prototypes
public subroutine of_set_cntl_id (string as_cntl_id)
public function integer of_get_cntl_no ()
public function string of_get_cntl_case ()
public function string of_get_default_date ()
end prototypes

public subroutine of_set_cntl_id (string as_cntl_id);/////////////////////////////////////////////////////////////////////////////
// Event/Function								Object				
//	--------------								------				
// of_set_cntl_id 							u_nvo_sys_cntl
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
//This function will store the cntl_id passed to this function into instance 
//variable is_cntl_id.  This function is called when any descendant objects 
//are created.  This function will also determine the row number that cntl_id 
//resides into instance variable il_sys_cntl_row. 
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument				Datatype				Description
//		---------	--------				--------				-----------
//    Value			as_cntl_id			string		
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value			Description
//		--------		-----			-----------
//		None
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	A.Sola			01/09/98		Created.
//
/////////////////////////////////////////////////////////////////////////////
String	ls_find
is_cntl_id  =  Upper (as_cntl_id)	// Convert to upper case
ls_find  =  "cntl_id = '"  +  is_cntl_id  + "'"
il_sys_cntl_row  =  ids_sys_cntl.Find (ls_find, 1, ids_sys_cntl.RowCount() )

end subroutine

public function integer of_get_cntl_no ();/////////////////////////////////////////////////////////////////////////////
// Event/Function								Object				
//	--------------								------				
// of_get_cntl_no 							u_nvo_sys_cntl
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
//This function will return the column cntl_no from datastore ids_sys_cntl.  
//This functions required function of_set_cntl_id to be called when a 
//descendant object is created. 
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument				Datatype				Description
//		---------	--------				--------				-----------
//    None
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value			Description
//		--------		-----			-----------
//		Integer						cntl_no
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	A.Sola			01/09/98		Created.
// 05/04/11 WinacentZ Track Appeon Performance tuning
//
/////////////////////////////////////////////////////////////////////////////
Long	ll_cntl_no
// 05/04/11 WinacentZ Track Appeon Performance tuning
//ll_cntl_no	=	ids_sys_cntl.object.cntl_no [il_sys_cntl_row]
ll_cntl_no	=	ids_sys_cntl.GetItemNumber(il_sys_cntl_row, "cntl_no")
Return ll_cntl_no

end function

public function string of_get_cntl_case ();/////////////////////////////////////////////////////////////////////////////
// Event/Function								Object				
//	--------------								------				
// of_get_cntl_CASE 							u_nvo_sys_cntl
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
//This function will return the column cntl_case from datastore ids_sys_cntl.  
//This functions required function of_set_cntl_id to be called when a 
//descendant object is created. 
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument				Datatype				Description
//		---------	--------				--------				-----------
//    None
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value			Description
//		--------		-----			-----------
//		String						cntl_case
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	A.Sola			01/09/98		Created.
// 05/04/11 WinacentZ Track Appeon Performance tuning
//
/////////////////////////////////////////////////////////////////////////////
String	ls_cntl_case
// 05/04/11 WinacentZ Track Appeon Performance tuning
//ls_cntl_case	=	ids_sys_cntl.object.cntl_case [il_sys_cntl_row]
ls_cntl_case	=	ids_sys_cntl.GetItemString(il_sys_cntl_row, "cntl_case")
Return ls_cntl_case

end function

public function string of_get_default_date ();/////////////////////////////////////////////////////////////////////////////
// Event/Function								Object				
//	--------------								------				
// of_get_default_date						u_nvo_sys_cntl
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
//	This function will return the current date in a string format.  This 
//	date will be used to fill in the text on the window's "Date" single-line 
//	edit control.  This is computed here instead of each window because if 
//	the format of the date changes, it will only have to be changed in this 
//	function.  
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument				Datatype				Description
//		---------	--------				--------				-----------
//    None
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value			Description
//		--------		-----			-----------
//		String						current_date
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	A.Sola			01/09/98		Created.
//	FDG				01/12/99		Track 2047c.  Convert ls_date to have a 
//										4 digit year.
//
/////////////////////////////////////////////////////////////////////////////
Datetime ldte_datetime
String	ls_date
ldte_datetime = gnv_app.of_get_server_date_time()
ls_date = String(Date(ldte_datetime), 'm/d/yyyy')
Return ls_date

end function

event constructor;// 06/14/11 WinacentZ Track Appeon Performance tuning-reduce call times
ids_sys_cntl  =  CREATE  n_ds
ids_sys_cntl.DataObject  =  'd_sys_cntl'
ids_sys_cntl.SetTransObject (Stars2ca)
//ids_sys_cntl.Retrieve()
gds_sys_cntl.ShareData(ids_sys_cntl)
end event

on u_nvo_sys_cntl.create
call super::create
end on

on u_nvo_sys_cntl.destroy
call super::destroy
end on

event destructor;// 06/14/11 WinacentZ Track Appeon Performance tuning-reduce call times
ids_sys_cntl.ShareDataOff()
DESTROY  ids_sys_cntl
end event

