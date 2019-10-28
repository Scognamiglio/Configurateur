Param(
 [parameter(Mandatory=$true)][String]$label,
[String]$val,
[Boolean]$parle=$TRUE
)
## Permet de récupérer le chemin du dossier puis rajout \var devant.
$Chemin=[System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)+"\var"

## Permet de récupérer la liste des fichiers contenu dans le dossier \var
$tab=Get-ChildItem $Chemin -Name
for($i=0;$i -le $tab.Length-1;$i++){
    $tab[$i]=($tab[$i] -split ".txt")[0] # Garde seulement ce qu'il y avant _pour_powershell
}


foreach($value in $tab){
    if($label -like $value){
        $path=-join($Chemin,"\",$value,".txt") # Créer le chemin du fichier en question

        if($val -notlike ""){
            Set-Content -Path $path -Value $val ## Rentre le deuxième argument dans le fichier nommé comme le premier argument.
            if($parle){ ## Si la variable #PARLE est à FALSE, alors aucun message indique la modification (utilisé quand setter est utilisé comme une méthode pour une autre fonction.
                echo "la variable $label a été changé en $val"
            }
        }else{
            $ret=Get-Content -Path $path ## récupère le contenu du fichier
            echo $ret
        }
    }
}

if($label -like "help"){
    echo "
la commande setter peut accepter jusqu'à deux paramètres, le label et la valeur.
Il y a 5 label possible :
    - lang : permet de changer la langue par défault de votre préprod, il faut un update pour que la modificication soit prise en compte. Sinon utilisé la commande lang directement.
    - mail : permet de changer le mail de débug utilisé avec la commande create_auto pour l'option création de la préprod, encoder le mail avant.
    - lien : Contient le lien de votre repo avis-vérif. par exemple C:\wamp\www\interne.avis-verifies.com
    - nav : Permet de changer le navigateur par défault utiliser avec l'outil. Chrome pour google Chrome et firefox pour firefox
    - nom : indiqué l'élément toujours présent au début votre branche, c'est généralement votre nom ou votre prénom.
Pour la valeur, si elle est présente, elle écrasera l'ancienne valeur. Si elle est absente elle affichera la valeur actuelle (un get en gros)"
}