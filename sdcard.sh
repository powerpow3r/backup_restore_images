#!/bin/sh

source "$PWD/variables_engine_deck"


img_way="/home/roboneers/Desktop/sdcard/backup.tur.img.gz"

while true
do
    lsblk
    echo "Введіть назву карти пам'яті зі списку"
    read name
    
    echo "Choose an option:"
    echo "1. Записати одну карту і вийти"
    echo "2. Записати ще одну карту"
    echo "3. Вийти"
    read option
    
    case $option in
        1) 
            sudo gunzip -c $img_way | sudo dd of=/dev/$name bs=1M status=progress
            sudo eject /dev/$name
            echo $?
            yad --title="Complete" --text="Complete $name" --button="OK:0"
            exit
            ;;
        2)
	    gnome-terminal -- sh -c "cd $PROGRAM_FOLDER/data/; ./sdcard.sh"      
            sudo gunzip -c $img_way | sudo dd of=/dev/$name bs=1M status=progress
            sudo eject /dev/$name
            echo $?
            yad --title="Complete" --text="Complete $name" --button="OK:0"
            exit
            ;;
        3) 
            exit
            ;;
        *)
            yad --title="Error" --text="Invalid choice" --button="OK:0"
            ;;
    esac
done
