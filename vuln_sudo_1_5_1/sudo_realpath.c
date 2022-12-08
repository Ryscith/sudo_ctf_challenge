/*
 *  CU sudo version 1.3.1
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 1, or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Please send bugs, changes, problems to sudo-bugs@cs.colorado.edu
 *
 *******************************************************************
 *
 *  This module contains sudo_realpath(3), a customized version of
 *  realpath(3).  It is necesary to do the final chdir(2) as the
 *  uid of the invoking user.
 *
 *  sudo_realpath(3) takes a path to qualify and a pointer to a string
 *  as a copyout parameter.  This string should be of size MAXPATHLEN.
 *
 *  Todd C. Miller (millert@colorado.edu) Fri Jun  3 18:32:19 MDT 1994
 */

#ifndef lint
static char rcsid[] = "$Id$";
#endif /* lint */

#include "config.h"

#include <stdio.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif /* HAVE_UNISTD_H */
#ifdef HAVE_STRING_H
#include <string.h>
#endif /* HAVE_STRING_H */
#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif /* HAVE_STRINGS_H */
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <netinet/in.h>

#include "sudo.h"
#include "options.h"

#ifndef STDC_HEADERS
extern char *strcpy	__P((char *, const char *));
extern ssize_t readlink	__P((const char *, char *, size_t));
extern int lstat	__P((const char *, struct stat *));
#endif /* !STDC_HEADERS */


/*
 * Posix versions for those without
 */
#ifndef _S_IFMT
#define _S_IFMT		S_IFMT
#endif /* _S_IFMT */
#ifndef _S_IFLNK
#define _S_IFLNK	S_IFLNK
#endif /* _S_IFLNK */


/*
 * Prototypes
 */
static void realpath_restore	__P((char *));


/******************************************************************
 *
 *  sudo_goodpath()
 *
 *  this function takes a path and makes sure it describes a a file
 *  that is a normal file and executable by root.
 */

char * sudo_goodpath(path)
    const char * path;
{
    struct stat statbuf;		/* for stat(2) */
    int err;				/* if stat(2) got an error */

    /* check for brain damage */
    if (path == NULL || path[0] == '\0')
	return(NULL);

    /* we need to be root for the stat */
    set_perms(PERM_ROOT);

    err = stat(path, &statbuf);

    /* discard root perms */
    set_perms(PERM_USER);

    /* make sure path describes an executable regular file */
    if (!err && S_ISREG(statbuf.st_mode) &&(statbuf.st_mode & 0000111))
	return((char *)path);
    else
	return(NULL);
}



#ifdef USE_REALPATH
/******************************************************************
 *
 *  sudo_realpath()
 *
 *  this function takes a path and makes it fully qualified and resolves
 *  all symbolic links, returning the fully qualfied path.
 */

char * sudo_realpath(old, new)
    const char * old;
          char * new;
{
    char buf[MAXPATHLEN+1];			/* generic path buffer */
    struct stat statbuf;			/* for lstat() */
    char * temp;				/* temporary ptr */
    int len;					/* length parameter */
    int err;					/* did we get an error? */

    /* check for brain damage */
    if (old == NULL || old[0] == '\0')
	return(NULL);

    new[MAXPATHLEN] = '\0';
    (void) strncpy(new, old, MAXPATHLEN);

    /* we need to be root for this section */
    set_perms(PERM_ROOT);

    /*
     * Resolve the last component of the path if it is a link
     * until it is a non-link.
     */
    errno = 0;
    while (!lstat(new, &statbuf) && (statbuf.st_mode & _S_IFMT) == _S_IFLNK) {
	/* it's a link */

	if ((len = readlink(new, buf, sizeof(buf))) <= 0) {
	    realpath_restore(cwd);
	    return(NULL);
	}
	buf[len] = '\0';

	/*
	 * If the link is absolute, copy it in, else remove the last
	 * component in new and append the link unless the sum is too long.
	 */
	if (buf[0] == '/') {
	    (void) strcpy(new, buf);
	} else {
	    if ((temp = strrchr(new, '/')))
		*(++temp) = '\0';

	    if (strlen(new) + strlen(buf) >= MAXPATHLEN ) {
		errno = ENAMETOOLONG;
		realpath_restore(cwd);
		return(NULL);
	    }

	    (void) strcat(new, buf);
	}
    }

    /* did an lstat() fail? */
    if (errno) {
	realpath_restore(cwd);
	return(NULL);
    }

    /*
     * separate the last component from the rest of the path
     * so we can do a getcwd() safely.
     */
    if (!(temp = strrchr(new, '/'))) {
	/* this should not happen */
	errno = ENOTDIR;
	realpath_restore(cwd);
	return(NULL);
    }

    (void) strcpy(buf, ++temp);
    *temp = '\0';

    /*
     * chdir() to new and go a getcwd() to find real path then
     * append buf * (last component of the path) and return.
     */
    if (chdir(new)) {
	realpath_restore(cwd);
	return(NULL);
    }

    if (!(getcwd(new, MAXPATHLEN))) {
	realpath_restore(cwd);
	return(NULL);
    }

    /* append "/" and buf to new but watch for double '/' */
    len = strlen(new);
    if (len) {
	temp = new + len - 1;
	if (*temp != '/') {
	    *(++temp) = '/';
	    *(++temp) = '\0';
	}

    }
    (void) strcat(new, buf);

    realpath_restore(cwd);
    return(new);
}



/******************************************************************
 *
 *  realpath_ret()
 *
 *  this function cd's to cwd, closes it, and returns path.
 */

static void realpath_restore(cwd)
    char * cwd;
{
    /* relinquish root privs and chdir to where we started... */
    set_perms(PERM_USER);
    if (chdir(cwd)) {
	(void) fprintf(stderr,
		       "Error: cannot change dir back to %s, sudo aborting!\n",
		       cwd);
	exit(1);
    }
}
#endif /* USE_REALPATH */
