selectSearch(){
    local tablefile="$1"

    if [[ ! -s "$tablefile" ]]; then
        echo "the table is empty"
        return
    fi

    echo "Search by:"
    select field in "ID" "Name" "Company" "Age"
    do
        case $field in
            "ID") colnum=1; break ;;
            "Name") colnum=2; break ;;
            "Company") colnum=3; break ;;
            "Age") colnum=4; break ;;
            "Exit")  break ;;
            *) echo "Invalid option" ;;
        esac
    done

    read -p "Enter the value to search for : " value

    local result
    result=$(awk -F'\\|\\|' -v col="$colnum" -v val="$value" '$col==val {print $1" || "$2" || "$3" || "$4}' "$tablefile")

    if [[ -z "$result" ]]; then
        echo "no matching rows found"
    else
        echo "$result"
    fi
}