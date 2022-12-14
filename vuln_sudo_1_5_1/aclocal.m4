dnl Local m4 macors for autoconf (used by sudo)
snl XXX - should cache values in all cases!!!
dnl
dnl checks for programs

dnl
dnl check for sendmail
dnl
AC_DEFUN(SUDO_PROG_SENDMAIL, [AC_MSG_CHECKING(for sendmail)
if test -f "/usr/sbin/sendmail"; then
    AC_MSG_RESULT(/usr/sbin/sendmail)
    AC_DEFINE(_CONFIG_PATH_SENDMAIL, "/usr/sbin/sendmail")
elif test -f "/usr/lib/sendmail"; then
    AC_MSG_RESULT(/usr/lib/sendmail)
    AC_DEFINE(_CONFIG_PATH_SENDMAIL, "/usr/lib/sendmail")
elif test -f "/usr/etc/sendmail"; then
    AC_MSG_RESULT(/usr/etc/sendmail)
    AC_DEFINE(_CONFIG_PATH_SENDMAIL, "/usr/etc/sendmail")
elif test -f "/usr/ucblib/sendmail"; then
    AC_MSG_RESULT(/usr/ucblib/sendmail)
    AC_DEFINE(_CONFIG_PATH_SENDMAIL, "/usr/ucblib/sendmail")
elif test -f "/usr/local/lib/sendmail"; then
    AC_MSG_RESULT(/usr/local/lib/sendmail)
    AC_DEFINE(_CONFIG_PATH_SENDMAIL, "/usr/local/lib/sendmail")
elif test -f "/usr/local/bin/sendmail"; then
    AC_MSG_RESULT(/usr/local/bin/sendmail)
    AC_DEFINE(_CONFIG_PATH_SENDMAIL, "/usr/local/bin/sendmail")
else
    AC_MSG_RESULT(not found)
fi
])dnl

dnl
dnl check for vi
dnl
AC_DEFUN(SUDO_PROG_VI, [AC_MSG_CHECKING(for vi)
if test -f "/usr/bin/vi"; then
    AC_MSG_RESULT(/usr/bin/vi)
    AC_DEFINE(_CONFIG_PATH_VI, "/usr/bin/vi")
elif test -f "/usr/ucb/vi"; then
    AC_MSG_RESULT(/usr/ucb/vi)
    AC_DEFINE(_CONFIG_PATH_VI, "/usr/ucb/vi")
elif test -f "/usr/bsd/vi"; then
    AC_MSG_RESULT(/usr/bsd/vi)
    AC_DEFINE(_CONFIG_PATH_VI, "/usr/bsd/vi")
elif test -f "/bin/vi"; then
    AC_MSG_RESULT(/bin/vi)
    AC_DEFINE(_CONFIG_PATH_VI, "/bin/vi")
elif test -f "/usr/local/bin/vi"; then
    AC_MSG_RESULT(/usr/local/bin/vi)
    AC_DEFINE(_CONFIG_PATH_VI, "/usr/local/bin/vi")
else
    AC_MSG_RESULT(not found)
fi
])dnl

dnl
dnl check for pwd
dnl
AC_DEFUN(SUDO_PROG_PWD, [AC_MSG_CHECKING(for pwd)
if test -f "/usr/bin/pwd"; then
    AC_MSG_RESULT(/usr/bin/pwd)
    AC_DEFINE(_CONFIG_PATH_PWD, "/usr/bin/pwd")
elif test -f "/bin/pwd"; then
    AC_MSG_RESULT(/bin/pwd)
    AC_DEFINE(_CONFIG_PATH_PWD, "/bin/pwd")
elif test -f "/usr/ucb/pwd"; then
    AC_MSG_RESULT(/usr/ucb/pwd)
    AC_DEFINE(_CONFIG_PATH_PWD, "/usr/ucb/pwd")
elif test -f "/usr/sbin/pwd"; then
    AC_MSG_RESULT(/usr/sbin/pwd)
    AC_DEFINE(_CONFIG_PATH_PWD, "/usr/sbin/pwd")
else
    AC_MSG_RESULT(not found)
fi
])dnl

dnl
dnl check for mv
dnl
AC_DEFUN(SUDO_PROG_MV, [AC_MSG_CHECKING(for mv)
if test -f "/usr/bin/mv"; then
    AC_MSG_RESULT(/usr/bin/mv)
    AC_DEFINE(_CONFIG_PATH_MV, "/usr/bin/mv")
elif test -f "/bin/mv"; then
    AC_MSG_RESULT(/bin/mv)
    AC_DEFINE(_CONFIG_PATH_MV, "/bin/mv")
elif test -f "/usr/ucb/mv"; then
    AC_MSG_RESULT(/usr/ucb/mv)
    AC_DEFINE(_CONFIG_PATH_MV, "/usr/ucb/mv")
elif test -f "/usr/sbin/mv"; then
    AC_MSG_RESULT(/usr/sbin/mv)
    AC_DEFINE(_CONFIG_PATH_MV, "/usr/sbin/mv")
else
    AC_MSG_RESULT(not found)
fi
])dnl

dnl
dnl check for bourne shell
dnl
AC_DEFUN(SUDO_PROG_BSHELL, [AC_MSG_CHECKING(for bourne shell)
if test -f "/bin/sh"; then
    AC_MSG_RESULT(/bin/sh)
    AC_DEFINE(_CONFIG_PATH_BSHELL, "/bin/sh")
elif test -f "/usr/bin/sh"; then
    AC_MSG_RESULT(/usr/bin/sh)
    AC_DEFINE(_CONFIG_PATH_BSHELL, "/usr/bin/sh")
elif test -f "/sbin/sh"; then
    AC_MSG_RESULT(/sbin/sh)
    AC_DEFINE(_CONFIG_PATH_BSHELL, "/sbin/sh")
elif test -f "/sbin/sh"; then
    AC_MSG_RESULT(/usr/sbin/sh)
    AC_DEFINE(_CONFIG_PATH_BSHELL, "/usr/sbin/sh")
else
    AC_MSG_RESULT(not found)
fi
])dnl

dnl
dnl Where the log file goes, use /var/log if it exists, else /{var,usr}/adm
dnl
AC_DEFUN(SUDO_LOGFILE, [AC_MSG_CHECKING(for log file location)
if test -d "/var/log"; then
    AC_MSG_RESULT(/var/log/sudo.log)
    AC_DEFINE(_CONFIG_PATH_LOGFILE, "/var/log/sudo.log")
elif test -d "/var/adm"; then
    AC_MSG_RESULT(/var/adm/sudo.log)
    AC_DEFINE(_CONFIG_PATH_LOGFILE, "/var/adm/sudo.log")
elif test -d "/usr/adm"; then
    AC_MSG_RESULT(/usr/adm/sudo.log)
    AC_DEFINE(_CONFIG_PATH_LOGFILE, "/usr/adm/sudo.log")
else
    AC_MSG_RESULT(unknown, you will have to set _PATH_SUDO_LOGFILE by hand)
fi
])dnl

dnl
dnl Where the log file goes, use /var/log if it exists, else /{var,usr}/adm
dnl
AC_DEFUN(SUDO_TIMEDIR, [AC_MSG_CHECKING(for timestamp file location)
if test -d "/var/run"; then
    AC_MSG_RESULT(/var/run/sudo)
    AC_DEFINE(_CONFIG_PATH_TIMEDIR, "/var/run/sudo")
elif test -d "/tmp"; then
    AC_MSG_RESULT(/tmp/.odus)
    AC_DEFINE(_CONFIG_PATH_TIMEDIR, "/tmp/.odus")
else
    AC_MSG_RESULT(unknown, you will have to set _PATH_SUDO_TIMEDIR by hand)
fi
])dnl

dnl
dnl check for shadow passwords
dnl NOTE: not verbose
dnl
AC_DEFUN(SUDO_CHECK_SHADOW_GENERIC, [
if test -z "$SHADOW_TYPE" -a -d /tcb/files/auth; then
    AC_CHECK_FUNC(getprpwuid, SHADOW_TYPE="SPW_SECUREWARE")
fi
if test -z "$SHADOW_TYPE" -a -s /etc/shadow; then
    AC_CHECK_FUNC(getspnam, SHADOW_TYPE="SPW_SVR4")
fi
if test -z "$SHADOW_TYPE" -a -s /etc/master.passwd; then
    SHADOW_TYPE="SPW_BSD"
fi
if test -z "$SHADOW_TYPE"; then
    SHADOW_TYPE="SPW_NONE"
    $2
else
    $1
fi
AC_DEFINE_UNQUOTED(SHADOW_TYPE, $SHADOW_TYPE)
])

AC_DEFUN(SUDO_CHECK_SHADOW_SUNOS4, [AC_MSG_CHECKING(for shadow passwords)
if test -s /etc/security/passwd.adjunct; then
    AC_MSG_RESULT(yes)
    [$1]
else
    AC_MSG_RESULT(no)
    [$2]
fi
])

AC_DEFUN(SUDO_CHECK_SHADOW_ULTRIX4, [AC_MSG_CHECKING(for shadow passwords)
if test -s /etc/auth.pag; then
    AC_MSG_RESULT(yes)
    [$1]
else
    AC_MSG_RESULT(no)
    [$2]
fi
])

AC_DEFUN(SUDO_CHECK_SHADOW_BSD, [AC_MSG_CHECKING(for shadow passwords)
if test -s /etc/master.passwd; then
    AC_MSG_RESULT(yes)
    [$1]
else
    AC_MSG_RESULT(no)
    [$2]
fi
])

AC_DEFUN(SUDO_CHECK_SHADOW_HPUX9, [AC_MSG_CHECKING(for shadow passwords)
if test -s /.secure/etc/passwd; then
    AC_MSG_RESULT(yes)
    [$1]
else
    AC_MSG_RESULT(no)
    [$2]
fi
])

AC_DEFUN(SUDO_CHECK_SHADOW_SVR4, [AC_MSG_CHECKING(for shadow passwords)
if test -s /etc/shadow; then
    AC_MSG_RESULT(yes)
    [$1]
else
    AC_MSG_RESULT(no)
    [$2]
fi
])

AC_DEFUN(SUDO_CHECK_SHADOW_SECUREWARE, [AC_MSG_CHECKING(for shadow passwords)
if test -d /tcb/files/auth; then
    AC_MSG_RESULT(yes)
    [$1]
else
    AC_MSG_RESULT(no)
    [$2]
fi
])

AC_DEFUN(SUDO_CHECK_SHADOW_DUNIX, [AC_MSG_CHECKING(for shadow passwords)
if test "`. /etc/rc.config ; echo $SECURITY`" = "ENHANCED"; then
    AC_MSG_RESULT(yes)
    [$1]
else
    AC_MSG_RESULT(no)
    [$2]
fi
])

dnl
dnl
dnl check for fullly working void
dnl
AC_DEFUN(SUDO_FULL_VOID, [AC_MSG_CHECKING(for full void implementation)
AC_TRY_COMPILE(, [void *foo;
foo = (void *)0; (void *)"test";], AC_DEFINE(VOID, void)
AC_MSG_RESULT(yes), AC_DEFINE(VOID, char)
AC_MSG_RESULT(no))])

dnl
dnl SUDO_CHECK_TYPE(TYPE, DEFAULT)
dnl XXX - should require the check for unistd.h...
dnl
AC_DEFUN(SUDO_CHECK_TYPE,
[AC_REQUIRE([AC_HEADER_STDC])dnl
AC_MSG_CHECKING(for $1)
AC_CACHE_VAL(sudo_cv_type_$1,
[AC_EGREP_CPP($1, [#include <sys/types.h>
#if STDC_HEADERS
#include <stdlib.h>
#endif
#if HAVE_UNISTD_H
#include <unistd.h>
#endif], sudo_cv_type_$1=yes, sudo_cv_type_$1=no)])dnl
AC_MSG_RESULT($sudo_cv_type_$1)
if test $sudo_cv_type_$1 = no; then
  AC_DEFINE($1, $2)
fi
])

dnl
dnl Check for size_t declation
dnl
AC_DEFUN(SUDO_TYPE_SIZE_T,
[SUDO_CHECK_TYPE(size_t, int)])

dnl
dnl Check for ssize_t declation
dnl
AC_DEFUN(SUDO_TYPE_SSIZE_T,
[SUDO_CHECK_TYPE(ssize_t, int)])

dnl
dnl check for POSIX utime() using struct utimbuf
dnl
AC_DEFUN(SUDO_FUNC_UTIME_POSIX,
[AC_MSG_CHECKING(for POSIX utime)
AC_CACHE_VAL(sudo_cv_func_utime_posix,
[rm -f conftestdata; > conftestdata
AC_TRY_RUN([#include <sys/types.h>
#include <sys/time.h>
#include <utime.h>
main() {
struct utimbuf ut;
ut.actime = ut.modtime = time(0);
utime("conftestdata", &ut);
exit(0);
}], sudo_cv_func_utime_posix=yes, sudo_cv_func_utime_posix=no,
  sudo_cv_func_utime_posix=no)
rm -f core core.* *.core])dnl
AC_MSG_RESULT($sudo_cv_func_utime_posix)
if test $sudo_cv_func_utime_posix = yes; then
  AC_DEFINE(HAVE_UTIME_POSIX)
fi
])

dnl
dnl check for sa_len field in struct sockaddr
dnl
AC_DEFUN(SUDO_SOCK_SA_LEN,
[AC_MSG_CHECKING(for sa_len field in struct sockaddr)
AC_CACHE_VAL(sudo_cv_sock_sa_len,
[AC_TRY_RUN([#include <sys/types.h>
#include <sys/socket.h>
main() {
struct sockaddr s;
s.sa_len = 0;
exit(0);
}], sudo_cv_sock_sa_len=yes, sudo_cv_sock_sa_len=no,
  sudo_cv_sock_sa_len=no)
rm -f core core.* *.core])dnl
AC_MSG_RESULT($sudo_cv_sock_sa_len)
if test $sudo_cv_sock_sa_len = yes; then
  AC_DEFINE(HAVE_SA_LEN)
fi
])

dnl
dnl check for max length of uid_t in string representation.
dnl if MAXUID exists there is no real way to see if uid_t is
dnl signed or not so we add one on the off chance that it is.
dnl
AC_DEFUN(SUDO_UID_T_LEN,
[AC_REQUIRE([AC_TYPE_UID_T])
AC_MSG_CHECKING(max length of uid_t)
AC_CACHE_VAL(sudo_cv_uid_t_len,
[rm -f conftestdata
AC_TRY_RUN(
[#include <stdio.h>
#include <pwd.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/param.h>
main() {
  FILE *f;
  char b[BUFSIZ];
#ifdef UID_MAX
  uid_t u = UID_MAX;
#else
# ifdef MAXUID
  uid_t u = MAXUID;
# else
  uid_t u = (uid_t) -1;
# endif
#endif

  if ((f = fopen("conftestdata", "w")) == NULL)
    exit(1);

  (void) sprintf(b, "%u", u);
  (void) fprintf(f, "%d\n", strlen(b));
  (void) fclose(f);
  exit(0);
}], sudo_cv_uid_t_len=`cat conftestdata`, sudo_cv_uid_t_len=10)
])
rm -f conftestdata
AC_MSG_RESULT($sudo_cv_uid_t_len)
AC_DEFINE_UNQUOTED(MAX_UID_T_LEN, $sudo_cv_uid_t_len)
])
