FUNCTION z_vb_check.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_ID) TYPE  ZID
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  ZT_MESSAGE
*"----------------------------------------------------------------------
  LOOP AT gt_buffer_zvbak INTO DATA(ls_buffer_zvbak) where id = iv_id.

    CHECK ls_buffer_zvbak-chngind = 'I' OR ls_buffer_zvbak-chngind = 'U'.

* Nettowert darf nicht negativ sein
    IF ls_buffer_zvbak-netwr < 0.
      MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '005' INTO DATA(lv_msg).
      DATA(ls_message) = CORRESPONDING symsg( syst ).
      et_messages = VALUE #( BASE et_messages ( ls_message ) ).
    ENDIF.

* Angabe eines Nettowert ohne Währung ist nicht zulässig
    IF ls_buffer_zvbak-netwr <> 0 AND ls_buffer_zvbak-waerk IS INITIAL.
      MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '006' INTO lv_msg.
      ls_message = CORRESPONDING #( syst ).
      et_messages = VALUE #( BASE et_messages ( ls_message ) ).
    ENDIF.

  ENDLOOP.

ENDFUNCTION.
