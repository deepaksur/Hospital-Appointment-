CLASS zcl_appt_util_it18 DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_appt_hdr,
             appointmentid TYPE zsappt_it18,
           END OF ty_appt_hdr,
           BEGIN OF ty_appt_itm,
             appointmentid TYPE zsappt_it18,
             slotnumber    TYPE int2,
           END OF ty_appt_itm.
    TYPES: tt_appt_hdr TYPE STANDARD TABLE OF ty_appt_hdr,
           tt_appt_itm TYPE STANDARD TABLE OF ty_appt_itm.

    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_appt_util_it18.

    METHODS:
      set_hdr_value
        IMPORTING im_appt_hdr TYPE zcit_appt_h_it18
        EXPORTING ex_created  TYPE abap_boolean,
      get_hdr_value
        EXPORTING ex_appt_hdr TYPE zcit_appt_h_it18,
      set_itm_value
        IMPORTING im_appt_itm TYPE zcit_appt_i_it18
        EXPORTING ex_created  TYPE abap_boolean,
      get_itm_value
        EXPORTING ex_appt_itm TYPE zcit_appt_i_it18,
      set_hdr_t_deletion
        IMPORTING im_appt_doc TYPE ty_appt_hdr,
      set_itm_t_deletion
        IMPORTING im_appt_itm_info TYPE ty_appt_itm,
      get_hdr_t_deletion
        EXPORTING ex_appt_docs TYPE tt_appt_hdr,
      get_itm_t_deletion
        EXPORTING ex_appt_info TYPE tt_appt_itm,
      set_hdr_deletion_flag
        IMPORTING im_appt_delete TYPE abap_boolean,
      get_deletion_flags
        EXPORTING ex_appt_hdr_del TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: gs_appt_hdr_buff  TYPE zcit_appt_h_it18,
                gs_appt_itm_buff  TYPE zcit_appt_i_it18,
                gt_appt_hdr_t_buff TYPE tt_appt_hdr,
                gt_appt_itm_t_buff TYPE tt_appt_itm,
                gv_appt_delete    TYPE abap_boolean.
    CLASS-DATA mo_instance TYPE REF TO zcl_appt_util_it18.
ENDCLASS.

CLASS zcl_appt_util_it18 IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF im_appt_hdr-appointmentid IS NOT INITIAL.
      gs_appt_hdr_buff = im_appt_hdr.
      ex_created = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value.
    ex_appt_hdr = gs_appt_hdr_buff.
  ENDMETHOD.

  METHOD set_itm_value.
    IF im_appt_itm IS NOT INITIAL.
      gs_appt_itm_buff = im_appt_itm.
      ex_created = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_itm_value.
    ex_appt_itm = gs_appt_itm_buff.
  ENDMETHOD.

  METHOD set_hdr_t_deletion.
    APPEND im_appt_doc TO gt_appt_hdr_t_buff.
  ENDMETHOD.

  METHOD set_itm_t_deletion.
    APPEND im_appt_itm_info TO gt_appt_itm_t_buff.
  ENDMETHOD.

  METHOD get_hdr_t_deletion.
    ex_appt_docs = gt_appt_hdr_t_buff.
  ENDMETHOD.

  METHOD get_itm_t_deletion.
    ex_appt_info = gt_appt_itm_t_buff.
  ENDMETHOD.

  METHOD set_hdr_deletion_flag.
    gv_appt_delete = im_appt_delete.
  ENDMETHOD.

  METHOD get_deletion_flags.
    ex_appt_hdr_del = gv_appt_delete.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_appt_hdr_buff, gs_appt_itm_buff,
           gt_appt_hdr_t_buff, gt_appt_itm_t_buff, gv_appt_delete.
  ENDMETHOD.
ENDCLASS.

