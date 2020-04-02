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

#Creates 4 nodes 
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns color 1 Green
$ns color 2 Blue

#Establishing links
#change the bandwidth here
$ns duplex-link $n0 $n2 0.9Mb 20ms DropTail
$ns duplex-link $n1 $n2 0.9Mb 20ms DropTail
$ns duplex-link $n2 $n3 0.9Mb 20ms DropTail

$ns queue-limit $n0 $n2 10


$ns duplex-link-op $n0 $n2 orient right-down 
$ns duplex-link-op $n1 $n2 orient right-up 
$ns duplex-link-op $n2 $n3 orient right 

$ns duplex-link-op $n0 $n2 color Green
$ns duplex-link-op $n1 $n2 color blue

#Set TCP  Connection between n(0) and n(3):
	set tcp [new Agent/TCP]
	$ns attach-agent $n0 $tcp
	set sink [new Agent/TCPSink]
	$ns attach-agent $n3 $sink
	$ns connect $tcp $sink
	$tcp set fid_ 1



#Attach FTP Application over TCP:
	set ftp [new Application/FTP]
	$ftp attach-agent $tcp
	$ftp set type_ FTP
#Set UDP Connection between n(1) and n(3):
	set udp [new Agent/UDP]
	$ns attach-agent $n1 $udp
	set null [new Agent/Null]
	$ns attach-agent $n3 $null
	$ns connect $udp $null
	$udp set fid_ 2

#Attach CBR Traffic over UDP:
	set cbr [new Application/Traffic/CBR]
	$cbr set packetSize_ 500						
	$cbr set interval_ 0.01
	$cbr attach-agent $udp
#Schedule Events:
	$ns at 0.5 "$ftp start"
	$ns at 1.0 "$cbr start"
	$ns at 9.0 "$cbr stop"
	$ns at 9.5 "$ftp stop"
	$ns at 10.0 "finish"
	$ns run


