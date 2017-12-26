$PBExportHeader$appeondom_document.sru
forward
global type appeondom_document from appeondom_object
end type
end forward

global type appeondom_document from appeondom_object
end type
global appeondom_document appeondom_document

type variables

end variables

forward prototypes
public function string getobjectclassstring ()
public function appeondom_element getrootelement ()
public function boolean getelementsbytagname (string strtagname, ref appeondom_element appeondom_element_array[])
public function boolean savedocument (string strfilename)
public function boolean newdocument (string as_rootelementname)
end prototypes

public function string getobjectclassstring ();
return 'appeondom_document'

end function

public function appeondom_element getrootelement ();oleobject lole_temp
appeondom_element  appeondom_temp

appeondom_temp = create appeondom_element

lole_temp = iole_dom.documentElement()

appeondom_temp.uf_setDom(lole_temp)

return appeondom_temp
end function

public function boolean getelementsbytagname (string strtagname, ref appeondom_element appeondom_element_array[]);int i
oleobject oNodeList
oleobject lole_child

/*
//1.
oNodeList = iole_dom.childNodes()
 for i = 1 to oNodeList.length()
	lole_child = oNodeList.item(i - 1)
	
	if lole_child.nodeTypeString = 'element' then		
		appeondom_arg[upperbound(appeondom_arg) + 1]  = create appeondom_element
		appeondom_arg[upperbound(appeondom_arg) ] .uf_setDom(lole_child)	
	end if
	
	if lole_child.nodename() = strelementname  then		
		appeondom_get.uf_setDom(lole_child)		
		return appeondom_get
	end if
next
*/

//2.
oNodeList = iole_dom.getElementsByTagName( strtagname )

for i = 1 to oNodeList.length()   
	lole_child = oNodeList.item(i - 1)
    if lole_child.nodeTypeString = 'element' then		
		appeondom_element_array[upperbound(appeondom_element_array) + 1]  = create appeondom_element
		appeondom_element_array[upperbound(appeondom_element_array) ].uf_setDom(lole_child)	
	end if
next

if oNodeList.length()   > 0 then 
	return true
end if

return false
end function

public function boolean savedocument (string strfilename);iole_dom.save(strfilename)

Return True
end function

public function boolean newdocument (string as_rootelementname);boolean lb_Return

lb_Return = iole_nodeDoc.LoadXML("<" + as_RootElementName + "/>")
iole_dom = iole_nodeDoc

return lb_Return
end function

on appeondom_document.create
call super::create
end on

on appeondom_document.destroy
call super::destroy
end on

