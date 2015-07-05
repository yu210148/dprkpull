<?php
function clean_up(){
    $audioFileName = "KCNA_News-*.ogg";
    $command = "rm -rf $audioFileName";
    $command = escapeshellcmd($command);
    exec($command);
    return 0;
}
clean_up();
?>