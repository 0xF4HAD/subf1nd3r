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
echo -e "\e[1;32m Welcome to subf1nd3r - Make Your Subdomain & JS Hunting Faster & Easy! 🔍 \e[0m"





  url=$1
  RESET="\e[0m"
  YELLOW="\e[1;33m"
  RED = "\e[1;31m"

# Making Dir (jq -r '.[].subdomain' tesla.json | grep -v '^null$' > c99.txt)

    if [ ! -d "$url" ];then
        mkdir $url
    fi
    if [ ! -d "$url/Subdomains" ];then
        mkdir $url/Subdomains
    fi
    if [ ! -d "$url/Subdomains/recon" ];then
        mkdir $url/Subdomains/recon
    fi
    if [ ! -d "$url/Subdomains/js" ];then
        mkdir $url/Subdomains/js
    fi
    if [ ! -d "$url/Subdomains/param" ];then
    mkdir $url/Subdomains/param
    fi
    if [ ! -d "$url/Subdomains/docs" ];then
    mkdir $url/Subdomains/docs
    fi
    if [ ! -d "$url/Subdomains/OWASP" ];then
    mkdir $url/Subdomains/OWASP 
    fi
   
    

# Harvesting subdomains (assetfinder & Sublist3r & subfinder & Crt.sh & amass)
    echo -e "$RED[🔍+++🔍++++🔍]  Subdomains Enumerating 🔍...$RESET"

    echo -e "$YELLOW[+] Harvesting subdomains with assetfinder...$RESET"
    assetfinder --subs-only $url > $url/Subdomains/assetfinder.txt

    echo -e "$YELLOW[+] Harvesting subdomains with Sublist3r...$RESET"
    sublist3r  -d $url -o  $url/Subdomains/sublist3r.txt

    echo -e "$YELLOW[+] Harvesting subdomains with subfinder...$RESET"
    subfinder -d $url  > $url/Subdomains/subfinder.txt

    echo -e "$YELLOW[+] Harvesting subdomains with Findomain...$RESET"
    findomain -t $url  -u $url/Subdomains/findomain.txt

    echo -e "$YELLOW[+] Harvesting subdomains with Findomain...$RESET"
    github-subdomains -t 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 -d $url -o $url/Subdomains/githubsubdomain.txt
    
    echo -e "$YELLOW[+] Double checking for subdomains with amass and Crt.sh ...$RESET"
    amass enum -passive -d $url | tee -a $url/Subdomains/amass.txt
    curl -s https://crt.sh/\?q\=%25.$url\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> $url/Subdomains/crt.txt

    echo -e "$YELLOW[+] Harvesting subdomains with Webarchive ...$RESET"
    curl -s "http://web.archive.org/cdx/search/cdx?url=*.$url/*&output=text&fl=original&collapse=urlkey" |sort| sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' | uniq >> $url/Subdomains/waybacksubdomain.txt
     
    echo -e "$YELLOW[+] Harvesting subdomains with nmap ...$RESET"
    nmap --script hostmap-crtsh.nse $url -o $url/Subdomains/nmapsubs.txt

    echo -e "$YELLOW[+] Harvesting subdomains with certspotter ...$RESET"
    curl -s "https://api.certspotter.com/v1/issuances?domain=$url&include_subdomains=true&expand=dns_names" | jq .[].dns_names | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >> $url/Subdomains/certspotter.txt
    
    echo -e "$YELLOW[+] Harvesting subdomains with jldc ...$RESET"
    curl -s "https://jldc.me/anubis/subdomains/$url" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >> $url/Subdomains/jldc.txt
    

    echo -e "$YELLOW[+] Harvesting subdomains with anubis ...$RESET"
    curl -s "https://jldc.me/anubis/subdomains/$url" | jq -r '.' | grep -o "\w.*$url" | sort -u >> $url/Subdomains/anubis.txt

    echo -e "$YELLOW[+] Harvesting subdomains with Hackertarget ...$RESET"
    curl -s "https://api.hackertarget.com/hostsearch/?q=$url" |sed 's/,.*//' | sort -u >> $url/Subdomains/Hackertarget.txt


    echo -e "$YELLOW[+] Harvesting subdomains with Otx ...$RESET"
    curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$url/url_list?limit=100&page=1" | grep -o '"hostname": *"[^"]*' | sed 's/"hostname": "//' | sort -u | sort -u >> $url/Subdomains/otx.txt

    echo -e "$YELLOW[+] Harvesting IP with hackertarget ...$RESET"
    curl -s "https://api.hackertarget.com/hostsearch/?q=$url" |  sed 's/^[^,]*,//' | sort -u >> $url/Subdomains/ip.txt 

# Harvesting subdomains using Bruteforce 

    echo -e "$RED[🔍++++++++🔍] Subdomains Bruteforce...🔍$RESET"
    echo -e "$YELLOW[+] Subdomain Bruteforce using gobuster ...$RESET"
    gobuster dns -d $url -w /root/wordlist/subdomain/all.txt -o $url/Subdomains/gobuster.txt

    echo -e "$YELLOW[+] Subdomain Bruteforce using shuffledns ...$RESET"
    shuffledns -d $url -w /root/wordlist/subdomain/all.txt -r /root/tools/massdns/lists/resolvers.txt -o $url/Subdomains/shuffledns.txt 

    cat $url/Subdomains/assetfinder.txt $url/Subdomains/amass.txt  $url/Subdomains/sublist3r.txt $url/Subdomains/subfinder.txt $url/Subdomains/crt.txt $url/Subdomains/findomain.txt $url/Subdomains/githubsubdomain.txt $url/Subdomains/waybacksubdomain.txt $url/Subdomains/certspotter.txt $url/Subdomains/jldc.txt $url/Subdomains/anubis.txt $url/Subdomains/Hackertarget.txt $url/Subdomains/otx.txt $url/Subdomains/gobuster.txt  $url/Subdomains/shuffledns.txt | anew $url/Subdomains/final.txt

    # Generate Permutations with dnsGen (Overall Best Way)
    #echo -e "$RED[🔍++++++++🔍] Subdomains Permutations...🔍$RESET"
    #dnsgen $url/Subdomains/final1.txt >> $url/Subdomains/dnsgen_wordlist.txt

    #Find Resolvable Domains with MassDNS
    #echo -e "$RED[🔍++++++++🔍] Find Resolvable Domains...🔍$RESET"
    #massdns -r /root/tools/massdns/lists/resolvers.txt -t A -o S $url/Subdomains/dnsgen_wordlist.txt -w $url/Subdomains/livesub.txt
    #sed 's/A.*//' livesub.txt | sed 's/CN.*//' | sed 's/\..$//' | sort -u >> $url/Subdomains/final.txt

    rm -rf $url/Subdomains/assetfinder.txt $url/Subdomains/amass.txt  $url/Subdomains/sublist3r.txt $url/Subdomains/subfinder.txt $url/Subdomains/crt.txt $url/Subdomains/findomain.txt $url/Subdomains/githubsubdomain.txt $url/Subdomains/waybacksubdomain.txt $url/Subdomains/certspotter.txt $url/Subdomains/jldc.txt $url/Subdomains/anubis.txt $url/Subdomains/Hackertarget.txt $url/Subdomains/otx.txt $url/Subdomains/gobuster.txt  $url/Subdomains/shuffledns.txt 
  
    # jq -r 'keys[]' input.json | grep -v '^"$' > subdomains.txt
    echo -e "$YELLOW[+] Harvesting subdomains with Knockpy ...$RESET"
    knockpy $url

    # Probing for alive domains
    echo -e "$YELLOW[+] Probing for alive domains...$RESET"
    cat $url/Subdomains/final.txt | httprobe -c 50 -p 8080,8081,8089 | tee $url/Subdomains/recon/http.servers
    cat $url/Subdomains/final.txt | httpx -sc -td -title -probe -fhr -location  -mc 200 >> $url/Subdomains/recon/httpxinfo.txt
    httpx -l $url/Subdomains/final.txt -ports 443,80,8080,8000,8888 -threads 200 > $url/Subdomains/recon/alive_subdomain.txt

    #  Extract Params
    echo -e "$YELLOW[+] Harvesting params  with Katana|Gau|waybackurls ...$RESET"
    cat $url/Subdomains/recon/alive_subdomain.txt | katana  | httpx -mc 200 | tee $url/Subdomains/param/katana.txt
    gau --subs $url  >> $url/Subdomains/param/gauparam.txt
    cat $url/Subdomains/recon/alive_subdomain.txt | gau | sort -u  >> $url/Subdomains/param/gauparam.txt
    waybackurls $url  >> $url/Subdomains/param/waybackparam.txt
    cat $url/Subdomains/recon/alive_subdomain.txt | waybackurls | sort -u  >> $url/Subdomains/param/waybackparam.txt

    cat $url/Subdomains/param/katana.txt $url/Subdomains/param/gauparam.txt  | sort -u >> $url/Subdomains/param/finalparam.txt
    cat $url/Subdomains/param/finalparam.txt | uro -o $url/Subdomains/param/filterparam.txt


    # JavaScript file extract 
    echo -e "$YELLOW[+] Harvesting JavaScript File  with Katana|Gau|waybackurls|subjs ...$RESET"
    cat $url/Subdomains/param/filterparam.txt | grep '.js$' > $url/Subdomains/js/jsfiles.txt
    gau --subs $url | grep '.js$' >> $url/Subdomains/js/gaujs.txt
    waybackurls $url | grep '.js$' >> $url/Subdomains/js/waybackjs.txt
    cat $url/Subdomains/recon/alive_subdomain.txt | httpx | subjs >> $url/Subdomains/js/subjs.txt
    cat $url/Subdomains/js/jsfiles.txt $url/Subdomains/js/gaujs.txt $url/Subdomains/js/waybackjs.txt $url/Subdomains/js/subjs.txt  | sort -u >> $url/Subdomains/js/finaljs.txt

    # Extract PDF,DOCS,XLS , \.php|\.asp|\.jsp|\.py|\.rb|\.do 
    echo -e "$YELLOW[+] Harvesting PDF,DOCS,XLS , \.php|\.asp|\.jsp|\.py|\.rb|\.do  ...$RESET"
    grep -oP '^https?://(?:[^/]*/){2}' $url/Subdomains/param/filterparam.txt | sort -u | tee $url/Subdomains/docs/root-dirs.txt
    cat $url/Subdomains/param/filterparam.txt | unfurl keys | sort -u | grep -vE 'filter1|filter2' | tee $url/Subdomains/docs/params.txt
    cat $url/Subdomains/param/filterparam.txt | grep -Ei '\.pdf' | httpx -mc 200 | tee $url/Subdomains/docs/pdfs.txt
    cat $url/Subdomains/param/filterparam.txt | grep -Ei '\.doc' | httpx -mc 200 | tee $url/Subdomains/docs/docs.txt
    cat $url/Subdomains/param/filterparam.txt | grep -Ei '\.xls' | httpx -mc 200 | tee $url/Subdomains/docs/xls.txt
    cat $url/Subdomains/param/filterparam.txt | grep -Ei '\.php|\.asp|\.jsp|\.py|\.rb|\.do' | httpx -mc 200 | tee $url/Subdomains/docs/extensions.txt
    cat $url/Subdomains/param/filterparam.txt | grep -Ei 'login|register|signup|signin|sign-up|sign-in|dashboard' | httpx -mc 200 > $url/Subdomains/docs/auth-endpoints.txt


    #Find OWASP Top 10 Path XSS,SQLi,SSRF,LFI,RCE,SubdomainTakeOver
    echo -e "$YELLOW[+] Harvesting OWASP Top 10 Path (SSRF,LFI,XSS,SSTI,SQLi,RCE,IDOR,SubdomainTakeOver)  ...$RESET"
    cat $url/Subdomains/param/filterparam.txt | gf ssrf | sort -u |anew $url/Subdomains/OWASP/ssrf.txt
    cat $url/Subdomains/param/filterparam.txt | gf lfi | sort -u |anew  $url/Subdomains/OWASP/lfi.txt
    cat $url/Subdomains/param/filterparam.txt | gf xss | uro | grep -v -e "jpg" -e "jpeg" -e "gif" -e "css" -e "tif" -e "tiff" -e "png" | qsreplace -a | httpx -silent | tee  $url/Subdomains/OWASP/xss.txt
    cat $url/Subdomains/param/filterparam.txt | gf ssti | sort -u |anew  $url/Subdomains/OWASP/ssti.txt
    cat $url/Subdomains/param/filterparam.txt | gf sqli | sort -u |anew  $url/Subdomains/OWASP/sqli.txt
    cat $url/Subdomains/param/filterparam.txt | gf rce | sort -u |anew   $url/Subdomains/OWASP/rce.txt
    cat $url/Subdomains/param/filterparam.txt | gf redirect | sort -u |anew $url/Subdomains/OWASP/redirect.txt
    cat $url/Subdomains/param/filterparam.txt | gf idor | sort -u |anew $url/Subdomains/OWASP/idor.txt
    cat $url/Subdomains/recon/alive_subdomain.txt | httpx -path "/cgi-bin/admin.cgi?Command=sysCommand&Cmd=id" -nc -ports 80,443,8080,8443 -mr "uid=" -silent | tee $url/Subdomains/OWASP/cgiRCE.txt
    SubOver -l $url/Subdomains/final.txt -o $url/Subdomains/OWASP/subtakeover.txt
    subjack -w $url/Subdomains/final.txt -t 100 -timeout 30 -ssl -c /usr/share/subjack/fingerprints.json -v 3  >> $url/Subdomains/OWASP/takeovers.txt
    subzy run --targets $url/Subdomains/final.txt --hide_fails   >> $url/Subdomains/OWASP/subtakeover.txt
















    #manually Collect Domains from 
    #--> https://subdomainfinder.c99.nl/   (jq -r '.[].subdomain' example.json | grep -v '^null$' > c99.txt)
    # nuclei -l js.txt -t ~/.local/nuclei-templates/javascript -s critical,high,medium,low (nuclei) 
    # cat final.txt | httpx -sc -td -title -probe -fhr -location  -mc 200
  
