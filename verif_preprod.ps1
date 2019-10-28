$mysqlnet=[Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$branche=branche
$dbhost = "cluster-netreviews-developper.cluster-cqm3shtx2gud.eu-west-1.rds.amazonaws.com" # nom d'hôte ou adresse IP du serveur
$Chemin=[System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)+"\var"
$retenu=connect "mysqlshow  --defaults-extra-file=my.cnf -h $dbhost"
for($i=0;$i -lt $retenu.Length;$i++){
    $retenu[$i]=(($retenu[$i]-split "svnbranches_")[1]-split " ")[0]
}
if($retenu -contains $branche){
    echo $true
}else{
    echo $false
}
