Param(
    [String]$first
)
if($first -like 'help'){
    echo "Permet d'introduire l'outil et s'occupe automatiquement de toutes les configurations nécéssaire à son bon fonctionnement. Si il n'y a aucun argument, l'outil va effectuer toutes les étapes une, sinon mettre en chiffre l'étape qui vous intéresse.`n 1:Configuration ssh et copie du fichier de configuration pour mysql`n 2:Authentification svn sur la VM`n 3:Configuration du path`n 4:Configuration des variables globales"
}else{


#Méthode pour rajouter des chemins au path.
function addPath{
    param ([String]$add)
    $Reg = "Registry::HKLM\System\CurrentControlSet\Control\Session Manager\Environment"
    $NewPath = ((Get-ItemProperty -Path "$Reg" -Name PATH).Path) + $add
    Set-ItemProperty -Path "$Reg" -Name PATH –Value $NewPath
    echo "pour que la mise à jour soit prise en compte, il faut ouvrir une nouvelle fenêtre powershell et attendre un peu."
}

    $Chemin=[System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)+"\var"

    ## Partie pour la connexion ssh de la command connect et ce qui faut pour l'aspect mysql.
    if($first -like '1' -or $first -like ''){
        echo "`n ===Step 1:Configuration ssh et copie du fichier de configuration pour mysql.==="
        ## Rejoins le répertoire où les clefs Asyncrone pour ssh seront généré
        cd ~\.ssh\
        ## Génére les clefs (appuyer sur entré tout le temps)
        ssh-keygen
        ## Changer le type de démarage de ssh-agent en Manual pour pouvoir le lancer
        Set-Service ssh-agent -StartupType Manual
        ## Lance ssh-agent
        Start-Service ssh-agent
        ## Rajout la clef privé à notre agent ssh
        ssh-add .\id_rsa
        ## Créer le dossier .ssh sur la vm dans le doute où il n'existe pas
        ssh production@192.168.56.102 mkdir .ssh
        ## déplace la clef publique dans le fichier authorized_keys pour permettre la connexion sans mot de passe
        scp .\id_rsa.pub production@192.168.56.102:\home\production\.ssh\authorized_keys
        ## déplace un fichier utilisé pour la connexion par mysql
        scp "$Chemin\acc.txt" production@192.168.56.102:\home\production\my.cnf
    }
    ## Partie pour la création du fichier de connexion svn
    if($first -like '2' -or $first -like ''){
        echo "`n ===Step 2:Authentification svn sur la VM==="
        #Demande le mot de passe
        $mdp=Read-Host "indiquer le mot de passe Subversion (un des premiers mail que vous avez reçu)"
        #Récupère le nom du fichier pour la connexion
        $name=(get-childitem $env:APPDATA"\Subversion\auth\svn.simple")
        #En récupère le contenu.
        $str=Get-Content $env:APPDATA"\Subversion\auth\svn.simple\$name"
        #Calcul la taille du mot de passe
        $taille=$mdp.Length
        #Modifie le fichier pour le passer de windows à linux.
        $str[2]="V 6"
        $str[3]="simple"
        $str[6]="V $taille"
        $str[7]=$mdp
        #Transforme le tableau en String
        $str=$str -join "`r"
        #Remplie le fichier auth_svn avec le contenu de $str
        setter "auth_svn" $str 
        #Transfère le fichier sur la vm
        scp "$Chemin\auth_svn.txt" production@192.168.56.102:\home\production\.subversion\auth\svn.simple\old
        #Convertie le fichier à cause du problème sur les retours à la ligne de windows à linux
        connect "sed 's/\r/\n/g' /home/production/.subversion/auth/svn.simple/old > /home/production/.subversion/auth/svn.simple/3117f463e6122e605fecafcfc808cfdd"
    }
    ## Partie pour la configuration du path système.
    if($first -like '3' -or $first -like ''){
        echo "`n ===Step 3:Configuration du path==="
        echo "à partir de maintenant, répondez y si voulez."
        #Récupère le chemin de l'outil.
        $path=[Environment]::GetEnvironmentVariable("Path")
        
        # Gère le rajout de l'outil dans le path.
        if($path.Contains([System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition))){
            echo "outil déjà présent dans le PATH"
        }ElseIf ("y" -like (Read-Host "Voulez vous rajouter les commandes de cet outil à votre path ? ça permettra d'utiliser les commandes sans être dans le dossier où l'outil est installé.")){

            addPath -add ([System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition))
        }

        # gère l'ajout de svn dans le path.
        $path_svn=$Env:ProgramFiles+"\TortoiseSVN\bin"
        if($path.Contains($path_svn)){
            echo "svn déjà présent dans le PATH"
        }Elseif(test-path $path_svn){
            If ("y" -like (Read-Host "Voulez vous rajouter $path_svn à votre path ? `nce n'est plus spécialement nécéssaire vu que l'outil est présent sur la vm`nil est conseillé d'en vérifier la présence`nen cas d'absence, voir avec l'infra.")){
                addPath -add $path_svn
            }
        }



    }
    ## Partie sur la configuration des variables globales.
    if($first -like '4' -or $first -like ''){
        echo "`n ===Step 4:Configuration des variables globales==="
        # Tableau associatif à la powershell
        $array_var=@{
            lang = "indiquer votre langue (FR par exemple)`npour savoir comment écrire les autres langues, se référer au value de la select box pour la langue sur /tools/";
            lien = "indiquer le lien vers votre repo sur la vm. par défault, c'est interne.avis-verifies.com";
            mail = "indiquer votre email encoder";
            nav = "indiquer votre navigateur favoris (chrome ou firefox par exemple)";
            nom = "indiquer l'indicatif présent au début de votre branche`n Par exemple, si mes branches ressemble à ça loicsco_20190729_sms_11543, j'indiquerai loisco.`n faite attention à ce que votre indicatif soit présent que pour vous(préférable, pas obligé)"
        }


        foreach($key in $array_var.Keys){
            setter $key (Read-Host $array_var[$key]) $false
        }
    }
}