HA$PBExportHeader$pbdom_builder.sru
forward
global type pbdom_builder from nonvisualobject
end type
end forward

global type pbdom_builder from nonvisualobject
end type
global pbdom_builder pbdom_builder

type variables

private:

OLEObject iole_document
//pbdom_document idom_document
pbdom_doctype idom_document
end variables

forward prototypes
public function pbdom_document buildfromstring (string as_xml)
public function pbdom_document buildfromfile (string as_file)
public function pbdom_document buildfromdatastore (datastore ads_data)
public function pbdom_document buildfromdatastore (datastore ads_data, boolean abl_apb)
end prototypes

public function pbdom_document buildfromstring (string as_xml);boolean lb_success
string ls_rtn

if isnull(as_xml) or as_xml = "" then
	return idom_document
end if

lb_success = iole_document.loadXML(as_xml)
if lb_success = true then
	ls_rtn = 'success'
	idom_document.uf_setDom(iole_document)
else
	ls_rtn = 'failure'
end if

return idom_document

end function

public function pbdom_document buildfromfile (string as_file);
boolean lb_success
string ls_rtn

lb_success = iole_document.load(as_file)
if lb_success = true then
	ls_rtn = 'success'
	idom_document.uf_setDom(iole_document)
else
	ls_rtn = 'failure'
end if

return idom_document

end function

public function pbdom_document buildfromdatastore (datastore ads_data);integer li_Return
pbdom_document ldom_document
string ls_Xml = "c:\$pbdom_data.xml"

IF gb_is_web THEN //APB Unsupport
	ldom_document = buildfromdatastore(ads_data,true)
	return ldom_document
End if

if isnull(ads_data) then
	return idom_document
end if
if not IsValid(ads_data) then
	return idom_document
end if

li_Return = ads_data.SaveAs(ls_Xml, xml!, true)

if li_Return <> 1 then
	FileDelete(ls_Xml)
	return idom_document
end if

ldom_document = BuildFromFile(ls_Xml)
FileDelete(ls_Xml)

return ldom_document
end function

public function pbdom_document buildfromdatastore (datastore ads_data, boolean abl_apb);string ls_Xml
integer li_Return
pbdom_document		ldom_document
ldom_document = Create PBDOM_Document

ls_Xml = '<?xml version="1.0" encoding="UTF-16LE" standalone="no" ?><data/>'
ldom_document = this.BuildFromString(ls_Xml)


int							i,j
String						ls_colname,ls_data
PBDOM_ELEMENT		Element_Root,Element_datarow,Element_column
Element_Root = ldom_document.GetRootElement()

for i = 1 to ads_data.rowcount()
			//Add the data_row Element
			if not isvalid(Element_datarow) then Element_datarow = CREATE PBDOM_ELEMENT
			if not isvalid(Element_column) then Element_column = CREATE PBDOM_ELEMENT						
			Element_datarow.SetName("data_row")
					
			for j =1 to Long(ads_data.describe("DataWindow.Column.Count"))
				ls_colname = ads_data.Describe("#"+string(j)+".name")
				if isnull(ls_colname) or ls_colname = "" then continue 
				
				Element_column.SetName(ls_colname)				
				ls_data = ads_data.Describe("Evaluate('LookUpDisplay(" + ls_colname + ")', " + String(i) + ")") 
				if isnull(ls_data) then ls_data = ""
				Element_column.AddContent(ls_data)	
				
				Element_datarow.AddContent(Element_column)
			next
					
			Element_Root.AddContent(Element_datarow)
					
next

if isvalid(Element_datarow) then Destroy Element_datarow
if isvalid(Element_column) then Destroy Element_column

return ldom_document



	
end function

on pbdom_builder.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pbdom_builder.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
iole_document = create OLEObject
iole_document.connectToNewObject('msxml.domdocument')
iole_document.preserveWhiteSpace = true

idom_document = create pbdom_doctype

end event

event destructor;
iole_document.disconnectObject()
destroy iole_document

end event

