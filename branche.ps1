Param(
[String]$first="blblbl"
)
if($first -like "help"){
echo "Permet d'afficher le nom de la branche. Si il y'a un argument ça affichera toutes les branches qui contiennent l'argument."
}else{
    $prenom= (setter "nom")+"*" 

    if($first -eq "blblbl"){
    $lien=setter "lien"
    echo (((connect "svn info $lien")-split "\n")[3]-split "branches\/")[1]
    }else{
        $var=list
        foreach ($info in $var){
            $info="$info"
            if($info -like "*$first*"){
            echo $info
            }
        }
    }
    }