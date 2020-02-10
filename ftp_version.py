import requests
# find and save the current Github release
html = str(
           requests.get('https://github.com/poseidon/matchbox/releases/latest')
           .content)
index = html.find('Release v')
github_version = html[index + 8 :index + 14]
print("Latest:", github_version)
file = open('github_version.txt', 'w')
file.writelines(github_version)
file.close()

# find and save the current Matchbox version on FTP server
html = str(
             requests.get(
                        'https://oplab9.parqtec.unicamp.br/pub/ppc64el/matchbox/'
                        ).content)
index = html.rfind('matchbox-')
ftp_version = html[index + 7:index + 12]
file = open('ftp_version.txt', 'w')
file.writelines(ftp_version)
file.close()