@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View for Appointment Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCIT_APPT_HI_IT18
  as select from zcit_appt_h_it18 as AppointmentHeader
  composition [0..*] of ZCIT_APPT_II_IT18 as _appointmentitem
{
  key appointmentid          as AppointmentId,
  patientname                as PatientName,
  patientage                 as PatientAge,
  gender                     as Gender,
  contactnumber              as ContactNumber,
  doctorname                 as DoctorName,
  department                 as Department,
  appointmentdate            as AppointmentDate,
  appointmentstatus          as AppointmentStatus,
  @Semantics.amount.currencyCode: 'Currency'
  consultationfee            as ConsultationFee,
  currency                   as Currency,
  @Semantics.user.createdBy: true
  local_created_by           as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at           as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by      as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at      as LocalLastChangedAt,

  /* Associations */
  _appointmentitem
}
