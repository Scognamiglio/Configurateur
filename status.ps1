Param(
    [String]$first
)
if($first -like 'help'){
    echo "Affiche le status de la branche (si il y'a des fichier commit par exemple)"
}else{
    $lien=setter "lien"
    $test= connect.ps1 "svn status $lien"

    if($test){
    echo $test
    }else{
    echo "Rien à commit"
    }
}