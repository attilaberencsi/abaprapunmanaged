FUNCTION z_vb_read.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_ID) TYPE  ZID
*"  EXPORTING
*"     REFERENCE(ES_ZVBAK) TYPE  ZVBAK
*"     REFERENCE(ET_MESSAGES) TYPE  ZT_MESSAGE
*"----------------------------------------------------------------------
  CLEAR es_zvbak.
  CLEAR et_messages.

  SELECT SINGLE * FROM zvbak WHERE id = @iv_id INTO @es_zvbak.

  READ TABLE gt_buffer_zvbak INTO DATA(ls_buffer_zvbak) WITH KEY id = iv_id.
  IF sy-subrc = 0.
    CASE ls_buffer_zvbak-chngind.
      WHEN 'U'.
        es_zvbak = CORRESPONDING #( ls_buffer_zvbak ).
      WHEN  'D'.
        CLEAR es_zvbak.
      WHEN 'I'.
        es_zvbak = CORRESPONDING #( ls_buffer_zvbak ).
    ENDCASE.
  ENDIF.

  IF es_zvbak IS INITIAL.
    MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '001' WITH iv_id INTO DATA(lv_msg).
    et_messages = VALUE #( ( CORRESPONDING #( syst ) ) ).
  ENDIF.

ENDFUNCTION.
