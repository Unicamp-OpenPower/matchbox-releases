github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)
status=$(curl -s --head -w %{http_code} https://oplab9.parqtec.unicamp.br/pub/ppc64el/matchbox-$github_version -o /dev/null)

addr="ftp://oplab9.parqtec.unicamp.br"
path="/test/marcelo/matchbox/"
version="v0.8.3"
   
if [ [$status==404] ]
then
    echo "CLONING"
    git clone https://github.com/poseidon/matchbox.git
    
    echo "cd"
    cd matchbox

    echo "BUILDING"
    make
    
    echo "ls -la"
    ls -la

    echo "version"
    ./bin/matchbox -version

    echo "Getting BINARY inside bin"
    cd bin
    mv matchbox matchbox-$version
    
    echo "MOVING BINARY"
    lftp -c "open -u $FTP_USER,$FTP_PASSWORD ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/matchbox matchbox-$version"
fi


#deleting if necessary
# if [[ $github_version > $ftp_version ]]
    # then
    #     #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /test/marcelo/rclone/latest rclone-$github_version"
    #     #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /test/marcelo/rclone/latest/rclone-$ftp_version"
    # fi
    #lftp -c "open -u $FTP_USER,$FTP_PASSWORD ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/matchbox matchbox-$version"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/rclone-$del_version"

    # lftp -c "open -u $USER,$PASS $addr; cd $path; mv rclone-$ftp_version ../"

    # mv rclone rclone-$github_version
    # lftp -c "open -u $USER,$PASS $addr; cd $path; put rclone-$github_version"