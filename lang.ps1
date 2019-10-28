Param(
 [parameter(Mandatory=$true)][String]$langue
)
if($langue -like "help"){
    echo "Permet de changer la langue de la préprod. Une fois la langue changer, elle serra garder même après un update (avec cet outil), faire lang FR pour repasser en français"
}else{
    $lien=setter "lien"
    setter "lang" $langue $FALSE

    $rev=branche
    Invoke-WebRequest -Uri "http://www-$rev.dev.netreviews.eu/tools/" -Method "POST" -Headers @{"Origin"="http://www-$rev.dev.netreviews.eu"; "Upgrade-Insecure-Requests"="1"; "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"; "Referer"="http://www-$rev.dev.netreviews.eu/tools/"} -ContentType "application/x-www-form-urlencoded" -Body "international=$langue&svnupdate=Update+Svn+%21"

    echo "la langue est passé à $langue"
}