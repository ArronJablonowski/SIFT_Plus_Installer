#!/bin/bash
# 
## Installer Script for SIFT+ (sift workstation, plus some extra tools, and system tweaks & setup.) 
##
## For use with Ubuntu 20 Desktop -or- Ubuntu 22 Desktop only. 
##              *****************      *****************
##
## version 0.5.4
## by: Arron Jablonowski 
## last modified: Aug 28 2024
# 
#

######################################################### URLs #########################################################
########################################################################################################################
# CAST -- *still in beta
# - https://github.com/ekristen/cast
castURI="https://github.com/ekristen/cast/releases/download/v0.14.44/cast-v0.14.44-linux-amd64.deb"

# Networkminer 
# - https://www.netresec.com/?page=Blog&month=2014-02&post=HowTo-install-NetworkMiner-in-Ubuntu-Fedora-and-Arch-Linux
networkminerURI="https://www.netresec.com/?download=NetworkMiner"

# Google Chrome 
googleChromeURI="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

########################################################################################################################
########################################################################################################################

echo "" 
echo "Please ensure the system has been fully updated and recently rebooted prior to running this installer script. "
echo "You have 10 Seconds to cancel this installer. Otherwise please wait... "
sleep 10

currentSystemName=$HOSTNAME # get the current hostname to change it back to the original from SIFT install renaming host. 

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) # Gets the script's current location 

MAJOR_VERSION=$(lsb_release -r | cut -d':' -f2 | awk '{$1=$1};1' | cut -d'.' -f1) # Get the OS Major Version - there are some differences between Ubuntu 20 & Ubuntu 22 

# Check if Script was ran as sudo/root - Prevents things from ending up in the wrong directories.
if [ "$EUID" -eq 0 ]; then # $EUID equal to 0 (root user)
    echo " "
    echo "Please re-run script as a nonroot user."
    echo "ie. don't use 'sudo' when running installer script. "
    echo "  -- the script will call sudo & ask for your sudo pw as needed."
    echo " "
    exit  # EXIT Script 
else # Else user is not root - continue execution 
    clear 
    echo " " 
    echo "   __________________      "
    echo '  |# :            : #|     '
    echo "  |  :            :  |     "
    echo "  |  :   SIFT+    :  |     "
    echo "  |  :   v0.5.4   :  |     "
    echo "  |  :____________:  |     "
    echo "  |     __________   |     "
    echo "  |    | __       |  |     "
    echo "  |    ||  |      |  |     "
    echo "  \____||__|______|__|     "
    echo " " 
    echo " " 
    echo "  - This script will take awhile to run. Please be patient."
    sleep 2
    echo "  - Watch the CLI's output for MULTIPLE prompts for a sudo password."
    sleep 2
    echo "  - Ignore any Ubuntu Error Reporting Notices. "
    sleep 2 
    echo "  - IF install script fails to install something: "
    sleep 2
    echo "      -- Fix errors, dependancies, etc."
    sleep 2
    echo "      -- Ensure sources.list file is ORIGINAL Ubuntu sources.list"
    sleep 2
    echo "      -- Re-run this script."
    echo " " 
    sleep 5    
fi

### START FUNCTIONS ###
#######################

run_system_updates() {
    # Run Updates 
    sudo apt update && sudo apt upgrade -y
    # snap  
    sudo apt install -y snapd # ensure snapd is (already) installed 
    # Make sure snap is up to date
    sudo snap refresh       
} 

set_system_timezone_Chicago() {
    # Set timezone 
    sudo timedatectl set-timezone America/Chicago # Chicago (central time)
}

install_additionalSoftware() {
	# apt installs 
    sudo apt install -y git              # git
    sudo apt install -y nmap             # NMap 
    sudo apt install -y gimp             # Gimp (image editing software)
    sudo apt install -y shotwell         # image viewer (& desktop background changer)
    sudo apt install -y keepassxc        # Keepass XC (a better Keepass fork)
	sudo apt install -y openssh-server   # Open SSH Server   
    sudo apt install -y p7zip-full       # 7-zip (7z)
	sudo apt install -y xtrlock          # Xtrlock - Clear lock screen 
	sudo apt install -y whois            # WhoIs comes with mkpasswd for making encrypted passwords suited for shadow file
    sudo apt install -y espeak           # terminal voice
    sudo apt install -y remmina          # RDP, VNC, etc. client
    sudo apt install -y gparted          # partitioning tool     
    sudo apt install -y chkrootkit       # Checks for known Rootkits on local system
    sudo apt install -y evolution evolution-ews # Evolution email client & MS Exchange Web Server Plugin 
    sudo apt install -y gnome-todo       # Sticky Notes / Task tracking 
    sudo apt install -y aspell           # Spell Check for Evolution Email 
    sudo apt install -y fierce           # A DNS reconnaissance tool for locating non-contiguous IP space
    sudo apt install -y net-tools        # Ensure netstat is installed
    sudo apt install -y sysstat          # install 'iostat'. Great for watching the I/O of a drive during imaging process. 
    
    # Lynis - checks the system and the software configuration, to see if there is any room for improvements to the security defenses.
    sudo apt install -y lynis # Lynis is a security auditing tool for Linux, Mac OSX, and UNIX systems. Both local and remote. 

    # libreoffice
    sudo apt install -y libreoffice libreoffice-gnome libreoffice-evolution

    # Gnome tweaks (per OS version) & extensions 
        # if [ $MAJOR_VERSION = "20" ]; then sudo apt install -y gnome-tweak-tool; fi   # Ubuntu 20 
    sudo apt install -y gnome-tweaks # 'gnome-tweaks' and the above 'gnome-tweak-tool' point to the same application and gnome-tweaks is prefered, as Ubuntu 22 does not know what the Gnome-Tweak-Tool is.  
    sudo apt install -y gnome-shell-extensions 
    sudo apt install -y gnome-shell-extension-manager   
   
    sudo apt install -y snapd # ensure snapd is (already) installed 
   
    # Sqlight browser 
    sudo snap install sqlitebrowser --edge # SQLitebrowser    

    # Zoom  
    # sudo snap install zoom-client # Install Zoom 

    # IDEs 
    sudo snap install code --classic # MS Code
    sudo snap install pycharm-community --classic  # PyCharm Community edition  
    # sudo snap install notepad-plus-plus # NotePad++ (& wine)

    # Extras 
    sudo snap install zaproxy --classic  # ZAP 
    # sudo snap install postman            #
    sudo snap install cherrytree         # CherryTree Notes
    sudo snap install vlc                # VLC media player
    sudo apt install -y cmatrix          # cli animation 
    sudo apt install -y cowsay           # Cow, that says things. 
    sudo apt install -y sl               # sl <> lsjk - animation for misstypeing ls. 
    sudo apt install -y cheese           # Webcam photo booth
    # sudo apt install -y macchanger     # MAC Changer tool
    
    # Bulk file renamers 
    # sudo apt install -y thunar           # Bulk renaming tool 
    # sudo snap install smart-file-renamer # Bulk File Renamer
    
    # Xfce4 stuff 
    sudo apt install -y xfce4-taskmanager
    # sudo apt install -y xfce4-settings-manager
    # sudo apt install -y xfce4-panel 
    # sudo apt install -y xfce4-cpugraph-plugin # CPU monitor (can cause UI issues in some cases.)
	
	# Google Chrome (download from google)
	wget $googleChromeURI -O /tmp/google-chrome-stable_current_amd64.deb
	if test -f /tmp/google-chrome-stable_current_amd64.deb; then 
        sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
    else 
        echo "Chrome Browser Failed to Download! Try again later, manually."
        sleep 5
    fi 

    ### Will be installed with SIFT (CAST) ###
    # sudo apt install -y testdisk              # TestDisk/PhotoRec - Data recovery software - Great for media (photos, etc.)
    # sudo apt install -y foremost              # foremost - Data recovery software
    # sudo apt install -y scalpel               # scalpel - Data recovery software
    # sudo apt install -y safecopy              # safecopy - One of the best Linux Data Recovery Tools 
	# sudo apt install -y clamav                # Gets installed w/SIFT Workstation
    # sudo apt install -y wireshark             # Wireshark & TShark 
    # sudo apt install -y mplayer               # Can be used to play ogg files from CLI/scripts (system sounds: /usr/share/sounds/ubuntu/ringtones/) 
    # sudo snap install powershell --classic    # PowerShell

    sudo apt autoremove -y # clean up any unneeded packages 

}

add_netminer_alias() {
    # bashrc 
    if grep -q networkminer ~/.bashrc; then
        echo " "
        echo "The alias 'networkminer' has already been added to the ~/.bashrc file. Skipping step... "
        echo " "
        sleep 5
    else
        # networkminer alias not found, so add it.
        echo " " >> ~/.bashrc # add some space
        echo " " >> ~/.bashrc # add some space
        echo "alias networkminer='mono /opt/NetworkMiner*/NetworkMiner.exe --noupdatecheck' " >> ~/.bashrc
    fi
    
    # zshrc 
    if grep -q networkminer ~/.zshrc; then
        echo " "
        echo "The alias 'networkminer' has already been added to the ~/.zshrc file. Skipping step... "
        echo " "
        sleep 5
    else
        # networkminer alias not found, so add it. 
        echo " " >> ~/.zshrc # add some space
        echo " " >> ~/.zshrc # add some space
        echo "alias networkminer='mono /opt/NetworkMiner*/NetworkMiner.exe --noupdatecheck' " >> ~/.zshrc
    fi 
    
}

## Install Network Miner
install_NetworkMiner() {
    # echo "mono /opt/NetworkMiner*/NetworkMiner.exe --noupdatecheck " > ~/runNetworkMiner.sh
	sudo apt install mono-devel -y # mono is required to run networkminer.exe 
	wget $networkminerURI -O /tmp/nm.zip
    sudo unzip /tmp/nm.zip -d /opt/
    cd /opt/NetworkMiner*
    sudo chmod +x NetworkMiner.exe
    sudo chmod -R go+w AssembledFiles/
    sudo chmod -R go+w Captures/	

	# Make an Alias 'networkminer' (in both .bashrc & .zshrc) 
    add_netminer_alias # Adds Alias to bashrc & zshrc files
    
}

## Install CAST CLI tool 
install_CAST(){
	# Download CAST - For SIFT & Remnux CLI
	wget $castURI -O /tmp/cast_linux_amd64.deb
    sleep 2
	
    # Install CAST (if exists)
    if test -f /tmp/cast_linux_amd64.deb; then 
	    sudo dpkg -i /tmp/cast_linux_amd64.deb 
    else 
        echo "The CAST CLI Tool has failed to download. Exiting Installer..." 
        echo "Please contact your IT support."
        sleep 5
        exit
    fi

}

install_OLE_tools() {
    # https://pypi.org/project/oletools/
    # Per documentation it should be installed w/ sudo, despite the sudo warning durring install. 
    
    # pip3  (Python3 package manager)
    sudo apt install -y python3-pip  
    
    # OleTools - Malware analysis tools 
	sudo -H pip install -U oletools[full]
    # sudo -H pip install -U oletools      
}

cast_Install_SIFT(){
	# Install SIFT workstation, and configure with Saltstack 
	sudo cast install teamdfir/sift-saltstack
}

cleanup_Desktop() {
    # Move all the Desktop stuff to Documents
	[[ -d "~/Documents/SIFT_cheatsheets" ]] || mkdir ~/Documents/SIFT_cheatsheets
	mv ~/Desktop/*.pdf ~/Documents/SIFT_cheatsheets/
    mv ~/Desktop/* ~/Documents/ 
}

disable_gnome_lockscreen_timeout() {
    # Disable auto screen lock after x mins ('uint32 0' == disabled, else replace with seconds)
    gsettings set org.gnome.desktop.session idle-delay 'uint32 0'           
}

set_Gnome_Power_Settings() {
    # Power & lockscreen settins 
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false    # Disable screen dimming when system is idle 
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
}

set_shortcut_key_bindings(){
    # Set Key Bindings (Similar to Windows shortcut keys) 
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"  # WindowsKey+D - Show Desktop 
    gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>x']" # WindowsKey+X - Terminal (close enough to WinKey+X,then A)
    # gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']" ### Use the CUSTOM binding (below) instead of this one. 

    ## Setup Custom Key Bindings ##
        # custom0 (New Nautilus window 'Windows Key + E', similar to Windows file Explorer ) 
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'New Nautilus Window'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'nautilus -w'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>e'
   
}

set_Gnome_Theme_Settings() {
    # Modify Gnome settings 
    gsettings set org.gnome.ControlCenter last-panel 'info-overview'        # Set the "Settings" (last panel) to the "About" System page.
    gsettings set org.gnome.desktop.background show-desktop-icons false     # Disable Icons on Desktop, for a cleaner look (& to prevent info leakage durring meetings etc.)
    gsettings set org.gnome.desktop.interface enable-hot-corners false      # Disable hot corners 
    gsettings set org.gnome.desktop.interface show-battery-percentage true  # Show the battery percentage  
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' # Set the buttons a window 

    # Ubuntu 20 Settings 
    if [ $MAJOR_VERSION = "20" ]; then
        gsettings set org.gnome.shell.extensions.desktop-icons show-home false  # remove home folder from desktop
        gsettings set org.gnome.shell.extensions.desktop-icons show-trash false # remove trash can from desktop
    fi 
    
    # Ubuntu 22 Settings 
    if [ $MAJOR_VERSION = "22" ]; then 
        gsettings set org.gnome.shell.extensions.ding show-home false           # remove home folder from desktop (no trash can to hide)
    fi 
         
    # Nautilus Preferences 
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
    # gsettings set org.gnome.nautilus.preferences show-hidden-files true 

    # Dock Position Settings 
    # gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false    # Don't extend Dock to end of screen - More OSX like.
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false       # Auto hide dock when window overlaps dock 
    
}

set_Dock_Favorites() {
    # Set the Dock Favorites 
    gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Todo.desktop', 'code_code.desktop', 'libreoffice-writer.desktop', 'org.gnome.Evolution.desktop', 'google-chrome.desktop', 'org.keepassxc.KeePassXC.desktop']"
}

enable_Firewall() {
	#Enable Firewall 
	sudo apt install ufw -y 
	sudo ufw enable #Enable Firewall 
	sudo ufw allow ssh #Open port 22 - SSH 
}

install_Vanilla_Gnome() {
    # Ubuntu 20 Only -- It is not as nice looking on Ubuntu 22. 
    if [ $MAJOR_VERSION = "20" ]; then
        sudo apt update && sudo apt install -y vanilla-gnome-desktop 
    fi 
}

install_zshell_plus_config() {
    sudo apt install zsh -y
    sleep 2
    
    # If file exists, move to user's home dir 
    if test -f $SCRIPT_DIR/zshrc; then 
        cp $SCRIPT_DIR/zshrc ~/.zshrc
        # Setup Zsh config for root 
        sudo cp $SCRIPT_DIR/zshrc /root/.zshrc 
    else 
        echo "Zsh config file (zshrc) is missing. Please configure Zsh manually. "
        sleep 5 
    fi
    
    # Set Zsh as the defualt shell. 
    chsh -s $(which zsh)
    
    # Set Zsh as the defualt shell for Root 
    sudo  chsh -s $(which zsh)
}

set_Numix_Theme_Settings() {
    # Set themes to Numix 
    gsettings set org.gnome.desktop.interface icon-theme 'Numix'
    
    # gsettings set org.gnome.desktop.interface icon-theme 'Numix-Circle'
    gsettings set org.gnome.desktop.interface gtk-theme 'Numix'
    gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
}

install_Numix_Theme() {
    # Install Numix PPA & Themes 
    sudo add-apt-repository ppa:numix/ppa -y
    sudo apt-get update
    sudo apt-get install -y numix-gtk-theme numix-icon-theme-circle numix-icon-theme-square
    set_Numix_Theme_Settings # Call function to set Numix Theme 
}

set_hostname() {
    # (re)set the host's name to the original - SIFT changes the hostname to "siftworkstation" durring install. 
    echo ""
    echo "(Re)set the hostname:"
    echo "  -  Previously Named: $currentSystemName "
    echo "  -   SIFT renamed it: siftworkstation "
    
    # Reset Hostname -  change it back to the original hostname from 'siftworkstation'
    hostnamectl set-hostname $currentSystemName
    
    ## Modify the SALTSTACK configs
    # smb config - change (host) 'netbios name'  
    sudo sed -i "s/SIFTWORKSTATION/$currentSystemName/g" /var/cache/salt/minion/files/base/sift/files/samba/smb.conf
   
    # smb config - change the 'server string' as seen by user connecting to share  
    sudo sed -i "s/SIFT WORKSTATION/$currentSystemName/g" /var/cache/salt/minion/files/base/sift/files/samba/smb.conf
   
    # set hostname 
    sudo sed -i "s/siftworkstation/$currentSystemName/g" /var/cache/salt/minion/files/base/sift/config/hostname.sls
}

install_touchegg(){
    # Touchegg is used w/X11 Gestures extension to use mouse guestures similar to MacOS. 
    sudo add-apt-repository ppa:touchegg/stable -y 
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y touchegg

    # Open X11 Gesture webpage: 
    # xdg-open https://extensions.gnome.org/extension/4033/x11-gestures/ 
    # xdg-open https://extensions.gnome.org 

}

force_x11(){
    # Force X11 login, becuase Wayland UI does not play well with Xtrlock, Zoom Screen Sharing, VMWare Horizon Client, and some other applications. 
    # Uncomments the "#WaylandEnable=false" line in config 
     sudo sed -i "s/#WaylandEnable=false/WaylandEnable=false/g" /etc/gdm3/custom.conf
}

install_plaso_tools(){
    # Install Plaso tools - log2timeline, Psteal, Psort, etc. 
    sudo add-apt-repository universe -y   
    sudo apt-get update
    sudo apt-get upgrade -y 
    sudo add-apt-repository ppa:gift/stable -y 
    sudo apt-get update 
    sudo apt-get install -y plaso-tools  
    # sudo apt-get install -y python-plaso 

}

install_Autopsy_snap(){
    sudo apt install -y snapd # ensure snapd is (already) installed 
    sudo snap refresh # make sure snap is up to date 
    # Install Autopsy snap - forensics investigation tool
    sudo snap install autopsy
}


######################
### Function Calls ###
######################

### Pre Install Config ### 
disable_gnome_lockscreen_timeout # Change the lock screen settings 
set_Gnome_Power_Settings         # Change power settings to prevent screen from turning off 
enable_Firewall                  # Enable UFW & open port 22


### Updates ### 
run_system_updates               # Run System Updates (apt update, upgrade and snap refresh)


### Installs ### 
install_zshell_plus_config       # Zsh plus a custom config file 
install_Numix_Theme              # Numix Theme
install_Vanilla_Gnome            # Install Vanilla Gnome (Ubunu 20 Only) - Doesn't look as nice in Ubuntu 22, IMO. 
install_NetworkMiner             # Install Network Miner 
install_OLE_tools                # Install OLE Tools
install_CAST                     # CAST is required to install SIFT/Remnux 
cast_Install_SIFT                # Install SIFT Workstation 
install_plaso_tools              # Install Plaso tools (log2timeline, etc.) - forensic tools for timeline generation and analysis. 
                                 ## Plaso tools - https://plaso-fork.readthedocs.io/en/latest/index.html
install_Autopsy_snap             # Install Autopsy snap - forensic tools 
install_additionalSoftware       # Install additional apps
# install_touchegg               ## Add ppa and install touchegg for mouse gestures (similar to MacOS mouse gestures). Install "X11 gestures" extension. 
                                 ## TouchEgg only works (well) with certain track pads. Please do your own research before installing. 
                                 ## X11 Gestures - https://extensions.gnome.org/extension/4033/x11-gestures/


### Configure OS ###
set_system_timezone_Chicago      # Set the System's timezone to Chicago time. (central time - US)
set_shortcut_key_bindings        # Configures a few custom key bindings similar to Windows OS. 
set_Gnome_Theme_Settings         # reset these settings again post SIFT/Remnux install, to override any changes made by installer. 
set_Numix_Theme_Settings         # reset to Numix theme after SIFT/Remnux install
set_Dock_Favorites               # Put Favorite apps on Dock 
cleanup_Desktop                  # clean up the desktop by moving everything to the Documents folder  
set_hostname                     # (re)set the host's name back to the original (ie. not SiftWorkstation)
## force_x11                     ## Breaking FireFox.. ?? Not sure why.   # Manual Force/Change X11 (over Wayland) for compatability with some applications 
                                 ## Potential memory leak with FireFox and X11. Lots of RAM should mitigate symptoms.  


sleep 5 # Give slower systems time for the dust to settle, before telling user to reboot. 
echo " "
echo " "
echo "      **************************** "
echo "      ** You should reboot now. ** "
echo "      **************************** "
echo " "
echo " "
