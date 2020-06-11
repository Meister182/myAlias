_home=/home/$(users)
_target=myAlias


function consumeFlags ()
{
    _path=$_home

    while test $# -gt 0; do
        case "$1" in
            -h |--help)
                echo " "
                echo " This is a simple script to setup personalized linux alias."
                echo " "
                echo " Available flags:"
                echo "  -h, --help"
                echo "       Display a brief description of this script in the terminal ."
                echo " "
                echo "  -p, --path [path/to/save/myAlias/file]"
                echo "       Allows the user to specifie where to save the myAlias file."
                echo " "
                echo " "
                echo " "
                exit 0
            ;;

            -p |--path)
                if ! [ -z ]$2 ]; then
                    _path=$(readlink -f $2)
                fi
            ;;
        esac
        shift
    done
}


#==================================================================
#                       Main
#==================================================================
consumeFlags $@

# Check if my Alias file is in path folder
if !(ls $_path | grep $_target -q); then
    echo "Added myAlias file to" $_path
    cp myAlias $_path
fi

# Check if my Alias sourced in ~/.bashrc
if !(cat $_home/.bashrc | grep $_target -q); then
    echo "Added myAlias file to" $_home"/.bashrc"

    echo " " > $_home/.bashrc
    echo "# This line was added by the myAlias/setup.sh script." > $_home/.bashrc
    echo "source" $_path/myAlias > $_home/.bashrc
fi

echo "Done!"