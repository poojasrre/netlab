set ns [new Simulator]
set Bandwidth "1Mb"
set paketsize 700
set intval 0.004
set nf [open out.nam w]
$ns namtrace-all $nf
set f [open out.tr w]
$ns trace-all $f
set old_data 0
proc finish {} {
global ns nf
$ns flush-trace
close $nf
exec awk {
{
if($1=="-"&& $5=="cbr") {
print $2"\t"$11
}
}
} out.tr > throughput.data
exec nam out.nam &
exec xgraph throughput.data &
exit 0
}
for {set i 0} {$i < 6} {incr i} {
set n($i) [$ns node]
}
$ns color 1 purple
$ns color 2 green
$ns color 3 darkgreen
for {set i 0} {$i < 6} {incr i} {
$ns duplex-link $n($i) $n([expr ($i+1)%6]) $Bandwidth 10ms DropTail
}
set tcp1 [new Agent/TCP]
$ns attach-agent $n(0) $tcp1
$tcp1 set fid_ 1 ;

set sink1 [new Agent/TCPSink]
$ns attach-agent $n(3) $sink1

$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n(3) $tcp2
$tcp2 set fid_ 1 ;

set sink2 [new Agent/TCPSink]
$ns attach-agent $n(5) $sink2

$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

set tcp3 [new Agent/TCP]
$ns attach-agent $n(5) $tcp3
$tcp3 set fid_ 1 ;

set sink3 [new Agent/TCPSink]
$ns attach-agent $n(2) $sink3

$ns connect $tcp3 $sink3

set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3

set tcp4 [new Agent/TCP]
$ns attach-agent $n(2) $tcp4
$tcp4 set fid_ 1 ;

set sink4 [new Agent/TCPSink]
$ns attach-agent $n(4) $sink4

$ns connect $tcp4 $sink4

set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4

set tcp5 [new Agent/TCP]
$ns attach-agent $n(4) $tcp5
$tcp5 set fid_ 1 ;

set sink5 [new Agent/TCPSink]
$ns attach-agent $n(0) $sink5

$ns connect $tcp5 $sink5

set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp5

set udp0 [new Agent/UDP]
$ns attach-agent $n(5) $udp0

$udp0 set fid_ 3 ;
$tcp3 set fid_ 2 ;

set cbr0 [new Application/Traffic/CBR]
$cbr0 set interval_ $intval
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n(2) $null0

$ns connect $udp0 $null0

$ns at 0.1 "$ftp1 start"
$ns at 0.125 "$ns detach-agent $n(0) $tcp1; $ns detach-agent $n(3) $sink1"
$ns at 1.0 "finish"
$ns at 0.131 "$ftp2 start"
$ns at 0.14 "$ns detach-agent $n(3) $tcp2; $ns detach-agent $n(5) $sink2"
$ns at 1.0 "finish"
$ns at 0.157 "$ftp3 start"
$ns at 0.185 "$ns detach-agent $n(5) $tcp3; $ns detach-agent $n(2) $sink3"
$ns at 1.0 "finish"
$ns at 0.19 "$ftp4 start"
$ns at 0.21 "$ns detach-agent $n(2) $tcp4; $ns detach-agent $n(4) $sink4"
$ns at 1.0 "finish"
$ns at 0.211 "$ftp5 start"
$ns at 0.22 "$ns detach-agent $n(4) $tcp5; $ns detach-agent $n(0) $sink5"
$ns at 1.0 "finish"
$ns at 0.157 "$cbr0 start"
#$ns rtmodel-at 1.0 down $n(1) $n(2)
#$ns rtmodel-at 2.0 up $n(1) $n(2)
$ns at 0.185 "$cbr0 stop"
$ns at 1.0 "finish"
$ns run

