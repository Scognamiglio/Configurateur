Param(
[String]$temps="0h00",
[String]$update="non",
[String]$langue="FR",
[String]$note="Fin de tâche"
)
if($temps -like "help"){
    echo "cette commande permet de mettre un message de commit formater pour être normalement le dernier, elle accepte 4 arguments
Arg1: le temps passé (format 0h00)
Arg2: update svn ? (par défault non)
Arg3: langue pour déploiement (par défault FR)
Arg3: une note (Par défault Fin de tâche)

Ex: La commande `"fin 4h00 non US`" pour la branche loicsco_20190910_celio_11966 commitera avec ce message:

needprod #11966 @4h00

Branches : loicsco_20190910_celio_11966
Déploiement : US
Redmine : https://redmine.netreviews.eu/issues/11966
Note : Fin de tâche"
}else{

    $rev=branche
    $numero=($rev -split "_")[-1]
    $message="\`"needprod #$numero @$temps

    Branches : $rev
    Déploiement : $langue
    Redmine : https://redmine.netreviews.eu/issues/$numero
    Note : $note\`""
    $lien=setter "lien"
    connect "svn commit -m $message $lien"

    if($update -like "oui"){
        $lag=setter "lang"
        Invoke-WebRequest -Uri "http://www-$rev.dev.netreviews.eu/tools/" -Method "POST" -Headers @{"Origin"="http://www-$rev.dev.netreviews.eu"; "Upgrade-Insecure-Requests"="1"; "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"; "Referer"="http://www-$rev.dev.netreviews.eu/tools/"} -ContentType "application/x-www-form-urlencoded" -Body "international=$lag&svnupdate=Update+Svn+%21"
    }
}