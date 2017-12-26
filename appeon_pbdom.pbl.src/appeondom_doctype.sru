$PBExportHeader$appeondom_doctype.sru
forward
global type appeondom_doctype from appeondom_document
end type
end forward

global type appeondom_doctype from appeondom_document
end type
global appeondom_doctype appeondom_doctype

type variables

private:
appeondom_processinginstruction inv_process[]
OLEObject iole_root

end variables

forward prototypes
public function string getname ()
public function string gettext ()
public function boolean getcontent (ref appeondom_object a_objnode[])
end prototypes

public function string getname ();
return '#document'

end function

public function string gettext ();
return ''

end function

public function boolean getcontent (ref appeondom_object a_objnode[]);
OLEObject lole_childs
OLEObject lole_item, lole_doc
appeondom_object lnv_domChilds[]
long i

lole_childs = iole_dom.childNodes
for i = 1 to lole_childs.length
	lole_item = lole_childs.item(i - 1)
	lnv_domChilds[i] = this.uf_createDomObject(lole_item.nodetypestring)
	if lole_item.nodetypestring = 'element' then
		lole_item = iole_dom.documentElement
	end if
	lnv_domChilds[i].uf_setDom(lole_item)
next

this.uf_destroyObjs(inv_domChilds)
inv_domChilds = lnv_domChilds

a_objNode = inv_domChilds

return true

end function

on appeondom_doctype.create
call super::create
end on

on appeondom_doctype.destroy
call super::destroy
end on

