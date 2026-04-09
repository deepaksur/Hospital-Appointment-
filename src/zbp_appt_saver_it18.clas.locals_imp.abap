CLASS lsc_ZCIT_APPT_HI_IT18 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
    METHODS cleanup_finalize  REDEFINITION.
ENDCLASS.

CLASS lsc_ZCIT_APPT_HI_IT18 IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA(lo_util) = zcl_appt_util_it18=>get_instance( ).
    lo_util->get_hdr_value(
      IMPORTING ex_appt_hdr = DATA(ls_appt_hdr) ).
    lo_util->get_itm_value(
      IMPORTING ex_appt_itm = DATA(ls_appt_itm) ).
    lo_util->get_hdr_t_deletion(
      IMPORTING ex_appt_docs = DATA(lt_appt_headers) ).
    lo_util->get_itm_t_deletion(
      IMPORTING ex_appt_info = DATA(lt_appt_items) ).
    lo_util->get_deletion_flags(
      IMPORTING ex_appt_hdr_del = DATA(lv_appt_hdr_del) ).

    " 1. Save / Update Header
    IF ls_appt_hdr IS NOT INITIAL.
      MODIFY zcit_appt_h_it18 FROM @ls_appt_hdr.
    ENDIF.

    " 2. Save / Update Item (Slot)
    IF ls_appt_itm IS NOT INITIAL.
      MODIFY zcit_appt_i_it18 FROM @ls_appt_itm.
    ENDIF.

    " 3. Handle Deletions
    IF lv_appt_hdr_del = abap_true.
      " Delete header + all slots for the appointment
      LOOP AT lt_appt_headers INTO DATA(ls_del_hdr).
        DELETE FROM zcit_appt_h_it18
          WHERE appointmentid = @ls_del_hdr-appointmentid.
        DELETE FROM zcit_appt_i_it18
          WHERE appointmentid = @ls_del_hdr-appointmentid.
      ENDLOOP.
    ELSE.
      LOOP AT lt_appt_headers INTO ls_del_hdr.
        DELETE FROM zcit_appt_h_it18
          WHERE appointmentid = @ls_del_hdr-appointmentid.
      ENDLOOP.
      LOOP AT lt_appt_items INTO DATA(ls_del_itm).
        DELETE FROM zcit_appt_i_it18
          WHERE appointmentid = @ls_del_itm-appointmentid
            AND slotnumber    = @ls_del_itm-slotnumber.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    zcl_appt_util_it18=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
