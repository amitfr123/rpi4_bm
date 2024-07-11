ENTRY(_start)

SECTIONS
{
    . = 0x80000;
    .wow : {
        KEEP(*(.wow))
    }
    .text :
    {
        KEEP(*(.text.boot))
        *(.text .text.*)
    }
    . = ALIGN(4096); /* align to page size */

    .rodata :
    {
        *(.rodata)
    }
    . = ALIGN(4096); /* align to page size */

    __data_start = .;
    .data :
    {
        *(.data)
    }
    . = ALIGN(4096); /* align to page size */
    __data_end = .;

    __bss_start = .;
    .bss :
    {
        bss = .;
        *(.bss)
    }
    . = ALIGN(4096); /* align to page size */
    __bss_end = .;
    __bss_size = __bss_end - __bss_start;
    __end = .;
}