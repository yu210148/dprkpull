<?php
function clean_up(){
    $audioFileName = "KCNA_News-*.ogg";
    $command = "rm -rf $audioFileName";
    
    // escaping the shell command was causing the wildcard not to work
    //$command = escapeshellcmd($command);
    
    //debug
    //$command = "echo $command";
    
    exec($command);
    return 0;
}
clean_up();
?>