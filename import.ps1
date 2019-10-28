Param(
 [parameter(Mandatory=$true)][String]$idwebsite,
[String]$langue="fr",
[String]$nombre="none"
)
if($idwebsite -like "help"){
    echo "Import un client.
exemple:import d7bd5cd2-df36-ded4-bdbc-bfa8f8cd544d fr all
se référer à /tools/ et au valeur des select pour le fr et le all"
}else{
    $lien=setter "lien"
    $rev=branche


    Invoke-WebRequest -Uri "http://www-$rev.dev.netreviews.eu/tools/" -Method "POST" -Headers @{"Origin"="http://www-$rev.dev.netreviews.eu"; "Upgrade-Insecure-Requests"="1"; "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"; "Referer"="http://www-$rev.dev.netreviews.eu/tools/"} -ContentType "application/x-www-form-urlencoded" -Body "idWebsite=$idwebsite&plateforme=$langue&import_type=$nombre&with_purge=N&with_log_avis=N&importfromprod=Import+Data+%21"
}