#!/bin/bash

# ./disk.sh
# [선수작업] Harddisk 장착 후 확인
# 앞으로 다음과 같은 과정을 진행합니다.
# 1) 장치 인삭과 파티션 작업
# 2) 파일 시스템 작업
# 3) 마운트 작업

# 위의 과정을 진행하기 위한 정보를 입력합니다.
# 아무키나 입력하면 입력을 시작합니다.
# 

set -e

# 0) 시작 문구 추가
    echo "1) 장치 인식과 파티션 작업을 진행합니다."
    echo "- Disk 파티션 작업 및 마운트 작업을 진행하기 위한 정보를 입력합니다."
    echo "- Enter키 입력하시면 입력을 진행합니다(Press Enter)"
    read

# 1) 장치 인식과 파티션 작업
    echo
    echo "[현재 인식된 디스크 목록입니다]"
    lsblk -d -o NAME,SIZE,MODEL

    echo
    echo -n "- Disk 이름을 입력하세요(ex: /dev/sdb): " 
    read DISKNAME
    echo " - 선택한 Disk 이름" : $DISKNAME
    
if [[ -z "$DISKNAME" || ! -b "$DISKNAME" ]]; then
    DISK_STATUS='false'
else
    DISK_STATUS='true'
fi

case $DISK_STATUS in
    true)
        echo " - [ OK ] 디스크 '$DISKNAME' 가 정상적으로 인식되었습니다."
        echo " - 파티션 작업을 시작 하도록 하겠습니다."
        
        echo " - 기존 파티션 테이블을 GPT로 설정하고, 전체 영역에 ext4 파티션을 생성합니다."
        parted -s "$DISKNAME" mklabel gpt
        parted -s "$DISKNAME" mkpart primary ext4 1MiB 100%
        echo " - 파티션 생성 완료: $DISKNAME"
        parted "$DISKNAME" print ;;

    false)
        echo "- [ FAIL ] 입력한 디스크 '$DISKNAME' 가 존재하지 않습니다."
        exit 1
        ;;
 esac

 # 2) 파일 시스템 작업
    echo
    echo "2) 파일 시스템 작업을 시작합니다."
    echo -n "- 파일 시스템 종류를 입력하세요(ex:ext4 | xfs) :"
    read FSTYPE

    PARTNAME="${DISKNAME}1"

    if [ "$FSTYPE" == "ext4" ]; then
        echo "- ext4 파일 시스템으로 포멧합니다. :  $PARTNAME"
        mkfs.ext4 "$PARTNAME"
    elif [ "$FSTYPE" == "xfs" ]; then
        echo "- xfs 파일 시스템으로 포멧합니다. :  $PARTNAME"
        mkfs.xfs "$PARTNAME"
    else
        echo "- [FAIL] 잘못된 지정 방식입니다."
        exit 1;
    fi

    echo
    echo "- 파일 시스템 생성 결과"
    blkid "$PARTNAME"

# 3) 마운트 작업
    echo
    echo "- 3) 마운트 작업을 시작합니다."
    echo -n "- 마운트할 디렉토리 경로를 입력하세요 (ex: /mnt/data): "
    read MOUNTPOINT

    # 디렉토리 확인후 없을 시 새로 생성
    if [ ! -d "$MOUNTPOINT" ]; then
        echo "- 마운트 경로가 존재하지 않아 생성합니다 : $MOUNTPOINT"
        mkdir -p "$MOUNTPOINT"
    fi

    # 마운트 작업 진행
    mount "$PARTNAME" "$MOUNTPOINT"
    
    # 마운트 작업 성공 여부 확인
    if mountpoint -q "$MOUNTPOINT"; then
        echo "- [ OK ] 마운트 성공: $MOUNTPOINT"
    else
        echo "- [ FAIL ] 마운트 실패"
        exit 1 
    fi

# 4) /etc/fstab파일에 등록
    echo
    echo "- 부팅 시 자동 마운트를 위하여 환경설정을 등록하겠습니까? (yes | no)"
    read ADD_FSTAB

    case $ADD_FSTAB in
        'y'|'yes'|'YES'|'Yes'|'YEs'|'Y')
             UUID=$(blkid "$PARTNAME" | awk -F'"' '{print $2}')

            if [[ -z "$UUID" ]]; then
                echo "- [FAIL] UUID를 찾을 수 없습니다. fstab 등록 중단."
                exit 1
            fi
                echo "UUID=$UUID  $MOUNTPOINT  $FSTYPE  defaults  0 2" >> /etc/fstab
                echo "- [ OK ] /etc/fstab에 등록에 성공했습니다. : UUID=$UUID → $MOUNTPOINT" ;;

         'n'|'N'|'No'|'no'|'NO')
            echo "[INFO] /etc/fstab 등록을 생략했습니다." ;;

        *)  echo '- [FAIL] 잘못된 입력입니다. 스크립트를 종료합니다.'
            exit 1 ;;
    esac

    echo "- 마무리 확인 작업"
    df -hT | grep "$MOUNTPINT"