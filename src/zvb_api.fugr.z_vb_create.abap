FUNCTION z_vb_create.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IS_ZVBAK) TYPE  ZVBAK
*"  EXPORTING
*"     REFERENCE(ES_ZVBAK) TYPE  ZVBAK
*"     REFERENCE(ET_MESSAGES) TYPE  ZT_MESSAGE
*"----------------------------------------------------------------------
  DATA ls_buffer_zvbak TYPE zvbak_buffer.

  DATA lv_id_max TYPE zid.

  CLEAR es_zvbak.
  CLEAR et_messages.

  ls_buffer_zvbak = CORRESPONDING #( is_zvbak ).

* Ermittlung der ID
  LOOP AT gt_buffer_zvbak INTO ls_buffer_zvbak WHERE chngind = 'I'.
    IF ls_buffer_zvbak-id > lv_id_max.
      lv_id_max = ls_buffer_zvbak-id.
    ENDIF.
  ENDLOOP.
  IF sy-subrc <> 0.
    SELECT FROM zvbak FIELDS MAX( id ) INTO @lv_id_max.
  ENDIF.

  lv_id_max = lv_id_max + 1.

  ls_buffer_zvbak-id = lv_id_max.

* Standard Ableitungen
  GET TIME STAMP FIELD ls_buffer_zvbak-zeitpkt.       "weitere admin daten...

* Aktionscode
  ls_buffer_zvbak-chngind = 'I'.

  INSERT ls_buffer_zvbak INTO TABLE gt_buffer_zvbak.

  es_zvbak = CORRESPONDING #( ls_buffer_zvbak ).

ENDFUNCTION.
