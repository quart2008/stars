$PBExportHeader$appeondom_exception.sru
forward
global type appeondom_exception from exception
end type
end forward

global type appeondom_exception from exception
end type
global appeondom_exception appeondom_exception

type variables
 
end variables

on appeondom_exception.create
call super::create
TriggerEvent( this, "constructor" )
end on

on appeondom_exception.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

