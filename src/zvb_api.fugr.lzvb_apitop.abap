FUNCTION-POOL zvb_api.                      "MESSAGE-ID ..


*TYPES: BEGIN OF ty_buffer_zvbak.
*         INCLUDE TYPE zvbak AS data.
*TYPES:   chngind TYPE cdchngind,
*       END OF ty_buffer_zvbak.

* DATA gt_buffer_zvbak TYPE STANDARD TABLE OF ty_buffer_zvbak.


DATA gt_buffer_zvbak TYPE zvbak_buffer_t.


* INCLUDE LZVB_APID...                       " Local class definition
