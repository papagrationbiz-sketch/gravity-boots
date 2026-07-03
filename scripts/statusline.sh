#!/bin/bash

JSON_INPUT=$(cat)

eval $(echo "$JSON_INPUT" | jq -r '
  .cwd as $cwd |
  (.model.display_name // "none") as $model |
  (.context_window.total_input_tokens // 0) as $in_tok |
  (.context_window.total_output_tokens // 0) as $out_tok |
  ((.context_window.used_percentage // 0) | round) as $ctx_pct |
  (((1 - (.quota["gemini-5h"].remaining_fraction // 1)) * 100) | round) as $g5h |
  (.quota["gemini-5h"].reset_time // "") as $g5h_time |
  (.quota["gemini-5h"].reset_in_seconds // 0) as $g5h_reset |
  (((1 - (.quota["gemini-weekly"].remaining_fraction // 1)) * 100) | round) as $g1w |
  (.quota["gemini-weekly"].reset_time // "") as $g1w_time |
  (.quota["gemini-weekly"].reset_in_seconds // 0) as $g1w_reset |
  (((1 - (.quota["3p-5h"].remaining_fraction // 1)) * 100) | round) as $c5h |
  (.quota["3p-5h"].reset_time // "") as $c5h_time |
  (.quota["3p-5h"].reset_in_seconds // 0) as $c5h_reset |
  (((1 - (.quota["3p-weekly"].remaining_fraction // 1)) * 100) | round) as $c1w |
  (.quota["3p-weekly"].reset_time // "") as $c1w_time |
  (.quota["3p-weekly"].reset_in_seconds // 0) as $c1w_reset |
  "CWD=\($cwd | @sh) MODEL=\($model | @sh) IN_TOK=\($in_tok) OUT_TOK=\($out_tok) CTX_PCT=\($ctx_pct) G5H=\($g5h) G5H_TIME=\($g5h_time | @sh) G5H_RESET=\($g5h_reset) G1W=\($g1w) G1W_TIME=\($g1w_time | @sh) G1W_RESET=\($g1w_reset) C5H=\($c5h) C5H_TIME=\($c5h_time | @sh) C5H_RESET=\($c5h_reset) C1W=\($c1w) C1W_TIME=\($c1w_time | @sh) C1W_RESET=\($c1w_reset)"
')

# 基本カラーコード
GREEN="\033[32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[35m"
RESET="\033[0m"

# Gitリポジトリ名とブランチ名をbash側で取得
BRANCH=""
if git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$CWD" symbolic-ref --short HEAD 2>/dev/null); then
  BRANCH="$git_branch"
elif git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$CWD" rev-parse --short HEAD 2>/dev/null); then
  BRANCH="${git_branch}(detached)"
fi
if [ -z "$BRANCH" ]; then
  BRANCH="-"
fi

REPO=""
if [ "$BRANCH" != "-" ]; then
  REPO=$(basename "$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null)")
fi
if [ -z "$REPO" ] || [ "$REPO" = "." ]; then
  REPO="-"
fi

# カレントディレクトリの短縮表示
SHORT_CWD="${CWD/#$HOME/~}"

# 🔴 ギミック1: Ctx（コンテキスト）の警告色判定（70%で黄、90%で赤）
if [ $CTX_PCT -ge 90 ]; then
  CTX_COLOR="\033[1;31m" # 危険（赤）
elif [ $CTX_PCT -ge 70 ]; then
  CTX_COLOR="\033[1;33m" # 注意（黄）
else
  CTX_COLOR="\033[35m"   # 通常（マゼンタ）
fi

# 🔴 ギミック2: リミット消費率の警告色判定関数
get_limit_color() {
  local val=$1
  local def_color=$2
  if [ $val -ge 90 ]; then
    printf "\033[1;31m" # 危険（赤）
  elif [ $val -ge 70 ]; then
    printf "\033[1;33m" # 注意（黄）
  else
    printf "$def_color" # 安全（各AIのデフォルト色）
  fi
}

G5H_COL=$(get_limit_color $G5H $CYAN)
G1W_COL=$(get_limit_color $G1W $CYAN)
C5H_COL=$(get_limit_color $C5H $YELLOW)
C1W_COL=$(get_limit_color $C1W $YELLOW)

parse_iso_to_epoch() {
  local iso="$1"
  # Try BSD date (macOS)
  if epoch=$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$iso" "+%s" 2>/dev/null); then
    echo "$epoch"
    return
  fi
  # Try GNU date (Linux)
  if epoch=$(date -d "$iso" "+%s" 2>/dev/null); then
    echo "$epoch"
    return
  fi
  echo ""
}

format_epoch_local() {
  local epoch="$1"
  if [ -z "$epoch" ]; then
    printf ""
    return
  fi
  # macOS / BSD date
  if res=$(date -r "$epoch" '+%m/%d %H:%M' 2>/dev/null); then
    printf "%s" "$res"
    return
  fi
  # Linux / GNU date
  if res=$(date -d "@$epoch" '+%m/%d %H:%M' 2>/dev/null); then
    printf "%s" "$res"
    return
  fi
  printf ""
}

format_reset_time() {
  local iso="$1"
  local sec="$2"
  if [ -z "$iso" ] || [ "$iso" = "null" ] || [ "$sec" -le 0 ]; then
    printf ""
    return
  fi
  local epoch=$(parse_iso_to_epoch "$iso")
  if [ -n "$epoch" ]; then
    local formatted=$(format_epoch_local "$epoch")
    if [ -n "$formatted" ]; then
      printf "(↺%s)" "$formatted"
      return
    fi
  fi
  printf ""
}

G5H_RST=$(format_reset_time "$G5H_TIME" "$G5H_RESET")
G1W_RST=$(format_reset_time "$G1W_TIME" "$G1W_RESET")
C5H_RST=$(format_reset_time "$C5H_TIME" "$C5H_RESET")
C1W_RST=$(format_reset_time "$C1W_TIME" "$C1W_RESET")

# モデル選択の動的色
if [[ "$MODEL" == *Gemini* ]]; then MODEL_COLOR="${CYAN}"; elif [[ "$MODEL" == *Claude* ]]; then MODEL_COLOR="${YELLOW}"; else MODEL_COLOR="\033[1;37m"; fi

# ----------------- 出力部分 -----------------

# 1行目：Repo branch Directory
printf "[${GREEN}%s/%s${RESET}] %s\n" "$REPO" "$BRANCH" "$SHORT_CWD"

# 2行目：Model Ctx Tokens
printf "Model: ${MODEL_COLOR}%s${RESET} | Ctx: ${CTX_COLOR}%s%%${RESET} | Tokens: %s in / %s out\n" "$MODEL" "$CTX_PCT" "$IN_TOK" "$OUT_TOK"

# 3行目：Gemini Claude
printf "${CYAN}◆ Gem${RESET} 5h:${G5H_COL}%s%%%s${RESET} 1w:${G1W_COL}%s%%%s${RESET} | ${YELLOW}● Cld${RESET} 5h:${C5H_COL}%s%%%s${RESET} 1w:${C1W_COL}%s%%%s${RESET}\n" \
  "$G5H" "$G5H_RST" "$G1W" "$G1W_RST" "$C5H" "$C5H_RST" "$C1W" "$C1W_RST"
