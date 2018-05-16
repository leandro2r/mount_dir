#!/bin/bash

while getopts "s:p:d:h" opt; do
    case $opt in
        s)
            src="${OPTARG}"
        ;;
        p)
            path="${OPTARG}"
        ;;
        d)
            dir="${OPTARG}"
        ;;
        h|\?)
            echo "-s <host> -p <host_path> -d <mount_dir>"
            exit 1
        ;;
    esac
done

validate_input()
{
    # Validation
    if [[ -z "${src}" ]]; then
        echo -e "\033[1mSource host attribute is required\033[0m"
        exit 1
    fi
    echo -e "\033[1mSetting source host: \033[0m${src}"

    if [[ -z "${path}" ]]; then
        # Default path
        path="/home/user/projects/"

    fi
    echo -e "\033[1mSetting host path: \033[0m${path}"

    if [[ -z "${dir}" ]]; then
        # Default directories
        dir=(`cat mount_dir.txt`)
    fi
    echo -e "\033[1mSetting mount directories: \033[0m${dir[@]}\n"
}

umount()
{
    echo -e "\033[1mUmounting repositories:\033[0m"

    for folder in "${dir[@]}"
    do
        sudo umount -f ${folder}/ 2> /dev/null
        echo -e "\t- \033[0;33m${folder}/\033[0m"

        regex="sshfs.*${dir}.*"
        pids=(`pgrep -f "${regex}"`)

        if [[ ${#pids[@]} -gt 0 ]]; then
            for pid in "${pids[@]}"
            do
                sudo kill -9 ${pid}
            done
        fi
    done
}

mount()
{
    echo -e "\033[1mMounting repositories:\033[0m"

    sshfs="sshfs ${src}:${path}"

    for folder in "${dir[@]}"
    do
        ${sshfs}${folder} ${folder}/
        echo -e "\t- \033[0;32m${folder}/\033[0m"
    done
}

validate_input
umount
mount
