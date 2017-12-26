$PBExportHeader$nvo_methodcall.sru
forward
global type nvo_methodcall from nonvisualobject
end type
end forward

global type nvo_methodcall from nonvisualobject
end type
global nvo_methodcall nvo_methodcall

type variables
appeondom_Document  doc ,idoc_response
appeondom_Element     root ,element_parent,inv_root

appeondom_Builder ibuilder_Bldr ,inv_builder

constant string is_pmobject	=	"params"
constant string is_m_szBoundary = "B"
string is_xml,is_lasterror,is_szvalue,is_objectid
s_fieldMap  istr_fieldMap
n_ir in_ir

end variables

forward prototypes
public function integer of_setmethodname (string as_name)
public function integer of_setobjectid (string as_id)
public function integer of_addlong (string as_name, long al_value)
public function integer of_isvalid (string as_object)
public function integer of_addtag (string as_name, appeondom_element ptag)
public function integer of_sendrequest (string as_url)
public function string of_getresponsefield (string as_szname)
public function integer of_clear ()
public function long of_writefileentries ()
public function string of_getfieldentry (string as_szkey, string as_szvalue)
public function string of_getfileentry (string szkey)
public function integer of_addfield (string as_szname, string as_szvalue)
public function string of_tostring ()
public function long of_writerequest (ref string as_xml)
public function long of_writefieldentries (ref string as_xml)
public function long of_writeeof (ref string as_xml)
public function long of_writeblankline (ref string as_xml)
public function integer of_readdatafromfile (string as_xml)
public function string of_getfield (string as_szname)
public function appeondom_element of_parsexml (string as_xml)
public function integer of_setxmltag (appeondom_element lnv_root)
public function string of_getnodevalue (string as_type, string as_name, appeondom_element ao_nodes[])
public function long of_getlong (string as_name)
public function integer of_addstringtag (ref appeondom_element pparenttag, string as_name, string as_attribute, string as_text)
public function integer of_addstring (string as_name, string as_attribute, string as_text)
public function appeondom_element of_gettag_find (string as_name, string as_attributevalue, appeondom_element ao_nodes[])
public function integer of_addlongtag (appeondom_element pparenttag, string as_name, long al_text)
public function appeondom_element of_gettag (string as_name, string as_attributevalue, appeondom_element adom_this)
public function string of_getstring (string as_name, appeondom_element adom_this)
end prototypes

public function integer of_setmethodname (string as_name);appeondom_ELEMENT Element_Child

Element_parent = root.getchildelement('methodcall' )

Element_Child = CREATE appeondom_ELEMENT

Element_Child.SetName( "methodname")

Element_Child.AddContent( as_name )

root.AddContent( Element_Child )
destroy Element_Child
return 0
end function

public function integer of_setobjectid (string as_id);appeondom_ELEMENT Element_Child

if of_isvalid(is_pmobject) =-1 then return -1
if of_isvalid( "object") =-1 then return -1

Element_Child = CREATE appeondom_ELEMENT
Element_Child = root.getchildelement("object" )
Element_Child.setattribute("id", as_id)
//root.AddContent( Element_Child )
destroy Element_Child
return 0

end function

public function integer of_addlong (string as_name, long al_value);if of_isvalid(is_pmobject) =-1 then return -1
of_addlongtag(element_parent,as_name,al_value)
return 0

end function

public function integer of_isvalid (string as_object);if not isvalid(root) then
	is_lasterror = 'Invalid object state.'
	return -1
end if
string as_name =''
appeondom_element ldom_nodes[], ldom_return
ldom_nodes[1] = root

ldom_return =  of_gettag_find(as_object,as_name,ldom_nodes)
if not isvalid(ldom_return) then
	appeondom_ELEMENT Element_Child
	
	Element_Child = CREATE appeondom_ELEMENT
	Element_Child.SetName(as_object)
	root.AddContent( Element_Child )
	destroy Element_Child
	
	Element_parent = root.getchildelement(as_object )
else
	Element_parent = ldom_return
end if

return 0
end function

public function integer of_addtag (string as_name, appeondom_element ptag);if of_isvalid(is_pmobject) =-1 then return -1
element_parent.addcontent(ptag)
return 0
end function

public function integer of_sendrequest (string as_url);string  ls_headers 
Blob lblb_args
long ll_rc,ll_port,ll_begin,ll_end
inet iinet_base

ls_headers= "Content-Type: multipart/related; boundary=" + is_m_szBoundary + ";~r~n";

of_WriteRequest( is_xml )
 
 ll_begin = pos(as_url,":",8)
 ll_end  =pos(as_url,"/",8)
 if ll_begin >0 and ll_end >0 and ll_end > ll_begin  then
 	ll_port =long(mid(as_url,ll_begin+1,ll_end - ll_begin -1))
 end if

iinet_base =create inet
ll_rc = GetContextService( "Internet", iinet_base )
in_ir = create n_ir

IF ll_rc = 1 THEN	
	lblb_args =blob(is_xml,EncodingANSI!)	
	ll_rc = iinet_base.PostURL(as_url, lblb_args,  ls_headers,ll_port, in_ir )
		
	if ll_rc <>1 then 
		choose case ll_rc
			case -1  
				is_lasterror ='General error'
			case -2  
				is_lasterror ='Invalid URL'
			case -4  
				is_lasterror ='Cannot connect to the Internet'
			case -5  
				is_lasterror ='Unsupported secure (HTTPS) connection attempted'
			case -6  
				is_lasterror ='Internet request failed'
		end choose
		destroy in_ir
		destroy iinet_base
		return -1
	end if
	ll_rc = of_readdatafromfile(in_ir.is_data)
END IF

destroy in_ir
destroy iinet_base
return ll_rc
end function

public function string of_getresponsefield (string as_szname);// Get field
//return m_reader.GetField( szName )
return of_getfield(as_szName)
 
end function

public function integer of_clear ();// clear the form
return 1
end function

public function long of_writefileentries ();long lRequestSize = 0;
//POSITION p = m_fileMap.GetStartPosition();
//while( p )
//{
//	// add a field
//	CString szValue;
//	CString szKey;
//	m_fileMap.GetNextAssoc( p, szKey, szValue );
//
//	CFile f;
//	if( !f.Open( szValue, CFile::modeRead ) )
//		ThrowMultiPartException( "Unable to open File: " + szValue );
//
//	CString request = GetFileEntry( szKey, f );
//
//	lRequestSize += request.GetLength();
//	lRequestSize += f.GetLength() + 2; // size of file + 2
//
//	if( pFile )
//	{
//		pFile->Write( request, request.GetLength() );
//
//		char buffer[200 * 1024]; // 200 K
//		// read the file, and send it to the HttpFile
//		while( true )
//		{
//			UINT bytesRead = f.Read(buffer, 200*1024 );
//			if( bytesRead )
//				pFile->Write( buffer, bytesRead );
//
//			if( bytesRead < 200*1024 )
//				break;
//		}
//		pFile->Write( "\r\n", 2 );
//	}
//}
//
	return lRequestSize
end function

public function string of_getfieldentry (string as_szkey, string as_szvalue);string szResult;

//	szResult.Format( "--%s\r\n"
//					"Content-Type: text/xml\r\n"
//					"Content-ID: %s\r\n"
//					"Content-Length: %d\r\n\r\n"
//					"%s\r\n", m_szBoundary, szKey, strlen( szValue ), szValue );
szResult = "--"+is_m_szBoundary+"~r~n"  		&
				+"Content-Type: text/xml~r~n"		&
				+"Content-ID: "+as_szkey+"~r~n"    		&
				+"Content-Length: "+string(len(as_szvalue))+"~r~n~r~n"   	&
				+as_szvalue +"~r~n"
return szResult;
end function

public function string of_getfileentry (string szkey);String szResult;

//szResult.Format( "--%s\r\n"
//				"Content-Type: application/octet-stream\r\n" 
//				"Content-Length: %ld\r\n\r\n", m_szBoundary, szKey, _f.GetFileName(), _f.GetLength() );
//
return szResult;
end function

public function integer of_addfield (string as_szname, string as_szvalue);// Add field
long ll_bound,ll_i
ll_bound= UpperBound(istr_fieldMap.szkey[])
for ll_i = 1 to ll_bound
	if as_szname= istr_fieldMap.szkey[ll_i] then exit
next

if ll_i > ll_bound  then
	istr_fieldMap.szkey[ll_i] = as_szname
	istr_fieldMap.szvalue[ll_i]  = as_szvalue
else
	istr_fieldMap.szvalue[ll_i] = as_szvalue
end if

return 0
end function

public function string of_tostring ();string ls_file,ls_xml
integer li_FileNum

if  DirectoryExists ( gv_ini_path ) Then
	if right(gv_ini_path,1) ="\" then
		ls_file =gv_ini_path + "tostring.xml"
	else
     	ls_file =gv_ini_path + "\tostring.xml"
	end if
else
	ls_file ="c:\tostring.xml"
end if
doc.SaveDocument( ls_file )

li_FileNum = FileOpen(ls_file)
FileRead(li_FileNum, ls_xml)
FileClose(li_FileNum)
FileDelete ( ls_file )
return ls_xml
end function

public function long of_writerequest (ref string as_xml);	long lRequestSize = 0;

//	lRequestSize += WriteBlankLine( pFile );
//	lRequestSize += WriteBlankLine( pFile );
//	lRequestSize += WriteFieldEntries( pFile );
//	lRequestSize += WriteEOF( pFile );
	
	lRequestSize+= of_WriteBlankLine(as_xml)
	lRequestSize+= of_WriteBlankLine(as_xml)
	lRequestSize += of_WriteFieldEntries( as_xml )
	lRequestSize += of_WriteEOF( as_xml )
	return lRequestSize;
end function

public function long of_writefieldentries (ref string as_xml);long lRequestSize = 0;
//	POSITION p = m_fieldMap.GetStartPosition();
//	while( p )
//	{
//		// add a field
//		CString szValue;
//		CString szKey;
//		m_fieldMap.GetNextAssoc( p, szKey, szValue );
//
//		CString request = GetFieldEntry( szKey, szValue );
//
//		lRequestSize += request.GetLength();
//
//		if( pFile )
//		{
//			pFile->Write( request, request.GetLength() );
//			OutputDebugString( request);
//		}
//	}
long ll_bound,ll_i
string ls_szKey,ls_szValue,request

ll_bound =upperbound(istr_fieldMap.szkey[])
for ll_i = 1 to ll_bound
	ls_szKey =istr_fieldMap.szkey[ll_i]
	ls_szValue =istr_fieldMap.szValue[ll_i]
	request = of_GetFieldEntry( ls_szKey, ls_szValue )
	lRequestSize += len(request)
	as_xml += request
next

return lRequestSize
end function

public function long of_writeeof (ref string as_xml);long lRequestSize = 0;

//CString request = "--" + m_szBoundary + "--\r\n";
//
//lRequestSize += request.GetLength();
//
//if( pFile )
//{
//	pFile->Write( request, request.GetLength() );
//	OutputDebugString( request);
//}
string request="--" + is_m_szBoundary + "--~r~n"
lRequestSize += len(request)
as_xml = as_xml + request
return lRequestSize
end function

public function long of_writeblankline (ref string as_xml);long lRequestSize = 0;

//CString request = "\r\n";
//
//lRequestSize += request.GetLength();
//
//if( pFile )
//{
//	pFile->Write( request, request.GetLength() );
//	OutputDebugString( request);
//}

string request ="~r~n"
lRequestSize = len(request)
as_xml +=request
//is_xml = as_xml
return lRequestSize
end function

public function integer of_readdatafromfile (string as_xml);long ll_pos ,ll_pos1,ll_i,ll_upperbound,ll_length
string ls_m_szBoundary,ls_contentType,ls_contentId,ls_contentLength,ls_blankline,ls_contents
string ls_temp_line[]
n_cst_string lnv_string

lnv_string.of_parsetoarray(as_xml,'~r~n',ls_temp_line[]) 
ll_upperbound = upperbound(ls_temp_line)
if ll_upperbound =0 then return -1

ll_pos = pos(ls_temp_line[1], "boundary=" )
if ll_pos <0 then 
	//messagebox('',"Boundary not found")
	is_lasterror ='Boundary not found'
	return -1 
end if

ls_m_szBoundary = "--" + Mid( ls_temp_line[1],ll_pos+9 );
if right(ls_m_szBoundary,1)=';' then
	ls_m_szBoundary = left(ls_m_szBoundary,len(ls_m_szBoundary) - 1)	
end if

for ll_i = 2 to ll_upperbound
	 if ls_temp_line[ll_i] = ls_m_szBoundary then exit
next

if ll_i +5 > ll_upperbound then return -1
//ls_contentType  = ls_temp_line[ll_i + 1]
// read the Content-ID:
ls_contentId =ls_temp_line[ll_i + 2]
ll_pos = pos(ls_contentId, "Content-ID:" ) 
if ll_pos < 0 then 
	//messagebox('',"Tag out of order looking for Content-ID: "+string(ls_contentId))
	is_lasterror ="Tag out of order looking for Content-ID: "+string(ls_contentId)
	return -1 
end if

ls_contentId = Mid( ls_contentId,ll_pos+12 )
// read the Content-Length:
ls_contentLength=ls_temp_line[ll_i + 3]
ll_pos = pos(ls_contentLength, "Content-Length:" ) 
if ll_pos < 0 then 
	//messagebox('',"Tag out of order looking for Content-Length: "+string(ls_contentLength))
	is_lasterror ="Tag out of order looking for Content-Length: "+string(ls_contentLength)
	return -1 
end if
ls_contentLength=trim(Mid(ls_contentLength,ll_pos+16 ))
ll_length = long(ls_contentLength)
// Next line should be blank
ls_blankline =trim(ls_temp_line[ll_i + 4])
if ls_blankline <> '' then 
	is_lasterror = 'EOF looking for blank line:'
	return -1
end if

if len(ls_temp_line[ll_i + 5])  <> ll_length then return -1
ls_contents = ls_temp_line[ll_i + 5]

istr_fieldMap.szkey[1]	=ls_contentId
istr_fieldMap.szvalue[1]	=ls_contents

return 0
end function

public function string of_getfield (string as_szname);string ls_value =''
long ll_i
for ll_i =1 to upperbound(istr_fieldMap.szkey)
	if istr_fieldMap.szkey[ll_i] = as_szname then
		ls_value = istr_fieldMap.szvalue[ll_i]
		exit
	end if
next 

return ls_value
end function

public function appeondom_element of_parsexml (string as_xml);idoc_response = inv_builder.BuildFromString(as_xml)
inv_root = idoc_response.GetRootElement()

return inv_root


end function

public function integer of_setxmltag (appeondom_element lnv_root);long ll_i
appeondom_element lnv_nodes[]

//if inv_root.isrootelement() then
lnv_root.getChildElements(lnv_nodes)
for ll_i  =1 to upperbound(lnv_nodes)
	if  lnv_nodes[ll_i].getname() ='fault'  then
		//messagebox('',string(lnv_nodes[ll_i].gettext()))
		is_lasterror = string(lnv_nodes[ll_i].gettext())
		return -1
	end if
next

for ll_i  =1 to upperbound(lnv_nodes)
	if  lnv_nodes[ll_i].getname() ='params'  then exit
next
if ll_i > upperbound(lnv_nodes) then 
	is_lasterror ='Invalid XML tag passed to MethodResponse'
	//messagebox('','Invalid XML tag passed to MethodResponse')
	return -1
end if
//end if
return 0

end function

public function string of_getnodevalue (string as_type, string as_name, appeondom_element ao_nodes[]);appeondom_element lnv_nodes[], lnv_null[]
long ll, ll_row
string ls_value

for ll = 1 to upperbound(ao_nodes)
	if ao_nodes[ll].getname()=as_type and ao_nodes[ll].getattributevalue("name") =as_name  then
		ls_value = ao_nodes[ll].gettext()
		exit
	end if
	lnv_nodes = lnv_null
	ao_nodes[ll].getChildElements(lnv_nodes)
	if Upperbound(lnv_nodes) > 0 then
		ls_value = of_getnodevalue(as_type,as_name, lnv_nodes)
		if trim(ls_value) <> '' then exit
	end if
next
if as_type='long' and trim(ls_value)='' then ls_value ='0'
return ls_value

end function

public function long of_getlong (string as_name);//long MethodResponse::getLong( LPCTSTR name )
appeondom_element lnv_nodes[]
lnv_nodes[1] = inv_root
return  long(of_getnodevalue('long',as_name,lnv_nodes))

end function

public function integer of_addstringtag (ref appeondom_element pparenttag, string as_name, string as_attribute, string as_text);appeondom_ELEMENT Element_Child

Element_Child = CREATE appeondom_ELEMENT
Element_Child.SetName(as_name ) //
if trim(as_attribute)<> '' then
	Element_Child.setattribute("name", as_attribute)	
end if
Element_Child.settext(as_text)
pparenttag.AddContent( Element_Child )
destroy Element_Child

return 0
end function

public function integer of_addstring (string as_name, string as_attribute, string as_text);if of_isvalid(is_pmobject) =-1 then return -1
return of_addstringtag(element_parent,as_name,as_attribute,as_text)
 

end function

public function appeondom_element of_gettag_find (string as_name, string as_attributevalue, appeondom_element ao_nodes[]);appeondom_element ldom_this, lnv_null[],lnv_nodes[]
//"clientinfo", "return" 
long ll, ll_row
string ls_value

for ll = 1 to upperbound(ao_nodes)
	if as_attributevalue <> '' then 
		if ao_nodes[ll].getname()=as_name and ao_nodes[ll].getattributevalue("name") =as_attributevalue  then
			ldom_this =  ao_nodes[ll]
			exit
		end if
	else
		if ao_nodes[ll].getname()=as_name  then
			ldom_this =  ao_nodes[ll]
			exit
		end if
	end if
	lnv_nodes = lnv_null
	ao_nodes[ll].getChildElements(lnv_nodes)
	if Upperbound(lnv_nodes) > 0 then
		ldom_this = of_gettag_find(as_name,as_attributevalue, lnv_nodes)
		if  isvalid(ldom_this) then exit
	end if
next
return ldom_this
end function

public function integer of_addlongtag (appeondom_element pparenttag, string as_name, long al_text);appeondom_ELEMENT Element_Child

Element_Child = CREATE appeondom_ELEMENT
Element_Child.SetName('long')
if trim(as_name) <> '' then 
	Element_Child.setattribute("name", as_name)	
end if
Element_Child.settext(string(al_text))
pparenttag.AddContent( Element_Child )
destroy Element_Child

return 0

end function

public function appeondom_element of_gettag (string as_name, string as_attributevalue, appeondom_element adom_this);appeondom_element lnv_nodes[]
lnv_nodes[1] =adom_this
return  of_gettag_find(as_name,as_attributevalue,lnv_nodes)
end function

public function string of_getstring (string as_name, appeondom_element adom_this);//CString MethodResponse::getString( LPCTSTR name )
appeondom_element lnv_nodes[]
lnv_nodes[1] = adom_this
return  of_getnodevalue('string',as_name,lnv_nodes)
end function

on nvo_methodcall.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_methodcall.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;string ls_xml
//ls_xml = '<?xml version="1.0" encoding="UTF-8"?> ' + &
ls_xml ='<methodcall></methodcall>'

doc = create appeondom_Document 
root = create appeondom_Element  
element_parent = CREATE appeondom_ELEMENT 	
ibuilder_Bldr = Create appeondom_Builder

doc = ibuilder_Bldr.BuildFromString(ls_xml)
root = doc.getrootelement()

idoc_response  = create appeondom_Document 
inv_root = create appeondom_Element  
inv_builder =CREATE  appeondom_Builder
end event

event destructor;if isvalid(doc) then 
	destroy doc
end if
if isvalid(root) then
	destroy root
end if
if isvalid(ibuilder_Bldr) then
	destroy ibuilder_Bldr
end if
if isvalid(element_parent) then
	destroy element_parent
end if
if isvalid(inv_builder) then
	destroy inv_builder
end if
if isvalid(idoc_response) then
	destroy idoc_response
end if
if isvalid(inv_root) then
	destroy inv_root
end if

end event

