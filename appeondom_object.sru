HA$PBExportHeader$appeondom_object.sru
forward
global type appeondom_object from nonvisualobject
end type
end forward

global type appeondom_object from nonvisualobject
end type
global appeondom_object appeondom_object

type variables
protected:
OLEObject iole_dom
OLEObject iole_nodeDoc

appeondom_object inv_domChilds[]

end variables

forward prototypes
public function string getobjectclassstring ()
public function boolean getcontent (ref appeondom_object a_objnode[])
public subroutine uf_setdom (ref oleobject aole_dom)
public function string getname ()
public function string gettext ()
protected subroutine uf_destroyobjs (powerobject a_obj[])
public function appeondom_object uf_createdomobject (string as_type)
public subroutine setname (string as_name)
public function oleobject of_getobject ()
end prototypes

public function string getobjectclassstring ();
return 'appeondom_object'

end function

public function boolean getcontent (ref appeondom_object a_objnode[]);
OLEObject lole_childs
OLEObject lole_item
appeondom_object lnv_domChilds[]
long i

lole_childs = iole_dom.childNodes
for i = 1 to lole_childs.length
	lole_item = lole_childs.item(i - 1)
	lnv_domChilds[i] = this.uf_createDomObject(lole_item.nodetypestring)
	lnv_domChilds[i].uf_setDom(lole_item)
next

this.uf_destroyObjs(inv_domChilds)
inv_domChilds = lnv_domChilds

a_objNode = inv_domChilds

return true

end function

public subroutine uf_setdom (ref oleobject aole_dom);
iole_dom = aole_dom

end subroutine

public function string getname ();
string ls_nodeName

ls_nodeName = iole_dom.nodeName

return ls_nodeName

end function

public function string gettext ();/*
OLEObject lole_item, lole_node
string ls_nodeText, ls_xml
long ll_len, i

ls_xml = iole_dom.xml
iole_nodeDoc.loadXML(ls_xml)
ll_len = iole_nodeDoc.childNodes.length
if ll_len > 0 then
	lole_node = iole_nodeDoc.childNodes.item[0]
	ll_len = lole_node.childNodes.length
	for i = ll_len - 1 to 1 step -1
		lole_item = lole_node.childNodes.item[i]
		if lole_item.nodeTypeString = 'element' then
			lole_node.removeChild(lole_item)
		end if
	next
	ls_nodeText = iole_nodeDoc.text
else
	ls_nodeText = iole_dom.text
end if
*/
string ls_nodeText

if not isvalid(iole_dom) or isnull(iole_dom) then
	setnull(ls_nodeText)
	return ls_nodeText
end if

ls_nodeText = iole_dom.text
return ls_nodeText


end function

protected subroutine uf_destroyobjs (powerobject a_obj[]);
long i

for i = 1 to upperBound(a_obj)
	if isValid(a_obj[i]) then destroy a_obj[i]
next

end subroutine

public function appeondom_object uf_createdomobject (string as_type);
appeondom_object lnv_domObj

as_type = lower(as_type)
choose case as_type
	case 'element'
		lnv_domObj = create appeondom_element
	case 'attribute'
		lnv_domObj = create appeondom_attribute
	case 'doctype'
		lnv_domObj = create appeondom_doctype
	case 'document'
		lnv_domObj = create appeondom_document
	case 'processinginstruction'
		lnv_domObj = create appeondom_processingInstruction
	case 'text'
		lnv_domObj = create appeondom_text
	case else
		messageBox('Error!', 'Error appeondom type - ' + as_type)
end choose

return lnv_domObj

end function

public subroutine setname (string as_name);
end subroutine

public function oleobject of_getobject ();return iole_dom
end function

on appeondom_object.create
call super::create
TriggerEvent( this, "constructor" )
end on

on appeondom_object.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
this.uf_destroyObjs(inv_domChilds)
iole_nodeDoc.disconnectObject()

destroy iole_nodeDoc

end event

event constructor;
iole_nodeDoc = create OLEObject
iole_nodeDoc.connectToNewObject('msxml.domdocument')
iole_nodeDoc.preserveWhiteSpace = true

end event

