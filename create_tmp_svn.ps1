$Chemin=[System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)+"\var"

$mdp=Read-Host "indiquer le mot de passe Subversion (un des premiers mail que vous avez reçu)"
$name=(get-childitem $env:APPDATA"\Subversion\auth\svn.simple")
$str=Get-Content $env:APPDATA"\Subversion\auth\svn.simple\$name"
$taille=$mdp.Length
$str[2]="V 6"
$str[3]="simple"
$str[6]="V $taille"
$str[7]=$mdp
$str=$str -join "`r"
setter "auth_svn" $str 
scp "$Chemin\auth_svn.txt" production@192.168.56.102:\home\production\.subversion\auth\svn.simple\old
connect "sed 's/\r/\n/g' /home/production/.subversion/auth/svn.simple/old > /home/production/.subversion/auth/svn.simple/3117f463e6122e605fecafcfc808cfdd"
