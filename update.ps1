Param(
[String]$commit=""
)
if($commit -like "help"){
    echo "Permet de commit, puis de update svn à l'utilisation de la commande. Il est possible de changer le message de commit en indiquant un argument (utiliser les `" pour faire un commentaire avec des espaces.)"
}else{
    $lien=setter "lien"
    $lag=setter "lang"
    $rev=branche

    $numero=($rev -split "_")[-1] ## récupère le numéro contenu dans la branche
    if($commit -like "x"){
        $commit="\`"on\`"";
    }else{
        $commit="\`"on #$numero
$commit\`""
    }
    #svn add C:\wamp\www\interne.avis-verifies.com --force
    connect "svn commit -m $commit $lien"

    if(verif_preprod){
        Invoke-WebRequest -Uri "http://www-$rev.dev.netreviews.eu/tools/" -Method "POST" -Body "international=$lag&svnupdate=Update+Svn+%21"
    }
<#
Invoke-WebRequest permet de créer une requète http à l'aide de plusieurs élemnts. -Uri qui indique la page qui serra la cible de la requète, la méthode qui donne le type de la requète, POST par exemple.
Il y'a ensuite le body qui contient les données que l'on aurait remplie à l'aide de la page /tools/ international correspont à la langue et svnupdate indique de mettre à jour le svn
#>

}