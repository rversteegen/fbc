/* Default linker script, for normal executables */
OUTPUT_FORMAT("coff-go32-exe")
ENTRY(start)
SECTIONS
{
  .text  0x1000+SIZEOF_HEADERS : {
    *(.text)
    *(.text.*)
    *(.gnu.linkonce.t*)
    *(.const*)
    *(.ro*)
    *(.gnu.linkonce.r*)
    etext  =  . ; PROVIDE(_etext = .) ;
    . = ALIGN(0x200);
  }
  .data  ALIGN(0x200) : {
    djgpp_first_ctor = . ;
    *(SORT(.ctors.*))
    *(.ctor)
    djgpp_last_ctor = . ;
    djgpp_first_dtor = . ;
    *(SORT(.dtors.*))
    *(.dtor)
    djgpp_last_dtor = . ;

    ___FB_CTOR_BEGIN__ = . ; __FB_CTOR_BEGIN__ = . ;
    *(.fb_ctors);
    ___FB_CTOR_END__ = . ; __FB_CTOR_END__ = . ;
    ___FB_DTOR_BEGIN__ = . ; __FB_DTOR_BEGIN__ = . ;
    *(.fb_dtors);
    ___FB_DTOR_END__ = . ; __FB_DTOR_END__ = . ;

    *(.data)
    *(.data.*)
    *(.gcc_exc*)
    ___EH_FRAME_BEGIN__ = . ;
    *(.eh_fram*)
    ___EH_FRAME_END__ = . ;
    LONG(0);
    *(.gnu.linkonce.d*)
    edata  =  . ; PROVIDE(_edata = .) ;
    . = ALIGN(0x200);
  }

  .bss  SIZEOF(.data) + ADDR(.data) :
  {
    *(.bss .bss.* .gnu.linkonce.b.*)
    *(COMMON)
     end = . ; PROVIDE(_end = .) ;
     . = ALIGN(0x200);
  }
  /* Stabs debugging sections.  */
  .stab 0 : { *(.stab) }
  .stabstr 0 : { *(.stabstr) }
  /* DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  .debug_info     0 : { *(.debug_info) *(.gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
}
