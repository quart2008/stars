HA$PBExportHeader$pbdom_doctype.sru
forward
global type pbdom_doctype from pbdom_document
end type
end forward

global type pbdom_doctype from pbdom_document
end type
global pbdom_doctype pbdom_doctype

type variables

private:
pbdom_processinginstruction inv_process[]
OLEObject iole_root

end variables

forward prototypes
public function string getname ()
public function string gettext ()
public function boolean getcontent (ref pbdom_object a_objnode[])
end prototypes

public function string getname ();
return '#document'

end function

public function string gettext ();
return ''

end function

public function boolean getcontent (ref pbdom_object a_objnode[]);
OLEObject lole_childs
OLEObject lole_item, lole_doc
pbdom_object lnv_domChilds[]
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

on pbdom_doctype.create
call super::create
end on

on pbdom_doctype.destroy
call super::destroy
end on

