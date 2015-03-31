 #Define options
set val(chan)           Channel/WirelessChannel                  ;# channel type
set val(prop)           Propagation/TwoRayGround            ;# radio-propagation model
set val(netif)            Phy/WirelessPhy                               ;# network interface type
set val(mac)            Mac/802_11                                     ;# MAC type
set val(ifq)              Queue/DropTail/PriQueue                 ;# interface queue type
set val(ll)                 LL                                                     ;# link layer type
set val(ant)              Antenna/OmniAntenna                       ;# antenna model
set val(ifqlen)           50                                                     ;# max packet in ifq
set val(nn)                30                                                       ;# number of mobilenodes
set val(rp)               AODV                                               ;# routing protocol
set val(x)                500                                                     ;# X dimension of topography
set val(y)                400                                                     ;# Y dimension of topography  
set val(stop)           30                                                       ;# time of simulation end

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
                   -llType $val(ll) \
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


for {set i 0} {$i < $val(nn) } { incr i } {
            set n($i) [$ns node]      
}


## Provide initial location of mobilenodes..
            for {set i 0} {$i < $val(nn) } { incr i } {
                  set xx [expr rand()*500]
                  set yy [expr rand()*400]
                  $n($i) set X_ $xx
                  $n($i) set Y_ $yy
                  
            }

# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
# 30 defines the node size for nam
$ns initial_node_pos $n($i) 30
}

for {set i 0} {$i < $val(nn)} {incr i} {
	set id($i) $i
	set head($i) 0
	set covered($i) 0
}

for {set i 0} {$i < $val(nn)} {incr i} {
      for {set j 0} {$j <$val(nn)} {incr j} {	
	set connected($i,$j) 0
	set connect($i,$j) 0
}
}
	for { set i 0 } { $i < $val(nn)} { incr i } {
		set fileName "node"
		append fileName $i ".txt"
		puts $fileName
		set fp [open $fileName w]
		fconfigure $fp -buffering line
		puts -nonewline $fp "neighbours of node:"
		puts $fp $i
		for {set j 0 } { $j < $val(nn)} { incr j } {
			set x1 [expr int([$n($i) set X_])]
			set y1 [expr int([$n($i) set Y_])]
			set x2 [expr int([$n($j) set X_])]
			set y2 [expr int([$n($j) set Y_])]
			set d [expr int(sqrt(pow(($x2-$x1),2)+pow(($y2-$y1),2)))]
			if { $d <= 200 && $i != $j } {
				puts -nonewline $fp "node::"
				puts -nonewline $fp $j
				puts -nonewline $fp "  "
				puts -nonewline $fp "distance->"
				puts $fp $d
			}
		}
		puts $fp ""
		puts $fp ""
	}
	close $fp

#stop procedure..
$ns at $val(stop) "stop"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
exec nam wireless3.nam &
	exit 0
}
$ns run
