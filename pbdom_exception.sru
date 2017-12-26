HA$PBExportHeader$pbdom_exception.sru
forward
global type pbdom_exception from exception
end type
end forward

global type pbdom_exception from exception
end type
global pbdom_exception pbdom_exception

type variables
 
end variables

on pbdom_exception.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pbdom_exception.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

