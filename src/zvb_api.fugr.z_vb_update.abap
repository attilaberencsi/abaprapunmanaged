FUNCTION z_vb_update.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IS_ZVBAK) TYPE  ZVBAK
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  ZT_MESSAGE
*"----------------------------------------------------------------------

  DATA ls_buffer_zvbak TYPE zvbak_buffer.

  CLEAR et_messages.

  IF is_zvbak-id IS INITIAL.
    MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '002' INTO DATA(lv_msg).
    et_messages = VALUE #( ( CORRESPONDING #( syst ) ) ).
    RETURN.
  ENDIF.

  READ TABLE gt_buffer_zvbak ASSIGNING FIELD-SYMBOL(<lfs_buffer_zvbak>) WITH KEY id = is_zvbak-id
                                                                                 chngind = 'U'.
  IF <lfs_buffer_zvbak> IS ASSIGNED.
    <lfs_buffer_zvbak> = is_zvbak.
    <lfs_buffer_zvbak>-chngind = 'U'.
    GET TIME STAMP FIELD <lfs_buffer_zvbak>-zeitpkt.       "weitere admin daten...
  ELSE.
    ls_buffer_zvbak = CORRESPONDING #( is_zvbak ).
    GET TIME STAMP FIELD ls_buffer_zvbak-zeitpkt.
    ls_buffer_zvbak-chngind = 'U'.
    APPEND ls_buffer_zvbak TO gt_buffer_zvbak.
  ENDIF.

ENDFUNCTION.
