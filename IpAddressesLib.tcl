proc IpDottedToInt {s} {
  scan $s %d.%d.%d.%d a b c d
  return [expr [format 0x%02x%02x%02x%02x $a $b $c $d]]
}

proc IpIntToDotted {n} {
  scan [format %08lx $n] %02x%02x%02x%02x a b c d
  return [format %d.%d.%d.%d $a $b $c $d]
}

proc MaskLenToInt {n} {
  return [expr [format 0b%-032s [string repeat 1 $n]]]
}

proc MaskLenToDotted {n} {
  return [IpIntToDotted [MaskLenToInt $n]]
}

proc MaskDottedToLen {s} {
  return [string length [string trimright [format %-032b [IpDottedToInt $s]] 0]]
}

proc IsDottedIpValid {s} {
  set r [regexp {^([0-9]{1,3}\.){3}[0-9]{1,3}$} $s]
  if {$r} {
    scan $s %d.%d.%d.%d a b c d
    set sa [format %d.%d.%d.%d [expr $a%256] [expr $b%256] [expr $c%256] [expr $d%256]]
    set r [expr [IpDottedToInt $s] == [IpDottedToInt $sa]]
  }
  return $r
}

proc IsDottedMaskValid {s} {
  return [expr [IsDottedIpValid $s] && [IpDottedToInt $s] == [IpDottedToInt [MaskLenToDotted [MaskDottedToLen $s]]]]
}
