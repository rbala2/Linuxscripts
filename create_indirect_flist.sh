#!/usr/bin/bash
####################################################################################################################
# Naem:                 : create_indirect_flist.sh
# Author                : Raja S. Bala
# Change History        : 11/30/2017 - Intial Development
#
#
# Usage                 : create_indirect_flist.sh -p <folder path> -f <list file suffix> -F <pattren> [-s <session/workflow/calling job name for log filename>]
#
#
#####################################################################################################################

### Initialization ###
if [ $# -lt 4 ]; then
        grep Usage "$0" | head -1
        exit 1
fi

LOG_DIR=/opt/informatica/server/infa_shared/ETL/logs/prepostscripts
LOG_FILENAME=${LOG_DIR}/$(basename ${0})_`date +'%d%m%Y%H%M%S'`.txt
TOP_DIR=`pwd`

while getopts ":p:f:F:s:" opt; do
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
                s)
                        LOG_FILENAME=${LOG_DIR}/$(basename ${0})_${OPTARG}_`date +'%d%m%Y%H%M%S'`.txt
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

echo "Indirect file list Prepartion started -- "  `date` > $LOG_FILENAME

if [ ! -d $TOP_DIR ]; then
	echo "No such Directory exist " >> $LOG_FILENAME
	echo "Indirect file list Prepartion Ended -- "  `date` >> $LOG_FILENAME
	exit 1
fi

# creating a dummy file to avoid balnk file list on no input file 
echo "Below files are added..." >> $LOG_FILENAME
cd $TOP_DIR
ls -1 ${FILE_PATRN}* &>> $LOG_FILENAME
if [ $? -gt 0 ] ; then
	touch dummy_file_${FILE_PATRN}.txt
	echo "NO input files found in $TOP_DIR , Creating dummy_file.txt"  >> $LOG_FILENAME
	ls -1 dummy_file_${FILE_PATRN}.txt > $TOP_DIR/list_${FILE_LIST}.txt
else
	ls -1 ${FILE_PATRN}* > $TOP_DIR/list_${FILE_LIST}.txt
fi
echo "Indirect file list Prepartion Ended -- "  `date` >> $LOG_FILENAME










