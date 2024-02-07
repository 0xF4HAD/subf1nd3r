echo -e "\e[1;31m"
cat << "EOF"

  █████▒▄▄▄       ██▀███   ▒█████   ██▓     ██▓  ██████ ▄▄▄█████▓▓█████  ██▀███  
▓██   ▒▒████▄    ▓██ ▒ ██▒▒██▒  ██▒▓██▒    ▓██▒▒██    ▒ ▓  ██▒ ▓▒▓█   ▀ ▓██ ▒ ██▒
▒████ ░▒██  ▀█▄  ▓██ ░▄█ ▒▒██░  ██▒▒██░    ▒██▒░ ▓██▄   ▒ ▓██░ ▒░▒███   ▓██ ░▄█ ▒
░▓█▒  ░░██▄▄▄▄██ ▒██▀▀█▄  ▒██   ██░▒██░    ░██░  ▒   ██▒░ ▓██▓ ░ ▒▓█  ▄ ▒██▀▀█▄  
░▒█░    ▓█   ▓██▒░██▓ ▒██▒░ ████▓▒░░██████▒░██░▒██████▒▒  ▒██▒ ░ ░▒████▒░██▓ ▒██▒
 ▒ ░    ▒▒   ▓▒█░░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒░▓  ░░▓  ▒ ▒▓▒ ▒ ░  ▒ ░░   ░░ ▒░ ░░ ▒▓ ░▒▓░
 ░       ▒   ▒▒ ░  ░▒ ░ ▒░  ░ ▒ ▒░ ░ ░ ▒  ░ ▒ ░░ ░▒  ░ ░    ░     ░ ░  ░  ░▒ ░ ▒░
 ░ ░     ░   ▒     ░░   ░ ░ ░ ░ ▒    ░ ░    ▒ ░░  ░  ░    ░         ░     ░░   ░ 
             ░  ░   ░         ░ ░      ░  ░ ░        ░              ░  ░   ░        
EOF
echo -e "\e[0m"
echo -e "\e[1;32m Subdomain Hunter !\e[0m"

  url=$1
  RESET="\e[0m"
  YELLOW="\e[1;33m"

# Making Dir (jq -r '.[].subdomain' tesla.json | grep -v '^null$' > c99.txt)

    if [ ! -d "$url" ];then
        mkdir $url
    fi
    if [ ! -d "$url/Subdomains" ];then
        mkdir $url/Subdomains
    fi
   
    

# Harvesting subdomains (assetfinder & Sublist3r & subfinder & Crt.sh & amass)

    echo "$YELLOW[+] Harvesting subdomains with assetfinder...$RESET"
    assetfinder --subs-only $url >> $url/Subdomains/assetfinder.txt

    echo "$YELLOW[+] Harvesting subdomains with Sublist3r...$RESET"
    sublist3r  -d $url  >> $url/Subdomains/sublist3r.txt

    echo "$YELLOW[+] Harvesting subdomains with subfinder...$RESET"
    subfinder -d $url  >> $url/Subdomains/subfinder.txt
    
    echo "$YELLOW[+] Double checking for subdomains with amass and Crt.sh ...$RESET"
    #amass enum -passive -d $url | tee -a $url/Subdomains/amass.txt
    curl -s https://crt.sh/\?q\=%25.$url\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> $url/Subdomains/crt.txt
    # sort -u $url/recon/final1.txt >> $url/recon/final.txt
    cat $url/Subdomains/assetfinder.txt  $url/Subdomains/sublist3r.txt $url/Subdomains/subfinder.txt $url/Subdomains/crt.txt | anew $url/Subdomains/final.txt
    
    # jq -r 'keys[]' input.json | grep -v '^"$' > subdomains.txt
    # echo "$YELLOW[+] Harvesting subdomains with Knockpy ...$RESET"
    # knockpy $url

    #manually Collect Domains from 
    #--> https://subdomainfinder.c99.nl/   (jq -r '.[].subdomain' example.json | grep -v '^null$' > c99.txt)
    #
