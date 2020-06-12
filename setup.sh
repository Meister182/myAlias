#! /bin/bash
_home=/home/$USER
_target=myAlias
_path=$_home

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
                echo "       Allows the user to specify where to save the myAlias file."
                echo " "
                echo "  -h, --home [path/to/.bashrc]"
                echo "       In case the automatic detection of .bashrc filr fails, it"
                echo "      allows the user to provide its path."
                echo " "
                echo " "
                echo " "
                exit 0
            ;;

            -p |--path)
                if ! [ -z $2 ]; then
                    _path=$(readlink -f $2)
                fi
            ;;

            -h |--home)
                if ! [ -z $2 ]; then
                    _home=$(readlink -f $2)
                fi
            ;;

        esac
        shift
    done

    if !(ls -a $_home | grep .bashrc -q); then
        echo ".bashrc was not detected.. please provide a valid path to .bashrc file."
        echo "Example:"
        echo "  ./setup -h /home/user"
        exit
    fi
}


#==================================================================
#                       Main
#==================================================================
consumeFlags $@

# Check if my Alias file is in path folder
if !(ls $_path | grep $_target -q); then
    cp myAlias $_path
    echo "Added myAlias file to" $_path
elif ! cmp --silent myAlias $_path/myAlias; then
        cp myAlias $_path
        echo "myAlias file was updated"
fi

# Check if my Alias sourced in ~/.bashrc
if !(cat $_home/.bashrc | grep $_target -q); then
    echo " " >> $_home/.bashrc
    echo "# This line was added by https://github.com/meister182/myAlias/setup.sh script." >> $_home/.bashrc
    echo "source" $_path/myAlias >> $_home/.bashrc
    echo ""
    echo "For changes to take effect restart the terminal or run: source ~/.bashrc"
    echo "run myAlias to check the available alias"
fi

echo "Done!"