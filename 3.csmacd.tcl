#send packets one by one
set ns [new Simulator]
$ns color 1 Green
foreach i " 0 1 2 3 4 5 " {
set n$i [$ns node]
}

$n0 color "purple"
$n1 color "purple"
$n2 color "violet"
$n3 color "violet"
$n4 color "chocolate"
$n5 color "chocolate"

$n0 shape box ;
$n1 shape box ;
$n2 shape box ;
$n3 shape box ;
$n4 shape box ;
$n5 shape box ;

$ns at 0.0 "$n0 label SYS1"
$ns at 0.0 "$n1 label SYS2"
$ns at 0.0 "$n2 label SYS3"
$ns at 0.0 "$n3 label SYS4"
$ns at 0.0 "$n4 label SYS5"
$ns at 0.0 "$n5 label SYS6"

set nf [open csma.nam w]
$ns namtrace-all $nf
set f [open csma.tr w]
$ns trace-all $f

$ns duplex-link $n0 $n2 0.1Mb 20ms DropTail
$ns duplex-link-op $n0 $n2 orient right-down
$ns queue-limit $n0 $n2 5
$ns duplex-link $n1 $n2 0.1Mb 20ms DropTail
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link $n2 $n3 0.1Mb 20ms DropTail
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link $n3 $n4 0.1Mb 20ms DropTail
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link $n3 $n5 0.1Mb 20ms DropTail
$ns duplex-link-op $n3 $n5 orient right-down

Agent/TCP set nam_tracevar_ true

set tcp [new Agent/TCP]
$tcp set window_ 1
$tcp set maxcwnd_ 1
$tcp set fid_ 1

$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set tcp1 [new Agent/TCP]
$tcp1 set window_ 1
$tcp1 set maxcwnd_ 1
$tcp1 set fid_ 1

$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1

$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$tcp2 set window_ 1
$tcp2 set maxcwnd_ 1
$tcp2 set fid_ 1

$ns attach-agent $n1 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n0 $sink2

$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

set tcp3 [new Agent/TCP]
$tcp3 set window_ 1
$tcp3 set maxcwnd_ 1
$tcp3 set fid_ 1

$ns attach-agent $n0 $tcp3
set sink3 [new Agent/TCPSink]
$ns attach-agent $n1 $sink3


$ns connect $tcp3 $sink3

set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3

$ns at 0.05 "$ftp start"
$ns at 0.071 "$ns queue-limit $n2 $n0 0"
$ns at 0.10 "$ns queue-limit $n2 $n0 5"
$ns at 0.09 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n2 $sink"
$ns at 0.25 "finish"
$ns at 0.05 "$ftp1 start"
$ns at 0.072 "$ns queue-limit $n2 $n1 0"
$ns at 0.10 "$ns queue-limit $n2 $n1 5"
$ns at 0.09 "$ns detach-agent $n1 $tcp1 ; $ns detach-agent $n2 $sink1"
$ns at 0.25 "finish"
$ns at 0.10 "$ftp2 start"
$ns at 0.13 "$ns detach-agent $n0 $tcp2 ; $ns detach-agent $n1 $sink2"
$ns at 0.25 "finish"
$ns at 0.12 "$ftp3 start"
$ns at 0.14 "$ns detach-agent $n1 $tcp1 ; $ns detach-agent $n0 $sink3"
$ns at 0.25 "finish"
$ns at 0.0 "$ns trace-annotate \"CSMA/CA\""
$ns at 0.05 "$ns trace-annotate \"FTP starts at 0.01\""
$ns at 0.05 "$ns trace-annotate \"Send Packet_1 from SYS1 to SYS0 and Packet_2 from SYS0 to SYS1 \""
$ns at 0.073 "$ns trace-annotate \"Collision Occurs so 2 Packets are lossed\""
$ns at 0.10 "$ns trace-annotate \"Retransmit Packet_1 from SYS1 to SYS0 \""
$ns at 0.12 "$ns trace-annotate \"Retransmit Packet_2 from SYS0 to SYS1 \""
$ns at 0.20 "$ns trace-annotate \"FTP stops\""

proc finish {} {
global ns nf
$ns flush-trace
close $nf
puts "filtering..."
#exec tclsh ../bin/namfilter.tcl csma.nam
#puts "running nam..."
exec nam csma.nam &
exit 0
}
$ns run