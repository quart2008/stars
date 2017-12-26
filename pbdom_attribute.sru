HA$PBExportHeader$pbdom_attribute.sru
forward
global type pbdom_attribute from pbdom_object
end type
end forward

global type pbdom_attribute from pbdom_object
end type
global pbdom_attribute pbdom_attribute

forward prototypes
public function string getobjectclassstring ()
end prototypes

public function string getobjectclassstring ();
return 'pbdom_attribute'
end function

on pbdom_attribute.create
call super::create
end on

on pbdom_attribute.destroy
call super::destroy
end on

