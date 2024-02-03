CLASS lhc_mysalesorder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE mysalesorder.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE mysalesorder.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE mysalesorder.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK mysalesorder.

    METHODS read FOR READ
      IMPORTING keys FOR READ mysalesorder RESULT result.

ENDCLASS.

CLASS lhc_mysalesorder IMPLEMENTATION.

  METHOD create.

    DATA lt_messages TYPE zt_message.
    DATA ls_zvbak_in TYPE zvbak.
    DATA ls_zvbak_out TYPE zvbak.

    LOOP AT entities INTO DATA(ls_entity).

      ls_zvbak_in = CORRESPONDING #( ls_entity MAPPING FROM ENTITY USING CONTROL ).

      CALL FUNCTION 'Z_VB_CREATE'
        EXPORTING
          is_zvbak    = ls_zvbak_in
        IMPORTING
          es_zvbak    = ls_zvbak_out
          et_messages = lt_messages.

      IF lt_messages IS INITIAL.
        APPEND VALUE #(  %cid = ls_entity-%cid  salesorderid = ls_zvbak_out-id ) TO mapped-mysalesorder.
      ELSE.
        "fill failed return structure for the framework
        APPEND VALUE #(  %cid = ls_entity-%cid salesorderid = ls_zvbak_in-id ) TO failed-mysalesorder.
        "fill reported structure to be displayed on the UI
        APPEND VALUE #( salesorderid = ls_zvbak_in-id
                        %cid = ls_entity-%cid
                        %msg = new_message( id = lt_messages[ 1 ]-msgid
                                            number = lt_messages[ 1 ]-msgno
                                            v1 = lt_messages[ 1 ]-msgv1
                                            v2 = lt_messages[ 1 ]-msgv2
                                            v3 = lt_messages[ 1 ]-msgv3
                                            v4 = lt_messages[ 1 ]-msgv4
                                            severity = CONV #( lt_messages[ 1 ]-msgty ) )
       ) TO reported-mysalesorder.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    DATA lt_messages TYPE zt_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      CALL FUNCTION 'Z_VB_DELETE'
        EXPORTING
          iv_id       = <key>-salesorderid
        IMPORTING
          et_messages = lt_messages.

      IF lt_messages IS INITIAL.
        APPEND VALUE #( salesorderid = <key>-salesorderid ) TO mapped-mysalesorder.
      ELSE.
        "fill failed return structure for the framework
        APPEND VALUE #(  salesorderid = <key>-salesorderid ) TO failed-mysalesorder.
        "fill reported structure to be displayed on the UI
        APPEND VALUE #( salesorderid = <key>-salesorderid
                        %msg = new_message( id = lt_messages[ 1 ]-msgid
                                            number = lt_messages[ 1 ]-msgno
                                            v1 = lt_messages[ 1 ]-msgv1
                                            v2 = lt_messages[ 1 ]-msgv2
                                            v3 = lt_messages[ 1 ]-msgv3
                                            v4 = lt_messages[ 1 ]-msgv4
                                            severity = CONV #( lt_messages[ 1 ]-msgty ) )
       ) TO reported-mysalesorder.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    FIELD-SYMBOLS: <lv_field_old> TYPE any.
    FIELD-SYMBOLS: <lv_field_new> TYPE any.
    FIELD-SYMBOLS <lv_field_behv_flag> TYPE any.

    DATA lr_descr_struc TYPE REF TO data.
    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.
    DATA ls_zvbak TYPE zvbak.
    DATA lt_messages TYPE zt_message.

* Alten Stand lesen (aus Transaktionspuffer) mittels EML. Alternativ mittels API Z_VB_READ.
    READ ENTITIES OF zi_mysalesorder IN LOCAL MODE
    ENTITY mysalesorder
    ALL FIELDS WITH CORRESPONDING #( entities )
    RESULT DATA(lt_mysalesorders).

* Neuen Stand übernehmen
    LOOP AT entities INTO DATA(ls_entity).

      READ TABLE lt_mysalesorders INTO DATA(ls_mysalesorder) WITH KEY %tky = ls_entity-%tky.
      IF sy-subrc = 0.
        CLEAR lr_descr_struc.
        CLEAR lo_structdescr.
        CREATE DATA lr_descr_struc LIKE ls_entity.
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data_ref( p_data_ref = lr_descr_struc ).
        LOOP AT lo_structdescr->components ASSIGNING FIELD-SYMBOL(<lv_component>).
          IF <lv_component>-name <> 'SALESORDERID' AND <lv_component>-name(1) <> '%'.
            ASSIGN COMPONENT <lv_component>-name OF STRUCTURE ls_entity TO <lv_field_new>.
            ASSIGN COMPONENT <lv_component>-name OF STRUCTURE ls_mysalesorder TO <lv_field_old>.
            ASSIGN COMPONENT <lv_component>-name OF STRUCTURE ls_entity-%control TO <lv_field_behv_flag>.
            IF <lv_field_old> IS ASSIGNED AND <lv_field_new> IS ASSIGNED AND <lv_field_behv_flag> = if_abap_behv=>mk-off.
              <lv_field_new> = <lv_field_old>.
            ENDIF.
          ENDIF.
        ENDLOOP.

        ls_zvbak = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).

        CALL FUNCTION 'Z_VB_UPDATE'
          EXPORTING
            is_zvbak    = ls_zvbak
          IMPORTING
            et_messages = lt_messages.
        .

        IF lt_messages IS INITIAL.
          APPEND VALUE #( salesorderid = ls_entity-salesorderid ) TO mapped-mysalesorder.
        ELSE.
          "fill failed return structure for the framework
          APPEND VALUE #(  salesorderid = ls_entity-salesorderid ) TO failed-mysalesorder.
          "fill reported structure to be displayed on the UI
          APPEND VALUE #( salesorderid = ls_entity-salesorderid
                          %msg = new_message( id = lt_messages[ 1 ]-msgid
                                              number = lt_messages[ 1 ]-msgno
                                              v1 = lt_messages[ 1 ]-msgv1
                                              v2 = lt_messages[ 1 ]-msgv2
                                              v3 = lt_messages[ 1 ]-msgv3
                                              v4 = lt_messages[ 1 ]-msgv4
                                              severity = CONV #( lt_messages[ 1 ]-msgty ) )
         ) TO reported-mysalesorder.
        ENDIF.


      ELSE.

*  Fehlerhandling

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD lock.

    DATA lt_messages TYPE zt_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

*     Sperre setzen
      CALL FUNCTION 'Z_VB_LOCK'
        EXPORTING
          iv_id       = <key>-salesorderid
        IMPORTING
          et_messages = lt_messages.
      .
      IF lt_messages IS NOT INITIAL.

        "fill failed return structure for the framework
        APPEND VALUE #(  salesorderid = <key>-salesorderid ) TO failed-mysalesorder.
        "fill reported structure to be displayed on the UI
        APPEND VALUE #( salesorderid = <key>-salesorderid
                        %msg = new_message( id = lt_messages[ 1 ]-msgid
                                            number = lt_messages[ 1 ]-msgno
                                            v1 = lt_messages[ 1 ]-msgv1
                                            v2 = lt_messages[ 1 ]-msgv2
                                            v3 = lt_messages[ 1 ]-msgv3
                                            v4 = lt_messages[ 1 ]-msgv4
                                            severity = CONV #( lt_messages[ 1 ]-msgty ) )
       ) TO reported-mysalesorder.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD read.

    DATA ls_zvbak TYPE zvbak.
    DATA lt_messages TYPE zt_message.

    LOOP AT keys INTO DATA(key).

      CALL FUNCTION 'Z_VB_READ'
        EXPORTING
          iv_id       = key-salesorderid
        IMPORTING
          es_zvbak    = ls_zvbak
          et_messages = lt_messages.

      IF lt_messages IS INITIAL.
        INSERT CORRESPONDING #( ls_zvbak MAPPING TO ENTITY ) INTO TABLE result.
      ELSE.
        APPEND VALUE #( salesorderid = key-salesorderid
                        %fail-cause = if_abap_behv=>cause-not_found
                      ) TO failed-mysalesorder.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_mysalesorder DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS cleanup           REDEFINITION.

ENDCLASS.

CLASS lsc_zi_mysalesorder IMPLEMENTATION.

  METHOD check_before_save.

    DATA lt_buffer_zvbak TYPE zvbak_buffer_t.
    DATA lt_messages TYPE zt_message.

    CALL FUNCTION 'Z_VB_READ_ALL'
      IMPORTING
        et_buffer_zvbak = lt_buffer_zvbak.

    LOOP AT lt_buffer_zvbak INTO DATA(ls_buffer_zvbak).

      CALL FUNCTION 'Z_VB_CHECK'
        EXPORTING
          iv_id       = ls_buffer_zvbak-id
        IMPORTING
          et_messages = lt_messages.

      LOOP AT lt_messages INTO DATA(ls_message).
        APPEND VALUE #( salesorderid = ls_buffer_zvbak-id ) TO failed-mysalesorder.
        reported-mysalesorder = VALUE #( BASE reported-mysalesorder
                                          ( salesorderid = ls_buffer_zvbak-id
                                            %msg = me->new_message( severity = if_abap_behv_message=>severity-error
                                                                    id       = ls_message-msgid
                                                                    number   = ls_message-msgno
                                                                    v1 = ls_message-msgv1
                                                                    v2 = ls_message-msgv2
                                                                    v3 = ls_message-msgv3
                                                                    v4 = ls_message-msgv4 )
                                           ) ).
      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.

  METHOD finalize.

    DATA lt_buffer_zvbak TYPE zvbak_buffer_t.
    DATA lt_messages TYPE zt_message.

    CALL FUNCTION 'Z_VB_READ_ALL'
      IMPORTING
        et_buffer_zvbak = lt_buffer_zvbak.

    LOOP AT lt_buffer_zvbak INTO DATA(ls_buffer_zvbak).

      CALL FUNCTION 'Z_VB_ENRICH'
        EXPORTING
          iv_id       = ls_buffer_zvbak-id
        IMPORTING
          et_messages = lt_messages.

      IF lt_messages IS NOT INITIAL.
        APPEND VALUE #(  salesorderid = ls_buffer_zvbak-id ) TO failed-mysalesorder.
        APPEND VALUE #( salesorderid = ls_buffer_zvbak-id
                        %msg = new_message( id = lt_messages[ 1 ]-msgid
                                            number = lt_messages[ 1 ]-msgno
                                            v1 = lt_messages[ 1 ]-msgv1
                                            v2 = lt_messages[ 1 ]-msgv2
                                            v3 = lt_messages[ 1 ]-msgv3
                                            v4 = lt_messages[ 1 ]-msgv4
                                            severity = CONV #( lt_messages[ 1 ]-msgty ) )
       ) TO reported-mysalesorder.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD save.

    CALL FUNCTION 'Z_VB_SAVE'.

  ENDMETHOD.

  METHOD cleanup.

    CALL FUNCTION 'Z_VB_INITIALIZE'.

  ENDMETHOD.

ENDCLASS.
