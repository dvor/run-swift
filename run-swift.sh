TEMP_FILE="$(mktemp)"
trap "rm $TEMP_FILE" SIGHUP SIGINT SIGTERM exit

files=()
xcrun_arguments=()
script_arguments=()

script_path=$1
contents=$(cat $script_path)
dirname=$(dirname $script_path)

for arg in "${@:2}"; do
  script_arguments+=($arg)
done

preprocess_pattern="^#\!(arg|import) (.*)"

while read -r line; do
  if [[ $line =~ $preprocess_pattern ]]; then
    case ${BASH_REMATCH[1]} in
      "arg" )
      xcrun_arguments+=(${BASH_REMATCH[2]})
      ;;
      "import" )
      files+=("$dirname/${BASH_REMATCH[2]}")
      ;;
      * )
      ;;
    esac
  fi
done <<< "$contents"

files+=($script_path)

for f in ${files[@]}; do cat "$f"; echo "\n"; done > $TEMP_FILE
sed -i '' '/^#/d' $TEMP_FILE

eval "xcrun swift ${xcrun_arguments[@]} $TEMP_FILE ${script_arguments[@]}"

exit $?
