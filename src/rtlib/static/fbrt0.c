/* FB runtime initialization and cleanup */

#include "../fb.h"

/* note: they must be static, or shared libraries in Linux would reuse the 
		 same function */

#if defined(HOST_ANDROID) || defined(HOST_DARWIN)
/* Why isn't this method used on all platforms? */
/* Have to set the constructor priority high so that it runs before module level code.
   FIXME: On Android some destructor seems to be running before fb_hDoExit and ending the program */
static void fb_hDoInit( void ) __attribute__((constructor(101)));
static void fb_hDoExit( void ) __attribute__((destructor(101)));
#endif

/*:::::*/
static void fb_hDoInit( void )
{
	/* the last to be defined, the first that will be called */
	fb_hRtInit( );
}

/*:::::*/
static void fb_hDoExit( void )
{
	/* the last to be defined, the last that will be called */

	fb_hRtExit( );
}

/* This puts the init/exit global ctor/dtor for the rtlib in the sorted ctors/dtors
   section.  A named section of .?tors.65435 = Priority(100) */

#if !defined(HOST_ANDROID) && !defined(HOST_DARWIN)

static void * priorityhDoInit __attribute__((section(".ctors.65435"), used)) = fb_hDoInit;
static void * priorityhDoExit __attribute__((section(".dtors.65435"), used)) = fb_hDoExit;

#endif
