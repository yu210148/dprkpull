function clean_up(){
    $.ajax({
        url: "clean_up.php",
        type: "POST",
    });
};