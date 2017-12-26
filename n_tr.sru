HA$PBExportHeader$n_tr.sru
$PBExportComments$Ancestor transaction object <logic>
forward
global type n_tr from transaction
end type
end forward

global type n_tr from transaction
event documentation ( )
end type
global n_tr n_tr

type prototypes
// 05/12/11 AndyG Track Appeon Performance tuning
//*********************************************************************
// 08/16/11 limin Track Appeon Performance Tuning --fix bug
//Function String fx_get_next_key_id(string a_key_type) RPCFUNC ALIAS FOR "fx_get_next_key_id"
subroutine fx_get_next_key_id(string a_key_type, ref string return_val ) RPCFUNC ALIAS FOR "fx_get_next_key_id"

//  05/18/2011  limin Track Appeon Performance Tuning
subroutine ue_refer_case_part(string p_case_id,string p_case_spl,string p_case_ver,string p_case_newver,  &
string p_refer_user,string p_refer_dept,string v_oldcase,string v_olduser,string v_GcUserId,  & 
ref string return_val ) RPCFUNC ALIAS FOR "UE_REFER_CASE_PART"

//  06/13/2011  limin Track Appeon Performance Tuning
subroutine ue_reassign_case(string p_case_id,string p_case_spl,string p_case_ver, &
string p_refer_user,string p_refer_dept,string v_olduser,string v_GcUserId,  & 
ref string return_val ) RPCFUNC ALIAS FOR "UE_REASSIGN_CASE"

// 06/24/11 limin Track Appeon Performance Tuning  --reduce call time
subroutine uf_audit_log(string v_case_id,string v_case_spl,string v_case_ver, &
string v_GcUser, string v_message, ref string return_val ) RPCFUNC ALIAS FOR "UF_AUDIT_LOG"

//07/14/11 LiangSen Track Appeon Performance tuning
subroutine uf_insert_patient_id(string	as_sql,ref string as_return) rpcfunc alias for "UF_INSERT_PATIENT_ID"


end prototypes

type variables
// 04/28/11 AndyG Track Appeon UFA Work around SQLCA.LOCK
String				is_lock

// Embedded SQL used in of_execute()
Protected		String	is_sql
end variables

forward prototypes
public function integer of_disconnect ()
public function integer of_commit ()
public function integer of_rollback ()
public function boolean of_isconnected ()
public function integer of_check_status (string as_sql)
public subroutine of_set_sql (string as_sql)
public function integer of_copyto (ref transaction atr_target)
public function integer of_insert (string as_sql)
public function integer of_set_textsize ()
public function integer of_execute (string as_sql)
public function integer of_connect ()
public function integer of_check_status ()
public subroutine of_set_autocommit (boolean ab_switch)
public subroutine of_execute_sqls (string as_sql[])
public function string of_get_next_key_id (string as_key_type)
public subroutine of_ue_refer_case_part (string as_case_id, string as_case_spl, string as_case_ver, string as_case_newver, string as_refer_user, string as_refer_dept, string as_oldcase, string as_olduser, string as_gcuserid, ref string as_return_val)
public subroutine of_ue_reassign_case (string as_case_id, string as_case_spl, string as_case_ver, string as_refer_user, string as_refer_dept, string as_olduser, string as_gcuserid, ref string as_return_val)
public subroutine of_uf_audit_log (string as_case_id, string as_case_spl, string as_case_ver, string as_gcuser, string as_message, ref string as_return_val)
public subroutine of_uf_insert_patient_id (string as_sql, ref string as_return)
end prototypes

public function integer of_disconnect ();//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_disconnect
//
//	Arguments:	None
//
//	Returns:
//			Integer - SQLCA.SQLCode.  You don't want to open the Database error
//							window (via of_check_status() ) if you are attempting
//							to disconnect from a transaction that's not connected.
//
//	Description:
//		This function will connect to this transaction.
//
//////////////////////////////////////////////////////////////////////////////

is_sql	=	'Disconnect '		// Save the SQL for of_check_status()

DISCONNECT	USING	This ;

Return	SQLCA.SQLCode

end function

public function integer of_commit ();//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_commit
//
//	Arguments:	None
//
//	Returns:
//			Integer - Function of_check_status() returns SQLCode
//
//	Description:
//		This function will connect to this transaction.
//
//////////////////////////////////////////////////////////////////////////////

Integer	li_rc

is_sql	=	'Commit using This'		// Save the SQL for of_check_status()

COMMIT	USING	This ;

li_rc	=	of_check_status()

IF	li_rc	<	0		THEN
//	This.of_rollback()
END IF

Return	li_rc

end function

public function integer of_rollback ();//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_rollback
//
//	Arguments:	None
//
//	Returns:
//			Integer - Function of_check_status() returns SQLCode
//
//	Description:
//		This function will rollback any database changes.
//
//////////////////////////////////////////////////////////////////////////////

is_sql	=	'Rollback using This'		// Save the SQL for of_check_status()

ROLLBACK	USING	This ;

Return	of_check_status()

end function

public function boolean of_isconnected ();//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_isconnected
//
//	Arguments:	None
//
//	Returns:		Boolean 
//					TRUE	=	You are connected to this transaction
//					FALSE =	You are not connected to this transaction
//
//	Description:
//		This function will determine if this transaction is connected.
//
//////////////////////////////////////////////////////////////////////////////

IF	This.DBHandle()	=	0		THEN
	Return	FALSE
ELSE
	Return	TRUE
END IF

end function

public function integer of_check_status (string as_sql);//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_check_status - Overloaded function
//
//	Parms:	as_sql - The embedded SQL just executed.
//
//	Description:
//		This routine is called whenever embedded SQL is used and will check
//		the SQLCode for errors.  If an error occured, open w_db_error with
//		the error information.  Function of_check_status() is called to do 
//		this.
//
//////////////////////////////////////////////////////////////////////////////


is_sql	=	as_sql

Return	This.of_check_status()

end function

public subroutine of_set_sql (string as_sql);//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_set_sql
//
//	Arguments:	as_sql
//
//	Returns:		None
//
//	Description:
//		This function saves the SQL passed to this function in case an 
//		error occurs with any embedded SQL calls.
//
//////////////////////////////////////////////////////////////////////////////

is_sql	=	as_sql

end subroutine

public function integer of_copyto (ref transaction atr_target);//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_copyto
//
//	Arguments:	atr_target - The target transaction object (by reference)
//
//	Returns:		Integer
//					 1 = Successful
//					-1 = Error
//
//	Description:
//		This function copies the contents of this object to the transaction
//		object passed in.
//
// 04/28/11 AndyG Track Appeon UFA Work around SQLCA.LOCK
//////////////////////////////////////////////////////////////////////////////

//	Check arguments
IF	NOT	IsValid (atr_target)		THEN
	Return -1
END IF

// Copy the transaction values

atr_target.DBMS				=	This.DBMS
atr_target.Database			=	This.Database
atr_target.LogID				=	This.LogID
atr_target.LogPass			=	This.LogPass
atr_target.ServerName		=	This.ServerName
atr_target.UserID				=	This.UserID
atr_target.DBPass				=	This.DBPass
// 04/28/11 AndyG Track Appeon UFA
//atr_target.Lock				=	This.Lock
//atr_target.is_lock				=	This.is_lock
atr_target.DbParm				=	This.DbParm
atr_target.Autocommit		=	This.Autocommit
atr_target.sqlcode			=	This.sqlcode
atr_target.sqldbcode			=	This.sqldbcode
atr_target.sqlnrows			=	This.sqlnrows
atr_target.sqlerrtext		=	This.sqlerrtext
atr_target.sqlreturndata	=	This.sqlreturndata

Return 1

end function

public function integer of_insert (string as_sql);//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_insert
//
//	Arguments:
//			as_sql - The SQL to execute
//
//	Returns:
//			Integer - Function of_check_status() returns SQLCode
//
//	Description:
//			This function will execute the embedded SQL passed.  It will then
//			check the status and ignore the status if a duplicate insert occurred.
//
//	Note:	This function was created as an alternative to using 'Ignore Dup Key'
//			in ASE.
//
//////////////////////////////////////////////////////////////////////////////
//
//	FDG	12/07/00	Stars 4.7.  Created.
//
//////////////////////////////////////////////////////////////////////////////

Boolean	lb_duplicate

is_sql	=	as_sql		// Save the SQL for of_check_status()

Execute Immediate	:as_sql	Using	This ;

lb_duplicate	=	gnv_sql.of_is_duplicate_insert (This.sqldbcode)

IF	lb_duplicate		THEN
	Return	0
ELSE
	Return	This.of_check_status()
END IF


end function

public function integer of_set_textsize ();//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_set_textsize
//
//	Description:
//		This routine is called whenever we connect to the database. Default
//		textsize on the database is set to 32K.  Must increase it to 2 gig
//		to allow retrieval of large Notes.
//
//////////////////////////////////////////////////////////////////////////////
//	Modification History
//
//	NLG	10-13-99	Created.
//	FDG	12/12/00	Stars 4.7.  Make SQL DBMS-independent.
//	08/06/08	GaryR	SPR 5407	Add a class to support MSS variations
//
//////////////////////////////////////////////////////////////////////////////

String	ls_sql

ls_sql	=	Trim ( gnv_sql.of_get_textsize () )

IF	ls_sql	>	' '	THEN
	IF	This.of_execute (ls_sql)	<>	0		THEN
		Messagebox('Database Error','Error setting textsize. SQL: ' + ls_sql )
		return -1
	END IF
END IF

Return 1
end function

public function integer of_execute (string as_sql);//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_execute
//
//	Arguments:
//			as_sql - The SQL to execute
//
//	Returns:
//			Integer - Function of_check_status() returns SQLCode
//
//	Description:
//		This function will execute the embedded SQL passed.  It will then
//		check the status.
//
//////////////////////////////////////////////////////////////////////////////

is_sql	=	as_sql		// Save the SQL for of_check_status()

Execute Immediate	:as_sql	Using	This ;

Return	of_check_status()

end function

public function integer of_connect ();//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_connect
//
//	Arguments:	None
//
//	Returns:
//			Integer - Function of_check_status() returns SQLCode
//
//	Description:
//		This function will connect to this transaction.
//
//////////////////////////////////////////////////////////////////////////////
//	Modifications:
//	NLG	10-13-99	If successful connect, call of_set_textsize()
//	FDG	02/21/01	Once connect, execute the SQL to change the database owner.
//						This only applies when connecting to an Oracle database.
//	GaryR	12/17/04	Track 4142d	Identify individual user sessions in the database
// 04/29/11 AndyG Track Appeon UFA Work around SQLCA.LOCK
// 06/16/2011  limin Track Appeon Performance Tuning
//
//////////////////////////////////////////////////////////////////////////////

Int		li_rc, li_settext	//NLG 10-13-99
String	ls_schema_sql, ls_session_sql
String	ls_sql	,	ls_execsql[]
int		li_i			// 06/17/2011  limin Track Appeon Performance Tuning

is_sql	=	'Connect using This'		// Save the SQL for of_check_status()

CONNECT	USING	This ;

li_rc = of_check_status()

//NLG 10-13-99
if li_rc = 0 then

	// 04/29/11 AndyG Track Appeon UFA Added.
	If Len(Trim(This.is_Lock)) > 0 Then
		ls_sql =  'SET TRANSACTION ISOLATION LEVEL ' + this.is_Lock + ';'
		// 06/16/2011  limin Track Appeon Performance Tuning
		li_rc	=	This.of_execute (ls_sql)
		li_i ++
		ls_execsql[li_i] = ls_sql
	End If
	
	li_settext = of_set_textsize()
	// FDG 02/21/01 begin
	ls_schema_sql	=	gnv_sql.of_get_schema_sql()
	IF	IsNull (ls_schema_sql)			&
	OR	Trim (ls_schema_sql)		< ' '	THEN
	ELSE
		// Schema SQL found (probably for Oracle).  Execute it.
		is_sql	=	ls_schema_sql
		// 06/16/2011  limin Track Appeon Performance Tuning
		li_rc	=	This.of_execute (ls_schema_sql)
		li_i	++
		ls_execsql[li_i] = ls_schema_sql
	END IF
	// FDG 02/21/01 end
	
	//	Set unique session
	ls_session_sql = gnv_sql.of_get_session_sql()
	IF NOT IsNull( ls_session_sql ) AND Trim( ls_session_sql ) <> "" THEN
		is_sql	=	ls_session_sql
		// 06/16/2011  limin Track Appeon Performance Tuning
		li_rc	=	This.of_execute (ls_session_sql)
		li_i	++
		ls_execsql[li_i] = ls_session_sql
	END IF
	
//	// 06/16/2011  limin Track Appeon Performance Tuning
//	gn_appeondblabel.of_startqueue()
//	this.of_execute_sqls(ls_execsql)
//	gn_appeondblabel.of_commitqueue()
	
end if

Return	li_rc
end function

public function integer of_check_status ();//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_check_status
//
//	Description:
//		This routine is called whenever embedded SQL is used and will check
//		the SQLCode for errors.  If an error occured, open w_db_error with
//		the error information.
//
//////////////////////////////////////////////////////////////////////////////
//	Modification History
//
//	FDG	02/17/98	Added dataobject to the structure.
// JasonS 08/15/02 Track 3098d  only return -1 and error out if not currently idled
//
//////////////////////////////////////////////////////////////////////////////

str_db_error	lstr_db

CHOOSE CASE This.SQLCode
	CASE 0
		is_sql	=	''
		Return This.SQLCode
	CASE 100
		is_sql	=	''
		Return This.SQLCode
END CHOOSE

// SQLCode = -1 - An error occured

// Disclaimer
// ----------
//	The purpose of the of_get_idle check is to deal with the issues of having sql in the activate
// event of a window.  After idling, the activate event fires before the database re-connection is
// made.  Thus we need to check that and return a 0 if we are currently idle.  This will prevent the 
// sql in the activate event from giving the user an invalid database error.

// JasonS 08/15/02 Begin - Track 3098d
//	Check if currently timed out
IF NOT gnv_app.of_get_idle() THEN Return 0
// JasonS 08/15/02 End - Track 3098d

String	ls_message

ls_message = "A database error has occurred in " + &
	gnv_app.of_get_appname() + "."
	
lstr_db.trans				=	This
lstr_db.message			=	ls_message
lstr_db.row_num			=	0
lstr_db.sqldbcode			=	This.sqldbcode
lstr_db.sqlerrtext		=	This.sqlerrtext
lstr_db.sqlreturndata	=	This.sqlreturndata

lstr_db.sqlsyntax			=	is_sql
lstr_db.dataobject		=	'Embedded SQL'

is_sql	=	''

OpenWithParm (w_db_error, lstr_db)

Return This.SQLCode

end function

public subroutine of_set_autocommit (boolean ab_switch);//----------------------------------------------------------------------------------//
//	Script	  	n_tr.of_set_autocommit
//	Arguments	ab_switch - Boolean
//----------------------------------------------------------------------------------//
//	Description	Sets the AutoCommit flag for the transaction object
//		
//	09/11/03	MikeF	3655d	Added function to set AutoCommit 
//----------------------------------------------------------------------------------//
This.autocommit = ab_switch
end subroutine

public subroutine of_execute_sqls (string as_sql[]);//////////////////////////////////////////////////////////////////////////////
//
//	Script:  n_tr.of_execute_sqls
//
//	Arguments:
//			array as_sql - The SQL to execute
//
//	Returns:
//			None
//
//	Description:
//		This function will execute the embedded SQL passed.  If it check the status
//		not is zero then return.
// 05/10/11 WinacentZ Track Appeon Performance tuning.
// 05/27/11 AndyG Track Appeon Performance tuning
//
//////////////////////////////////////////////////////////////////////////////

Long		ll_i, ll_count
String		ls_sql

// 05/27/11 AndyG Track Appeon Performance tuning
ll_count = UpperBound(as_sql)

For ll_i = 1 To ll_count
	ls_sql = as_sql[ll_i]
	// 05/27/11 AndyG Track Appeon Performance tuning
	If IsNull(ls_sql) Or Trim(ls_sql) = "" Then Continue
	Execute Immediate :ls_sql Using Stars2ca;
	If Not gb_is_web Then
		If This.Sqlcode <> 0 Then
			Return
		End If
	End If
Next

end subroutine

public function string of_get_next_key_id (string as_key_type);/************************************************
//
//	Script:  n_tr.of_get_next_key_id
//
//	Arguments:
//			as_key_type - The key type
//
//	Returns:
//			string - Return the next key id.
//
//	Description:
//
//
***********************************************/
//
// 05/12/11 AndyG Track Appeon Performance tuning
// 07/06/11 limin Track Appeon Performance Tuning 
// 10/12/11 limin Track Appeon Performance Tuning --fix bug
//
//////////////////////////////////////////////////////////////////////////////

String ls_key_id

If  gs_dbms  =  'ASE'  then
	DECLARE p_fx_get_next_key_id PROCEDURE FOR dbo.fx_get_next_key_id
	@a_key_type =:as_key_type, @return_val =:ls_key_id output  using this;
	EXECUTE p_fx_get_next_key_id ;
	FETCH p_fx_get_next_key_id INTO :ls_key_id ;
	CLOSE p_fx_get_next_key_id;
Else
	ls_key_id = Space(50)
	This.fx_get_next_key_id(as_key_type,ls_key_id)
End If

// 07/06/11 limin Track Appeon Performance Tuning  --reduce call time
//If This.of_check_status() <> 0 Then  
If This.of_check_status() <> 0 or ls_key_id = 'ERROR' or trim(ls_key_id)='' Then 
	Errorbox(stars2ca,'Error Updating System Control Table')
	RETURN 'ERROR'
Else
	This.of_commit()  
	Return ls_key_id
End If
end function

public subroutine of_ue_refer_case_part (string as_case_id, string as_case_spl, string as_case_ver, string as_case_newver, string as_refer_user, string as_refer_dept, string as_oldcase, string as_olduser, string as_gcuserid, ref string as_return_val);//====================================================================
// Function: of_ue_refer_case_part()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value        string    as_case_id
// 	value        string    as_case_spl
// 	value        string    as_case_ver
// 	value        string    as_case_newver
// 	value        string    as_refer_user
// 	value        string    as_refer_dept
// 	value        string    as_oldcase
// 	value        string    as_olduser
// 	value        string    as_gcuserid
// 	reference    string    as_return_val
//--------------------------------------------------------------------
// Returns:  (None)
//--------------------------------------------------------------------
// Author:	limin		Date: 05/18/2011
//--------------------------------------------------------------------
//	Copyright (c) 2008-2011 Appeon, All rights reserved.
//--------------------------------------------------------------------
// Modify History:
////  05/18/2011  limin Track Appeon Performance Tuning
//====================================================================

If  gs_dbms  =  'ASE'  then	
	DECLARE p_ue_refer_case_part PROCEDURE FOR dbo.UE_REFER_CASE_PART
	@p_case_id =:as_case_id,@p_case_spl =:as_case_spl,@p_case_ver =:as_case_ver,@p_case_newver =:as_case_newver,
	@p_refer_user =:as_refer_user,@p_refer_dept =:as_refer_dept,@v_oldcase =:as_oldcase,@v_olduser =:as_olduser,@v_GcUserId =:as_GcUserId,@return_val =:as_return_val output  using this;
	EXECUTE p_ue_refer_case_part ;
	FETCH p_ue_refer_case_part INTO :as_return_val ;
	CLOSE p_ue_refer_case_part;
Else
	as_return_val = space(200)
	
	This.ue_refer_case_part(as_case_id,as_case_spl,as_case_ver,as_case_newver,as_refer_user, &
		as_refer_dept,as_oldcase, as_olduser,as_GcUserId,as_return_val	)	
End If

end subroutine

public subroutine of_ue_reassign_case (string as_case_id, string as_case_spl, string as_case_ver, string as_refer_user, string as_refer_dept, string as_olduser, string as_gcuserid, ref string as_return_val);//====================================================================
// Function: of_ue_reassign_case()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value        string    as_case_id
// 	value        string    as_case_spl
// 	value        string    as_case_ver
// 	value        string    as_refer_user
// 	value        string    as_refer_dept
// 	value        string    as_olduser
// 	value        string    as_gcuserid
// 	reference    string    as_return_val
//--------------------------------------------------------------------
// Returns:  (None)
//--------------------------------------------------------------------
// Author:	limin		Date: 06/13/2011
//--------------------------------------------------------------------
//	Copyright (c) 2008-2011 Appeon, All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

If  gs_dbms  =  'ASE'  then	
	DECLARE p_ue_reassign_case PROCEDURE FOR dbo.UE_REASSIGN_CASE
	@p_case_id  =:as_case_id,@p_case_spl  =:as_case_spl,@p_case_ver =:as_case_ver,@p_refer_user =:as_refer_user,
	@p_refer_dept =:as_refer_dept,@v_olduser =:as_olduser,@v_GcUserId =:as_GcUserId,@return_val =:as_return_val output  using this;
	EXECUTE p_ue_reassign_case ;
	FETCH p_ue_reassign_case INTO :as_return_val ;
	CLOSE p_ue_reassign_case;
Else
	as_return_val = space(200)
	
	This.ue_reassign_case(as_case_id,as_case_spl,as_case_ver,as_refer_user, &
		as_refer_dept, as_olduser,as_GcUserId,as_return_val )	
End If

end subroutine

public subroutine of_uf_audit_log (string as_case_id, string as_case_spl, string as_case_ver, string as_gcuser, string as_message, ref string as_return_val);//====================================================================
// Function: of_uf_audit_log()
//--------------------------------------------------------------------
// Description:	replace function n_cst_case.uf_audit_log 
//--------------------------------------------------------------------
// Arguments:
// 	value        string    as_case_id
// 	value        string    as_case_spl
// 	value        string    as_case_ver
// 	value        string    as_gcuser
// 	value        string    as_message
// 	reference    string    as_return_val
//--------------------------------------------------------------------
// Returns:  (None)
//--------------------------------------------------------------------
// Author:	limin		Date: 06/24/11
//--------------------------------------------------------------------
//	Copyright (c) 2008-2011 Appeon, All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

If  gs_dbms  =  'ASE'  then	
	DECLARE p_uf_audit_log PROCEDURE FOR dbo.UF_AUDIT_LOG
	@v_case_id =:as_case_id,@v_case_spl =:as_case_spl,@v_case_ver =:as_case_ver,@v_GcUser =:as_gcuser,
	@v_message =:as_message,@return_val =:as_return_val output  using this;
	EXECUTE p_uf_audit_log ;
	FETCH p_uf_audit_log INTO :as_return_val ;
	CLOSE p_uf_audit_log;
Else
	as_return_val = space(200)
	
	This.uf_audit_log(as_case_id,as_case_spl,as_case_ver,as_gcuser, as_message,as_return_val )	
End If

end subroutine

public subroutine of_uf_insert_patient_id (string as_sql, ref string as_return);// Function: of_uf_insert_patient_id()
//--------------------------------------------------------------------
// Description:	replace function n_cst_case.uf_audit_log 
//--------------------------------------------------------------------
// Arguments:
// 	value        string    as_sql
// 	value        string    as_return

//--------------------------------------------------------------------
// Returns:  (None)
//--------------------------------------------------------------------
// Author:	LiangSen		Date: 07/14/11
//--------------------------------------------------------------------
//	Copyright (c) 2008-2011 Appeon, All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

If  gs_dbms  =  'ASE'  then	
	DECLARE p_uf_insert_patient_id PROCEDURE FOR dbo.UF_INSERT_PATIENT_ID
	@v_sql =:as_sql,@v_return =:as_return output  using this;
	EXECUTE p_uf_insert_patient_id ;
	FETCH p_uf_insert_patient_id INTO :as_return ;
	CLOSE p_uf_insert_patient_id;
Else
	as_return = space(4)
	this.uf_insert_patient_id(as_sql,as_return)	
End If

end subroutine

on n_tr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

