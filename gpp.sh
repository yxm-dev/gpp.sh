#! /bin/bash

# GPP FUNCTION
function gpp() {

## Includes
    source ${BASH_SOURCE%/*}/pkgfile
    source $PKG_install_dir/files/platforms
    if [[ -f "$PKG_install_dir/config/config" ]]; then
        source $PKG_install_dir/config/config
        has_config="ok"
    else
        echo "error: A configuration file was not identified."
        echo "Try:"
        echo "* \"GPP -t\" to create it from a template;"
        echo "* \"GPP -c\" to generate it with the help of a TUI interface."
        has_config=""
    fi

## Auxiliary Data
    declare -A GPP_remote_ssh
    declare -A GPP_init_path
    for parent in ${!GPP_parent[@]}; do
        bound=${GPP_max[$parent]}
        bound_init=${GPP_max_init[$parent]}
        declare -i bound
        declare -i bound_init
        for (( j=0; j<=${GPP_max_init[$parent]}; j++ )); do
            GPP_remote_ssh[$parent,$j]="${GPP_platform_ssh[$parent]}/${GPP_user[$parent]}/${GPP_remote_repo[$parent,$j]}"
            GPP_init_path[$parent,$j]=${GPP_parent[$parent]}/${GPP_init[$parent,$j]}
        done
    done
    

## Auxiliary Functions
    function GPP_cmd(){
        if [[ -f "$1" ]]; then
            if [[ -n "$1" ]]; then
                eval "$(cat $1)"
            fi
        fi
    }
    function GPP_core(){ 
        echo "Synchronizing \"$1\" with \"$2\"..."
        if [[ -n $3 ]]; then
            sudo rsync -av --progress --delete --exclude-from $3 $1 $2
        else
            sudo rsync -av --progress --delete $1 $2
        fi
        echo "-------------------------"
    }
    function GPP_create_dir(){
        echo "Target directory \"$2\" does not exists. Create it? (y/n)"
        while :
        do
            read -e -p "> " GPP_create_dir
            if [[ "$GPP_create_dir" == "y" ]] || [[ "$GPP_create_dir" == "yes" ]]; then
                echo "Creating \"$2\"..."
                mkdir -p $2
                GPP_core $1 $2 $3
                break
            elif [[ "$GPP_create_dir" == "n" ]] || [[ "$GPP_create_dir" == "no" ]]; then
                echo "Target directory was not created."
                echo "Aborting..."
                break
            fi
            echo "Please, write y/yes or n/no"
            continue
        done
    } 
    function GPP_dir_file(){
        if [[ -d "$1" ]] && [[ -d "$2" ]]; then
             GPP_core $1 $2 $3
        elif [[ -d "$2" ]] && [[ -f "$1" ]] ||
             [[ -f "$2" ]] && [[ -d "$1" ]]; then
            echo "error: You are trying to sync a dir with a file."
        elif [[ -f "$1" ]] && [[ -f "$2" ]]; then
             GPP_core $1 $2 $3
        elif [[ -d "$1" ]] && [[ ! -d "$2" ]]; then
            GPP_create_dir $1 $2 $3
        elif [[ ! -d "$1" ]]; then
            echo "error: The source directory \"$1\" does not exists."
        elif [[ ! -f "$1" ]]; then
            echo "error: The source file \"$1\" does not exists." 
        fi
    }
    function GPP_push(){
        echo "Entering in $1..."
        cd $1
        echo "Moving to branch \"$4\"..."
        branches=$(git branch)
        branches_array=()
        while IFS= read -r line; do
            branch=$(echo "$line" | awk '{$1=$1};1' | sed 's/\* //')
            branches_array+=("$branch")
        done <<< "$branches"
        for branch in ${branches_array[@]}; do
            if [[ "$4" == "$branch" ]]; then
                git checkout $4
                has_branch="ok"
                break
            else
                has_branch=""
            fi
        done
        if [[ -z "$has_branch" ]]; then
            git branch -b $4
        fi
        echo "Adding the files..."
        git add .
        echo "Commiting..."
        git commit -m "$2"
        echo "Pushing remote \"$3\" to branch \"$4\"..."
        git push $3  $4
        echo "Done!"
        echo "-------------------------"
    }
    function GPP_sync(){
        GPP_cmd $PKG_install_dir/files/cmd_before/$parent/init/$j
        exclude_file=$PKG_install_dir/files/excludes/$parent/init/$j
        if [[ -f "$exclude_file" ]]; then
            if [[ -n "${GPP_local[$parent,$j]}" ]]; then
                GPP_dir_file ${GPP_source[$parent,$j]} ${GPP_init_path[$parent,$j]} $exclude_file
            else
                GPP_dir_file ${GPP_source[$parent,$j]} ${GPP_init_path[$parent,$j]}
            fi
                GPP_cmd $PKG_install_dir/files/cmd_after/$parent/init/$j
        fi
    }
    function GPP_sync_other(){
        GPP_cmd $PKG_install_dir/files/cmd_before/$parent/other/$j
        exclude_file=$PKG_install_dir/files/excludes/$parent/other/$j
        if [[ -n "${GPP_source[$parent,$j]}" ]] && [[ -n "${GPP_target[$parent,$j]}" ]]; then
            if [[ -f "$exclude_file" ]]; then
                GPP_dir_file ${GPP_source[$parent,$j]} ${GPP_target[$parent,$j]} $exclude_file
            else
                GPP_dir_file ${GPP_source[$parent,$j]} ${GPP_target[$parent,$j]} 
            fi
                GPP_cmd $PKG_install_dir/files/cmd_after/$parent/other/$j
        fi
    }
   function GPP_git_init_core(){
        is_git=$(find . -maxdepth 1 -name ".git" -type d)
        if [[ -z $is_git ]]; then
            echo "Initializing git-dir \"$1\"..."
            git init
        else
            echo "Directory \"$1\" already git initialized. Re-initialize it? (y/n)"
            while :
            do
                read -e -p "> " reinitialize_dir
                if [[ "$reinitialize_dir" == "y" ]] || [[ "$reinitialize_dir" == "yes" ]]; then
                    echo "Re-initilizing dir \"$1\"..."
                    git init
                    break
                elif [[ "$reinitialize_dir" == "n" ]] || [[ "$reinitialize_dir" == "no" ]]; then
                    echo "Directory \"$1\" was not re-initialized."
                    echo "Aborting..."
                    break
                fi
                echo "error: Please, write y/yes or n/no"
                continue
            done
        fi
    }
    function GPP_git_init(){
        if [[ -n "${GPP_init[$parent,$j]}" ]]; then
            if [[ -d ${GPP_init_path[$parent,$j]} ]]; then
                cd ${GPP_init_path[$parent,$j]} 
                GPP_git_init_core ${GPP_init_path[$parent,$j]}
                cd - > /dev/null
             elif [[ -f ${GPP_init_path[$parent,$j]} ]]; then
                echo "error: \"$GPP_init_path\" is a file..."
            else
                echo "error: directory \"${GPP_init_path[$parent,$j]}\" does not exists."
            fi
        fi
    }
    function GPP_add_remote(){
        if [[ -n "${GPP_remote[$parent,$j]}" ]] &&
           [[ -n "${GPP_init[$parent,$j]}" ]]; then
            if [[ -n "${GPP_remote_repo[$parent,$j]}" ]]; then
                cd ${GPP_init_path[$parent,$j]}
                has_git=$(find . -maxdepth 1 -type d -name ".git")
                if [[ -n $has_git ]]; then
                    mapfile -t remotes < <(git remote)
                    if [[ "${remotes[@]}" =~ "${GPP_remote[$parent,$j]}" ]]; then
                        echo "error: There already exists a remote \"${GPP_remote[$parent,$j]}\" in \"${GPP_init_path[$parent,$j]}\"."
                    else
                        git remote add ${GPP_remote[$parent,$j]} ${GPP_remote_ssh[$parent,$j]} > /dev/null
                        echo "Remote \"${GPP_remote[$parent,$j]}\" has been added."
                    fi
                else
                    echo "error: The directory \"${GPP_init_path[$parent,$j]}\" is not a git initialized dir."
                    echo "Initialize it with \"GPP -i ${GPP_init[$parent,$j]}\"."
                fi
                cd - > /dev/null
            else
                echo "error: Destination for remote \"${GPP_remote[$1,$2]}\" was not defined."
            fi
        fi
    }


## GPP Function Propertly
    if [[ -z "$1" ]]; then
        cat $PKG_install_dir/config/help.txt
    elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        cat $PKG_install_dir/config/help.txt
    elif [[ "$1" == "-c" ]] || [[ "$1" == "-cfg" ]] ||
       [[ "$1" == "--cfg" ]] || [[ "$1" == "--config" ]]; then
        echo "executing the config file..." 
    elif [[ "$1" == "-cl" ]] || [[ "$1" == "--clean" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        echo "Cleaning temporary files..."
        find $HOME -type f -iname ".*.*.??????" -delete
        echo "Done!"
    elif [[ "$1" == "-t" ]] || [[ "$1" == "-tpl" ]] || [[ "$1" == "--template" ]]; then
        if [[ -f "$PKG_install_dir/config/config" ]]; then
            echo "There already exists a configuration file."
            echo "Want to replace it by a template? (y/n)"
            while :
            do
                read -r -p "> " replace_config
                if [[ "$replace_config" == "yes" ]] || [[ "$replace_config" == "y" ]]; then
                    cp $PKG_install_dir/files/config.tpl $PKG_install_dir/config/config
                    echo "Your config file was replaced by a template."
                    break
                elif [[ "$replace_config" == "no" ]] || [[ "$replace_config" == "n" ]]; then
                    echo "Aborting..."
                    break
                else
                    echo "Please, write y/yes or n/no."
                    continue
                fi
            done
        else
            cp $PKG_install_dir/files/config.tpl $PKG_install_dir/config/config
            echo "A template for the configuration file was created."
            cd $PKG_install_dir/files
        fi
### sync mode
    elif [[ "$1" == "--sync" ]] || [[ "$1" == "-s" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi       
        if [[ -z "$2" ]]; then
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    GPP_sync     
                done
                for (( j=0; j <= ${GPP_max[$parent]}; j++ )); do
                    GPP_sync_other
                done
            done
        else
            for parent in ${!GPP_parent[@]}; do
                if [[ "$2" == "$parent" ]]; then
                    for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                        GPP_sync    
                    done
                    for (( j=0; j <= ${GPP_max[$parent]}; j++ )); do
                        GPP_sync_other    
                    done
                    break
                fi
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    if [[ "$2" == "${GPP_alias[$parent,$j]}" ]]; then
                        GPP_sync
                        has_alias="ok"
                        break
                    fi
                done
                for (( j=0; j <= ${GPP_max[$parent]}; j++ )); do
                    if [[ "$2" == "${GPP_alias_other[$parent,$j]}" ]]; then
                        GPP_sync_other
                        has_alias="ok"
                        break
                    fi
                done
            done
            if [[ -z "$has_alias" ]]; then
                echo "error: none configured sync triple with alias \"$2\"."
            fi
        fi
### init mode
    elif [[ "$1" == "-i" ]] || [[ "$1" == "--init" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        if [[ -z "$2" ]]; then
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    GPP_git_init
                done
            done
        else
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    if [[ "$2" == "${GPP_remote[$parent,$j]}" ]]; then
                        GPP_git_init
                        has_remote="ok"
                        break
                    fi
                done
            done
            if [[ -z "$has_remote" ]]; then
                echo "error: none configured git directory with remote \"$2\"."
            fi
        fi
### remote add mode
    elif [[ "$1" == "-ra" ]] || [[ "$1" == "--remote-add" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        if [[ -z "$2" ]]; then
            for parent in ${!GPP_parent[@]}; do       
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    GPP_add_remote
                done
            done
        else
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    if [[ "$2" == "${GPP_remote[$parent,$j]}" ]]; then
                        GPP_add_remote
                        has_remote="ok"
                        break
                    fi
                done
            done
            if [[ -z "$has_remote" ]]; then
                echo "error: none configured git directory with remote \"$2\"."
            fi
        fi

### push mode
    elif [[ "$1" == "-p" ]] || [[ "$1" == "--push" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        if [[ -z "$2" ]]; then
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    if [[ -n "${GPP_init[$parent,$j]}" ]] &&
                       [[ -n "${GPP_commit[$parent,$j]}" ]] &&
                       [[ -n "${GPP_remote[$parent,$j]}" ]] &&
                       [[ -n "${GPP_branch[$parent,$j]}" ]]; then
                        GPP_push ${GPP_init_path[$parent,$j]} "${GPP_commit[$parent,$j]}" "${GPP_remote[$parent,$j]}" "${GPP_branch[$parent,$j]}"
                    fi
                done
            done
        else
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    if [[ -n "${GPP_init[$parent,$j]}" ]] &&
                       [[ -n "${GPP_commit[$parent,$j]}" ]] &&
                       [[ -n "${GPP_remote[$parent,$j]}" ]] &&
                       [[ -n "${GPP_branch[$parent,$j]}" ]]; then
                        has_alias="ok"    
                        has_remote="ok"
                        if [[ -n "${GPP_alias[$parent,$j]}" ]]; then
                            if [[ "$2" == "${GPP_alias[$parent,$j]}" ]]; then
                                GPP_push ${GPP_init_path[$parent,$j]} "${GPP_commit[$parent,$j]}" "${GPP_remote[$parent,$j]}" "${GPP_branch[$parent,$j]}"
                                has_alias="ok"
                                has_remote="ok"
                                break
                            else
                                has_alias=""
                            fi
                        elif [[ "$2" == "-r" ]] || [[ "$2" == "--remote" ]]; then
                            if [[ "$3" == "${GPP_remote[$parent,$j]}" ]]; then
                                GPP_push ${GPP_init_path[$parent,$j]} "${GPP_commit[$parent,$j]}" "${GPP_remote[$parent,$j]}" "${GPP_branch[$parent,$j]}"
                                has_alias="ok"
                                has_remote="ok"
                                break
                            else
                                has_remote=""
                            fi
                        fi
                    fi
                done
            done
            if [[ -z "$has_alias" ]]; then
                echo "error: none configured git directory with alias \"$2\"."
            fi
            if [[ -z "$has_remote" ]]; then
                echo "error: none configured git directory with remote \"$3\"."
            fi
        fi
### list mode
    elif [[ "$1" == "-l" ]] || [[ "$1" == "--list" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        if [[ -z "$2" ]]; then
            echo "try:"
            echo "* \"gpp -l -i\" to get the list of git initialized dirs and aliases;"
            echo "* \"gpp -l -r\" to get the list of remotes and their source;"
            echo "* \"gpp -l -a\" to get the list of all aliases."
        elif [[ "$2" == "-i" ]] || [[ "$2" == "--init" ]]; then
            echo "The following is the list of git initialized directories with their aliases:"
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    if [[ -n "${GPP_alias[$parent,$j]}" ]] &&
                       [[ -n "${GPP_init[$parent,$j]}" ]]; then
                        echo "[$parent,$j]: ${GPP_alias[$parent,$j]}, ${GPP_init_path[$parent,$j]}"
                    fi
                done
            done
        elif [[ "$2" == "-r" ]] || [[ "$2" == "--remote" ]] || [[ "$2" == "--remotes" ]]; then
            echo "The following is the list of remotes and their associated repositories:"
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    if [[ -n "${GPP_remote[$parent,$j]}" ]]; then
                        if [[ -n "${GPP_remote_repo[$parent,$j]}" ]]; then
                            echo "[$parent,$j]: ${GPP_remote[$parent,$j]}, ${GPP_remote_repo[$parent,$j]}"
                        else
                            echo "[$parent,$j]: ${GPP_remote[$parent,$j]}, missing repo"
                        fi
                    else
                        echo "[$parent,$j]: missing remote, missing repo"
                    fi
                done
            done
        elif [[ "$2" == "-a" ]] || [[ "$2" == "--alias" ]] || [[ "$2" == "--aliases" ]]; then
            echo "The following is the list of all (init and other) aliases:"
            for parent in ${!GPP_parent[@]}; do
                for (( j=0; j <= ${GPP_max_init[$parent]}; j++ )); do
                    if [[ -n "${GPP_alias[$parent,$j]}" ]]; then
                        echo "init: ${GPP_alias[$parent,$j]}"
                    fi
                done
                for (( j=0; j <= ${GPP_max[$parent]}; j++ )); do
                    if [[ -n "${GPP_alias_other[$parent,$j]}" ]]; then
                        echo "other: ${GPP_alias_other[$parent,$j]}"
                    fi
                done
            done
        else
            echo "option not defined for the \"gpp()\" function."
        fi
### clean, sync and push
    elif [[ "$1" == "-a" ]] || [[ "$1" == "--all" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        gpp -cl
        gpp -s
        gpp -p
### error
    else
        echo "option not defined for the \"GPP()\" function."
    fi
}

# aliases
alias gpph="gpp -h"
alias gppc="gpp -c"
alias gpps="gpp -s"
alias gppp="gpp -p"
alias gppa="gpp -a"
alias gppi="gpp -i"
alias gppra="gpp -ra"
alias gppl="gpp -l"
alias gppli="gpp -l -i"
alias gpplr="gpp -l -r"
alias gppla="gpp -l -a"    
