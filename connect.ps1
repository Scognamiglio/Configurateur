Param(
[String]$command
)
if($command -like "help"){
    echo "Permet d'éxuter une commande directement sur la VM"
}else{
    ssh production@192.168.56.102 $command
}