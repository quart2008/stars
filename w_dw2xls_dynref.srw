HA$PBExportHeader$w_dw2xls_dynref.srw
$PBExportComments$Just referencing dynamically accessed DWs, so that no resource file is required when building  all in one EXE without PBDs.
forward
global type w_dw2xls_dynref from window
end type
type dw_2 from datawindow within w_dw2xls_dynref
end type
type dw_1 from datawindow within w_dw2xls_dynref
end type
end forward

global type w_dw2xls_dynref from window
integer width = 2533
integer height = 1408
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_2 dw_2
dw_1 dw_1
end type
global w_dw2xls_dynref w_dw2xls_dynref

on w_dw2xls_dynref.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.dw_2,&
this.dw_1}
end on

on w_dw2xls_dynref.destroy
destroy(this.dw_2)
destroy(this.dw_1)
end on

type dw_2 from datawindow within w_dw2xls_dynref
integer x = 105
integer y = 508
integer width = 686
integer height = 400
integer taborder = 20
string title = "none"
string dataobject = "d_dw2xls_object_sort_s"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_dw2xls_dynref
integer x = 105
integer y = 76
integer width = 686
integer height = 400
integer taborder = 10
string title = "none"
string dataobject = "d_dw2xls_object_sort"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

