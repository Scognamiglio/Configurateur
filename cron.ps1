Param(
[String]$cron,
[int]$wait=0
)

$Chemin=[System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)+"\var"
$lien=TYPE "$Chemin/lien_pour_powershell.txt"
$lag=TYPE "$Chemin/langue_pour_powershell.txt"
$rev=branche

if($wait -lt 5){
    $wait=5
}
while($TRUE){
    Invoke-WebRequest -Uri "http://www-$rev.dev.netreviews.eu/index.php?page=mod_run_cron_loic&cron=$cron"
    Start-Sleep -s $wait
}