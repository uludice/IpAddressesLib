#!/bin/sh

#\
exec tclsh "$0" "$@"

source IpAddressesLib.tcl

proc Test_Gen_Ip {n} {
  proc o {} {
    return [expr int(rand()*1000)]
  }

  set ok 0
  set r [ time {
    set ip [o].[o].[o].[o]
    if { ! [IsDottedIpValid $ip] } { 
      puts "$ip FAIL"
    } else {
      incr ok
      puts "$ip Ok"
    }
  } $n ] 
  puts "$ok/$n;  $r"
}

proc Test_All_Mask_Length_Verbose {} { 
  for {set i 0} {$i < 33} {incr i} {
    set m [MaskLenToDotted $i];
    set l [MaskDottedToLen $m];
    if {$i != $l} {
      puts "$m $l != $i FAIL!"
    } else {
      puts "$m $l Ok"
    }
  } 
}

Test_Gen_Ip 1000
Test_All_Mask_Length_Verbose
