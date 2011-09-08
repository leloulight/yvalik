if {[catch {package require Tcl 8.4}]} return
package ifneeded Tix 8.4.2  [list load [file join $dir Tix842.dll] Tix]
