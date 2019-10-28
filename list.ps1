Param(
[String]$first=""
)
if($first -like "help"){
    echo "permet de lister toutes les branches en votre nom. en cas d'argument la liste commençera appartir de la branche dont le nom correspont à l'argument"
}else{
    $Chemin=[System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)+"\var"
    $prenom= (setter "nom")+"*" 
    $var=connect.ps1 "svn ls svn://interne.avis-verifies.com/fr/avisverifies_newrepo20160720/branches" | Select-String -Pattern $prenom
    if($first -notlike ""){
    $verif=0
    }
    foreach ($info2 in $var){
        $info=$info2
        if($verif){
            $info="$info"
            $info=$info.Substring(0,$info.Length-1)
            echo $info
        }elseif($info2 -like "*$first*"){
        $verif=1
         $info="$info"
         $info=$info.Substring(0,$info.Length-1)
         echo $info
        }
    }
}