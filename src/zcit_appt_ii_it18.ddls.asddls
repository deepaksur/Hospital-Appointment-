@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View – Appointment Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZCIT_APPT_II_IT18
  as select from zcit_appt_i_it18
  association to parent ZCIT_APPT_HI_IT18 as _appointmentHeader
    on $projection.AppointmentId = _appointmentHeader.AppointmentId
{
  key appointmentid   as AppointmentId,
  key slotnumber      as SlotNumber,
  slottime            as SlotTime,
  diagnosis           as Diagnosis,
  prescription        as Prescription,
  followupdate        as FollowUpDate,
  slotstatus          as SlotStatus,
  @Semantics.user.createdBy: true
  local_created_by    as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at    as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,

  /* Associations */
  _appointmentHeader
}
