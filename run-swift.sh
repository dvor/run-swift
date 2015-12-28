TEMP_FILE="/tmp/$(uuidgen).swift"

cleanup() {
    rm $TEMP_FILE
}

trap "cleanup; exit" SIGHUP SIGINT SIGTERM

stage_files="files"
stage_source="source"
stage_args="args"

current=$stage_files
files=()
arguments=()

for arg in "$@"; do
    if [ $arg == "END" ]; then
        current=$stage_source
        continue
    fi

    if [ $current == $stage_files ]; then
        files+=($arg)
    elif [ $current == $stage_source ]; then
        files+=($arg)
        current=$stage_args
    elif [ $current == $stage_args ]; then
        arguments+=($arg)
    fi
done

cat ${files[@]} > $TEMP_FILE
sed -i ''  '/^#/d' $TEMP_FILE

xcrun swift -F Tools/Swift-Frameworks/ $TEMP_FILE ${arguments[@]}
result=$?

cleanup

exit $result
