source ../validation/IsNumTrue.sh
source ../validation/checkNameTrue.sh

InsertData(){
    local tablefile="$1"
    
    read -p "Enter your id : " id
    if ! validateAge "$id" ; then
        echo "Invalid id"
        return 1
    fi
    
    if awk -F'\\|\\|' -v id="$id" '$1==id {found=1} END{exit !found}' "$tablefile" ; then
        echo "this id is exist try to use another one"
        return 1
    fi
    
    read -p "Enter your name : " name
    if ! IsNameTrue "$name" ; then
        echo "Invalid name"
        return 1
    fi
    
    read -p "Enter your company : " company
    if ! IsNameTrue "$company" ; then
        echo "Invalid name of company"
        return 1
    fi
    
    read -p "Enter your age : " age
    if ! validateAge "$age" ; then
        echo "Invalid age"
        return 1
    fi
    
    echo "${id}||${name}||${company}||${age}" >> "$tablefile"
    echo "Row inserted successfully"
}