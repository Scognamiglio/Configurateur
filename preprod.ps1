Param(
    [String]$first
)
if($first -like 'help'){
    echo "Ouvre la preprod de la branche en cours. Si il y'a un argument, le script essayera d'ouvrir la préprod de la branche passer en argument. ex: preprod loicsco_20190729_sms_11543"
}else{
    if($first -like ""){
        $lien=setter "lien"
        $rev=branche
    }else{
        $rev=$first
    }
    $nav=setter "nav"
    Start-Process "$nav.exe" "www-$rev.dev.netreviews.eu"
}