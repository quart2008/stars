HA$PBExportHeader$appeondom_processinginstruction.sru
forward
global type appeondom_processinginstruction from appeondom_object
end type
end forward

global type appeondom_processinginstruction from appeondom_object
end type
global appeondom_processinginstruction appeondom_processinginstruction

type variables

private:
string is_text, is_name

end variables

forward prototypes
public function string getobjectclassstring ()
public subroutine settext (string as_text)
public subroutine uf_parse (string as_instruction)
end prototypes

public function string getobjectclassstring (); 
return 'appeondom_processinginstruction'

end function

public subroutine settext (string as_text);
end subroutine

public subroutine uf_parse (string as_instruction);
long ll_pos
string ls_name, ls_instruction, ls_text

ls_instruction = as_instruction

//Get instruction name
ll_pos = pos(ls_instruction, ' ')
ls_name = trim(mid(ls_instruction, 3, ll_pos - 2))
this.setName(ls_name)

ls_instruction = mid(ls_instruction, ll_pos + 1)

//Get text
ll_pos = pos(ls_instruction, '?>')
ls_text = left(ls_instruction, ll_pos - 1)
is_text = ls_text

end subroutine

on appeondom_processinginstruction.create
call super::create
end on

on appeondom_processinginstruction.destroy
call super::destroy
end on

