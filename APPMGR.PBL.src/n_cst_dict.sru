$PBExportHeader$n_cst_dict.sru
$PBExportComments$Includes functions to be performed on dictionary - Autoinstantiated <logic>
forward
global type n_cst_dict from n_base
end type
end forward

global type n_cst_dict from n_base descriptor "PB_ObjectCodeAssistants" = "{BB0DD54A-B36E-11D1-BB47-000086095DDA}" 
event type string ue_get_table_desc ( string as_inv_type )
event type string ue_get_table_name ( string as_inv_type )
event type string ue_get_col_desc ( string as_inv_type,  string as_col_name )
event type string ue_get_inv_type ( string as_table_name )
event type string ue_get_data_type ( string as_inv_type,  string as_col_name )
event type string ue_get_lookup_type ( string as_inv_type,  string as_col_name )
event type string ue_get_database_name ( string as_inv_type )
event type integer ue_get_data_len ( string as_inv_type,  string as_col_name )
event type string ue_build_dict_sql_select ( string as_table_name )
event type boolean ue_get_is_computed ( string as_inv_type,  string as_col_name )
event type string ue_get_formula ( string as_inv_type,  string as_col_name )
event type boolean ue_get_is_indexed ( string as_inv_type,  string as_col_name )
event type string ue_get_disp_format ( string as_inv_type,  string as_col_name )
event type string ue_get_elem_label ( string as_inv_type,  string as_col_name )
event type boolean ue_get_col_exists ( string as_inv_type,  string as_col_name )
event type string ue_get_elem_data_type ( string as_inv_type,  string as_col_name )
event type string ue_get_table_type ( string as_table_name )
event type integer ue_get_min_length ( string as_inv_type,  string as_col_name )
event type integer ue_get_lead_alpha ( string as_inv_type,  string as_col_name )
event type string ue_get_edit_mask ( string as_inv_type,  string as_col_name )
event type string ue_get_value_a ( string as_inv_type,  string as_col_name )
event type integer ue_get_crit_seq ( string as_inv_type,  string as_col_name )
end type
global n_cst_dict n_cst_dict

type variables
n_ds ids_table_desc
n_ds ids_table_name
n_ds ids_col_desc
n_ds ids_invoice_type

constant	string	ics_not_found 	= 'NOTFOUND'
constant	string	ics_error		= 'ERROR'
constant	string	ics_inv_type	= '@INV'
// 06/08/11 LiangSen Track Appeon Performance tuning
long	ii_invoice_type_count,ii_col_desc_count,&
		ii_table_name_count,ii_filter_count,&
		ii_disp_seq_count,ii_find_row
n_ds  ids_disp_seq  
string	is_table_name
//end LiangSen
end variables

forward prototypes
public function long uf_retrieve_column (string as_inv_type, string as_col_name)
public function string uf_get_string (string as_inv_type, string as_col_name, string as_dict_col)
public function integer uf_get_int (string as_inv_type, string as_col_name, string as_dict_col)
public function string uf_get_select_all (string as_tbl_type, boolean ab_prefix)
public function any uf_get_col_array (string as_tbl_type, boolean ab_prefix)
public function integer uf_get_dict_info (string as_tbl_type, ref sx_dictionary_data asx_data[])
public function integer uf_get_info_index (sx_dictionary_data asx_data[], string as_col_name)
public function any uf_get_select_all (string as_tbl_type, boolean ab_prefix, boolean ab_disp_seq_sort)
public function string uf_get_col_desc (string as_col_desc)
public subroutine uf_appeon_select_data ()
end prototypes

event type string ue_get_table_desc(string as_inv_type);/////////////////////////////////////////////////////////////////////////////
// Event/Function						Object				
//	--------------						------				
//	ue_get_table_desc					n_cst_dict
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
// This event retrieves a table decsription from the dictionary.
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument			Datatype			Description
//		---------	--------			--------			-----------
//		Value			as_inv_type		string			Invoice Type
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value				Description
//		--------		-----				-----------
//	 	String		ls_table_desc	Description of the table that matches the invoice type	
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	FNC				11/08/99		Created.
// 05/04/11 WinacentZ Track Appeon Performance tuning
//
/////////////////////////////////////////////////////////////////////////////

integer	li_rc

long		li_row,	&
			li_pos,	&
			li_rowcount
			

string	ls_table_desc

ids_table_desc.dataobject = 'd_table_desc'
li_rc = ids_table_desc.setTransObject(stars2ca)
if li_rc <> 1 then
	Messagebox('STARS','Error in SetTransObject for ids_table_desc'+&
						'~rin n_cst_dict::ue_get_table_desc()')
	return 'ERROR'
end if

//retrieve table name from dictionary
li_rowcount = ids_table_desc.retrieve(as_inv_type)
if li_rowcount = 1 then
	// 05/04/11 WinacentZ Track Appeon Performance tuning
//	ls_table_desc = ids_table_desc.object.elem_desc[1]	
	ls_table_desc = ids_table_desc.GetItemString(1, "elem_desc")
else
	Messagebox('STARS','Error retrieving from Dictionary for ids_table_desc' +&
						'~rin n_cst_dict::ue_get_table_desc()')
	return ics_error
end if

// Get the name to left of '/' or the 1st 15 bytes
li_pos = Pos (ls_table_desc, '/')
IF li_pos > 0  THEN
	ls_table_desc = left(ls_table_desc,li_pos - 1)
END IF

return ls_table_desc
end event

event type string ue_get_table_name(string as_inv_type);/////////////////////////////////////////////////////////////////////////////
// Event/Function						Object				
//	--------------						------				
//	ue_get_table_name					n_cst_dict
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
// This event retrieves a table name from the dictionary.
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument			Datatype			Description
//		---------	--------			--------			-----------
//		Value			as_inv_type		string			Invoice Type
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value				Description
//		--------		-----				-----------
//	 	String		ls_table_name	Name of the table that matches the invoice type	
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	FNC				11/08/99		Created.
// 05/04/11 WinacentZ Track Appeon Performance tuning
// 07/18/11 WinacentZ Track Appeon Performance tuning-fix bug
//
/////////////////////////////////////////////////////////////////////////////

integer	li_rc

long		li_row,	&
			li_pos,	&
			li_rowcount
			

string	ls_table_name

// 07/18/11 WinacentZ Track Appeon Performance tuning-fix bug
//ids_table_name.dataobject = 'd_dict_table_name'
//li_rc = ids_table_name.setTransObject(stars2ca)
//if li_rc <> 1 then
//	Messagebox('STARS','Error in SetTransObject for ids_table_name'+&
//						'~rin n_cst_dict::ue_get_table_name()')
//	RETURN ics_error
//end if
//
////retrieve table name from dictionary
//li_rowcount = ids_table_name.retrieve(as_inv_type,'%')

// 07/18/11 WinacentZ Track Appeon Performance tuning-fix bug
if ii_table_name_count <= 0 then
	ids_table_name.dataobject = 'd_dict_table_name'
	li_rc = ids_table_name.setTransObject(stars2ca)
	if li_rc <> 1 then
		Messagebox('STARS','Error in SetTransObject for ids_table_name'+&
						'~rin n_cst_dict::ue_get_table_name()')
		return ics_error
	end if
	ii_table_name_count = ids_table_name.retrieve('%','%')
end if
ids_table_name.setfilter('')
ids_table_name.filter()
ids_table_name.setfilter("upper(ELEM_TBL_TYPE) like '"+upper(as_inv_type)+"'")
ids_table_name.filter()
li_rowcount = ids_table_name.rowcount()

CHOOSE CASE li_rowcount
	CASE IS > 0
		// 05/04/11 WinacentZ Track Appeon Performance tuning
//		ls_table_name = ids_table_name.object.elem_name[1]	
		ls_table_name = ids_table_name.GetItemString(1, "elem_name")
	CASE 0 
		ls_table_name = ics_not_found
	CASE ELSE
		Messagebox('STARS','Error retrieving from Dictionary for ids_table_name' +&
						'~rin n_cst_dict::ue_get_table_name()')
		RETURN ics_error
END CHOOSE

return ls_table_name



end event

event type string ue_get_col_desc(string as_inv_type, string as_col_name);/////////////////////////////////////////////////////////////////////////////
// Event/Function						Object				
//	--------------						------				
//	ue_get_col_desc					n_cst_dict
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
// This event retrieves a column decsription from the dictionary.
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument			Datatype			Description
//		---------	--------			--------			-----------
//		Value			as_inv_type		string			Invoice Type
//		Value			as_col_name		string			Column Name
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value				Description
//		--------		-----				-----------
//	 	String		ls_col_desc		Description of the column that matches the 
//											invoice type and column name
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author	Date			Description
// ------	----			-----------
//	FNC		11/08/99		Created.
//	FDG		02/06/01		Stars 4.6 - PIMR.  If the data was already retrieved,
//								don't retrieve it again.  This requires a change to
//								the retrieval arguments to d_col_desc.
// MikeF 10/13/04 SPR3650d	Rewrote
//////////////////////////////////////////////////////////////////////////////////////
string	ls_col_desc
int		li_pos

ls_col_desc = This.uf_get_string( as_inv_type, as_col_name, "ELEM_DESC")

// Get the name to left of '/' or the 1st 15 bytes
Li_pos = Pos (ls_col_desc, '/')
IF li_pos = 0  &
OR li_pos > 16  THEN
	Li_pos = 16
END IF

ls_col_desc = Left ((ls_col_desc), li_pos - 1)

RETURN ls_col_desc
end event

event type string ue_get_inv_type(string as_table_name);/////////////////////////////////////////////////////////////////////////////
// Event/Function						Object				
//	--------------						------				
//	ue_get_inv_type					n_cst_dict
/////////////////////////////////////////////////////////////////////////////
//	Description
//	-----------
// This event retrieves a invoice type from the dictionary.
/////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//		Passed by	Argument			Datatype			Description
//		---------	--------			--------			-----------
//		Value			as_table_name	string			table name
/////////////////////////////////////////////////////////////////////////////
//	RETURNS
//		Datatype		Value				 Description
//		--------		-----				 -----------
//	 	String		ls_invoice_type Invoice type that matches the table name	
/////////////////////////////////////////////////////////////////////////////
//	HISTORY
//
// Author			Date			Description
// ------			----			-----------
//	AJS				11/18/99		Created.
// 05/04/11 WinacentZ Track Appeon Performance tuning
//  05/19/2011  limin Track Appeon Performance Tuning
// 06/08/11 LiangSen Track Appeon Performance tuning
// 09/22/11 LiangSen Track Appeon Performance tuning - fix bug
// 11/14/11 LiangSen Track Appeon Performance tuning - fix bug
/////////////////////////////////////////////////////////////////////////////

integer	li_rc

long		li_row,	&
			li_pos,	&
			li_rowcount
			

string	ls_invoice_type
long		li_foundrow            // 06/08/11 LiangSen Track Appeon Performance tuning

/*  06/08/11 LiangSen Track Appeon Performance tuning
//  05/19/2011  limin Track Appeon Performance Tuning
ids_invoice_type.DBCancel()
ids_invoice_type.reset()
//  05/19/2011  limin Track Appeon Performance Tuning

ids_invoice_type.dataobject = 'd_invoice_type'      
li_rc = ids_invoice_type.setTransObject(stars2ca)
if li_rc <> 1 then
	Messagebox('STARS','Error in SetTransObject for ids_invoice_type'+&
						'~rin n_cst_dict::ue_get_inv_type()')
	RETURN ics_error
end if

//retrieve invoice_type from dictionary
li_rowcount = ids_invoice_type.retrieve(as_table_name)  
*/
//  06/08/11 LiangSen Track Appeon Performance tuning
if ii_invoice_type_count = 0 then
	ids_invoice_type.dataobject = 'd_appeon_invoice_type'  
	li_rc = ids_invoice_type.SetTransObject(stars2ca)
	if li_rc <> 1 then
		Messagebox('STARS','Error in SetTransObject for ids_invoice_type'+&
							'~rin n_cst_dict::ue_get_inv_type()')
		RETURN ics_error
	end if
	ii_invoice_type_count = ids_invoice_type.retrieve()  
end if
// end LiangSen

/*06/08/11 LiangSen Track Appeon Performance tuning
if li_rowcount = 1 then
	// 05/04/11 WinacentZ Track Appeon Performance tuning
//	ls_invoice_type = ids_invoice_type.object.elem_tbl_type[1]	
	ls_invoice_type = ids_invoice_type.GetItemString(1, "elem_tbl_type")
else
	Messagebox('STARS','Error retrieving from Dictionary for ids_invoice_type' +&
						'~rin n_cst_dict::ue_get_inv_type()')
	RETURN ics_error
end if
*/
//06/08/11 LiangSen Track Appeon Performance tuning
if ii_invoice_type_count > 0 Then
	li_foundrow = ids_invoice_type.Find("upper(ELEM_NAME) = '"+upper(as_table_name)+"'",1,ii_invoice_type_count)
	if li_foundrow > 0 then		// 09/22/11 LiangSen Track Appeon Performance tuning - fix bug
		ls_invoice_type = ids_invoice_type.GetItemString(li_foundrow, "elem_tbl_type")
	else		
		//Modify by LiangSen 11/14/11
		ii_invoice_type_count = ids_invoice_type.retrieve()  
		li_foundrow = ids_invoice_type.Find("upper(ELEM_NAME) = '"+upper(as_table_name)+"'",1,ii_invoice_type_count)
		if li_foundrow > 0 Then
			ls_invoice_type = ids_invoice_type.GetItemString(li_foundrow, "elem_tbl_type")
		else
			Messagebox('STARS','Error retrieving from Dictionary for ids_invoice_type' +&
						'~rin n_cst_dict::ue_get_inv_type()')
			RETURN ics_error
		end if
		//End Ls
		// Modify by LiangSEN 11/14/11
//		Messagebox('STARS','Error retrieving from Dictionary for ids_invoice_type' +&
//						'~rin n_cst_dict::ue_get_inv_type()')
//		RETURN ics_error
	end if
else
	Messagebox('STARS','Error retrieving from Dictionary for ids_invoice_type' +&
						'~rin n_cst_dict::ue_get_inv_type()')
	RETURN ics_error
end if
//end
return ls_invoice_type
end event

event type string ue_get_data_type(string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_data_type
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			String - The column's data type.
//
//	Description:	Get the data type for a column from dictionary.  If the data type
//						is char or varchar, also return the length.
//
//
//////////////////////////////////////////////////////////////////////////////////////
//
//	FDG	06/26/00	Track 2934 (4.5 SP1).  Created.
//	FDG	07/10/00	Track 2891 (4.5 SP1).  Use uf_retrieve_column() to retrieve
//						the data from dictionary.
//	FDG	12/14/00	Stars 4.7.  Make checking of data types DBMS-independent
//	FDG	05/02/01	Track 3395 (4.6).	uf_retrieve_column() retrieves multiple rows.
// MikeF 10/13/04 SPR3650d	Computed columns. Rewrote
// 05/04/11 WinacentZ Track Appeon Performance tuning
// 08/19/11 LiangSen Track Appeon Performance tuning - fix bug ase 
//////////////////////////////////////////////////////////////////////////////////////
string	ls_data_type
int		li_data_len, li_scale

ls_data_type = This.uf_get_string( as_inv_type, as_col_name, "ELEM_DATA_TYPE")

IF	ls_data_type	= ics_not_found &
OR ls_data_type	= ics_error 	 THEN
	// No rows returned. Bypass
ELSE
	// 05/04/11 WinacentZ Track Appeon Performance tuning
//	li_data_len		=	ids_col_desc.object.elem_data_len [1]	
//	li_scale			=	ids_col_desc.object.elem_data_scale [1]	
//	li_data_len		=	ids_col_desc.GetItemNumber(1, "elem_data_len")		// 08/19/11 LiangSen Track Appeon Performance tuning - fix bug ase 
//	li_scale			=	ids_col_desc.GetItemNumber(1, "elem_data_scale")   // 08/19/11 LiangSen Track Appeon Performance tuning - fix bug ase 
	if ii_find_row > 0 then																// 08/19/11 LiangSen Track Appeon Performance tuning - fix bug ase 
		li_data_len		=	ids_col_desc.GetItemNumber(ii_find_row, "elem_data_len") // 08/19/11 LiangSen Track Appeon Performance tuning - fix bug ase 
		li_scale			=	ids_col_desc.GetItemNumber(ii_find_row, "elem_data_scale") // 08/19/11 LiangSen Track Appeon Performance tuning - fix bug ase 
		ii_find_row = 0
	end if

	IF	gnv_sql.of_is_character_data_type (ls_data_type)	THEN
		ls_data_type	+=	'('	+	String(li_data_len)	+	')'
	ELSEIF li_scale	>	0	THEN
		ls_data_type	+=	'('	+	String(li_data_len)	+	&
								','	+	String(li_scale)	+	')'
	ELSEIF li_data_len >	0	THEN
		ls_data_type	+=	'('	+	String(li_data_len)	+	')'
	END IF
END IF

Return	ls_data_type

end event

event type string ue_get_lookup_type(string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_lookup_type
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			String - The column's lookup type.
//
//	Description:	Get the lookup type for a column from dictionary.  
//
//////////////////////////////////////////////////////////////////////////////////////
//
//	FDG	07/10/00	Track 2891 (4.5 SP1).  Created.
//	FDG	05/02/01	Track 3395 (4.6).	uf_retrieve_column() retrieves multiple rows.
// MikeF 10/13/04 SPR3650d	Rewrote
//////////////////////////////////////////////////////////////////////////////////////

RETURN	This.uf_get_string( as_inv_type, as_col_name, "ELEM_LOOKUP_TYPE")
end event

event ue_get_database_name;//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_database_name
//
//	Arguments:		1.	as_inv_type
//
//	Returns:			String - The table's database name
//
//	Description:	Get the database name from dictionary.  
//
//
//////////////////////////////////////////////////////////////////////////////////////
//
//	FDG	11/21/00	Stars 4.7.  Created.
//
//////////////////////////////////////////////////////////////////////////////////////

String	ls_db

Select	db 
into		:ls_db
From		dictionary 
Where		elem_type = 'TB' and 
			elem_tbl_type = Upper( :as_inv_type )
Using Stars2ca;

IF Stars2ca.of_check_status() <> 0 then
	MessageBox ('Error', 'Error reading dictionary to retrieve database name in n_cst_dict.ue_get_database_name')
	Return ''
END IF

Return	ls_db


end event

event type integer ue_get_data_len(string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_data_len
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			Integer - The column's data length.
//
//	Description:	Get the data length for a column from dictionary.  This is mainly
//						used for string (char or varchar2) columns.
//
//
//////////////////////////////////////////////////////////////////////////////////////
//
//	FDG	01/18/02	Track 2691d (5.0).	Created.
// MikeF 10/13/04 SPR3650d	Rewrote
//////////////////////////////////////////////////////////////////////////////////////

RETURN	This.uf_get_int( as_inv_type, as_col_name, "ELEM_DATA_LEN")


end event

event type string ue_build_dict_sql_select(string as_table_name);//////////////////////////////////////////////////////////////////
//	Modification History:
//
// 04/27/11 limin Track Appeon Performance tuning
// 06/14/11 LiangSen Track Appeon Performance tuning
// 06/17/11 LiangSen Track Appeon Performance tuning
//
//////////////////////////////////////////////////////////////////

// Declare Variables
long ll_rowcount
integer 	li_idx, &
			li_len
string	ls_select
//n_ds lds_disp_seq   // 06/14/11 LiangSen Track Appeon Performance tuning

// Instantiate Variables
ls_select = ''

//  Retrieve case log's columns from DICTIONARY in correct order into datastore
/*06/14/11 LiangSen Track Appeon Performance tuning
lds_disp_seq = CREATE n_ds
lds_disp_seq.DataObject = 'd_build_dict_sql_select'
lds_disp_seq.SetTransObject( Stars2ca )

ll_rowcount = lds_disp_seq.Retrieve( as_table_name )
*/
// Begin - 06/14/11 LiangSen Track Appeon Performance tuning
if ii_disp_seq_count <= 0 or as_table_name <> is_table_name Then
	is_table_name = as_table_name
	ii_disp_seq_count = ids_disp_seq.Retrieve( as_table_name )
end if
//end LiangSen

//IF ll_rowcount < 0 THEN	//06/14/11 LiangSen Track Appeon Performance tuning
If ii_disp_seq_count < 0 Then		//06/14/11 LiangSen Track Appeon Performance tuning
	MessageBox('Database Error', 'Error retrieving for elem_tbl_type ' + as_table_name + ' from DICTIONARY ~r~rinto DataStore in n_cst_dict.ue_build_dict_sql_select()')
//	DESTROY lds_disp_seq		//06/14/11 LiangSen Track Appeon Performance tuning
	DESTROY ids_disp_seq		//06/14/11 LiangSen Track Appeon Performance tuning
	Return 'ERROR'
ELSE
	// Commit rows returned to prevent locking
	/*  06/17/11 LiangSen Track Appeon Performance tuning
	Stars2ca.of_commit()	   

	IF Stars2ca.of_check_status() <> 0 THEN
		MessageBox('DataBase Error', 'Error Committing rows from DataStore in w_case_maint.ue_retrieve_log()')
		Return 'ERROR'
	END IF
	*/
	// Build SELECT statement for d_case_log
//	FOR li_idx = 1   TO   ll_rowcount		//06/14/11 LiangSen Track Appeon Performance tuning
	For li_idx = 1   TO 	 ii_disp_seq_count 	 //06/14/11 LiangSen Track Appeon Performance tuning
		// 04/26/11 limin Track Appeon Performance tuning
//		ls_select += as_table_name + '.' + lds_disp_seq.object.elem_name[li_idx] + ", "
//		ls_select += as_table_name + '.' + lds_disp_seq.GetItemString(li_idx,"elem_name") + ", "   //06/14/11 LiangSen Track Appeon Performance tuning
		//06/14/11 LiangSen Track Appeon Performance tuning
		ls_select += as_table_name + '.' + ids_disp_seq.GetItemString(li_idx,"elem_name") + ", "
	NEXT
	
	//  05/25/2011  limin Track Appeon Performance Tuning
//	if (ls_select <> '') then
	if (ls_select <> '' AND NOT ISNULL(ls_select )  ) then
		// Remove the last comma from the end of SELECT statement
		li_len    = Len(ls_select)
		ls_select = "SELECT " + Left(ls_select, li_len -2)
	end if
END IF
//  05/25/2011  limin Track Appeon Performance Tuning
//IF (ls_select <> '') THEN
IF (ls_select <> '' AND NOT ISNULL(ls_select )  ) THEN
	RETURN ls_select
ELSE
	RETURN 'ERROR'
END IF

end event

event type boolean ue_get_is_computed(string as_inv_type, string as_col_name);//====================================================================================//
// Object:			n_cst_dict
//	Script:			ue_get_is_computed
//	Arguments:		String	as_inv_type		ELEM_TBL_TYPE
//						String	as_col_name		ELEM_NAME
//	Returns:			Boolean 						TRUE if Computed
//------------------------------------------------------------------------------------//
// IF ELEM_TYPE = 'CC', COmputed column. Return True
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	MikeF	10/12/04	SPR3650d	Created
//
//====================================================================================//

IF this.uf_get_string(as_inv_type, as_col_name, "ELEM_TYPE") = "CC" THEN
	RETURN TRUE
END IF

RETURN FALSE
end event

event type string ue_get_formula(string as_inv_type, string as_col_name);//====================================================================================//
// Object:			n_cst_dict
//	Script:			ue_get_formula
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//	Returns:			String : The Formula from SQL_FORMULA
//------------------------------------------------------------------------------------//
// Returns the SQL syntax for a computed column
//------------------------------------------------------------------------------------//
// 1. Determines if the current column is computed (ELEM_TYPE='CC')
// 2. Gets FORMULA_ID from the DICTIONARY (VALUE_A)
// 3. Reads and formats the text from SQL_FORMULA for use in a SQL statement
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	MikeF	10/12/04	SPR3650d	Created
//
//====================================================================================//

string			ls_formula_id, ls_formula
int				li_rows, loop_ix
n_ds				lds_formula
n_cst_string	lnv_string

IF NOT this.event ue_get_is_computed(as_inv_type,as_col_name) THEN
	RETURN "ERROR"
END IF

ls_formula_id = this.event ue_get_value_a( as_inv_type, as_col_name)

IF len(ls_formula_id) = 0 THEN
	MessageBox("ERROR","No Formula ID Defined for column " + as_col_name + &
					" for table type " + as_inv_type + ".")
	RETURN "ERROR"
END IF

lds_formula = CREATE n_ds
lds_formula.DataObject = 'd_sql_formula'
lds_formula.SetTransobject( stars2ca )
li_rows = lds_formula.Retrieve( ls_formula_id )

IF li_rows = 0 THEN
	MessageBox("ERROR","No Rows found in SQL_FORMULA for Formula " + ls_formula_id + ".")
	RETURN "ERROR"
END IF

FOR loop_ix = 1 TO li_rows
	ls_formula += lds_formula.GetItemString(loop_ix,"FORMULA_SYNTAX") + ' '
NEXT

ls_formula = lnv_string.of_globalreplace( ls_formula, ics_inv_type, as_inv_type)

RETURN ls_formula
	
end event

event type boolean ue_get_is_indexed(string as_inv_type, string as_col_name);//====================================================================================//
// Object:			n_cst_dict
//	Script:			ue_get_is_computed
//	Arguments:		String	as_inv_type		ELEM_TBL_TYPE
//						String	as_col_name		ELEM_NAME
//	Returns:			Boolean 						TRUE if Computed
//------------------------------------------------------------------------------------//
// IF ELEM_TYPE = 'CC', COmputed column. Return True
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	MikeF	10/12/04	SPR3650d	Created
//
//====================================================================================//

IF this.uf_get_string(as_inv_type, as_col_name, "ELEM_INDX_IND") = "I" THEN
	RETURN TRUE
END IF

RETURN FALSE
end event

event type string ue_get_disp_format(string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_disp_format
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			String - The column's Display Format.
//
//	Description:	Gets the Display Format for a column from dictionary.  
//
//==================================================================================//
// Maintenance
// ----- -------- ------------------------------------------------------------------
// MikeF 10/13/04 SPR3650d	Created
//==================================================================================//

RETURN	This.uf_get_string( as_inv_type, as_col_name, "DISP_FORMAT")


end event

event type string ue_get_elem_label(string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_elem_label
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			String - Column label.
//
//	Description:	Gets the ELEM_ELEM_LABEL for a column from dictionary.  
//
//==================================================================================//
// Maintenance
// ----- -------- ------------------------------------------------------------------
// MikeF 10/13/04 SPR3650d	Created
//==================================================================================//

RETURN	This.uf_get_string( as_inv_type, as_col_name, "ELEM_ELEM_LABEL")


end event

event type boolean ue_get_col_exists(string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_elem_label
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			String - Column label.
//
//	Description:	Gets the ELEM_ELEM_LABEL for a column from dictionary.  
//
//==================================================================================//
// Maintenance
// ----- -------- ------------------------------------------------------------------
// MikeF 10/13/04 SPR3650d	Created
//==================================================================================//
IF This.uf_retrieve_column( as_inv_type, as_col_name ) > 0 THEN
	RETURN TRUE
END IF

RETURN FALSE


end event

event type string ue_get_elem_data_type(string as_inv_type, string as_col_name);//==================================================================================//
//	Script:			ue_get_elem_data_type
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			String - ELEM_DATA_TYPE from dictionary
//
//==================================================================================//
// Maintenance
// ----- -------- -------- ---------------------------------------------------------
// MikeF 10/13/04 SPR3650d	Computed columns. Created
//==================================================================================//
RETURN This.uf_get_string( as_inv_type, as_col_name, "ELEM_DATA_TYPE")

end event

event type string ue_get_table_type(string as_table_name);//====================================================================================//
// Object:			n_cst_dict
//	Script:			ue_get_table_type
//	Arguments:		String	as_table_name
//	Returns:			String 	Table's ELEM_TBL_TYPE
//------------------------------------------------------------------------------------//
// Returns the (first) ELEM_TBL_TYPE from the Dictionary for a given table name
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	MikeF	10/12/04	SPR3650d	Created
// 04/27/11 limin Track Appeon Performance tuning
// 05/04/11 WinacentZ Track Appeon Performance tuning
// 06/10/11 LiangSen Track Appeon Performance tuning
//====================================================================================//
integer	li_rc

long		li_rowcount, li_index
boolean	lb_found
			
string	ls_tbl_type

/*06/10/11 LiangSen Track Appeon Performance tuning
ids_table_name.dataobject = 'd_dict_table_name'
li_rc = ids_table_name.setTransObject(stars2ca)
if li_rc <> 1 then
	Messagebox('STARS','Error in SetTransObject for ids_table_name'+&
						'~rin n_cst_dict::ue_get_table_name()')
	return 'ERROR'
end if

//retrieve table name from dictionary
li_rowcount = ids_table_name.retrieve('%',as_table_name)
*/
//begin - 06/10/11 LiangSen Track Appeon Performance tuning
if ii_table_name_count <= 0 then
	ids_table_name.dataobject = 'd_dict_table_name'
	li_rc = ids_table_name.setTransObject(stars2ca)
	if li_rc <> 1 then
		Messagebox('STARS','Error in SetTransObject for ids_table_name'+&
						'~rin n_cst_dict::ue_get_table_name()')
		return 'ERROR'
	end if
	ii_table_name_count = ids_table_name.retrieve('%','%')
end if
	ids_table_name.setfilter('')
	ids_table_name.filter()
	ids_table_name.setfilter("upper(ELEM_NAME) like '"+upper(as_table_name)+"'")
	ids_table_name.filter()
	ii_filter_count = ids_table_name.rowcount()
//end LiangSen

//CHOOSE CASE li_rowcount 			//06/10/11 LiangSen Track Appeon Performance tuning
CHOOSE CASE	ii_filter_count  //06/10/11 LiangSen Track Appeon Performance tuning
	CASE 0 
		ls_tbl_type = ics_not_found		
	CASE 1
		// 05/04/11 WinacentZ Track Appeon Performance tuning
//		ls_tbl_type = ids_table_name.object.elem_tbl_type[1]			
		ls_tbl_type = ids_table_name.GetItemString(1, "elem_tbl_type")
	CASE IS > 1
//		FOR li_index = 1 TO li_rowcount		//06/10/11 LiangSen Track Appeon Performance tuning
		For li_index = 1 TO ii_filter_count    //06/10/11 LiangSen Track Appeon Performance tuning
			// 04/26/11 limin Track Appeon Performance tuning
//			IF left(as_table_name,4) = "MEDC" THEN
//			// Need to get "real" type, not fast track.
//				IF left(ids_table_name.object.elem_tbl_type[li_index],1) = 'O' &
//				OR left(ids_table_name.object.elem_tbl_type[li_index],1) = 'Q' THEN
//					// Fast track. Keep looking
//				ELSE
//					lb_found = TRUE
//					ls_tbl_type = ids_table_name.object.elem_tbl_type[li_index]	
//					EXIT
//				END IF
//			END IF
//
//			IF NOT lb_found THEN
//				ls_tbl_type = ids_table_name.object.elem_tbl_type[1]			
//			END IF
			IF left(as_table_name,4) = "MEDC" THEN
			// Need to get "real" type, not fast track.
				IF left(ids_table_name.GetItemString(li_index,"elem_tbl_type"),1) = 'O' &
				OR left(ids_table_name.GetItemString(li_index,"elem_tbl_type"),1) = 'Q' THEN
					// Fast track. Keep looking
				ELSE
					lb_found = TRUE
					ls_tbl_type = ids_table_name.GetItemString(li_index,"elem_tbl_type")
					EXIT
				END IF
			END IF

			IF NOT lb_found THEN
				ls_tbl_type = ids_table_name.GetItemString(1,"elem_tbl_type")			
			END IF
		NEXT
		
	CASE ELSE
		Messagebox('STARS','Error retrieving Dictionary Table Type' +&
						'~rin n_cst_dict::ue_get_table_type()')
		ls_tbl_type = ics_error
END CHOOSE

RETURN ls_tbl_type
end event

event type integer ue_get_min_length(string as_inv_type, string as_col_name);//==================================================================================//
// Object			n_cst_dict
// Event				ue_get_min_len
//	Arguments		String	as_inv_type
//						String	as_col_name
//	Returns:			Integer - MIN_LEN
//----------------------------------------------------------------------------------//
//	Get the minimum length for a column from dictionary. Used for string 
// (char or varchar2) columns.
//----------------------------------------------------------------------------------//
// MikeF 10/21/04 SPR3650d	Created
//==================================================================================//
RETURN	This.uf_get_int( as_inv_type, as_col_name, "MIN_LEN")


end event

event type integer ue_get_lead_alpha(string as_inv_type, string as_col_name);//==================================================================================//
// Object			n_cst_dict
// Event				ue_get_lead_alpha
//	Arguments		String	as_inv_type
//						String	as_col_name
//	Returns:			Integer 	LEAD_ALPHA
//----------------------------------------------------------------------------------//
//	Get the lead alpha for a column from dictionary. Used for string 
// (char or varchar2) columns.
//----------------------------------------------------------------------------------//
// MikeF 10/21/04 SPR3650d	Created
//==================================================================================//
RETURN	This.uf_get_int( as_inv_type, as_col_name, "LEAD_ALPHA")


end event

event type string ue_get_edit_mask(string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_elem_label
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			String EDIT_MASK
//
//	Description:	Gets the EDIT_MASK for a column from dictionary.  
//
//==================================================================================//
// Maintenance
// ----- -------- ------------------------------------------------------------------
// MikeF 10/22/04 SPR3650d	Created
//==================================================================================//

RETURN	This.uf_get_string( as_inv_type, as_col_name, "EDIT_MASK")


end event

event type string ue_get_value_a(string as_inv_type, string as_col_name);//==================================================================================//
//	Script:			ue_get_elem_data_type
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			String 	VALUE_A from dictionary
//
//==================================================================================//
// Maintenance
// ----- -------- -------- ---------------------------------------------------------
// MikeF 10/13/04 SPR3650d	Computed columns. Created
//==================================================================================//
RETURN This.uf_get_string( as_inv_type, as_col_name, "VALUE_A")

end event

event type integer ue_get_crit_seq(string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			ue_get_data_len
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			Integer - The column's data length.
//
//	Description:	Get the criteria sequence for a column from dictionary.
//
//
//////////////////////////////////////////////////////////////////////////////////////
//
// Katie 01/22/07 Created for SPR 4758
//////////////////////////////////////////////////////////////////////////////////////

RETURN	This.uf_get_int( as_inv_type, as_col_name, "CRIT_SEQ")

end event

public function long uf_retrieve_column (string as_inv_type, string as_col_name);//////////////////////////////////////////////////////////////////////////////////////
//	Script:			uf_retrieve_column
//
//	Arguments:		1.	as_inv_type
//						2.	as_col_name
//
//	Returns:			Long - The # of rows returned in ids_col_desc.
//
//	Description:	Based on the parms, retrieve the column information from
//						dictionary into ids_col_desc.
//
//
//////////////////////////////////////////////////////////////////////////////////////
//
//	FDG	07/10/00	Track 2891 (4.5 SP1).  Created.
// 06/08/11 LiangSen Track Appeon Performance tuning
//
//////////////////////////////////////////////////////////////////////////////////////

Integer	li_rc
long		li_rowcount // 06/08/11 LiangSen Track Appeon Performance tuning    

/*  06/08/11 LiangSen Track Appeon Performance tuning
ids_col_desc.SetTransObject (Stars2ca)
// If row already in memeory, don't re-retrieve
IF  ids_col_desc.RowCount() = 1 THEN
	IF  ids_col_desc.GetItemString(1,"ELEM_TBL_TYPE") = as_inv_type & 
	AND ids_col_desc.GetItemString(1,"ELEM_NAME")	  = as_col_name THEN
		RETURN 1
	END IF
END IF

RETURN	ids_col_desc.Retrieve (as_inv_type, as_col_name)
*/
// 06/08/11 LiangSen Track Appeon Performance tuning begin
if ii_col_desc_count <= 0  then
	ids_col_desc.SetTransObject (Stars2ca)
	ii_col_desc_count = ids_col_desc.Retrieve()
end if
li_rowcount = ids_col_desc.Find("upper(ELEM_TBL_TYPE) = '"+upper(as_inv_type)+"' and upper(ELEM_NAME) = '"+upper(as_col_name)+"'",1,ii_col_desc_count)
return li_rowcount
//end LiangSen




end function

public function string uf_get_string (string as_inv_type, string as_col_name, string as_dict_col);//====================================================================================//
// Object:			n_cst_dict
//	Script:			uf_get_string
//	Arguments:		String	as_inv_type		ELEM_TBL_TYPE
//						String	as_col_name		ELEM_NAME
//						String	as_dict_col		Dictionary Column to retrieve
//	Returns:			String 						The Formula from SQL_FORMULA
//------------------------------------------------------------------------------------//
// Returns the String column value from a Dictionary row
//------------------------------------------------------------------------------------//
// 1. Retrieves the Dictionary row for the given Table and Name
// 2. Returns the value from the dictionary row
// 3. Check return code:
//
//		<0 	SQL error
//		0 		No row found in the Dictionary
//		1		Successful
//		>1		Multiple rows returned from Dictionary (Duplicates)
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	MikeF	10/12/04	SPR3650d	Created
// 06/14/11 LiangSen Track Appeon Performance tuning
//
//====================================================================================//
long	li_rc

li_rc = this.uf_retrieve_column( as_inv_type, as_col_name )

IF li_rc = 0 THEN
	RETURN ics_not_found
END IF

/*  06/14/11 LiangSen Track Appeon Performance tuning
IF li_rc = 1 THEN
	RETURN trim(ids_col_desc.getItemString( 1, as_dict_col ))
END IF
*/
// begin - 06/14/11 LiangSen Track Appeon Performance tuning
If li_rc > 0 Then
	ii_find_row = li_rc
	RETURN trim(ids_col_desc.getItemString( li_rc, as_dict_col )) 
End If 
//end LiangSen
MessageBox("ERROR","Unable to retrieve column " + as_dict_col + " for ELEM_TBL_TYPE " + &
			as_inv_type + ", ELEM_NAME " + as_col_name + ". Return code = " + String(li_rc))

RETURN ics_error
end function

public function integer uf_get_int (string as_inv_type, string as_col_name, string as_dict_col);//====================================================================================//
// Object:			n_cst_dict
//	Script:			uf_get_string
//	Arguments:		String	as_inv_type		ELEM_TBL_TYPE
//						String	as_col_name		ELEM_NAME
//						String	as_dict_col		Dictionary Column to retrieve
//	Returns:			String 						The Formula from SQL_FORMULA
//------------------------------------------------------------------------------------//
// Returns the String column value from a Dictionary row
//------------------------------------------------------------------------------------//
// 1. Retrieves the Dictionary row for the given Table and Name
// 2. Returns the value from the dictionary row
// 3. Check return code:
//
//		<0 	SQL error
//		0 		No row found in the Dictionary
//		1		Successful
//		>1		Multiple rows returned from Dictionary (Duplicates)
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	MikeF	10/12/04	SPR3650d	Created
// 06/14/11 LiangSen Track Appeon Performance tuning
//
//====================================================================================//
long	li_rc

li_rc = this.uf_retrieve_column( as_inv_type, as_col_name )

IF li_rc = 0 THEN
	RETURN li_rc
END IF
/*   06/14/11 LiangSen Track Appeon Performance tuning
IF li_rc = 1 THEN
	RETURN ids_col_desc.getitemnumber( 1, as_dict_col )
END IF
*/ 
// begin - 06/14/11 LiangSen Track Appeon Performance tuning
IF li_rc >= 1 THEN
	RETURN ids_col_desc.getitemnumber( li_rc, as_dict_col )
END IF
//end LiangSen
MessageBox("ERROR","Unable to retrieve column " + as_dict_col + " for ELEM_TBL_TYPE " + &
				as_inv_type + ", ELEM_NAME " + as_col_name + ". Return code = " + String(li_rc))
RETURN -1
end function

public function string uf_get_select_all (string as_tbl_type, boolean ab_prefix);//====================================================================================//
// Object:			n_cst_dict
//	Script:			uf_get_sELECT_ALL
//	Arguments:		String	as_tbl_type		ELEM_TBL_TYPE
//						Boolean	ab_prefix		Controls whether to prefix the column names with tbl type	
//	Returns:			String 						List of columns seperated by 
//------------------------------------------------------------------------------------//
// Returns column names seperated by commas for use in SELECT clause
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	MikeF	10/22/04	SPR3650d	Created
// MikeF 01/12/05 SPR4234d For computed columns, return FORMULA + " AS " + Column Name
//	Katie	05/27/2010	SPR5527	Moved logic to uf_get_select_all(string, boolean, boolean) so that
//							we can pass in whether to sort by the disp_seq or the column number.
//====================================================================================//

return uf_get_select_all(as_tbl_type, ab_prefix, false)
end function

public function any uf_get_col_array (string as_tbl_type, boolean ab_prefix);//====================================================================================//
// Object:			n_cst_dict
//	Script:			uf_get_col_array
//	Arguments:		String	as_tbl_type		ELEM_TBL_TYPE
//						Boolean	ab_prefix		Controls whether to prefix the column names with tbl type	
//	Returns:			String 						List of columns seperated by 
//------------------------------------------------------------------------------------//
// Returns column names seperated by commas for use in SELECT clause
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	MikeF	10/22/04	SPR3650d	Created
//	Katie	05/27/2010	SPR5527	Changed to using the uf_get_select_all function
//						that will allow sort by the DISP_SEQ column of dictionary.
//====================================================================================//
string			ls_select, ls_columns[]
n_cst_string	lnv_string

ls_select = this.uf_get_select_all( as_tbl_type, ab_prefix, true)
IF ls_select = ics_error THEN
	ls_columns[1] = ics_error
ELSE
	ls_columns = lnv_string.of_stringtoarray( ls_select, ",")	
END IF

RETURN ls_columns
end function

public function integer uf_get_dict_info (string as_tbl_type, ref sx_dictionary_data asx_data[]);//====================================================================================//
// Object:			n_cst_dict
//	Script:			uf_get_dict_info
//	Arguments:		String	as_tbl_type		ELEM_TBL_TYPE
//			(By Ref)	sx_dictionary_data	asx_data		Array to populate dictionary info	
//	Returns:			Integer 			-1 Error, 1 Success
//------------------------------------------------------------------------------------//
// Sets dictionary structure based on Table type
//------------------------------------------------------------------------------------//
// Maintenance
// -------- ----- ------------------------------------------------------------
// 12/14/95	DKG   Access dictionary thru w_main.dw_dictionary_hidden.
//	07/01/03	GaryR	Track 3613d Account for DENTAL codes
// 10/22/04 MikeF	SPR 3650d Get rid of w_main.dw_dictionary_hidden
//	02/16/07	GaryR	Track 4905	Centralize logic to prevent PB reference bugs
//============================================================================//

Int		li_rows, li_index
n_ds		lds_dict
sx_dictionary_data lsx_clear[]

// Clear out array
asx_data = lsx_clear

// Create datastore
lds_dict = Create n_ds
lds_dict.Dataobject = 'd_dictionary_tbl_type'
lds_dict.SetTransObject( stars2ca )
li_rows = lds_dict.Retrieve( as_tbl_type )

IF	li_rows	< 1 THEN
	MessageBox('ERROR','Error retrieving Dictionary for Table Type: ' + &
						as_tbl_type, StopSign! )
	Destroy lds_dict
	Return -1
END IF

FOR li_index = 1 To li_rows
	asx_data[li_index].elem_name     = lds_dict.GetItemString(li_index, "elem_name")
	asx_data[li_index].data_type     = lds_dict.GetItemString(li_index, "elem_data_type")
	asx_data[li_index].elem_lookup	= lds_dict.GetItemString(li_index, "elem_lookup_type" )
	asx_data[li_index].min_len       = lds_dict.GetItemNumber(li_index, "min_len")
	asx_data[li_index].max_len       = lds_dict.GetItemNumber(li_index, "elem_data_len")
	asx_data[li_index].leading_alpha = lds_dict.GetItemNumber(li_index, "lead_alpha")	
NEXT

Destroy lds_dict

Return 1
end function

public function integer uf_get_info_index (sx_dictionary_data asx_data[], string as_col_name);//====================================================================================//
// Object:			n_cst_dict
//	Script:			uf_get_info_index
//	Arguments:		sx_dictionary_data	asx_data		Array to search	
//						String	as_col_name		ELEM_NAME to find in the array
//			(By Ref)	
//	Returns:			Integer 	Index in the array  -1 = not found
//------------------------------------------------------------------------------------//
// Searches the dictionary structure based on elem name
//	This function replaces the global fx_get_dict_index
//------------------------------------------------------------------------------------//
// Maintenance
// -------- ----- ------------------------------------------------------------
//	02/16/07	GaryR	Track 4905	Centralize logic to prevent PB reference bugs
//============================================================================//

Integer	li_cnt, li_ctr

li_cnt = UpperBound( asx_data )

FOR li_ctr = 1 TO li_cnt
	IF Upper( asx_data[li_ctr].elem_name ) = Upper( as_col_name ) THEN Return li_ctr
NEXT

Return -1
end function

public function any uf_get_select_all (string as_tbl_type, boolean ab_prefix, boolean ab_disp_seq_sort);//====================================================================================//
// Object:			n_cst_dict
//	Script:			uf_get_sELECT_ALL
//	Arguments:		String	as_tbl_type		ELEM_TBL_TYPE
//						Boolean	ab_prefix		Controls whether to prefix the column names with tbl type	
//						Boolean	ab_disp_seq_sort	Overriders the default sort by column number with a
//													sort by the DISP_SEQ column of the dictionary.
//	Returns:			String 						List of columns seperated by 
//------------------------------------------------------------------------------------//
// Returns column names seperated by commas for use in SELECT clause
//------------------------------------------------------------------------------------//
// Maintenance
// ----- -------- -------- -----------------------------------------------------------
//	Katie	05/27/2010	SPR5527	Intial Creation.
//====================================================================================//

string	ls_select, ls_name
int		li_rc, li_index
n_ds		lds_dict

lds_dict = CREATE n_ds
lds_dict.DataObject = 'd_dictionary_tbl_type'
lds_dict.SetTransObject(stars2ca)
li_rc = lds_dict.retrieve(as_tbl_type)

IF li_rc = 0 THEN RETURN ics_not_found
IF li_rc < 0 THEN RETURN ics_error

if ab_disp_seq_sort then 
	lds_dict.SetSort("DISP_SEQ")
	lds_dict.Sort()
end if

FOR li_index = 1 TO li_rc
	IF li_index > 1 THEN
		ls_select += ','
	END IF
	
	ls_name = lds_dict.GetItemString(li_index,"ELEM_NAME")
	
	IF this.event ue_get_is_computed( as_tbl_type, ls_name) THEN
		ls_select += this.event ue_get_formula( as_tbl_type, ls_name ) + " AS "
	ELSE
		IF ab_prefix THEN
			ls_select += as_tbl_type + "."
		END IF		
	END IF

	ls_select += ls_name
NEXT

RETURN ls_select
end function

public function string uf_get_col_desc (string as_col_desc);//====================================================================
// Function: uf_get_col_desc()
//--------------------------------------------------------------------
// Description: This event retrieves a column decsription from the dictionary.
//			rewrite	ue_get_col_desc					n_cst_dict
//--------------------------------------------------------------------
// Arguments:
// 	value    string    as_col_desc
//--------------------------------------------------------------------
// Returns:  string  Description of the column that matches the 
//											invoice type and column name
//--------------------------------------------------------------------
// Author:	limin		Date: 06/01/2011
//--------------------------------------------------------------------
//	Copyright (c) 2008-2011 Appeon, All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================
string	ls_col_desc
int		li_pos

ls_col_desc = as_col_desc

// Get the name to left of '/' or the 1st 15 bytes
Li_pos = Pos (ls_col_desc, '/')
IF li_pos = 0  &
OR li_pos > 16  THEN
	Li_pos = 16
END IF

ls_col_desc = Left ((ls_col_desc), li_pos - 1)

RETURN ls_col_desc
end function

public subroutine uf_appeon_select_data ();//***********************************************************************
//   Date   Init               Description of Changes Made                
// -------- ----	-------------------------------------------------------- 
// 06/13/11 Liangsen Track Appeon Performance tuning
// 06/14/11 LiangSen Track Appeon Performance tuning
// 09/25/11 LiangSen Track Appeon Performance tuning - fix  bug #105
//
//***********************************************************************

//begin - 06/13/11 LiangSen Track Appeon Performance tuning
//ids_disp_seq = CREATE n_ds						// 06/14/11 LiangSen Track Appeon Performance tuning
ids_disp_seq.DataObject = 'd_build_dict_sql_select'	// 06/14/11 LiangSen Track Appeon Performance tuning
ids_disp_seq.SetTransObject( Stars2ca )	// 06/14/11 LiangSen Track Appeon Performance tuning

/*  // 09/25/11 LiangSen Track Appeon Performance tuning - fix  bug #105
ids_invoice_type.dataobject = 'd_appeon_invoice_type'  
ids_col_desc.SetTransObject (Stars2ca)
ids_invoice_type.SetTransObject(stars2ca)
gn_appeondblabel.of_startqueue()
ii_col_desc_count = ids_col_desc.Retrieve()
commit using Stars2ca;
ii_invoice_type_count = ids_invoice_type.retrieve()  
gn_appeondblabel.of_commitqueue()
if gb_is_web Then
	ii_col_desc_count = ids_col_desc.rowcount( )
	ii_invoice_type_count = ids_invoice_type.rowcount()  
end if
*/
//end LiangSen
end subroutine

event constructor;call super::constructor;//***********************************************************************
//   Date   Init               Description of Changes Made                
// -------- ----	-------------------------------------------------------- 
// 06/08/11 LiangSen Track Appeon Performance tuning
// 06/14/11 LiangSen Track Appeon Performance tuning
// 09/19/11 LiangSen Track Appeon Performance tuning - fix bug #105
// 09/22/11 LiangSen Track Appeon Performance tuning - fix bug #105
//
//***********************************************************************
ids_table_desc 	= CREATE n_ds
ids_table_name 	= CREATE n_ds
ids_col_desc 		= CREATE n_ds
ids_invoice_type 	= CREATE n_ds
ids_disp_seq 		= CREATE n_ds						// 06/14/11 LiangSen Track Appeon Performance tuning

//ids_col_desc.DataObject	=	'd_col_desc'  // 06/08/11 LiangSen Track Appeon Performance tuning
ids_col_desc.DataObject = 'd_appeon_col_desc' // 06/08/11 LiangSen Track Appeon Performance tuning
/*  09/22/11 LiangSen Track Appeon Performance tuning - fix bug #105
// 09/19/11 LiangSen Track Appeon Performance tuning - fix bug #105
IF gs_dbms = 'ORA' Then
	ids_col_desc.DataObject = 'd_appeon_col_desc_proc' 
elseif gs_dbms = 'ASE' Then
	ids_col_desc.DataObject = 'd_appeon_col_desc_proc_ase'
else
	ids_col_desc.DataObject = 'd_appeon_col_desc'
end if
*/



end event

on n_cst_dict.create
call super::create
end on

on n_cst_dict.destroy
call super::destroy
end on

event destructor;destroy(ids_table_desc)
destroy(ids_table_name)
destroy(ids_col_desc)
destroy(ids_invoice_type)
end event

