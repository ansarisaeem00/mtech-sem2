#Create a simulator object:
set ns [new Simulator]

set nf [open ex1.nam w]
$ns namtrace-all $nf

#Tell the simulator to use static routing:
$ns rtproto Static

#Set up trace files in write mode
set traceFile [open ex1.tr w]
$ns trace-all $traceFile

#Set up NAM files in write mode (for visualization)
set nf [open ex1.nam w]

$ns namtrace-all $nf

#Define the finish function
proc finish {} {
global ns traceFile

# clears trace file contents 
$ns flush-trace

#Close the trace files
close $traceFile
#Execute the awk script(to filter out the data from the the trace file)
exec awk -f ex1.awk ex1.tr &

#Execute the NAM porgram to visualize the graph
exec nam ex1.nam &
exit 0
}

#Creates 3 nodes 
for {set i 1} {$i < 4} {incr i} {
set n($i) [$ns node]
}

$ns color 2 Red

#Establishing links
#change the bandwidth here
$ns duplex-link $n(1) $n(2) 0.5Mb 20ms DropTail    
$ns duplex-link $n(2) $n(3) 0.5Mb 20ms DropTail


#Change the Queue length here
$ns queue-limit $n(1) $n(2) 10


#Create a UDP agent and attach it to node n(1)
set udp0 [new Agent/UDP]
$ns attach-agent $n(1) $udp0


#Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0


#Create a Null agent (a traffic sink) and attach it to node n(3)
set null0 [new Agent/Null]
$ns attach-agent $n(3) $null0 


#Connect the traffic source with the traffic sink and assign flow id color  
$ns connect $udp0 $null0  
$udp0 set fid_ 2


#Simulate events
$ns at 0.5 "$cbr0 start"
$ns at 2.0 "$cbr0 stop"
$ns at 2.0 "finish"


#Run the simulation
$ns run

