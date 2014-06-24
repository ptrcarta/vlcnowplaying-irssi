BEGIN {FS = ": ";}
{
if ($1 == "TIT2") {
    $1="";
    title=$0 ;
} else if ($1 == "TPE1") {
    $1="";
    artist=$0;
} else if ($1 == "TALB") {
    $1="";
    album=$0;
}
}
END {
    print "\0039",artist,"\00312-\0035",title,"\00312-",album ;
}
