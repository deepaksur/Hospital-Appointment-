@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Appointment Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCIT_APPT_HC_IT18
  provider contract transactional_query
  as projection on ZCIT_APPT_HI_IT18
{
  key AppointmentId,
  PatientName,
  PatientAge,
  Gender,
  ContactNumber,
  DoctorName,
  Department,
  AppointmentDate,
  @Search.defaultSearchElement: true
  AppointmentStatus,
  @Semantics.amount.currencyCode: 'Currency'
  ConsultationFee,
  Currency,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,

  /* Associations */
  _appointmentitem : redirected to composition child ZCIT_APPT_IC_IT18
}
