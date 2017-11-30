#!/usr/bin/bash
####################################################################################################################
# Naem:                 : file_archive.sh
# Author                : Raja S. Bala
# Change History        : 11/27/2017 - Intial Development
#
#
# Usage                 : file_archive.sh -p <folder path> [-f <list file> | -F <pattren>] [-a <archive destination> -d <date suffix> -s <session/workflow/calling job name>]
#
#
#####################################################################################################################

### Initialization ###

if [ $# -lt 4 ]; then
        grep Usage "$0" | head -1
        exit 1
fi

LOG_DIR=/opt/informatica/server/infa_shared/ETL/scripts/logs
LOG_FILENAME=${LOG_DIR}/${0}_`date +'%d%m%Y%H%M%S'`.txt
TOP_DIR=`pwd`
ARC_DIR="Archive"
DATE_SUFFIX=`date '+%d%M%Y'`

while getopts ":p:f:F:a:s:d" opt; do
        case $opt in
                p)
                        TOP_DIR=$OPTARG
                        ;;
                f)
                        FILE_LIST=$OPTARG
                        ;;
                F)
                        FILE_PATRN=$OPTARG
                        ;;
                a)
                        ARC_DIR=$OPTARG
                        ;;
                d)
                        DT_IND=1
                        ;;
                s)
                        LOG_FILENAME=${LOG_DIR}/${OPTARG}_`date +'%d%m%Y%H%M%S'`.txt
                        ;;
                \?)
                        echo "Invalid option: -$OPTARG" >&2
                        grep Usage "$0" | head -1
                        exit 1
                        ;;
                :)
                        echo "Option -$OPTARG requires an argument." >&2
                        exit 1
                        ;;
        esac
done

echo "File Archiving started -- "  `date` > $LOG_FILENAME
## Check for the file pattren and archive

if [ ! -z $FILE_PATRN ] ; then
        echo "Files with pattrern $FILE_PATRN are archiving to ${ARC_DIR} from $TOP_DIR " >>  $LOG_FILENAME
        mv $TOP_DIR/${FILE_PATRN}  ${TOP_DIR}/${ARC_DIR}/ &>> $LOG_FILENAME
        STATUS=$?
        echo "File Archiving ended -- "  `date` >> $LOG_FILENAME
        if [ $STATUS -gt 0 ] ; then
                exit 1
        fi
fi

#echo $FILE_LIST
#echo $ARC_DIR
#echo $DATE_SUFFIX
#echo $FILE_PATRN
# Check for the file list and archive

if [ ! -z $FILE_LIST ] ; then
        if [ -f ${TOP_DIR}/$FILE_LIST ] ; then
                FLIST=`cat ${TOP_DIR}/$FILE_LIST`
        else
                echo "list file dosen't exist ${TOP_DIR}/$FILE_LIST" >> $LOG_FILENAME
                FLIST=""
        fi
        for i in  $FLIST
        do
                echo "Moving file $i to $ARC_DIR from $TOP_DIR " >> $LOG_FILENAME
                if [ ! -z $DT_IND ] ; then
                        echo "File new name ${i}_${DATE_SUFFIX}" >> $LOG_FILENAME
                        mv $TOP_DIR/$i ${TOP_DIR}/${ARC_DIR}/${i}_${DATE_SUFFIX} &>> $LOG_FILENAME
                else
                        mv $TOP_DIR/$i ${TOP_DIR}/${ARC_DIR}/ &>> $LOG_FILENAME
                fi
        done

fi
echo "File Archiving ended -- "  `date` >> $LOG_FILENAME



		
