FTP_HOST='oplab9.parqtec.unicamp.br'
LOCALPATH=$TRAVIS_BUILD_DIR/matchbox
REMOTEPATH='/ppc64el/matchbox'
ROOTPATH="~/rpmbuild/RPMS/ppc64le"
REPO1="/repository/debian/ppc64el/matchbox"
REPO2="/repository/rpm/ppc64le/matchbox"
github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)
   
if [ $github_version != $ftp_version ]
then
   cd $LOCALPATH
   wget https://github.com/poseidon/matchbox/archive/v$github_version.zip
   unzip v$github_version.zip
   sudo mv matchbox-$github_version matchbox
   cd matchbox
   make
   ./bin/matchbox -version
   cd bin
   mv matchbox matchbox-$github_version
   cd $LOCALPATH
   git clone https://$USERNAME:$TOKEN@github.com/Unicamp-OpenPower/repository-scrips.git
   cd repository-scrips/
   chmod +x empacotar-deb.sh
   chmod +x empacotar-rpm.sh
   sudo mv empacotar-deb.sh $LOCALPATH/bin
   sudo mv empacotar-rpm.sh $LOCALPATH/bin
   cd $LOCALPATH/bin
   sudo ./empacotar-deb.sh matchbox matchbox-$github_version $github_version " "
   sudo ./empacotar-rpm.sh matchbox matchbox-$github_version $github_version " " "matchbox is a service that matches bare-metal machines to profiles that PXE boot and provision clusters"
   if [[ $github_version > $ftp_version ]]
   then
      lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O $REPO1 $LOCALPATH/bin/matchbox-$github_version-ppc64le.deb"
      lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O $REPO2 $ROOTPATH/matchbox-$github_version-1.ppc64le.rpm"
   fi
   #lftp -c "open -u $FTP_USER,$FTP_PASSWORD ftp://oplab9.parqtec.unicamp.br; put -O $REMOTEPATH matchbox-$github_version"
   #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm $REMOTEPATH/matchbox-$del_version"
fi
