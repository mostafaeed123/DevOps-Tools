existcol(){
    if [[ -f "Data_Base/$1/$2" ]] ; then
        return 0
    else 
        return 1
    fi
}