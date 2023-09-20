#! /bin/bash

# Declarations
    declare -A GP_parent
    declare -A GP_user
    declare -A GP_init
    declare -A GP_max_init
    declare -A GP_remote
    declare -A GP_remote_add
    declare -A GP_branch
    declare -A GP_commit
    declare -A GP_source
    declare -A GP_target
    declare -A GP_alias
    declare -A GP_max

    GP_parent["codeberg"]=$HOME/bkp/codeberg
    GP_parent["github"]=$HOME/bkp/github

    GP_user["codeberg"]="codeberg.org/yxm"
    GP_user["github"]="github.com/yxm-dev"
    
## defining git initialized dirs
    

### codeberg
    GP_init["codeberg",0]="backup"
    GP_init["codeberg",1]="math"
    GP_init["codeberg",2]="vim"

    GP_max_init["codeberg"]=2

### github
    GP_init["github",0]="config"
    GP_init["github",1]="dev"
    GP_init["github",2]="sh/bkp.sh"
    GP_init["github",3]="sh/cvt.sh"
    GP_init["github",4]="sh/ecl.sh"
    GP_init["github",5]="sh/emutt.sh"
    GP_init["github",6]="sh/pkg.sh"
    GP_init["github",7]="sh/sw.sh"
    GP_init["github",8]="sh/sync.sh"
    GP_init["github",9]="sh/menu.sh"
    GP_init["github",10]="sh/trsl.sh"
    GP_init["github",11]="sh/web.sh"
    GP_init["github",12]="sh/g.sh"
    GP_init["github",13]="sh/gp.sh"
    GP_init["github",14]="vim/essence.vim"
    GP_init["github",17]="vim/vimtex-colors.vim"
    GP_init["github",18]="stack"
    GP_init["github",19]="yxm-dev"
    GP_init["github",20]="sh/pdf.sh"
    GP_init["github",21]="sh/devto.sh"
    GP_init["github",22]="sh/gif.sh"
    GP_init["github",23]="sh/s3.sh"

    GP_max_init["github"]=23

## remotes (default is the name of the initialized dirs)
    
    GP_remote["codeberg",0]="backup"
    GP_remote["codeberg",1]="math"
    GP_remote["codeberg",2]="vim"

    GP_remote["github",0]="config"
    GP_remote["github",1]="dev"
    GP_remote["github",2]="bkp"
    GP_remote["github",3]="cvt"
    GP_remote["github",4]="ecl"
    GP_remote["github",5]="emutt"
    GP_remote["github",6]="pkg"
    GP_remote["github",7]="sw"
    GP_remote["github",8]="sync"
    GP_remote["github",9]="menu"
    GP_remote["github",10]="trsl"
    GP_remote["github",11]="web"
    GP_remote["github",12]="g"
    GP_remote["github",13]="gp"
    GP_remote["github",14]="essence"
    GP_remote["github",17]="vimtex"
    GP_remote["github",18]="stack"
    GP_remote["github",19]="yxm"
    GP_remote["github",20]="pdf"
    GP_remote["github",21]="devto"
    GP_remote["github",22]="gif"
    GP_remote["github",23]="s3"

## remote add (default is empty)
    GP_remote_add["codeberg",0]="ssh://git@codeberg.org/yxm/backup"
    GP_remote_add["codeberg",1]="ssh://git@codeberg.org/yxm/math"
    GP_remote_add["codeberg",2]="ssh://git@codeberg.org/yxm/vim"

    GP_remote_add["github",0]="ssh://git@github.com/yxm-dev/config"
    GP_remote_add["github",1]="ssh://git@github.com/yxm-dev/dev"
    GP_remote_add["github",2]="ssh://git@github.com/yxm-dev/bkp.sh"
    GP_remote_add["github",3]="ssh://git@github.com/yxm-dev/cvt.sh"
    GP_remote_add["github",4]="ssh://git@github.com/yxm-dev/ecl.sh"
    GP_remote_add["github",5]="ssh://git@github.com/yxm-dev/emutt.sh"
    GP_remote_add["github",6]="ssh://git@github.com/yxm-dev/pkg.sh"
    GP_remote_add["github",7]="ssh://git@github.com/yxm-dev/sw.sh"
    GP_remote_add["github",8]="ssh://git@github.com/yxm-dev/sync.sh"
    GP_remote_add["github",9]="ssh://git@github.com/yxm-dev/menu.sh"
    GP_remote_add["github",10]="ssh://git@github.com/yxm-dev/trsl.sh"
    GP_remote_add["github",11]="ssh://git@github.com/yxm-dev/web.sh"
    GP_remote_add["github",12]="ssh://git@github.com/yxm-dev/g.sh"
    GP_remote_add["github",13]="ssh://git@github.com/yxm-dev/gp.sh"
    GP_remote_add["github",14]="ssh://git@github.com/yxm-dev/essence.vim"
    GP_remote_add["github",17]=""
    GP_remote_add["github",18]="ssh://git@github.com/yxm-dev/stack"
    GP_remote_add["github",19]="ssh://git@github.com/yxm-dev/yxm-dev"
    GP_remote_add["github",20]="ssh://git@github.com/yxm-dev/pdf.sh"
    GP_remote_add["github",21]="ssh://git@github.com/yxm-dev/devto.sh"
    GP_remote_add["github",22]="ssh://git@github.com/yxm-dev/gif.sh"
    GP_remote_add["github",23]="ssh://git@github.com/yxm-dev/s3.sh"

## branches (default is master)
    
    GP_branch["codeberg",0]="master" 
    GP_branch["codeberg",1]="master"
    GP_branch["codeberg",2]="master"

    GP_branch["github",0]="master"
    GP_branch["github",1]="master"
    GP_branch["github",2]="master"
    GP_branch["github",3]="master"
    GP_branch["github",4]="master"
    GP_branch["github",5]="master"
    GP_branch["github",6]="master"
    GP_branch["github",7]="master"
    GP_branch["github",8]="master"
    GP_branch["github",9]="master"
    GP_branch["github",10]="master"
    GP_branch["github",11]="master"
    GP_branch["github",12]="master"
    GP_branch["github",13]="master"
    GP_branch["github",14]="master"
    GP_branch["github",17]="master"
    GP_branch["github",18]="master"
    GP_branch["github",19]="master"
    GP_branch["github",20]="master"
    GP_branch["github",21]="master"
    GP_branch["github",22]="master"
    GP_branch["github",23]="master"

## default commit (default is "...")
    
    GP_commit["codeberg",0]="..."
    GP_commit["codeberg",1]="..."
    GP_commit["codeberg",2]="..."

    GP_commit["github",0]="..."
    GP_commit["github",1]="..."
    GP_commit["github",2]="..."
    GP_commit["github",3]="..."
    GP_commit["github",4]="..."
    GP_commit["github",5]="..."
    GP_commit["github",6]="..."
    GP_commit["github",7]="..."
    GP_commit["github",8]="..."
    GP_commit["github",9]="..."
    GP_commit["github",10]="..."
    GP_commit["github",11]="..."
    GP_commit["github",12]="..."
    GP_commit["github",13]="..."
    GP_commit["github",14]="..."
    GP_commit["github",17]="..."
    GP_commit["github",18]="..."
    GP_commit["github",19]="..."
    GP_commit["github",20]="..."
    GP_commit["github",21]="..."
    GP_commit["github",22]="..."
    GP_commit["github",23]="..."

## defining local-git pairs
    
### codeberg
    GP_source["codeberg",0]=$HOME/files/
    GP_target["codeberg",0]=${GP_parent["codeberg"]}/backup/
    GP_alias["codeberg",0]="backup"
    
    GP_source["codeberg",1]=$HOME/files/nerd/math/pdfs/
    GP_target["codeberg",1]=${GP_parent["codeberg"]}/math/
    GP_alias["codeberg",1]="math"

    GP_source["codeberg",2]=$HOME/files/config/vim
    GP_target["codeberg",2]=${GP_parent["codeberg"]}/vim/
    GP_alias["codeberg",2]="vim"
   
    GP_max["codeberg"]=2

### github
    GP_source["github",0]=$HOME/files/nerd/dev/sh/bkp.sh/
    GP_target["github",0]=${GP_parent["github"]}/sh/bkp.sh/
    GP_alias["github",0]="bkp"
    
    GP_source["github",1]=$HOME/files/nerd/dev/sh/cvt.sh/
    GP_target["github",1]=${GP_parent["github"]}/sh/cvt.sh/
    GP_alias["github",1]="cvt"
    
    GP_source["github",2]=$HOME/files/nerd/dev/sh/ecl.sh/
    GP_target["github",2]=${GP_parent["github"]}/sh/ecl.sh/
    GP_alias["github",2]="ecl"
    
    GP_source["github",3]=$HOME/files/nerd/dev/sh/emutt.sh/
    GP_target["github",3]=${GP_parent["github"]}/sh/emutt.sh/
    GP_alias["github",3]="emutt"
     
    GP_source["github",4]=$HOME/files/nerd/dev/sh/pkg.sh/
    GP_target["github",4]=${GP_parent["github"]}/sh/pkg.sh/
    GP_alias["github",4]="pkg"
        
    GP_source["github",5]=$HOME/files/nerd/dev/sh/sw.sh/
    GP_target["github",5]=${GP_parent["github"]}/sh/sw.sh/
    GP_alias["github",5]="sw"
    
    GP_source["github",6]=$HOME/files/nerd/dev/sh/sync.sh/
    GP_target["github",6]=${GP_parent["github"]}/sh/sync.sh/
    GP_alias["github",6]="sync"
    
    GP_source["github",7]=$HOME/files/nerd/dev/sh/trsl.sh/
    GP_target["github",7]=${GP_parent["github"]}/sh/trsl.sh/
    GP_alias["github",7]="trsl"
    
    GP_source["github",8]=$HOME/files/nerd/dev/sh/web.sh/
    GP_target["github",8]=${GP_parent["github"]}/sh/web.sh/
    GP_alias["github",8]="web"
    
    GP_source["github",9]=$HOME/files/nerd/dev/sh/menu.sh/
    GP_target["github",9]=${GP_parent["github"]}/sh/menu.sh/
    GP_alias["github",9]="menu"
    
    GP_source["github",10]=$HOME/files/nerd/dev/vim/essence.vim/
    GP_target["github",10]=${GP_parent["github"]}/vim/essence.vim/
    GP_alias["github",10]="essence"
            
    GP_source["github",13]=$HOME/files/nerd/dev/vim/vimtex-colors.vim/
    GP_target["github",13]=${GP_parent["github"]}/vim/vimtex-colors.vim/
    GP_alias["github",13]="vimtex"
    
    GP_source["github",14]=$HOME/files/config/tex/preamble/
    GP_target["github",14]=${GP_parent["github"]}/config/tex/
    GP_alias["github",14]="config_tex"
    
    GP_source["github",15]=$HOME/files/config/linux/
    GP_target["github",15]=${GP_parent["github"]}/config/linux/
    GP_alias["github",15]="config_linux"
    
    GP_source["github",16]=$HOME/files/config/vim/vimrc
    GP_target["github",16]=${GP_parent["github"]}/config/vim/vimrc
    GP_alias["github",16]="vimrc"
    
    GP_source["github",17]=$HOME/files/config/vim/vimrc_keybind
    GP_target["github",17]=${GP_parent["github"]}/config/vim/vimrc_keybind
    GP_alias["github",17]="vimrc_keybind"
    
    GP_source["github",18]=$HOME/files/config/vim/vimrc_plugin
    GP_target["github",18]=${GP_parent["github"]}/config/vim/vimrc_plugin
    GP_alias["github",18]="vimrc_plugin"
      
    GP_source["github",19]=$HOME/files/nerd/doc/stk/
    GP_target["github",19]=${GP_parent["github"]}/stack/
    GP_alias["github",19]="stack"
    
    GP_source["github",20]=$HOME/files/nerd/dev/list/
    GP_target["github",20]=${GP_parent["github"]}/dev/
    GP_alias["github",20]="list"
        
    GP_source["github",21]=$HOME/files/nerd/dev/sh/g.sh/
    GP_target["github",21]=${GP_parent["github"]}/sh/g.sh/
    GP_alias["github",21]="g"
    
    GP_source["github",22]=$HOME/files/nerd/dev/sh/gp.sh/
    GP_target["github",22]=${GP_parent["github"]}/sh/gp.sh/
    GP_alias["github",22]="gp"

    GP_source["github",23]=$HOME/files/nerd/dev/sh/pdf.sh/
    GP_target["github",23]=${GP_parent["github"]}/sh/pdf.sh/
    GP_alias["github",23]="pdf"

    GP_source["github",24]=$HOME/files/nerd/dev/sh/devto.sh/
    GP_target["github",24]=${GP_parent["github"]}/sh/devto.sh/
    GP_alias["github",24]="devto"

    GP_source["github",25]=$HOME/files/nerd/dev/sh/gif.sh/
    GP_target["github",25]=${GP_parent["github"]}/sh/gif.sh/
    GP_alias["github",25]="gif"
    
    GP_source["github",26]=$HOME/files/nerd/dev/sh/s3.sh/
    GP_target["github",26]=${GP_parent["github"]}/sh/s3.sh/
    GP_alias["github",26]="s3"

    GP_max["github"]=26
