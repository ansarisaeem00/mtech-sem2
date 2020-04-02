set ns [new Simulator]
set nf [open ex3.nam w]
$ns namtrace-all $nf
set tf [open ex3.tr w]
$ns trace-all $tf

proc finish {} {
global ns nf tf
$ns flush-trace
close $nf
close $tf
exec nam ex3.nam &
exec awk -f ex3.awk ex3.tr &
exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns color 1 Blue
$ns color 2 Green

#Create links between the nodes
$ns duplex-link $n0 $n2 3Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 15ms DropTail
$ns duplex-link $n2 $n3 3Mb 10ms DropTail

#Set queue size and Monitor the queue
$ns queue-limit $n0 $n2 10
$ns duplex-link-op $n0 $n2 orient right-down 
$ns duplex-link-op $n1 $n2 orient right-up 
$ns duplex-link-op $n2 $n3 orient right 
#Set TCP TELNET Connection between n(0) and n(3):
	set tcp0 [new Agent/TCP]
	$ns attach-agent $n0 $tcp0
	set sink0 [new Agent/TCPSink]
	$ns attach-agent $n3 $sink0
	$ns connect $tcp0 $sink0
$tcp0 set fid_ 1
#Attach TELNET Application over TCP:
	set telnet [new Application/Telnet]
	$telnet attach-agent $tcp0
	$telnet set interval_ 0
#Set TCP FTP Connection between n(1) and n(3):
	set tcp1 [new Agent/TCP]
	$ns attach-agent $n1 $tcp1
	set sink1 [new Agent/TCPSink]
	$ns attach-agent $n3 $sink1
	$ns connect $tcp1 $sink1
$tcp1 set fid_ 2
#Attach Telnet Application over TCP:
	set ftp [new Application/FTP]
	$ftp attach-agent $tcp1
	$ftp set type_ FTP
#Schedule Events:
	$ns at 0.5 "$telnet start"
	$ns at 0.6 "$ftp start"
	$ns at 24.5 "$telnet stop"
	$ns at 24.5 "$ftp stop"
	$ns at 25.0 "finish"
	$ns run

