#!/bin/bash
# Author           : Fiodar Litskevich ( s187722@student.pg.edu.pl )
# Created On       : 2021-04-08
# Last Modified By : Fiodar Litskevich (  s187722@student.pg.edu.pl )
# Last Modified On : 2021-04-08
# Version          : 0.7
#
# Description      :
#
#Skrypt który postanowiłem przygotować skupi się na konwersji plików video z jednego
#rozszerzenia na inne, wybrane w menu.
#Początkowa wersja będzie konwertowała pliki z/do   następujących rozszerzeń: avi,mpeg,mp4 i 3gp.
#Przeglądając kod skryptu możliwy będzie jego prosty rozwój poprzez dodanie kolejnych rozszerzeń.
#Do poprawnego działania skryptu potrzebne jest dodatkowe oprogramowanie – FFMPEG.
#Jeżeli oprogramowanie to nie zostało zainstalowane,
#skrypt automatycznie pobierze i   zainstaluje oprogramowanie,
#jeżeli nie będzie to możliwe oprogramowanie musi zostać   zainstalowane manualnie.
#
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)
CWD=$(pwd)
FORMAT_FROM_CONVERT=""

if [ -f /"$CWD"/fils_for_script/config.rc ]; then

        . /"$CWD"/fils_for_script/config.rc   # --> Прочитать настройки из /etc/bashrc, если таковой имеется.
fi
echo "$test"

[[ -d $CWD/converted_files ]] || mkdir $CWD/converted_files




information(){ #tablet informacji ogarnia sie z pliku /fils_for_script/help
  zenity --text-info\
  --title="info"\
  --width=400\
  --height=500\
  --filename=$INFO
case $? in
  0)exit  ;;
esac
}
help(){ #tablet pomocy ogarnia sie z pliku /fils_for_script/help
  zenity --text-info\
  --title="help"\
  --width=400\
  --height=500\
  --filename=$HELP
case $? in
  0)exit  ;;
esac
}

function choose_file() { #tablet wybrania pliku do kowertacji
  FILE="$(zenity --file-selection --title='Select a File'  --file-filter=""*.avi" "*.mp4" "*.mpeg"  "*.3gp"")"
  case $? in

           1)
                  zenity --question \
                         --title="Word counter" \
                         --text="Plik nie był wybrany. chcesz wybrać ponownie?" \
                         && choose_file || exit;;
          -1)
                  echo "An unexpected error has occurred."; exit;;
  esac
}
function choose_folder() { #tablet wybrania całego foldera do konwertacji
  FOLDER_TO_CONVERT="$(zenity  --file-selection --title="Choose a directory" --directory)"
  case $? in
           0);;
           1)
                  zenity --question \
                         --title="Word counter" \
                         --text="Folder nie był wybrany. chcesz wybrać ponownie?" \
                         && choose_file || exit;;
          -1)
                  echo "An unexpected error has occurred."; exit;;
  esac
}
function choose_fihish_folder() { #tablet wybrania foldera do którego będo zapisane wszystkie pliki

  FINISH_FOLDER_FOR_CONVERT="$(zenity  --file-selection --title="Wybierz folder , do którego zapisać rezultat" --directory)"
  case $? in
           0);;
           1)
                  zenity --question \
                         --title="Word counter" \
                         --text="Folder nie był wybrany. chcesz wybrać ponownie?" \
                         && choose_fihish_folder || exit;;
          -1)
                  echo "An unexpected error has occurred."; exit;;
  esac
}
function format_FROM_convert() { #tablet do wybrania formata Z którego będzie konvertacja
  FORMAT_FROM_CONVERT="$(zenity --title="wybierz opcje" --width=400 --height=500 --text="wybierz format z którego knvertacji" \
  --list --column="Options" "avi" "mp4" "mpeg" "3gp")"
  case $? in
           0);;
           1)
                  zenity --question \
                         --title="Word counter" \
                         --text="Folder nie był wybrany. chcesz wybrać ponownie?" \
                         && format_FROM_convert || exit;;
          -1)
                  echo "An unexpected error has occurred."; exit;;
  esac
}
function convert_caly_folder() { #konvertacja kilku plików z jednego formatu do drógego

  format_to_convert_folder="$(zenity --title="wybierz opcje" --width=400 --height=500 --text="wybierz format do kturego będzie knvertacja" \
  --list --column="Options" "avi" "mp4" "mpeg" "3gp")"
  case $? in


           0)

            if [  "$FORMAT_FROM_CONVERT" = "$format_to_convert_folder" ]; then
              echo "Cannot convert $FORMAT_FROM_CONVERT to $format_to_convert_folder"
              exit
              else
                  if [  "$format_to_convert_folder" == "3gp"  ];then
                    for filename in "$FOLDER_TO_CONVERT"/*.$FORMAT_FROM_CONVERT; do

                    baseName=`basename -s ."${filename##*.}" $filename`			# poprzez to `` wykonuje sie ta komenda i przypisany jest wynik z tej komendy
                    echo "$baseName"
                    #dla 3gp jest dodany osobny kodak
                    ffmpeg -i "$filename" -f 3gp -vcodec libx264 -acodec aac "$FINISH_FOLDER_FOR_CONVERT"/"$baseName"."$format_to_convert_folder" 1>>"$CWD"/fils_for_script/log.txt  2>>"$CWD"/fils_for_script/error.txt
                    done
                  else
                    for filename in "$FOLDER_TO_CONVERT"/*.$FORMAT_FROM_CONVERT; do

                    baseName=`basename -s ."${filename##*.}" $filename`			# poprzez to `` wykonuje sie ta komenda i przypisany jest wynik z tej komendy
                    echo "$baseName"
                    ffmpeg -i "$filename" -ab 320k "$FINISH_FOLDER_FOR_CONVERT"/"$baseName"."$format_to_convert_folder" 1>>"$CWD"/fils_for_script/log.txt  2>>"$CWD"/fils_for_script/error.txt
                    done
                  fi
            echo "Conversion from ${FORMAT_FROM_CONVERT} to ${format_to_convert_folder} complete!"
            fi;;

           1)
                  exit;;
           -1)
                  echo "An unexpected error has occurred."; exit;;
  esac
}
function konvert_format_pliku() { #konvertacja jednego pliku z np avi do 3gp
  format="$(zenity --title="wybierz opcje" --width=400 --height=500 --text="wybierz format knvertacji" \
  --list --column="Options" "avi" "mp4" "mpeg" "3gp")"
    case $? in


             0)

               if [  "${FILE##*.}" = "$format" ]; then
                 echo "Cannot convert ${FILE##*.} to $format"
                 exit
                 else
                     if [  "${FILE##*.}" == "3gp"  ];then
                       baseName=`basename -s ."${FILE##*.}" $FILE`			# poprzez to `` wykonuje sie ta komenda i przypisany jest wynik z tej komendy
                       echo "$baseName"
                        #dla 3gp jest dodany osobny kodak
                       ffmpeg -i "$FILE" -f 3gp -vcodec libx264 -acodec aac "$FINISH_FOLDER_FOR_CONVERT"/"$baseName"."$format" 1>>"$CWD"/fils_for_script/log.txt  2>>"$CWD"/fils_for_script/error.txt

                     else


                       baseName=`basename -s ."${FILE##*.}" $FILE`			# poprzez to `` wykonuje sie ta komenda i przypisany jest wynik z tej komendy
                       echo "$baseName"
                       ffmpeg -i "$FILE" -ab 320k "$FINISH_FOLDER_FOR_CONVERT"/"$baseName"."$format" 1>>"$CWD"/fils_for_script/log.txt  2>>"$CWD"/fils_for_script/error.txt

                     fi
               echo "Conversion from ${FILE##*.} to ${format} complete!"
               fi;;
             1)
                    exit;;
             -1)
                    echo "An unexpected error has occurred."; exit;;
    esac
}
function convert_rozdzielnosc() { #funkcja zmiany rozdzielności wybranego pliku
  rozmiar_curr="$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 $FILE)"# tetaz wybrany plik ma rozdzielność
  rozmiar="$(zenity --forms --title="Zmiana rozdzielności(obecny rozmiar $rozmiar_curr)" \
  --text="Wprowadź nowy rozmiar." \
  --separator="," \
  --add-entry="rozmiar X" \
  --add-entry="rozmiar Y" )"


  case $? in
      0)
         x=$( echo $rozmiar | awk -F',' '{print $1}')#ogarnięcie rozmiar X z rozmiar
      nx="${x//[^0-9]/}"#obcinanie liter i innego od rozmiar X
      y=$( echo $rozmiar | awk -F',' '{print $2}')#ogarnięcie rozmiar Y z rozmiar
      ny="${y//[^0-9]/}"#obcinanie liter i innego od rozmiar Y
      echo "$nx $ny"
      if [[  $nx == ""  ]] || [[  $ny == ""  ]]; then #jeżeli po obcinaniu nic nie zostało sie , znaczy ze był wpisany nie poprawny format
        echo "wrong format "
        convert_rozdzielnosc
      fi
      baseName=`basename -s ."${FILE##*.}" $FILE`			# poprzez to `` wykonuje sie ta komenda i przypisany jest wynik z tej komendy
      echo "$baseName"
      format="${FILE##*.}"
       ffmpeg -i $FILE -s "$nx"x"$ny" -c:a copy "$FINISH_FOLDER_FOR_CONVERT"/"$baseName"."$format" 1>>"$CWD"/fils_for_script/log.txt  2>>"$CWD"/fils_for_script/error.txt;;
      1)
    exit;;
      -1)
          echo "An unexpected error has occurred."
          exit;;

  esac

}
function konvert_format() { # funkja do wybrania , czy chcesz konvertować jedyn plik lub cały folder
  folder_lub_plik="$(zenity --title="wybierz opcje" --width=400 --height=500 --text="wybierz,folder lub plik" \
  --list --column="Options" "1)Jedyn plik" "2)Cały folder")"
    case $? in
             0)
               case $folder_lub_plik in
                        "1)Jedyn plik")
                        choose_file
                        konvert_format_pliku
                         ;;
                         "2)Cały folder")
                         choose_folder
                         format_FROM_convert
                         convert_caly_folder
                         ;;
               esac;;
             1)
                    exit;;
             -1)
                    echo "An unexpected error has occurred."; exit;;
    esac
}
function cut_video() {
  time="$(zenity --forms --title="Obcinanie video" \
  --text="Wprowadź czas początku i długość" \
  --separator="," \
  --add-entry="początek (prosze napisać w formacie 00:60:60)" \
  --add-entry="długość (prosze napisać w formacie 00)" )"
case $? in
           0)
              start=$( echo $time | awk -F',' '{print $1}')
              length=$( echo $time | awk -F',' '{print $2}')
             # echo "19-12-01" | grep -E "^[1-9][0-9]{0,3}-(1[0-2]|0[1-9])-(0[1-9]|[12][0-9]|3[01])$"
              #sprawdzanie poprawności formatu czasu
              if [[ ! $start =~ ^[0-9]{2}:(6[0]|5[0-9]|4[0-9]|3[0-9]|2[0-9]|1[0-9]|0[0-9]):(6[0]|5[0-9]|4[0-9]|3[0-9]|2[0-9]|1[0-9]|0[0-9])$  ]] || [[  ! $length =~ ^[0-9]{2}$   ]]; then
                echo "wrong format "
                cut_video

              fi
                baseName="$(basename -- $FILE)"
                ffmpeg -i "$FILE" -ss "$start" -codec copy -t "$length" "$FINISH_FOLDER_FOR_CONVERT"/"cut.$baseName" 1>>"$CWD"/fils_for_script/log.txt  2>>"$CWD"/fils_for_script/error.txt
              ;;
           1)
                  exit;;
           -1)
                  echo "An unexpected error has occurred."; exit;;
esac


}
function get_sound() { #ogarnięcie dzwięku z video
    baseName=`basename -s ."${FILE##*.}" $FILE`
    ffmpeg -i $FILE -vn -ar 44100 -ac 2 -ab 192K -f mp3 "$FINISH_FOLDER_FOR_CONVERT"/sound."$baseName".mp3  1>>"$CWD"/fils_for_script/log.txt  2>>"$CWD"/fils_for_script/error.txt
}
######################### ODPALA SIE JAK WYWOLUJEMY Z KONSOLI ####################

if [ $# -gt 0 ];then
while getopts f:hr OPT; do
	case $OPT in

		f) FINISH_FOLDER_FOR_CONVERT=$OPTARG;;
		h) help;;
		r) information;;

		*) echo "Unknown parameter - ignored"
	esac
done
fi
function start() { # fynkcja początku programmu
  choose="$(zenity --title="wybierz opcje" --width=650 --height=500 --text="wybierz"\
    --list --column="Options"\
    "1)Konvertacja rozszeżenia"\
    "2)Folder do zapisywania wyników koversji formatu: $FINISH_FOLDER_FOR_CONVERT"\
    "3)Konvertacja rozdzielności"\
    "4)Prycinanie video"\
    "5)Ogarnięcie dzwięka z wideo"\
    "help"\
    "Opis programy")"

  case $? in
           0)
             case $choose in
                      "1)Konvertacja rozszeżenia")konvert_format;;
                      "2)Folder do zapisywania wyników koversji formatu: $FINISH_FOLDER_FOR_CONVERT")choose_fihish_folder;;
                      "3)Konvertacja rozdzielności")
                       choose_file
                       convert_rozdzielnosc;;
                       "4)Prycinanie video")
                       choose_file
                       cut_video;;
                       "5)Ogarnięcie dzwięka z wideo")
                       choose_file
                       get_sound ;;
                      "help")help;;

                      "Opis programy")information;;
             esac;;
           1)
                  exit;;
           -1)
                  echo "An unexpected error has occurred."; exit;;
  esac
}
while [[ true ]]; do

  start

done
