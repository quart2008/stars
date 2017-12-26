HA$PBExportHeader$pbdom_document.sru
forward
global type pbdom_document from pbdom_object
end type
end forward

global type pbdom_document from pbdom_object
end type
global pbdom_document pbdom_document

type variables

end variables

forward prototypes
public function string getobjectclassstring ()
public function pbdom_element getrootelement ()
public function boolean getelementsbytagname (string strtagname, ref pbdom_element pbdom_element_array[])
public function boolean savedocument (string strfilename)
public function boolean newdocument (string as_rootelementname)
end prototypes

public function string getobjectclassstring ();
return 'pbdom_document'

end function

public function pbdom_element getrootelement ();oleobject lole_temp
pbdom_element  pbdom_temp

pbdom_temp = create pbdom_element

lole_temp = iole_dom.documentElement()

pbdom_temp.uf_setDom(lole_temp)

return pbdom_temp
end function

public function boolean getelementsbytagname (string strtagname, ref pbdom_element pbdom_element_array[]);int i
oleobject oNodeList
oleobject lole_child

/*
//1.
oNodeList = iole_dom.childNodes()
 for i = 1 to oNodeList.length()
	lole_child = oNodeList.item(i - 1)
	
	if lole_child.nodeTypeString = 'element' then		
		pbdom_arg[upperbound(pbdom_arg) + 1]  = create pbdom_element
		pbdom_arg[upperbound(pbdom_arg) ] .uf_setDom(lole_child)	
	end if
	
	if lole_child.nodename() = strelementname  then		
		pbdom_get.uf_setDom(lole_child)		
		return pbdom_get
	end if
next
*/

//2.
oNodeList = iole_dom.getElementsByTagName( strtagname )

for i = 1 to oNodeList.length()   
	lole_child = oNodeList.item(i - 1)
    if lole_child.nodeTypeString = 'element' then		
		pbdom_element_array[upperbound(pbdom_element_array) + 1]  = create pbdom_element
		pbdom_element_array[upperbound(pbdom_element_array) ].uf_setDom(lole_child)	
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

on pbdom_document.create
call super::create
end on

on pbdom_document.destroy
call super::destroy
end on

