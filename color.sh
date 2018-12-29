#!/bin/bash
TEMP=`getopt -o laf:b:s:h --long list,all \
     -n 'color' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
#set 会重新排列参数的顺序，也就是改变$1,$2...$n的值，这些值在getopt中重新排列过了
eval set -- "$TEMP"

#经过getopt的处理，下面处理具体选项。
Usage(){
  echo "Usage: `basename $0` [options]"
  echo "highlight text using specific colors"
  echo ""
  echo "Flags:"
  echo "  -f fgcolor               frontground color"
  echo "  -b bgcolor               background color"
  echo "  -s style                 highlight style"
  echo "  -l, --list               list simple palette"
  echo "  -a, --all                list all palette"
}

FgColor(){
  case "$1" in
    black)
      return "30"
      ;;
    red)
      return "31"
      ;;
    green)
      return "32"
      ;;
    yellow)
      return "33"
      ;;
    blue)
      return "34"
      ;;
    purple)
      return "35"
      ;;
    skyblue)
      return "36"
      ;;
    white)
      return "37"
      ;;
    *)
      return "37"
      exit 1;;
  esac
}

BgColor(){
  case "$1" in
    black)
      return "40"
      ;;
    red)
      return "41"
      ;;
    green)
      return "42"
      ;;
    yellow)
      return "43"
      ;;
    blue)
      return "44"
      ;;
    purple)
      return "45"
      ;;
    skyblue)
      return "46"
      ;;
    white)
      return "47"
      ;;
    *)
      return "49"
      exit 1;;
  esac
}

Style(){
  case "$1" in
    normal)
      return "0"
      ;;
    bold)  
      return "1"
      ;;
    deepen)
      return "2"
      ;;
    italic)
      return "3"
      ;;
    underline)
      return "4"
      ;;
    blink)
      return "5"
      ;;
    reverse)
      return "7"
      ;;
    *)
      return "0"
      exit 1;;
  esac
}

fgcolor=37
bgcolor=41
style=0
while true ; do
    case "$1" in
        -l|--list)
          echo -e "\033[30m 黑色字 \033[0m" 
          echo -e "\033[31m 红色字 \033[0m" 
          echo -e "\033[32m 绿色字 \033[0m" 
          echo -e "\033[33m 黄色字 \033[0m" 
          echo -e "\033[34m 蓝色字 \033[0m" 
          echo -e "\033[35m 紫色字 \033[0m" 
          echo -e "\033[36m 天蓝字 \033[0m" 
          echo -e "\033[37m 白色字 \033[0m"

          echo -e "\033[40;37m 黑底白字 \033[0m" 
          echo -e "\033[41;37m 红底白字 \033[0m" 
          echo -e "\033[42;37m 绿底白字 \033[0m" 
          echo -e "\033[43;37m 黄底白字 \033[0m" 
          echo -e "\033[44;37m 蓝底白字 \033[0m" 
          echo -e "\033[45;37m 紫底白字 \033[0m" 
          echo -e "\033[46;37m 天蓝底白字 \033[0m" 
          echo -e "\033[47;30m 白底黑字 \033[0m"
          exit 1;;
        -a|--all)
          for STYLE in 0 1 2 3 4 5 6 7; do
            for FG in 30 31 32 33 34 35 36 37; do
              for BG in 40 41 42 43 44 45 46 47; do
                CTRL="\033[${STYLE};${FG};${BG}m"
                echo -en "${CTRL}"
                echo -n "${STYLE};${FG};${BG}"
                echo -en "\033[0m"
              done
              echo
            done
            echo
          done
          # Reset
          echo -e "\033[0m"
          exit 1;;
        -f)
          FgColor $2
          fgcolor=`echo $?`
          shift 2;;
        -b)
          BgColor $2
          bgcolor=`echo $?`
          shift 2;;
        -s)
          Style $2
          style=`echo $?`
          shift 2;;
        -h)
          Usage
          exit 1
          ;;
        
        --) 
          while read file; do
            echo $file|sed -e "s/\(${!#}\)/\x1B\[${style};${fgcolor};${bgcolor}m\1\x1B\[0m/g"
          done
          shift ; break ;;
        *)
          while read file; do
            echo $file|sed -e "s/\(${!#}\)/\x1B\[${style};${fgcolor};${bgcolor}m\1\x1B\[0m/g"
          done
          exit 1 ;;
    esac
done
