#!/bin/bash

if [[ ! -n "${1}" ]]; then
	echo "${0} onedrive|baidupan \"����Ŀ¼\" [6|���������ļ���] [loop|once] [1800|�������Ӽ��] [\"record_video/other|onedrive��baidupanĿ¼|/\"]"
	echo "ʾ����${0} onedrive \"record_video/other\" 6 loop 1800 \"record_video/other\""
	exit 1
fi

DIR_LOCAL="${2}" #����Ŀ¼
FILENUMBER="${3:-6}" #�����ļ���
LOOP="${4:-loop}" #�Ƿ�ѭ��
INTERVAL="${5:-1800}" #���Ӽ��
DIR_CLOUD="${6:-record_video/other}" #onedrive��baidupanĿ¼
DIR_ONEDRIVE=${DIR_CLOUD}
DIR_BAIDUPAN=${DIR_CLOUD}

if [ "${1}" == "onedrive" ]; then
	while true; do
		count=0;
		eval ls -tl "record" 2>/dev/null | awk '/^-/{print $NF}' | while read ONEFILE ; do #�����޸�ʱ���ж��ļ��¾�
			let count++
			if [ ${count} -gt ${FILENUMBER} ]; then
				LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
				echo "${LOG_PREFIX} upload onedrive ${DIR_LOCAL}/${ONEFILE} start" #��ʼ�ϴ�
				onedrive -s -f "${DIR_ONEDRIVE}" "${DIR_LOCAL}/${ONEFILE}"
				
				LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
				echo "${LOG_PREFIX} upload onedrive ${DIR_LOCAL}/${ONEFILE} stopped. remove ${DIR_LOCAL}/${ONEFILE}" #ɾ���ļ�
				rm -f "${DIR_LOCAL}/${ONEFILE}"
				
			else
				LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
				echo "${LOG_PREFIX} keep file $count ${DIR_LOCAL}/${ONEFILE}" #�����ļ�
			fi
		done
		
		LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
		echo "${LOG_PREFIX} backup done. retry after ${INTERVAL} seconds..."
		[[ "${LOOP}" == "once" ]] && break
		
		sleep ${INTERVAL}
	done
fi

if [ "${1}" == "baidupan" ]; then
	while true; do
		count=0;
		eval ls -t ${DIR_LOCAL} 2>/dev/null | while read ONEFILE ; do #�����޸�ʱ���ж��ļ��¾�
			let count++
			if [ ${count} -gt ${FILENUMBER} ]; then
				LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
				echo "${LOG_PREFIX} upload baidupan ${DIR_LOCAL}/${ONEFILE} start" #��ʼ�ϴ�
				BaiduPCS-Go upload "${DIR_LOCAL}/${ONEFILE}" "${DIR_BAIDUPAN}" > /dev/null
				
				LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
				echo "${LOG_PREFIX} upload baidupan ${DIR_LOCAL}/${ONEFILE} stopped. remove ${DIR_LOCAL}/${ONEFILE}" #ɾ���ļ�
				rm -f "${DIR_LOCAL}/${ONEFILE}"
				
			else
				LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
				echo "${LOG_PREFIX} keep file $count ${DIR_LOCAL}/${ONEFILE}" #�����ļ�
			fi
		done
		
		LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
		echo "${LOG_PREFIX} backup done. retry after ${INTERVAL} seconds..."
		[[ "${LOOP}" == "once" ]] && break
		
		sleep ${INTERVAL}
	done
fi
