#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 {on|off}"
    exit 1
fi
SW=$1

source /root/shell/function.sh

# GNOME extensions 모두 활성화
for i in $(gnome-extensions list); do
    gnome-extensions enable "$i"
done

# 바탕화면 아이콘 추가 함수
desktopicon() {
    DESKTOP_DIR=~/바탕화면
    mkdir -p "$DESKTOP_DIR"

    ICONS=(
        /usr/share/applications/org.gnome.Terminal.desktop
        /usr/share/applications/org.gnome.gedit.desktop
    )

    for icon in "${ICONS[@]}"; do
        if [ -f "$icon" ]; then
            cp "$icon" "$DESKTOP_DIR"
            chmod +x "$DESKTOP_DIR/$(basename "$icon")"
            print_good "$(basename "$icon") 아이콘 복사 완료"
        else
            print_error "$icon 파일이 존재하지 않음"
        fi
    done
}

case $SW in
    on)
        desktopicon
        ;;
    off)
        rm -f ~/바탕화면/org.gnome.Terminal.desktop
        rm -f ~/바탕화면/org.gnome.gedit.desktop
        print_info "바탕화면 아이콘 제거 완료"
        ;;
    *)
        echo "Usage: $0 {on|off}"
        exit 1
        ;;
esac

exit 0
