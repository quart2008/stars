$PBExportHeader$nvo_starsnet.sru
forward
global type nvo_starsnet from nonvisualobject
end type
end forward

global type nvo_starsnet from nonvisualobject
end type
global nvo_starsnet nvo_starsnet

type variables
string is_objectid,is_url,is_lasterror
appeondom_element idom_clientinfo,idom_ClaimsInfo

end variables

forward prototypes
public function integer of_logon (string as_szserver, string as_szname, string as_szpassword, string as_sznewpassword, string as_szwarehouse)
public function integer of_getclientinfo ()
public function string of_getusername ()
public function string of_getpassword ()
public function string of_getschema ()
public function long of_daystoexpire ()
public function integer of_changepassword (string as_currentpassword, string as_newpassword)
public function integer of_killusersession (string as_szserver, string as_szname, string as_szpassword, string as_szwarehouse)
public function integer of_resetexpiration ()
public function string of_getlasterror ()
public function string of_getfromdate ()
public function string of_gettdate ()
public function long of_isexcludepaymentdate ()
public function integer of_jobcreate (ref long al_job_id)
public function integer of_jobcancel (long al_jobid)
public function integer of_jobreset (long al_jobid)
public function integer of_jobdelete (long al_jobid)
public function integer of_jobupdatedesc (long al_jobid, string as_desc)
public function integer of_jobsubmit (long al_jobid, string as_desc, long al_priority, long al_sched_rule, string as_first_date)
public function integer of_release ()
public function integer of_updatefilterstats (string as_filterid)
public function integer of_getclaimstablenames (string as_invtype, string as_operand, string as_dateexp)
public function integer of_droptemptable (string as_tablename)
public function integer of_getfiltertablename (string as_filterid, ref string as_filtertable)
public function integer of_getidleminutes (ref long al_value)
public function integer of_isclientadmin (ref long al_value)
public function integer of_getbasetablenames (ref string as_tablenames[])
public function integer of_exec (string as_methodname, long al_jobid, string as_desc)
public function integer of_createtemptable (string as_tablename, string as_invtype, long al_columnindexes[], string as_indexcolumns[])
public function integer of_createimportfiltertable (string as_filterid, string as_datatype, ref string as_table_name)
public function integer of_createfiltertable (string as_filterid, string as_invtype, string as_colname, ref string as_table_name)
public function integer of_createkeytable (long al_jobid, string as_invtype, ref string as_table)
public function integer of_createicntable (long al_jobid, string as_invtype, ref string as_table)
public function string of_getreturnvalue (appeondom_element adom_this, string as_type, string as_name)
public function integer of_createtable (string as_methodname, long al_jobid, string as_invtype, ref string as_table)
end prototypes

public function integer of_logon (string as_szserver, string as_szname, string as_szpassword, string as_sznewpassword, string as_szwarehouse);string ls_xml,ls_url
nvo_methodcall lnv_call

lnv_call = create nvo_methodcall
lnv_call.of_setMethodName( "Logon" )
lnv_call.of_addString( "string","name",as_szname ) //'Andy' 
lnv_call.of_addString( "string","password", as_szPassword ) // 'Appeon123'
lnv_call.of_addString( "string","newPassword", as_szNewPassword ) //''
lnv_call.of_addString( "string","dictDbName", as_szWarehouse ) //'starsxl'

ls_xml = lnv_call.of_tostring()
lnv_call.of_AddField("Contents", ls_xml )

ls_url = as_szServer 
if left(ls_url,7) <> 'http://'  and left(ls_url,8) <> 'https://' then
	ls_url ='http://' + ls_url 
end if 

if lnv_call.of_SendRequest(ls_url)  = -1 then //('http://192.0.3.144:5275/STARServer')
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

lnv_call.of_parsexml(lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag(lnv_call.inv_root)= -1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

is_objectid = lnv_call.of_getstring('return',lnv_call.inv_root)
is_url =  ls_url

destroy lnv_call
return 0
end function

public function integer of_getclientinfo ();return of_exec("GetClientInfo",0,'')

end function

public function string of_getusername ();return of_getreturnvalue(idom_clientinfo,'string','dbUser')
end function

public function string of_getpassword ();return of_getreturnvalue(idom_clientinfo,'string','dbPassword')
end function

public function string of_getschema ();return of_getreturnvalue(idom_clientinfo,'string','schema')

end function

public function long of_daystoexpire ();return long(of_getreturnvalue(idom_clientinfo,'long','daysToExpire'))

end function

public function integer of_changepassword (string as_currentpassword, string as_newpassword);//void TStarsServer::ChangePassword(const char* _currentPassword,const char* _newPassword)
string ls_xml
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall

lnv_call.of_setMethodName( "ChangePassword" )
lnv_call.of_setObjectId(is_objectid )
lnv_call.of_addString( "string","currentPassword", as_currentpassword )
lnv_call.of_addString( "string","newPassword", as_newpassword )
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) =-1  then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

ls_xml = lnv_call.of_GetResponseField( "Contents" )
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag(lnv_call.inv_root) = -1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

destroy lnv_call
return 0

end function

public function integer of_killusersession (string as_szserver, string as_szname, string as_szpassword, string as_szwarehouse);//void TObjFactory::KillUserSession( LPCSTR szServer, LPCTSTR szName, LPCTSTR szPassword, LPCTSTR szWarehouse )
string ls_xml,ls_url
nvo_methodcall lnv_call

lnv_call = create nvo_methodcall
lnv_call.of_setMethodName( "KillUserSession" )
lnv_call.of_addString( "string","name",as_szname ) //'Andy' 
lnv_call.of_addString( "string","password", as_szPassword ) // 'Appeon123'
lnv_call.of_addString( "string","dictDbName", as_szWarehouse ) //'starsxl'

ls_xml = lnv_call.of_tostring()
lnv_call.of_AddField("Contents", ls_xml )

ls_url = as_szServer 
if left(ls_url,7) <> 'http://'  and left(ls_url,8) <> 'https://' then
	ls_url ='http://' + ls_url 
end if 

if lnv_call.of_SendRequest(ls_url) =-1 then //('http://192.0.3.144:5275/STARServer')
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if
lnv_call.of_parsexml(lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag(lnv_call.inv_root) = -1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

destroy lnv_call
return 0
end function

public function integer of_resetexpiration ();//void TStarsServer::ResetExpiration()
return of_exec('ResetExpiration',0,'')

end function

public function string of_getlasterror ();return is_lasterror
end function

public function string of_getfromdate ();return of_getreturnvalue(idom_ClaimsInfo,'string','fromDate')
end function

public function string of_gettdate ();return of_getreturnvalue(idom_ClaimsInfo,'string','tDate')
end function

public function long of_isexcludepaymentdate ();return long(of_getreturnvalue(idom_ClaimsInfo,'long','excludePaymentDate'))

end function

public function integer of_jobcreate (ref long al_job_id);string ls_xml

nvo_methodcall lnv_call
lnv_call = create nvo_methodcall


lnv_call.of_setMethodName("JobCreate" )
lnv_call.of_setObjectId(is_objectid )
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )

if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if
ls_xml = lnv_call.of_GetResponseField( "Contents" )
if trim(ls_xml) ='' then
	is_lasterror ="No ~'Contents~' found in Response message"
	destroy lnv_call
	return -1
end if

lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root)=-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

al_job_id = lnv_call.of_getlong( "return")

destroy lnv_call
return 0

end function

public function integer of_jobcancel (long al_jobid);return of_exec('JobCancel',al_jobid,'')

end function

public function integer of_jobreset (long al_jobid);return of_exec('JobReset',al_jobid,'')

end function

public function integer of_jobdelete (long al_jobid);return of_exec('JobDelete',al_jobid,'')

end function

public function integer of_jobupdatedesc (long al_jobid, string as_desc);return of_exec('JobUpdateDesc',al_jobid,as_desc)

end function

public function integer of_jobsubmit (long al_jobid, string as_desc, long al_priority, long al_sched_rule, string as_first_date);string ls_xml

nvo_methodcall lnv_call
lnv_call = create nvo_methodcall


lnv_call.of_setMethodName("JobSubmit" )
lnv_call.of_setObjectId(is_objectid )
lnv_call.of_addLong( "jobid", al_jobid )
lnv_call.of_addString("string", "desc", as_desc )
lnv_call.of_addLong( "priority", al_priority )
lnv_call.of_addLong( "sched_rule", al_sched_rule )
lnv_call.of_addString( "string", "first_date", as_first_date)
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )

if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if
ls_xml = lnv_call.of_GetResponseField( "Contents" )
if trim(ls_xml) ='' then
	is_lasterror ="No ~'Contents~' found in Response message"
	destroy lnv_call
	return -1
end if

lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root)=-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

destroy lnv_call
return 0

end function

public function integer of_release ();return of_exec('Release',0,'')

end function

public function integer of_updatefilterstats (string as_filterid);//void TStarsServer::UpdateFilterStats(const char* _filterID)
return of_exec("UpdateFilterStats",0,as_filterID)

end function

public function integer of_getclaimstablenames (string as_invtype, string as_operand, string as_dateexp);string ls_xml
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall

lnv_call.of_setMethodName( "GetClaimsTableNames" )
lnv_call.of_setObjectId(is_objectid )
lnv_call.of_addString("string", "invType", as_invType )
lnv_call.of_addString("string","operand", as_operand )
lnv_call.of_addString("string", "dateExp", as_dateExp )
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

ls_xml = lnv_call.of_GetResponseField( "Contents" )
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

idom_ClaimsInfo = lnv_call.of_gettag("claimsinfo", "return",lnv_call.inv_root)

destroy lnv_call
return 0
end function

public function integer of_droptemptable (string as_tablename);return of_exec( "DropTempTable",0,as_tablename)

end function

public function integer of_getfiltertablename (string as_filterid, ref string as_filtertable);//CString TStarsServer::GetFilterTableName(const char* _filterID)
//TClientInfo* TStarsServer::GetClientInfo()
string ls_xml
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall

lnv_call.of_setMethodName( "GetFilterTableName" )
lnv_call.of_setObjectId(is_objectid )
lnv_call.of_addstring("string","filterID", as_filterID)
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

ls_xml = lnv_call.of_GetResponseField( "Contents" )
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root) =-1 then 
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

as_filtertable = lnv_call.of_getString("return",lnv_call.inv_root)

destroy lnv_call
return 0
 
end function

public function integer of_getidleminutes (ref long al_value);//long TStarsServer::GetIdleMinutes()
string ls_xml
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall


lnv_call.of_setMethodName("GetIdleMinutes" )
lnv_call.of_setObjectId(is_objectid )
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) = -1 then 
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

ls_xml = lnv_call.of_GetResponseField( "Contents" )
if trim(ls_xml) ='' then
	is_lasterror ="No ~'Contents~' found in Response message"
	destroy lnv_call
	return -1
end if
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

al_value  = lnv_call.of_getlong( "return")
destroy lnv_call
return 0
end function

public function integer of_isclientadmin (ref long al_value);//long TStarsServer::IsClientAdmin()
string ls_xml
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall


lnv_call.of_setMethodName("IsClientAdmin" )
lnv_call.of_setObjectId(is_objectid )
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if
ls_xml = lnv_call.of_GetResponseField( "Contents" )
if trim(ls_xml) ='' then
	is_lasterror ="No ~'Contents~' found in Response message"
	destroy lnv_call
	return -1
end if
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root)=-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if
al_value = lnv_call.of_getlong( "return")

destroy lnv_call
return 0




end function

public function integer of_getbasetablenames (ref string as_tablenames[]);string ls_return 
long ll_i
nvo_methodcall  lnv_call
appeondom_element lnv_nodes[],ldom_this

lnv_call = create nvo_methodcall
ldom_this =lnv_call.of_gettag('stringlist','tableNames',idom_ClaimsInfo)
if not isvalid(ldom_this) then
	//is_lasterror =
	destroy lnv_call
	return -1
end if

ldom_this.getChildElements(lnv_nodes)
for ll_i =1 to upperbound(lnv_nodes)
	as_tablenames[ll_i] = lnv_nodes[ll_i].gettext()
next	

destroy lnv_call
return 0
end function

public function integer of_exec (string as_methodname, long al_jobid, string as_desc);string ls_xml

nvo_methodcall lnv_call
lnv_call = create nvo_methodcall


lnv_call.of_setMethodName(as_methodname)
lnv_call.of_setObjectId(is_objectid )
choose case as_methodname
	case 'JobReset','JobDelete','JobCancel'
		lnv_call.of_addLong( "jobid", al_jobid )
	case 'JobUpdateDesc'
		lnv_call.of_addLong( "jobid", al_jobid )
		lnv_call.of_addString( 'string',"desc", as_desc)
	case 'DropTempTable'
		lnv_call.of_addstring("string","tableName", as_desc)
	case 'UpdateFilterStats'	
		lnv_call.of_addstring("string","filterID", as_desc)
end choose

ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )

if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if
ls_xml = lnv_call.of_GetResponseField( "Contents" )
if trim(ls_xml) ='' then
	is_lasterror ="No ~'Contents~' found in Response message"
	destroy lnv_call
	return -1
end if

lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root)=-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

if as_methodname='GetClientInfo' then 
	idom_clientinfo = lnv_call.of_gettag("clientinfo", "return",lnv_call.inv_root)
end if

destroy lnv_call
return 0

end function

public function integer of_createtemptable (string as_tablename, string as_invtype, long al_columnindexes[], string as_indexcolumns[]);string ls_xml
long ll_i
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall
appeondom_element ldom_this

// Generate the methodCall XML
lnv_call.of_setMethodName( "CreateTempTable" )
lnv_call.of_setObjectId(is_objectid )
lnv_call.of_addstring("string","tableName", as_tablename)
lnv_call.of_addstring("string","invType", as_invtype)
//add pag call.addTag("columnIndexes", indexes)
lnv_call.of_addstring("longlist","columnIndexes", '')
ldom_this =lnv_call.of_gettag("longlist","columnIndexes",lnv_call.root)
for ll_i =1 to upperbound(al_columnindexes)
	lnv_call.of_addlongtag(ldom_this,'',al_columnindexes[ll_i])
next

lnv_call.of_addstring("stringlist","indexColumns", '')
ldom_this =lnv_call.of_gettag("stringlist","indexColumns",lnv_call.root)
for ll_i =1 to upperbound(as_indexcolumns)
	lnv_call.of_addstringtag(ldom_this,'string','',as_indexcolumns[ll_i])
next

ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

ls_xml = lnv_call.of_GetResponseField( "Contents" )
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root) =-1 then 
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

destroy lnv_call
return 0


end function

public function integer of_createimportfiltertable (string as_filterid, string as_datatype, ref string as_table_name);//CString TStarsServer::CreateImportFilterTable(const char* _filterID, const char* _dataType)string ls_xml
string ls_xml
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall

lnv_call.of_setMethodName( "CreateImportFilterTable" )
lnv_call.of_setObjectId(is_objectid )
lnv_call.of_addstring("string","filterID", as_filterID)
lnv_call.of_addString("string", "dataType", as_dataType )
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

ls_xml = lnv_call.of_GetResponseField( "Contents" )
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root) =-1 then 
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

as_table_name = lnv_call.of_getString("return",lnv_call.inv_root)

destroy lnv_call
return 0
 
end function

public function integer of_createfiltertable (string as_filterid, string as_invtype, string as_colname, ref string as_table_name);//CString TStarsServer::CreateFilterTable(const char* _filterID, const char* _invType, const char* _colName)
string ls_xml
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall

lnv_call.of_setMethodName( "CreateFilterTable" )
lnv_call.of_setObjectId(is_objectid )
lnv_call.of_addstring("string","filterID", as_filterID)
lnv_call.of_addString("string", "invType", as_invType )
lnv_call.of_addString("string", "colName", as_colName )
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

ls_xml = lnv_call.of_GetResponseField( "Contents" )
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root) =-1 then 
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

as_table_name = lnv_call.of_getString("return",lnv_call.inv_root)

destroy lnv_call
return 0
 
end function

public function integer of_createkeytable (long al_jobid, string as_invtype, ref string as_table);//CString TStarsServer::CreateKeyTable(long _jobId, const char* _invType)
return of_createtable( "CreateKeyTable" ,al_jobid,as_invtype,as_table)

end function

public function integer of_createicntable (long al_jobid, string as_invtype, ref string as_table);//CString TStarsServer::CreateICNTable(long _jobId, const char* _invType)
return of_createtable( "CreateICNTable" ,al_jobid,as_invtype,as_table)

end function

public function string of_getreturnvalue (appeondom_element adom_this, string as_type, string as_name);string ls_return 
nvo_methodcall  lnv_call
appeondom_element lnv_nodes[]

lnv_call = create nvo_methodcall
lnv_nodes[1] =adom_this
ls_return =  lnv_call.of_getnodevalue(as_type,as_name,lnv_nodes)

destroy lnv_call
return ls_return 
end function

public function integer of_createtable (string as_methodname, long al_jobid, string as_invtype, ref string as_table);//CString TStarsServer::CreateICNTable(long _jobId, const char* _invType)
string ls_xml
nvo_methodcall lnv_call
lnv_call = create nvo_methodcall

lnv_call.of_setMethodName( as_methodname )
lnv_call.of_setObjectId(is_objectid )
lnv_call.of_addLong("jobid", al_jobId )
lnv_call.of_addString("string", "invType", as_invType )
ls_xml = lnv_call.of_toString()

lnv_call.of_AddField("Contents", ls_xml )
if lnv_call.of_SendRequest(is_url ) =-1 then
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

ls_xml = lnv_call.of_GetResponseField( "Contents" )
lnv_call.of_parsexml( lnv_call.istr_fieldMap.szvalue[1])

if lnv_call.of_setxmltag( lnv_call.inv_root) =-1 then 
	is_lasterror = lnv_call.is_lasterror
	destroy lnv_call
	return -1
end if

as_table = lnv_call.of_getString("return",lnv_call.inv_root)

destroy lnv_call
return 0
 
end function

on nvo_starsnet.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_starsnet.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

