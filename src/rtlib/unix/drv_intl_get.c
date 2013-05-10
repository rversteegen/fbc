/* get i18n data */

#include "../fb.h"
#ifndef HOST_ANDROID
#include <langinfo.h>
#endif

const char *fb_DrvIntlGet( eFbIntlIndex Index )
{
	switch( Index ) {
	case eFIL_DateDivider:
		return "/";
	case eFIL_TimeDivider:
		return ":";
#ifdef HOST_ANDROID
	/* Android has very limited locale support in the NDK -- apparently only the C locale is supported.
	   Locale information is available from Java; also the CrystaX alternative NDK has locale support */
	case eFIL_NumDecimalPoint:
		return ".";
	case eFIL_NumThousandsSeparator:
		return ",";
#else
	case eFIL_NumDecimalPoint:
		return nl_langinfo( RADIXCHAR );
	case eFIL_NumThousandsSeparator:
		return nl_langinfo( THOUSEP );
#endif
	}
	return NULL;
}
