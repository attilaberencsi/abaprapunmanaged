FUNCTION z_vb_delete.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_ID) TYPE  ZID
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  ZT_MESSAGE
*"----------------------------------------------------------------------
  CLEAR et_messages.

  DATA lt_zvbak_db TYPE TABLE OF zvbak.

  SELECT id FROM zvbak WHERE id = @iv_id INTO CORRESPONDING FIELDS OF TABLE @lt_zvbak_db.

  IF lt_zvbak_db IS INITIAL.
    MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '001' INTO DATA(lv_msg).
    et_messages = VALUE #( ( CORRESPONDING #( syst ) ) ).
    RETURN.
  ELSE.
    READ TABLE gt_buffer_zvbak ASSIGNING FIELD-SYMBOL(<lfs_buffer_zvbak>) WITH KEY id = iv_id.
    IF <lfs_buffer_zvbak> IS ASSIGNED.
      <lfs_buffer_zvbak>-chngind = 'D'.
    ELSE.
      APPEND INITIAL LINE TO gt_buffer_zvbak ASSIGNING <lfs_buffer_zvbak>.
      <lfs_buffer_zvbak>-id = iv_id.
      <lfs_buffer_zvbak>-chngind = 'D'.
    ENDIF.
  ENDIF.

ENDFUNCTION.
