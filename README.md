# RFprocess
process continuous seismic data recorded by smartSolo to generate receiver function (RF)
>[!CAUTION]
>These scripts are not ready for immediate use but only provide a reference. Many parameters in the scripts need adjustment based on the actual filenames and storage paths. Changing the input paths, output paths, or filenames in one script will affect several other scripts.
>
>Pay attention to the variable related to 'read', 'write', 'in_dir', 'out_dir'
>
>If an earthquake happens exactly at midnight, spanning two days, this cut script might encounter issues. An easier solution could be to exclude such earthquakes if you have a sufficient number of other seismic events. 

## step 1 -Convert miniseed file to SAC file by [mseed2sac](https://github.com/EarthScope/mseed2sac/tree/main)

mseed2sac is a very powerful program for converting miniSEED to SAC and it surpports batch processing and metadata writing. But in the Step1_mseed2sac.sh, I only used its most basic functionality and processed them one by one. If you want to do batch processing and write metadata at the same time, please refer to its [manual](https://github.com/EarthScope/mseed2sac/blob/main/doc/mseed2sac.md).

1. Prepare the station information file:
> 453014218 2023-12-07T23:09:57 2024-01-03T03:33:02 -89.676285 30.003059 2822.58

Each line corresponds to one station, including its #SN, starttime, endtime, latitude, longitude

2. Change the 'dir' and 'f' variable in the script.

3. Run the step1 in this way:
```
sh Step1_mseed2sac.sh  $cmp
```
the 'cmp' variable can be 'Z', 'N', or 'E'

once step1 is finished, the sac files will be generated under the current path, with filenames formatteds as:
>Net.Sta.Loc.Channel.Quality.Year.Day.HHMMSS.SAC

e.g.,

>SS.14218.SW.GPN.D.2023.360.000000.SAC

## step 2 - Down sampling from 1000Hz(0.001s) to 50Hz(0.02s) by sac
Run the step2 under the same directory where the sac files are stored.

After this step, the original 1000Hz SAC files will be **over-written** by the new 50Hz SAC files.

## step3 - Preprocess by sac
First, the sac is used to remove the mean(rmean), the trend(rtr), and apply a taper(taper). Then it's used to remove the response (including a bandpass filter 0.01 - 20 Hz).
```
sh Step3_preprocess.sh $cmp
```
After this step, the processed files should be generated with the original filenames followed by '.removed'

e.g.,
>SS.14218.SW.GPN.D.2023.360.000000.SAC.removed

## step4 - cut earthquake event
Before run this script, prepare the earthquake event list:
>2023-12-26T13:11:43.180Z -5.2714 145.3057 87.171 5.1

Note: the epicentral distances of each event should be within the range of 30-90 deg, with a magnitude >= 5.0

Run:
```
sh Step4_cutevent.sh
```

This script will compute the theoretical arrival times using taup based on the IASP91 model, and then cut the seismic wave from 5 sec before the P-arrival to 75 sec after the P-arrival, saving it in SAC format.

This script will also perform a bandpass filter(0.3-5Hz) and write some event infomation to the header.

The directory of reading and saving data can be changed in the 'cut_ev.py' file.

## step5 - rotate to gcp

## step6 - calculate the RF
```
sh Step6_RF.sh
```
This will process all the event of all the stations.

if only want to process one event:
```
python rf.py $ev
```
where the variable $ev is the directory where there store the processed R&Z component data
