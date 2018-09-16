<?php 

$s = sum(10,20);
$date = date('m/d/Y h:i:s a', time());
echo "\nVSCode running PHP at Ignite! - ($date)\n"; 


function sum($a, $b): float {
    return $a + $b;
} 

?>
