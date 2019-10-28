Param(
    [String]$first
)
if($first -like 'help'){
    echo "Permet de lancer la VM sans la fênetre (vous pouvez quand même ouvrir la fênetre à l'aide de virtual-box)"
}else{
VBoxManage startvm "vm_dev" --type headless
}