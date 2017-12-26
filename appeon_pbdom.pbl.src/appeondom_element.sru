$PBExportHeader$appeondom_element.sru
forward
global type appeondom_element from appeondom_object
end type
end forward

global type appeondom_element from appeondom_object
end type
global appeondom_element appeondom_element

type variables

private:
appeondom_attribute inv_domAttr[]

end variables

forward prototypes
public function boolean getattributes (ref appeondom_attribute anv_domattr[])
public function string getobjectclassstring ()
public function boolean getchildelements (ref appeondom_element appeondom_arg[])
public function appeondom_element getchildelement (string strelementname)
public function appeondom_object addcontent (appeondom_object appeondom_object_ref)
public subroutine setname (string as_name)
public function appeondom_element setattribute (string strname, string strvalue)
public function string getattributevalue (string strattributename)
public function appeondom_element settext (string strtext)
public function integer of_getchildcount ()
public function boolean removechildelements ()
public function appeondom_object addcontent (string as_text)
end prototypes

public function boolean getattributes (ref appeondom_attribute anv_domattr[]);
OLEObject lole_attrs
OLEObject lole_item
appeondom_attribute lnv_domAttr[]
long i

lole_attrs = iole_dom.attributes

for i = 1 to lole_attrs.length
	lole_item = lole_attrs.item(i - 1)
	lnv_domAttr[i] = create appeondom_attribute
	lnv_domAttr[i].uf_setDom(lole_item)
next

this.uf_destroyObjs(inv_domAttr)
inv_domAttr = lnv_domAttr

anv_domAttr = inv_domAttr

return true

end function

public function string getobjectclassstring ();
return 'appeondom_element'

end function

public function boolean getchildelements (ref appeondom_element appeondom_arg[]);int i
oleobject oNodeList
oleobject lole_child

 oNodeList = iole_dom.childNodes()
 for i = 1 to oNodeList.length()
	lole_child = oNodeList.item(i - 1)
	if lole_child.nodeTypeString = 'element' then		
		appeondom_arg[upperbound(appeondom_arg) + 1]  = create appeondom_element
		appeondom_arg[upperbound(appeondom_arg) ] .uf_setDom(lole_child)	
	end if
next

return true
end function

public function appeondom_element getchildelement (string strelementname);
int i
oleobject oNodeList
oleobject lole_child
appeondom_element appeondom_get

appeondom_get = create appeondom_element

//1.
oNodeList = iole_dom.childNodes()
 for i = 1 to oNodeList.length()
	lole_child = oNodeList.item(i - 1)
	if lole_child.nodename() = strelementname  then		
		appeondom_get.uf_setDom(lole_child)		
		return appeondom_get
	end if
next

/*
//2.
oNodeList = iole_dom.getElementsByTagName( strelementname )

for i = 0 to oNodeList.length()   
	lole_child = oNodeList.item(i)
     if lole_child.nodename() = strelementname  then		
		appeondom_get.uf_setDom(lole_child)		
		return appeondom_get
	end if   
next
*/
return appeondom_get
end function

public function appeondom_object addcontent (appeondom_object appeondom_object_ref);Oleobject	lappeondom_object
lappeondom_object = appeondom_object_ref.of_getobject()

if not isvalid(lappeondom_object) or isnull(lappeondom_object) then
	return This
end if

iole_dom.appendChild(lappeondom_object)

return This


end function

public subroutine setname (string as_name);//iole_dom.nodeName = as_name

Oleobject root
root = iole_nodeDoc.documentElement()
iole_dom = iole_nodeDoc.createElement(as_name)

end subroutine

public function appeondom_element setattribute (string strname, string strvalue);if isnull(strvalue) then strvalue = ''
if strname <> '' then
	iole_dom.setAttribute(strname, strvalue)
end if

Return This

end function

public function string getattributevalue (string strattributename);oleobject		nodeId
string			ls_Value

nodeId = iole_dom.getAttributeNode(strattributename)

if not isvalid(nodeId) or isnull(nodeId) then
	setnull(ls_Value)
	return ls_Value
end if

ls_Value = nodeId.value()

Return ls_Value

end function

public function appeondom_element settext (string strtext);iole_dom.text = strtext
return This


end function

public function integer of_getchildcount ();integer li_Count
integer i, li_Length
string ls_nodeTypeString
oleobject lole_child

li_Length = iole_dom.childNodes.Length()

for i = 1 to li_Length
	lole_child = iole_dom.childNodes.item(i - 1)
	ls_nodeTypeString = lole_child.nodeTypeString
	ls_nodeTypeString = Lower(ls_nodeTypeString)	
	if ls_nodeTypeString = "element" then
		li_Count ++
	end if
next

Return li_Count
end function

public function boolean removechildelements ();integer i, li_Count

li_Count = of_GetChildCount()
for i = 1 to li_Count
	iole_dom.RemoveChild(iole_dom.childNodes.item(i))
next

Return true
end function

public function appeondom_object addcontent (string as_text);oleobject lole_Node

lole_Node = iole_nodeDoc.createTextNode(as_Text)
iole_dom.appendChild(lole_Node)

return This
end function

on appeondom_element.create
call super::create
end on

on appeondom_element.destroy
call super::destroy
end on

event destructor;call super::destructor;
this.uf_destroyObjs(inv_domAttr)

end event

