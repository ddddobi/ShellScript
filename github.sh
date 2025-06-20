#!/bin/bash

# GitHub 업로드 자동화 스크립트

echo "[ INFO ] GitHub 업로드 스크립트를 실행하시겠습니까? (y/n)"
read START_CONFIRM
[[ "$START_CONFIRM" != "y" ]] && echo "[ INFO ] 스크립트를 종료합니다." && exit 0

# 현재 디렉토리 확인
CURRENT_DIR=$(pwd)
echo "[ INFO ] 현재 디렉토리: $CURRENT_DIR"

echo -n "[ INFO ] GitHub 연동할 디렉토리를 입력하세요 (예: ~/github.shell): "
read WORKDIR

# 파일 복사
echo "[ INFO ] 현재 디렉토리에서 연동 디렉토리로 파일을 복사합니다."
mkdir -p "$WORKDIR"
cp -r "$CURRENT_DIR"/* "$WORKDIR"/

# 사용자 정보 입력
echo -n "[ INFO ] GitHub 사용자명 (ID): "
read GIT_USER

echo -n "[ INFO ] GitHub 등록 이메일 주소: "
read GIT_EMAIL

echo -n "[ INFO ] GitHub Personal Access Token (PAT): "
read -s GIT_TOKEN

echo

echo -n "[ INFO ] GitHub Repository 이름 (예: ShellScript): "
read REPO_NAME

# Git 설치 확인 및 설치
echo "[git-core] 패키지 설치 준비"
yum -y install git-core &> /dev/null && echo "[git-core] 패키지 설치 완료"

cd "$WORKDIR"
echo "# $REPO_NAME" > README.md

# Git 초기화 여부 확인
if [ -d ".git" ]; then
    echo "[ INFO ] 이미 Git 저장소로 초기화된 디렉토리입니다."
else
    git init
    echo "[ INFO ] Git 저장소 초기화 완료."
fi

# 사용자 정보 설정
git config user.name "$GIT_USER"
git config user.email "$GIT_EMAIL"
echo "[ INFO ] Git 사용자 설정 확인:"
echo "$GIT_USER"
echo "$GIT_EMAIL"

# 100MB 이상 파일 검사
echo "[ INFO ] 100MB 초과 파일 검사 중..."
find . -type f -size +100M > .large_files.txt
if [ -s .large_files.txt ]; then
    echo "[ WARNING ] 다음 파일은 100MB를 초과하여 GitHub 업로드가 차단됩니다:"
    cat .large_files.txt
    echo "[ FAIL ] 업로드를 중단합니다. 해당 파일을 삭제하거나 .gitignore에 등록하세요."
    exit 1
fi

# Add & Commit
git add .
echo -n "[ INFO ] 커밋 메시지를 입력하세요 (예: Initial commit): "
read COMMIT_MSG

git diff --cached --quiet || git commit -m "$COMMIT_MSG" || echo "[ INFO ] 커밋할 변경 사항이 없습니다."

# 원격 저장소 연결
REMOTE_URL="https://${GIT_USER}:${GIT_TOKEN}@github.com/${GIT_USER}/${REPO_NAME}.git"

git remote | grep -q origin
if [ $? -ne 0 ]; then
    git remote add origin "$REMOTE_URL"
    echo "[ INFO ] 원격 저장소 등록 완료"
else
    echo "[ INFO ] 원격 저장소 origin이 이미 존재합니다."
fi

git branch -M main

# Push & 충돌 처리
git push -u origin main 2> push_error.log || {
    if grep -qE "non-fast-forward|pre-receive hook declined|fetch first" push_error.log; then
        echo "[ WARNING ] 원격 저장소와 충돌이 발생했습니다."
        echo -n "[ 선택 ] 원격 내용을 먼저 병합하려면 1, 로컬로 덮어쓰려면 2를 입력하세요 (1/2): "
        read RESOLVE_CHOICE
        if [[ "$RESOLVE_CHOICE" == "1" ]]; then
            git pull origin main --allow-unrelated-histories --no-edit
            git push -u origin main
        elif [[ "$RESOLVE_CHOICE" == "2" ]]; then
            echo "[ INFO ] 로컬 저장소로 강제 덮어쓰기 중..."
            git push -u origin main --force
        else
            echo "[ FAIL ] 잘못된 입력입니다. 종료합니다."
            exit 1
        fi
    else
        echo "[ FAIL ] 예기치 않은 오류로 push에 실패했습니다."
        cat push_error.log
        exit 1
    fi
}

rm -f push_error.log

echo "[ SUCCESS ] GitHub 업로드가 완료되었습니다."
