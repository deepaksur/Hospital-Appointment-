CLASS lhc_AppointmentItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE AppointmentItm.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE AppointmentItm.
    METHODS read FOR READ
      IMPORTING keys FOR READ AppointmentItm RESULT result.
    METHODS rba_Appointmentheader FOR READ
      IMPORTING keys_rba FOR READ AppointmentItm\_Appointmentheader
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_AppointmentItem IMPLEMENTATION.
  METHOD update.
    DATA: ls_appt_itm TYPE zcit_appt_i_it18.
    LOOP AT entities INTO DATA(ls_entities).
      ls_appt_itm = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_appt_itm-appointmentid IS NOT INITIAL.
        SELECT FROM zcit_appt_i_it18 FIELDS *
          WHERE appointmentid = @ls_appt_itm-appointmentid
            AND slotnumber    = @ls_appt_itm-slotnumber
          INTO TABLE @DATA(lt_appt_itm).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_appt_util_it18=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_appt_itm = ls_appt_itm
            IMPORTING ex_created  = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #(
              appointmentid = ls_appt_itm-appointmentid
              slotnumber    = ls_appt_itm-slotnumber )
              TO mapped-appointmentitm.
            APPEND VALUE #( %key = ls_entities-%key
              %msg = new_message( id = 'ZCIT_APPT_MSG_IT18'
                number = 001 v1 = 'Slot Updated Successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-appointmentitm.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid = ls_entities-%cid_ref
            appointmentid = ls_appt_itm-appointmentid
            slotnumber    = ls_appt_itm-slotnumber )
            TO failed-appointmentitm.
          APPEND VALUE #(
            %cid = ls_entities-%cid_ref
            appointmentid = ls_appt_itm-appointmentid
            %msg = new_message( id = 'ZCIT_APPT_MSG_IT18'
              number = 001 v1 = 'Slot Not Found!'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-appointmentitm.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcl_appt_util_it18=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      DATA(ls_itm) = VALUE zcl_appt_util_it18=>ty_appt_itm(
        appointmentid = ls_key-appointmentid
        slotnumber    = ls_key-SlotNumber ).
      lo_util->set_itm_t_deletion( im_appt_itm_info = ls_itm ).
      APPEND VALUE #(
        %cid = ls_key-%cid_ref
        appointmentid = ls_key-appointmentid
        slotnumber    = ls_key-SlotNumber
        %msg = new_message( id = 'ZCIT_APPT_MSG_IT18'
          number = 001 v1 = 'Slot Deleted Successfully'
          severity = if_abap_behv_message=>severity-success ) )
        TO reported-appointmentitm.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    " Optional for transactional flow
  ENDMETHOD.

  METHOD rba_Appointmentheader.
    " Optional – Read by Association back to header
  ENDMETHOD.
ENDCLASS.
