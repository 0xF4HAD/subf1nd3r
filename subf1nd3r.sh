echo -e "\e[1;31m"
cat << "EOF"
  ██████  █    ██  ▄▄▄▄     █████▒██▓ ███▄    █ ▓█████▄ ▓█████  ██▀███  
▒██    ▒  ██  ▓██▒▓█████▄ ▓██   ▒▓██▒ ██ ▀█   █ ▒██▀ ██▌▓█   ▀ ▓██ ▒ ██▒
░ ▓██▄   ▓██  ▒██░▒██▒ ▄██▒████ ░▒██▒▓██  ▀█ ██▒░██   █▌▒███   ▓██ ░▄█ ▒
  ▒   ██▒▓▓█  ░██░▒██░█▀  ░▓█▒  ░░██░▓██▒  ▐▌██▒░▓█▄   ▌▒▓█  ▄ ▒██▀▀█▄  
▒██████▒▒▒▒█████▓ ░▓█  ▀█▓░▒█░   ░██░▒██░   ▓██░░▒████▓ ░▒████▒░██▓ ▒██▒
▒ ▒▓▒ ▒ ░░▒▓▒ ▒ ▒ ░▒▓███▀▒ ▒ ░   ░▓  ░ ▒░   ▒ ▒  ▒▒▓  ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░
░ ░▒  ░ ░░░▒░ ░ ░ ▒░▒   ░  ░      ▒ ░░ ░░   ░ ▒░ ░ ▒  ▒  ░ ░  ░  ░▒ ░ ▒░
░  ░  ░   ░░░ ░ ░  ░    ░  ░ ░    ▒ ░   ░   ░ ░  ░ ░  ░    ░     ░░   ░ 
      ░     ░      ░              ░           ░    ░       ░  ░   ░     
                        ░                        ░                      
EOF
echo -e "\e[0m"
echo -e "\e[1;32m Welcome to subf1nd3r - Make Your Subdomain Hunting Faster & Easy! 🔍 \e[0m"





  url=$1
  RESET="\e[0m"
  YELLOW="\e[1;33m"

# Making Dir 

    if [ ! -d "$url" ];then
        mkdir $url
    fi
    if [ ! -d "$url/Subdomains" ];then
        mkdir $url/Subdomains
    fi
   
    

# Harvesting subdomains (assetfinder & Sublist3r & subfinder & Crt.sh & amass)

    echo "$YELLOW[+] Harvesting subdomains with assetfinder...$RESET"
    assetfinder --subs-only $url > $url/Subdomains/assetfinder.txt

    echo "$YELLOW[+] Harvesting subdomains with Sublist3r...$RESET"
    sublist3r  -d $url -o  $url/Subdomains/sublist3r.txt

    echo "$YELLOW[+] Harvesting subdomains with subfinder...$RESET"
    subfinder -d $url  > $url/Subdomains/subfinder.txt

    echo "$YELLOW[+] Harvesting subdomains with Findomain...$RESET"
    findomain -t $url  -u $url/Subdomains/findomain.txt

    echo "$YELLOW[+] Harvesting subdomains with Findomain...$RESET"
    github-subdomains -d $url -o $url/Subdomains/githubsubdomain.txt
    
    echo "$YELLOW[+] Double checking for subdomains with amass and Crt.sh ...$RESET"
    #amass enum -passive -d $url | tee -a $url/Subdomains/amass.txt
    curl -s https://crt.sh/\?q\=%25.$url\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> $url/Subdomains/crt.txt
    cat $url/Subdomains/assetfinder.txt  $url/Subdomains/sublist3r.txt $url/Subdomains/subfinder.txt $url/Subdomains/crt.txt $url/Subdomains/findomain.txt $url/Subdomains/githubsubdomain.txt | anew $url/Subdomains/final.txt
    
    # jq -r 'keys[]' input.json | grep -v '^"$' > subdomains.txt || (jq -r '.[].subdomain' example.json | grep -v '^null$' > c99.txt)
    echo "$YELLOW[+] Harvesting subdomains with Knockpy ...$RESET"
    knockpy $url

    # Probing for alive domains

    echo -e "\e[1;33m[++] Probing for alive domains...\e[0m"
    cat $url/recon/Subdomains/final.txt | sort -u | httprobe -s -p https:443 | sed 's~https\?://~~; s~:443~~'  >> $url/recon/Subdomains/alive.txt
    cat $url/recon/Subdomains/final.txt | httpx -mc 200 | sort -u  >> $url/recon/Subdomains/alive.txt

    

    #manually Collect Domains from 
    #--> https://subdomainfinder.c99.nl/   (jq -r '.[].subdomain' example.json | grep -v '^null$' > c99.txt)
    # nuclei -l js.txt -t ~/.local/nuclei-templates/javascript -s critical,high,medium,low (nuclei) 
