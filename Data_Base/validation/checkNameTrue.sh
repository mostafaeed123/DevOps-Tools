
IsNameTrue(){
    if [[ "$1"  =~ ^[a-zA-Z][a-zA-Z0-9_]{0,8}$ ]]; then 
        return 0
    else
        return 1
    fi
}