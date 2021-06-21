# VideoMaster
## simple script for video processing on ffmpg and zenity 

### Purposes of a script:

1. cutting video from HH:MM:SS to SS where H -hour , M - min , S- sec 

  for example:

    00:20:00

    02

    11:59:11

    01

2. getting audio from video 

3. changing format of video 

4. Converting files from one format(avi,mpeg,3gp,mp4) to another(avi,mpeg,3gp,mp4)


 If you wish to upgrade it feel free to do it !

### To run a script you will first  need to type in following commands in order to install ffmpeg which is necessary to run a script and perform actions:

##### Follow below instructions to install FFmpeg.
```
Update the apt package manager using the following command:

sudo apt updateCopy

Now add JonathanF’s ffmpeg-4 repository to your Linux Mint system by using below command:

sudo add-apt-repository ppa:jonathonf/ffmpeg-4Copy

Now you are ready to install FFmpeg-4 on Linux Mint, Type following command to install FFmpeg:

sudo apt install ffmpegCopy
Confirm the installation and check FFmpeg version typing below command:

ffmpeg -version
```

Follow below instructions to install Zenity.
```
sudo apt-get update -y

sudo apt-get install -y zenity
```
