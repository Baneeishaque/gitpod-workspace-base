eval $(gp env -e) &&
    sudo apt update &&
    peaZipInstallationFile=PeaZip.deb &&
    gh release download --pattern '*GTK*.deb' --repo peazip/PeaZip --output $peaZipInstallationFile &&
    sudo apt install -y ./$peaZipInstallationFile &&
    rm $peaZipInstallationFile &&
    sudo rm -rf /var/lib/apt/lists/*
