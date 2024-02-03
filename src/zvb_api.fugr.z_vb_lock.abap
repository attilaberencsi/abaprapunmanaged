FUNCTION z_vb_lock.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_ID) TYPE  ZID
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  ZT_MESSAGE
*"----------------------------------------------------------------------
* Bei Verwendung der Lock API:
*  "Instantiate lock object
*  TRY.
*      DATA(lo_lock) = cl_abap_lock_object_factory=>get_instance( iv_name = 'EZ_ZVBAK' ).
*
*      "enqueue instance
*      lo_lock->enqueue(
*          it_parameter  = VALUE #( (  name = 'ID' value = REF #( iv_id ) ) )
*      ).
*
*      "lock error
*    CATCH cx_abap_lock_failure INTO DATA(lr_exp).
*      RAISE SHORTDUMP lr_exp.
*
*      "if foreign lock exists
*    CATCH cx_abap_foreign_lock INTO DATA(lx_foreign_lock).
*      MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '003' INTO DATA(lv_msg) WITH iv_id sy-uname.
*      et_messages = VALUE #( ( CORRESPONDING #( syst ) ) ).
*
*  ENDTRY.


  CLEAR et_messages.

  CALL FUNCTION 'ENQUEUE_EZ_ZVBAK'
    EXPORTING
*     mode_zvbak     = 'E'
*     mandt          = SY-MANDT
      id             = iv_id
*     x_id           = space
*     _scope         = '2'
*     _wait          = space
*     _collect       = ' '
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc = 0.
    RETURN.
  ELSEIF sy-subrc = 1.
    MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '003' INTO DATA(lv_msg) WITH iv_id sy-uname.
    et_messages = VALUE #( ( CORRESPONDING #( syst ) ) ).
  ELSE.
    MESSAGE ID 'ZVB_MESSAGES' TYPE 'E' NUMBER '004' INTO lv_msg.
    et_messages = VALUE #( ( CORRESPONDING #( syst ) ) ).
  ENDIF.

ENDFUNCTION.
