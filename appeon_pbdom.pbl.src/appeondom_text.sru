$PBExportHeader$appeondom_text.sru
forward
global type appeondom_text from appeondom_object
end type
end forward

global type appeondom_text from appeondom_object
end type
global appeondom_text appeondom_text

type variables

private:
string is_text

end variables

forward prototypes
public function string getname ()
public function boolean getcontent (ref appeondom_object a_objnode[])
public function string gettext ()
public function string getobjectclassstring ()
public subroutine settext (string as_text)
end prototypes

public function string getname ();
return '#text'

end function

public function boolean getcontent (ref appeondom_object a_objnode[]);
return false

end function

public function string gettext ();string ls_nodeText

ls_nodeText = iole_dom.text

return ls_nodeText

end function

public function string getobjectclassstring ();
return 'appeondom_text'

end function

public subroutine settext (string as_text);
is_text = as_text

end subroutine

on appeondom_text.create
call super::create
end on

on appeondom_text.destroy
call super::destroy
end on

