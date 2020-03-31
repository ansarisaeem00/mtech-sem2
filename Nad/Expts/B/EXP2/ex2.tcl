#Create a simulator object:
set ns [new Simulator]

set nf [open ex2.nam w]
$ns namtrace-all $nf

#Tell the simulator to use static routing:
$ns rtproto Static

#Set up trace files in write mode
set traceFile [open ex2.tr w]
$ns trace-all $traceFile

#Set up NAM files in write mode (for visualization)
set nf [open ex2.nam w]

$ns namtrace-all $nf

#Define the finish function
proc finish {} {
global ns traceFile

# clears trace file contents 
$ns flush-trace

#Close the trace files
close $traceFile
#Execute the awk script(to filter out the data from the the trace file)
exec awk -f ex2.awk ex2.tr &

#Execute the NAM porgram to visualize the graph
exec nam ex2.nam &
exit 0
}

#Creates 3 nodes 
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns color 1 Blue
$ns color 2 Red

#Establishing links
#change the bandwidth here
$ns duplex-link $n0 $n2 0.5Mb 20ms DropTail
$ns duplex-link $n1 $n2 0.5Mb 20ms DropTail
$ns duplex-link $n2 $n3 0.5Mb 20ms DropTail


set tcp0 [new Agent/TCP] 
$ns attach-agent $n0 $tcp0
set udp1 [new Agent/UDP] 
$ns attach-agent $n1 $udp1
set null0 [new Agent/Null] 
$ns attach-agent $n3 $null0
set sink0 [new Agent/TCPSink] 
$ns attach-agent $n3 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$ns connect $tcp0 $sink0
$ns connect $udp1 $null0
$ns at 0.1 "$cbr1 start"
$ns at 0.2 "$ftp0 start"
$ns at 0.5 "finish"
$ns run
