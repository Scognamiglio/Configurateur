Param(
[String]$test="PRODUCTION"
)
if($test -like "help"){
    echo "Changer la branche en cours par celle passer en argument, puis ouvre la préprod de cette branche sur notre navigateur. Si aucun argument n'est passer, on change pour la production et on ouvre la prod."
}else{
    $red=""

    if ($test -notlike "PRODUCTION") {
        $red=$test
        $test="branches/"+$test
    }
    $lien=setter "lien"
    $nav=setter "nav"
    setter "lang" "FR" $FALSE
    $verif = connect "svn status $lien"

    if($verif){
        echo "Il y'a des fichiers pas commit dans leurs dernière version"
        echo $verif
        $reponse= read-host "`n`rPour ne rien faire, n'entré rien et appuyer sur entrer.`nPour commit, puis switch, rentré c (il faut qu'il n'y est que des fichiers avec la lettre m dans le status, la gestion du reste n'a pas encore était implémenté)`nPour switch malgré tout, faite s (attention, peu recommandé)"
        if($reponse -like "c"){
            update "commit avant switch"
        }elseif($reponse -like "s"){
            
        }else{
            exit
        }
    }
        
    $test="svn://interne.avis-verifies.com/fr/avisverifies_newrepo20160720/"+$test
    connect.ps1 "svn switch $test $lien"

    if ($red -notlike ""){
        Start-Process "$nav.exe" "www-$red.dev.netreviews.eu"
    }else{
        Start-Process "$nav.exe" "www.avis-verifies.com/"
    }

}