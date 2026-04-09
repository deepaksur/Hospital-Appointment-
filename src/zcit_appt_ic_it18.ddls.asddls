@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Appointment Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCIT_APPT_IC_IT18
  as projection on ZCIT_APPT_II_IT18
{
  key AppointmentId,
  key SlotNumber,
  @Search.defaultSearchElement: true
  SlotTime,
  Diagnosis,
  Prescription,
  FollowUpDate,
  SlotStatus,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,

  /* Associations */
  _appointmentHeader : redirected to parent ZCIT_APPT_HC_IT18
}
