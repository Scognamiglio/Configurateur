Param(
[String]$tache="",
[String]$numero="",
[String]$preprod="",
[String]$idwebsite="",
[String]$langue="fr",
[String]$nombre="none"
)

if($tache -like "help"){
    echo "Cette commande permet de créer automatiquement une branche et ça préprod:
exemple: create_auto ma_tache 12305 oui d7bd5cd2-df36-ded4-bdbc-bfa8f8cd544d fr all
Si mon nom est loicsco et que la date et le 01/10/2019, ça vas créer une branche nommée
loicsco_20190927_ma_tache_12305 avec comme message 'on #12305'. Si il y'a écrit oui après le numéro, la préprod serra créer automatiquement après. si il y'a un idwebsite on l'importe. fr est la langue et all permet d'import toutes les données
P.S1: Pour savoir à quoi correspond fr et all, il suffit de regarder la page /tools/ et les valeurs dans les select
P.S2: Si vous ne voulez pas de numéro de tâche, indiqué x à la place du numéro"

}else{
    ##La méthode setter permet de récupérer (ou d'éditer) le contenu des fichiers dans /var/
    $prenom=setter "nom" 
    $mail=setter "mail"
    $lien=setter "lien"
    $date=get-date
    ## Récupère l'année
    $year=$date.Year

    ## Récupère le mois
    if ($date.Month -le 9){
        $month="0"+$date.Month
    }else{
        $month=$date.Month
    }

    ## Récupère le jour
    if ($date.Day -le 9){
        $day="0"+$date.Day
    }else{
        $day=$date.Day
    }
    [System.Net.ServicePointManager]::MaxServicePointIdleTime = 600000

    ## Si le numéro est égale à x, la tâche n'aura aucun numéro
    if($numero -notlike "x"){
        $name=$prenom+"_"+$year+$month+$day+"_"+$tache+"_"+$numero
        ## Le message est créer ici, on utilise le \`" pour échapé la " une première fois en powershell, puis une deuxième fois en linux.
        $message="\`"on #$numero $tache
    
Branches : $name
Redmine : https://redmine.netreviews.eu/issues/$numero
Note : Début de tâche\`""
    }else{
    $name=$prenom+"_"+$year+$month+$day+"_"+$tache
    $message="\`"Création de la branche $name sans numéro\`""
    }
    $test="branches/"+$name

    ##Se base sur la production pour créer la nouvelle branche
    connect "svn copy `"svn://interne.avis-verifies.com/fr/avisverifies_newrepo20160720/PRODUCTION`" `"svn://interne.avis-verifies.com/fr/avisverifies_newrepo20160720/$test`" -m `"$message`""
    ##Petite attente à cause de la vitesse de svn
    sleep 1
    if ($preprod -notlike ""){
        if("" -like $mail){
            $mail=Read-Host "mail inconnu, veuillez l'indiquer ici (encoder)"
            ADD-content -path "$Chemin/mail_pour_powershell.txt" -value $rep
        }
        ## Récupère le nom de la branche grace à la méthode branche
        $rev=branche
        try{
            ## Joue la requète http qui permet de lancer la création de la préprod
            Invoke-WebRequest -Uri "http://www-$name.dev.netreviews.eu/" -Method "POST" -Headers @{"Origin"="http://www-$name.dev.netreviews.eu"; "Upgrade-Insecure-Requests"="1"; "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"; "Referer"="http://www-$name.dev.netreviews.eu/"} -ContentType "application/x-www-form-urlencoded" -Body "debug_email=$mail&create=Create" -TimeoutSec 600000
        }catch{

        }
        sleep 1
        if("" -notlike $idwebsite){
            ## Joue la requète http qui permet de lancer l'import du client
            Invoke-WebRequest -Uri "http://www-$name.dev.netreviews.eu/tools/" -Method "POST" -Headers @{"Origin"="http://www-$name.dev.netreviews.eu"; "Upgrade-Insecure-Requests"="1"; "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"; "Referer"="http://www-$name.dev.netreviews.eu/tools/"} -ContentType "application/x-www-form-urlencoded" -Body "idWebsite=$idwebsite&plateforme=$langue&import_type=$nombre&with_purge=N&with_log_avis=N&importfromprod=Import+Data+%21" -TimeoutSec 600000
        }
    }
    $swi=Read-Host "switch sur la branche (répondre oui pour le faire)"

    if ($swi -like "oui"){
        ## Si on répond oui à la question, on passe sur la nouvelle branche.
        switch.ps1 $name
    }
}