/* get localized weekday name */

#include "../fb.h"
#ifndef HOST_ANDROID
#include <langinfo.h>
#endif

FBSTRING *fb_DrvIntlGetWeekdayName( int weekday, int short_names )
{
    const char *pszName;
    FBSTRING *result;
    size_t name_len;
#ifdef HOST_ANDROID
    pszName = "<day>";  //FIXME
#else
    nl_item index;

    if( weekday < 1 || weekday > 7 )
        return NULL;

    if( short_names ) {
        index = (nl_item) (ABDAY_1 + weekday - 1);
    } else {
        index = (nl_item) (DAY_1 + weekday - 1);
    }

    FB_LOCK();

    pszName = nl_langinfo( index );
#endif
    if( pszName==NULL ) {
        FB_UNLOCK();
        return NULL;
    }

    name_len = strlen( pszName );

    result = fb_hStrAllocTemp( NULL, name_len );
    if( result!=NULL ) {
        FB_MEMCPY( result->data, pszName, name_len + 1 );
    }

    FB_UNLOCK();

    return result;
}
