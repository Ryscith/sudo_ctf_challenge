# Sudo CTF Challenge
**Challenge Name:** Sudotdot\
**Prompt:** You've just landed a job at ../../best/software/inc. Congratulations!\
However, now that you're working here, you found out their security policies are\
quite oppressive. They're enforced using this old version of sudo. I wonder if\
you can find a way around it?

## Description of Vulnerability
This challenge takes advantage of CVE-1999-0958, which allows the user to bypass
the exclusion list on sudo by prepending ./ or ../ to the name of the program
they want to run.

## References
YouTube tutorial explaining the vulnerability: \
https://www.youtube.com/watch?v=R7c7vae_-gM \

CVE: \
https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-1999-0958
