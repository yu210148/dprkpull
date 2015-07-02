<?php
function clean_up(){
    $todaysDate = date('Y-m-d');
    $audioFileName = "KCNA_News-" . $todaysDate . ".ogg";
    $command = "rm -rf $audioFileName";
    $command = escapeshellcmd($command);
    exec($command);
    return 0;
}
clean_up();
?>