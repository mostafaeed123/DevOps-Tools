source ../validation/IsNumTrue.sh

deleteRow(){
    local tablefile="$1"

    read -p "Enter the id of the row to delete : " id

    if ! validateAge "$id" ; then
        echo "Invalid id"
        return 1
    fi

    if ! awk -F'\\|\\|' -v id="$id" '$1==id {found=1} END{exit !found}' "$tablefile" ; then
        echo "this id does not exist"
        return 1
    fi

    awk -F'\\|\\|' -v id="$id" '$1!=id' "$tablefile" > "$tablefile.tmp"
    mv "$tablefile.tmp" "$tablefile"

    echo "Row deleted successfully"
}