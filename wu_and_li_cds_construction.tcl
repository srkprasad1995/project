 #Define options
set val(chan)           Channel/WirelessChannel                  ;# channel type
set val(prop)           Propagation/TwoRayGround            ;# radio-propagation model
set val(netif)            Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                  ;# MAC type
set val(ifq)              Queue/DropTail/PriQueue                 ;# interface queue type
set val(ll)                 LL               ;# link layer type
set val(ant)              Antenna/OmniAntenna    ;# antenna model
set val(ifqlen)           50               ;# max packet in ifq
set val(nn)                30                 ;# number of mobilenodes
set val(rp)               AODV         ;# routing protocol
set val(x)                500               ;# X dimension of topography
set val(y)                400               ;# Y dimension of topography  
set val(stop)           30                 ;# time of simulation end

#Creating simulation: 
set ns [new Simulator]
set tracefd       [open wireless3.tr w]
set namtrace      [open wireless3.nam w]   

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON

for { set i 0 } { $i < $val(nn)} { incr i } {
	set back_bone($i) 0
}

for { set i 0 } { $i < $val(nn)} { incr i } {
	for {set j 0 } { $j < $val(nn)} { incr j } {
		for {set k 0 } { $k < $val(nn)} { incr k } {
			set connected($k,$j) 0
		}
	}
	set fileName "nodal"
	append fileName $i ".txt"
	set fp [open $fileName r]
	fconfigure $fp -buffering line
	set neighbours 0
	gets $fp neighbours
	for {set j 0 } { $j < $neighbours} { incr j } {
		set nod1 0
		gets $fp nod1
		set fileName "nodal"
		append fileName $nod1 ".txt"
		set fp1 [open $fileName r]
		fconfigure $fp1 -buffering line
		set neighbours1 0
		gets $fp1 neighbours1
		for {set k 0 } { $k < $neighbours1} { incr k } {
			set nod2 0
			gets $fp1 nod2
			set connected($nod1,$nod2) 1
		}
		close $fp1
	}
	close $fp
	set fp [open $fileName r]
	fconfigure $fp -buffering line
	set neighbours 0
	gets $fp neighbours
	for {set j 0 } { $j < $neighbours} { incr j } {
	set temp 0
	gets $fp temp
	set a($j) $temp
	}
	set flag 0
	for {set j 0 } { $j < $neighbours} { incr j } {
		if {$flag != 0 } {
			break
		} 
		for {set k $j } {$k < $neighbours} { incr k } {
			#puts -nonewline $a($j)
			#puts -nonewline "  "
			#puts $a($k)
			if { $a($j) != $i && $a($k) != $i && $j!=$k && $connected($a($j),$a($k)) != 1 } {
				set flag 1
				break;
			}
		}
	}
	if { $flag !=0 } {
		set back_bone($i) 1
		puts $i
	}
	close $fp
}
#applying rule 1

puts ""
puts ""

for { set i 0 } { $i < $val(nn)} { incr i } {
	if { $back_bone($i) == 1} {
		set fileName "nodal"
		append fileName $i ".txt"
		set fp [open $fileName r]
		fconfigure $fp -buffering line
		set neighbours 0
		gets $fp neighbours
		for {set j 0 } { $j < $neighbours} { incr j } {
			set nod1 0
			gets $fp nod1
			for {set k 0 } { $k < $val(nn)} { incr k } {
				set visited($k) 0
			}
			set fileName "nodal"
			append fileName $nod1 ".txt"
			set fp1 [open $fileName r]
			fconfigure $fp1 -buffering line
			set neighbours1 0
			gets $fp1 neighbours1
			set visited($nod1) 1
			for {set k 0 } { $k < $neighbours1} { incr k } {	
				set nod2 0
				gets $fp1 nod2
				set visited($nod2) 1
			}
			set fileName "nodal"
			append fileName $i ".txt"
			set fp3 [open $fileName r]
			fconfigure $fp3 -buffering line
			set neighbours3 0
			gets $fp3 neighbours3
			set f 1
			for { set k 0 } {$k < $neighbours3} {incr k} {
				set nod2 0
				gets $fp3 nod2 
				if { $visited($nod2) == 0} {
					#puts -nonewline $i
					#puts -nonewline $nod1
					#puts $nod2
					set f 0
					break;
				}
			}
			if { $f == 1 && $nod1>$i } {
			set back_bone($i) 0
			puts $i
			break
			}
			close $fp3
		}
	}
}

puts " back bone vertices::"

for {set i 0 } {$i < $val(nn)} { incr i } {
	if { $back_bone($i) == 1 } {
		puts $i
	}
}

puts ""
puts ""

#applying rule 2
for { set i 0 } { $i < $val(nn)} { incr i } {
	if { $back_bone($i) == 1} {
		puts $i
		set fileName "nodal"
		append fileName $i ".txt"
		set fp [open $fileName r]
		fconfigure $fp -buffering line
		set neighbours 0
		gets $fp neighbours
		for {set j 0 } { $j < $neighbours} { incr j } {
			set temp 0
			gets $fp temp
			set a($j) $temp
		}
		close $fp
		set f 0
		for {set j  0 } {$j < $neighbours } { incr j } {
			for {set k $j } { $k < $neighbours } {incr k} {
				if { $k == $j } {
					continue
				} 
				for {set l 0 } {$l < $val(nn)} {incr l} {
					set visited($l) 0
				}
				set fileName "nodal"
				append fileName $a($j) ".txt"
				set fpj [open $fileName r]
				fconfigure $fpj -buffering line
				set neighboursj 0
				gets $fpj neighboursj
				for { set nj 0 } {$nj < $neighboursj} {incr nj } {
					set nod2 0
					gets $fpj nod2
					set visited($nod2) 1
					#puts -nonewline $a($j)
					#puts -nonewline "  "
					#puts $nod2
				}
				close $fpj
				set fileName "nodal"
				append fileName $a($k) ".txt"
				set fpk [open $fileName r]
				fconfigure $fpk -buffering line
				set neighboursk 0
				gets $fpk neighboursk
				for {set nk 0} {$nk < $neighboursk} {incr nk} {
					set nod2 0
					gets $fpk nod2
					set visited($nod2) 1
					#puts -nonewline $a($k)
					#puts -nonewline "  "
					#puts $nod2
				}
				close $fpk
				set fileName "nodal"
				append fileName $i ".txt"
				set fp3 [open $fileName r]
				fconfigure $fp3 -buffering line
				set neighbours3 0
				gets $fp3 neighbours3
				set f 1
				for { set gk 0 } {$gk < $neighbours3} {incr gk} {
					set nod2 0
					gets $fp3 nod2 
					if { $visited($nod2) == 0} {
						set f 0
						break;
					}
				}
				close $fp3
				if { $f == 1 && $a($j)>$i && $a($k) >$i } {
				set back_bone($i) 0
				puts $i
				break
				}
			}
			
		}
	}
}


puts " back bone vertices::"

for {set i 0 } {$i < $val(nn)} { incr i } {
	if { $back_bone($i) == 1 } {
		puts $i
	}
}
