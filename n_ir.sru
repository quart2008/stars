HA$PBExportHeader$n_ir.sru
forward
global type n_ir from internetresult
end type
end forward

global type n_ir from internetresult
end type
global n_ir n_ir

type variables
blob iblob_data
string is_data
end variables

forward prototypes
public function integer internetdata (blob data)
end prototypes

public function integer internetdata (blob data);iblob_data = data
is_data = string(data,EncodingANSI!)
return 1
end function

on n_ir.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ir.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

