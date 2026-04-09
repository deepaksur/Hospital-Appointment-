CLASS lhc_AppointmentHdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR AppointmentHdr RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR AppointmentHdr RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE AppointmentHdr.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE AppointmentHdr.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE AppointmentHdr.
    METHODS read FOR READ
      IMPORTING keys FOR READ AppointmentHdr RESULT result.
    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK AppointmentHdr.
    METHODS rba_Appointmentitem FOR READ
      IMPORTING keys_rba FOR READ AppointmentHdr\_Appointmentitem
      FULL result_requested RESULT result LINK association_links.
    METHODS cba_Appointmentitem FOR MODIFY
      IMPORTING entities_cba FOR CREATE AppointmentHdr\_Appointmentitem.
ENDCLASS.

CLASS lhc_AppointmentHdr IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.  ENDMETHOD.
  METHOD lock.                       ENDMETHOD.

  METHOD create.
    DATA: ls_appt_hdr TYPE zcit_appt_h_it18.
    LOOP AT entities INTO DATA(ls_entities).
      ls_appt_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_appt_hdr-appointmentid IS NOT INITIAL.
        SELECT FROM zcit_appt_h_it18 FIELDS *
          WHERE appointmentid = @ls_appt_hdr-appointmentid
          INTO TABLE @DATA(lt_appt_hdr).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_appt_util_it18=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_appt_hdr = ls_appt_hdr
            IMPORTING ex_created  = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( %cid = ls_entities-%cid
              appointmentid = ls_appt_hdr-appointmentid )
              TO mapped-appointmenthdr.
            APPEND VALUE #( %cid = ls_entities-%cid
              appointmentid = ls_appt_hdr-appointmentid
              %msg = new_message( id = 'ZCIT_APPT_MSG_IT018'
                number = 001 v1 = 'Appointment Created Successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-appointmenthdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entities-%cid
            appointmentid = ls_appt_hdr-appointmentid )
            TO failed-appointmenthdr.
          APPEND VALUE #( %cid = ls_entities-%cid
            appointmentid = ls_appt_hdr-appointmentid
            %msg = new_message( id = 'ZCIT_APPT_MSG_IT018'
              number = 001 v1 = 'Duplicate Appointment ID'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-appointmenthdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_appt_hdr TYPE zcit_appt_h_it18.
    LOOP AT entities INTO DATA(ls_entities).
      ls_appt_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_appt_hdr-appointmentid IS NOT INITIAL.
        SELECT FROM zcit_appt_h_it18 FIELDS *
          WHERE appointmentid = @ls_appt_hdr-appointmentid
          INTO TABLE @DATA(lt_appt_hdr).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_appt_util_it18=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_appt_hdr = ls_appt_hdr
            IMPORTING ex_created  = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( appointmentid = ls_appt_hdr-appointmentid )
              TO mapped-appointmenthdr.
            APPEND VALUE #( %key = ls_entities-%key
              %msg = new_message( id = 'ZCIT_APPT_MSG_IT18'
                number = 001 v1 = 'Appointment Updated Successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-appointmenthdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entities-%cid_ref
            appointmentid = ls_appt_hdr-appointmentid )
            TO failed-appointmenthdr.
          APPEND VALUE #( %cid = ls_entities-%cid_ref
            appointmentid = ls_appt_hdr-appointmentid
            %msg = new_message( id = 'ZCIT_APPT_MSG_IT18'
              number = 001 v1 = 'Appointment Not Found!'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-appointmenthdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcl_appt_util_it018=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      DATA(ls_appt_doc) = VALUE zcl_appt_util_it18=>ty_appt_hdr(
        appointmentid = ls_key-appointmentid ).
      lo_util->set_hdr_t_deletion( EXPORTING im_appt_doc = ls_appt_doc ).
      lo_util->set_hdr_deletion_flag( EXPORTING im_appt_delete = abap_true ).
      APPEND VALUE #( %cid = ls_key-%cid_ref
        appointmentid = ls_key-appointmentid
        %msg = new_message( id = 'ZCIT_APPT_MSG_IT18'
          number = 001 v1 = 'Appointment Deleted'
          severity = if_abap_behv_message=>severity-success ) )
        TO reported-appointmenthdr.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zcit_appt_h_it18 FIELDS *
        WHERE appointmentid = @ls_key-appointmentid
        INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Appointmentitem.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zcit_appt_i_it18 FIELDS *
        WHERE appointmentid = @ls_key-appointmentid
        INTO TABLE @DATA(lt_items).
      LOOP AT lt_items INTO DATA(ls_item).
        APPEND CORRESPONDING #( ls_item ) TO result.
        APPEND VALUE #(
          source-appointmentid = ls_key-appointmentid
          target-appointmentid = ls_item-appointmentid
          target-slotnumber    = ls_item-slotnumber )
          TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Appointmentitem.
    DATA ls_appt_itm TYPE zcit_appt_i_it18.
    LOOP AT entities_cba INTO DATA(ls_entities_cba).
      ls_appt_itm = CORRESPONDING #( ls_entities_cba-%target[ 1 ] ).
      IF ls_appt_itm-appointmentid IS NOT INITIAL AND
         ls_appt_itm-slotnumber IS NOT INITIAL.
        SELECT FROM zcit_appt_i_it18 FIELDS *
          WHERE appointmentid = @ls_appt_itm-appointmentid
            AND slotnumber    = @ls_appt_itm-slotnumber
          INTO TABLE @DATA(lt_appt_itm).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_appt_util_it18=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_appt_itm = ls_appt_itm
            IMPORTING ex_created  = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #(
              %cid = ls_entities_cba-%target[ 1 ]-%cid
              appointmentid = ls_appt_itm-appointmentid
              slotnumber    = ls_appt_itm-slotnumber )
              TO mapped-appointmentitm.
            APPEND VALUE #(
              %cid = ls_entities_cba-%target[ 1 ]-%cid
              appointmentid = ls_appt_itm-appointmentid
              %msg = new_message( id = 'ZCIT_APPT_MSG_IT18'
                number = 001 v1 = 'Slot Created Successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-appointmentitm.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid = ls_entities_cba-%target[ 1 ]-%cid
            appointmentid = ls_appt_itm-appointmentid
            slotnumber    = ls_appt_itm-slotnumber )
            TO failed-appointmentitm.
          APPEND VALUE #(
            %cid = ls_entities_cba-%target[ 1 ]-%cid
            appointmentid = ls_appt_itm-appointmentid
            %msg = new_message( id = 'ZCIT_APPT_MSG_IT18'
              number = 002 v1 = 'Duplicate Slot Number'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-appointmentitm.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
