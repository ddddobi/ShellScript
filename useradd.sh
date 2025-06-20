#!/bin/bash
#########################################################
# crontab -e
# 분 시 일 월 요일 CMD
# 30 5 * * 1-5 /root/shell/useradd.sh >/var/log/useradd.log 2>&1
# => /var/log/useradd.log(스크립트 실행 확인) , /var/log/cron(스케줄러 확인) 
#########################################################
# 1) users/*.csv 파일 모으기
#  => users.list 파일 생성하기
# 2) users.list 파일 기반으로 사용자 추가
# 3) 사용자 추가 결과 메일 보내기
#########################################################


# 1) users/*.csv 파일모으기
BASEDIR=/root/shell/users
USERLIST=/$BASEDIR/user.list
> $USERLIST 
TMP1=/tmp/tmp1


ls $BASEDIR/*.csv > $TMP1 2>/dev/null
[ ! -s "$TMP1" ] && exit 1

for i in $BASEDIR/*.csv
do
    # echo $i 
    cat $i | tail -n 1 >> $USERLIST
done
# cat $USERLIST

# 2) user.list
for j in $(cat $USERLIST)
do
    # echo $j
    UNAME=$(echo $j | awk -F, '{print $1}')
    UPASS=$(echo $j | awk -F, '{print $2}')
    COMMENT=$(echo $j | awk -F, '{print $3 "," $4}')
    # echo $UNAME $UPASS $COMMENT

    useradd -c "$COMMENT" $UNAME
    echo $UPASS | passwd --stdin $UNAME
done

# 3) 사용자 추가 결과 보내기
MAILCONTENT=$BASEDIR/mail.txt
cat << EOF > $MAILCONTENT
메일 내용 

  메일 사용자 완료 레포트
	
- 일시 : $(date)
- 추가 사용자 목록 
EOF
cat $USERLIST >> $MAILCONTENT

mailx -s '[ OK ] 사용자 추가 완료' root < $MAILCONTENT
