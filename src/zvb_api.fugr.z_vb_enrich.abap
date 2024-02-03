FUNCTION z_vb_enrich.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_ID) TYPE  ZID
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  ZT_MESSAGE
*"----------------------------------------------------------------------
  DATA lv_status TYPE zstatus.
  DATA lr_descr_struc TYPE REF TO data.
  DATA lo_structdescr TYPE REF TO cl_abap_structdescr.
  FIELD-SYMBOLS: <lv_field> TYPE any.

  IF iv_id IS INITIAL.
    MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '002' INTO DATA(lv_msg).
    et_messages = VALUE #( ( CORRESPONDING #( syst ) ) ).
    RETURN.
  ENDIF.

  LOOP AT gt_buffer_zvbak ASSIGNING FIELD-SYMBOL(<lfs_buffer_zvbak>) WHERE id = iv_id.

    CHECK <lfs_buffer_zvbak>-chngind = 'I' OR <lfs_buffer_zvbak>-chngind = 'U'.

* Status 1: alle Felder gepflegt, Status 0: Pflege unvollständig
    lv_status = 1.
    CLEAR lr_descr_struc.
    CLEAR lo_structdescr.
    CREATE DATA lr_descr_struc LIKE <lfs_buffer_zvbak>.
    lo_structdescr ?= cl_abap_structdescr=>describe_by_data_ref( p_data_ref = lr_descr_struc ).
    LOOP AT lo_structdescr->components ASSIGNING FIELD-SYMBOL(<lv_component>).
      IF <lv_component>-name <> 'MANDT' AND <lv_component>-name <> 'STATUS'.
        ASSIGN COMPONENT <lv_component>-name OF STRUCTURE <lfs_buffer_zvbak> TO <lv_field>.
        IF <lv_field> IS INITIAL.
          lv_status = 0.
        ENDIF.
      ENDIF.
    ENDLOOP.

    <lfs_buffer_zvbak>-status = lv_status.

  ENDLOOP.

ENDFUNCTION.
