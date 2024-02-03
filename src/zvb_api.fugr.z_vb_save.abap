FUNCTION z_vb_save.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"----------------------------------------------------------------------
  LOOP AT gt_buffer_zvbak INTO DATA(ls_buffer_zvbak).
    CASE ls_buffer_zvbak-chngind.
      WHEN 'I'.
        INSERT zvbak FROM ls_buffer_zvbak.
      WHEN 'U'.
        UPDATE zvbak FROM ls_buffer_zvbak.
      WHEN 'D'.
        DELETE zvbak FROM ls_buffer_zvbak.
    ENDCASE.
  ENDLOOP.

  CLEAR gt_buffer_zvbak.

ENDFUNCTION.
