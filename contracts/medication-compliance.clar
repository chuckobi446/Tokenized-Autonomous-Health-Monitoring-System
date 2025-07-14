;; Medication Compliance Contract
;; Ensures proper prescription adherence and timing

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-INPUT (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-EXISTS (err u103))

;; Data Variables
(define-data-var next-medication-id uint u1)
(define-data-var next-dose-id uint u1)

;; Data Maps
(define-map medications
  uint
  {
    patient: principal,
    name: (string-ascii 50),
    dosage: uint,
    frequency-per-day: uint,
    interval-minutes: uint,
    start-date: uint,
    end-date: (optional uint),
    prescribed-by: principal,
    active: bool
  }
)

(define-map dose-records
  uint
  {
    medication-id: uint,
    patient: principal,
    scheduled-time: uint,
    actual-time: (optional uint),
    taken: bool,
    notes: (optional (string-ascii 200))
  }
)

(define-map patient-medications
  principal
  (list 50 uint)
)

(define-map authorized-prescribers
  principal
  bool
)

;; Authorization Functions
(define-public (authorize-prescriber (prescriber principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-prescribers prescriber true))
  )
)

;; Medication Management
(define-public (add-medication
  (patient principal)
  (name (string-ascii 50))
  (dosage uint)
  (frequency-per-day uint)
  (interval-minutes uint)
  (start-date uint)
  (end-date (optional uint)))
  (let
    (
      (medication-id (var-get next-medication-id))
      (current-medications (default-to (list) (map-get? patient-medications patient)))
    )
    (begin
      ;; Validate authorization
      (asserts!
        (or
          (is-eq tx-sender patient)
          (default-to false (map-get? authorized-prescribers tx-sender))
        )
        ERR-NOT-AUTHORIZED
      )

      ;; Validate inputs
      (asserts! (> (len name) u0) ERR-INVALID-INPUT)
      (asserts! (> dosage u0) ERR-INVALID-INPUT)
      (asserts! (and (> frequency-per-day u0) (<= frequency-per-day u24)) ERR-INVALID-INPUT)
      (asserts! (> interval-minutes u0) ERR-INVALID-INPUT)

      ;; Store medication
      (map-set medications medication-id
        {
          patient: patient,
          name: name,
          dosage: dosage,
          frequency-per-day: frequency-per-day,
          interval-minutes: interval-minutes,
          start-date: start-date,
          end-date: end-date,
          prescribed-by: tx-sender,
          active: true
        }
      )

      ;; Update patient medications list
      (map-set patient-medications patient
        (unwrap-panic (as-max-len? (append current-medications medication-id) u50))
      )

      ;; Increment medication ID
      (var-set next-medication-id (+ medication-id u1))

      (ok medication-id)
    )
  )
)

(define-public (record-dose-taken
  (medication-id uint)
  (scheduled-time uint)
  (actual-time uint)
  (notes (optional (string-ascii 200))))
  (let
    (
      (dose-id (var-get next-dose-id))
      (medication (unwrap! (map-get? medications medication-id) ERR-NOT-FOUND))
    )
    (begin
      ;; Validate authorization
      (asserts! (is-eq tx-sender (get patient medication)) ERR-NOT-AUTHORIZED)

      ;; Record dose
      (map-set dose-records dose-id
        {
          medication-id: medication-id,
          patient: (get patient medication),
          scheduled-time: scheduled-time,
          actual-time: (some actual-time),
          taken: true,
          notes: notes
        }
      )

      ;; Increment dose ID
      (var-set next-dose-id (+ dose-id u1))

      (ok dose-id)
    )
  )
)

(define-public (record-missed-dose
  (medication-id uint)
  (scheduled-time uint)
  (notes (optional (string-ascii 200))))
  (let
    (
      (dose-id (var-get next-dose-id))
      (medication (unwrap! (map-get? medications medication-id) ERR-NOT-FOUND))
    )
    (begin
      ;; Validate authorization
      (asserts! (is-eq tx-sender (get patient medication)) ERR-NOT-AUTHORIZED)

      ;; Record missed dose
      (map-set dose-records dose-id
        {
          medication-id: medication-id,
          patient: (get patient medication),
          scheduled-time: scheduled-time,
          actual-time: none,
          taken: false,
          notes: notes
        }
      )

      ;; Increment dose ID
      (var-set next-dose-id (+ dose-id u1))

      (ok dose-id)
    )
  )
)

(define-public (deactivate-medication (medication-id uint))
  (let
    (
      (medication (unwrap! (map-get? medications medication-id) ERR-NOT-FOUND))
    )
    (begin
      ;; Validate authorization
      (asserts!
        (or
          (is-eq tx-sender (get patient medication))
          (is-eq tx-sender (get prescribed-by medication))
        )
        ERR-NOT-AUTHORIZED
      )

      ;; Deactivate medication
      (ok (map-set medications medication-id
        (merge medication { active: false })
      ))
    )
  )
)

;; Read-only Functions
(define-read-only (get-medication (medication-id uint))
  (map-get? medications medication-id)
)

(define-read-only (get-patient-medications (patient principal))
  (map-get? patient-medications patient)
)

(define-read-only (get-dose-record (dose-id uint))
  (map-get? dose-records dose-id)
)

(define-read-only (calculate-compliance-rate (patient principal) (medication-id uint) (days uint))
  ;; Simplified compliance calculation
  ;; In a real implementation, this would analyze dose records over the specified period
  u85 ;; Placeholder return value
)

(define-read-only (is-prescriber-authorized (prescriber principal))
  (default-to false (map-get? authorized-prescribers prescriber))
)
