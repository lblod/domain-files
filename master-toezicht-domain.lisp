;; Association resource which should describe properties associated with the form to use
;; now only 'validity period' is specified, but could be extended with specific bestuursorgaan/eenheid/etc..
(define-resource inzending-voor-toezicht-form-version ()
  :class (s-prefix "toezicht:InzendingVoorToezichtFormVersion")
  :properties `((:start :date ,(s-prefix "toezicht:inzendingVoorToezichtFormVersionStart"))
                (:end :date ,(s-prefix "toezicht:inzendingVoorToezichtFormVersionEnd"))
                (:description :string ,(s-prefix "dct:description"))
                )

  :has-one `((form-node :via ,(s-prefix "toezicht:inzendingVoorToezichtFormVersionFormNode")
                        :as "form-node"))

  :resource-base (s-url "http://data.lblod.info/inzending-voor-toezicht-form-version/")
  :features `(include-uri)
  :on-path "inzending-voor-toezicht-form-versions")

(define-resource inzending-voor-toezicht ()
  :class (s-prefix "toezicht:InzendingVoorToezicht") ;; subclass of nie:InformationElement > nfo:DataContainer
  :properties `((:created :datetime ,(s-prefix "dct:created"))
                (:modified :datetime ,(s-prefix "dct:modified"))
                (:sent-date :datetime ,(s-prefix "nmo:sentDate"))
                (:received-date :datetime ,(s-prefix "nmo:receivedDate"))
                (:description :string ,(s-prefix "dct:description"))
                (:remark :string ,(s-prefix "ext:remark"))
                (:temporal-coverage :string ,(s-prefix "toezicht:temporalCoverage"))
                (:business-identifier :string ,(s-prefix "toezicht:businessIdentifier"))
                (:business-name :string ,(s-prefix "toezicht:businessName"))
                (:date-of-entry-into-force :date ,(s-prefix "toezicht:dateOfEntryIntoForce"))
                (:end-date :date ,(s-prefix "toezicht:endDate"))
                (:has-extra-tax-rates :boolean ,(s-prefix "toezicht:hasExtraTaxRates"))
                (:agenda-item-count :integer ,(s-prefix "toezicht:agendaItemCount"))
                (:session-date :datetime ,(s-prefix "toezicht:sessionDate"))
                (:decision-date-other-administration :date ,(s-prefix "toezicht:decisionDateOtherAdministration"))
                (:decision-summary :string ,(s-prefix "toezicht:decisionSummary"))
                (:date-handover :date ,(s-prefix "toezicht:dateHandover"))
                (:text :string ,(s-prefix "toezicht:text"))
                (:date-publication-webapp :date ,(s-prefix "toezicht:datePublicationWebapp"))
                )

  :has-one `((document-status :via ,(s-prefix "adms:status")
                              :as "status")
             (gebruiker :via ,(s-prefix "ext:lastModifiedBy")
                        :as "last-modifier")
             (bestuurseenheid :via ,(s-prefix "dct:subject")
                              :as "bestuurseenheid")
             (form-solution :via ,(s-prefix "ext:hasInzendingVoorToezicht")
                            :inverse t
                            :as "form-solution")
             (toezicht-inzending-type :via ,(s-prefix "dct:type")
                                     :as "inzending-type")
             (besluit-type :via ,(s-prefix "toezicht:decisionType")
                           :as "besluit-type")
             (toezicht-regulation-type :via ,(s-prefix "toezicht:regulationType")
                           :as "regulation-type")
             (bestuursorgaan :via ,(s-prefix "toezicht:decidedBy")
                             :as "bestuursorgaan")
             (toezicht-document-authenticity-type :via ,(s-prefix "toezicht:authenticityType")
                                                  :as "authenticity-type")
             (toezicht-account-acceptance-status :via ,(s-prefix "toezicht:accountAcceptanceStatus")
                                                 :as "account-acceptance-status")
             (toezicht-delivery-report-type :via ,(s-prefix "toezicht:deliveryReportType")
                                            :as "delivery-report-type")
             (toezicht-fiscal-period :via ,(s-prefix "toezicht:fiscalPeriod")
                                     :as "fiscal-period")
             (toezicht-nomenclature :via ,(s-prefix "toezicht:nomenclature")
                                    :as "nomenclature")
             (toezicht-tax-type :via ,(s-prefix "toezicht:taxType")
                                :as "tax-type")
             (inzending-voor-toezicht-melding :via ,(s-prefix "dct:subject")
                                :inverse t
                                :as "melding")
             )
  :has-many `((file :via ,(s-prefix "nie:hasPart")
                    :as "files")
              (tax-rate :via ,(s-prefix "toezicht:taxRate")
                        :as "tax-rates")
              (simplified-tax-rate :via ,(s-prefix "toezicht:simplifiedTaxRate")
                        :as "simplified-tax-rates")
              (file-address :via ,(s-prefix "toezicht:fileAddress") :as "file-addresses")
              )
  :resource-base (s-url "http://data.lblod.info/inzendingen-voor-toezicht/")
  :features `(no-pagination-defaults include-uri)
  :on-path "inzendingen-voor-toezicht")

(define-resource toezicht-tax-type ()
  :class (s-prefix "toezicht:TaxType")
  :properties `(
                (:label :string ,(s-prefix "skos:prefLabel"))
                (:active :boolean ,(s-prefix "ext:isActiveToezichtCodeListEntry"))
                )
  :resource-base (s-url "http://data.lblod.info/toezicht-tax-types")
  :features `(include-uri)
  :on-path "toezicht-tax-types")

(define-resource toezicht-nomenclature ()
  :class (s-prefix "toezicht:Nomenclature")
  :properties `((:label :string ,(s-prefix "skos:prefLabel"))
                (:code :string ,(s-prefix "toezicht:nomenclatureCode")))
  :resource-base (s-url "http://data.lblod.info/toezicht-nomenclatures")
  :features `(include-uri)
  :on-path "toezicht-nomenclatures")

(define-resource toezicht-fiscal-period ()
  :class (s-prefix "toezicht:FiscalPeriod")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :resource-base (s-url "http://data.lblod.info/toezicht-fiscal-periods")
  :features `(include-uri)
  :on-path "toezicht-fiscal-periods")

(define-resource toezicht-delivery-report-type ()
  :class (s-prefix "toezicht:DeliveryReportType")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :resource-base (s-url "http://data.lblod.info/toezicht-delivery-report-types")
  :features `(include-uri)
  :on-path "toezicht-delivery-report-types")

(define-resource toezicht-account-acceptance-status ()
  :class (s-prefix "toezicht:AccountAcceptanceStatus")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :resource-base (s-url "http://data.lblod.info/toezicht-account-acceptance-statuses")
  :features `(include-uri)
  :on-path "toezicht-account-acceptance-statuses")

(define-resource toezicht-document-authenticity-type ()
  :class (s-prefix "toezicht:DocumentAuthenticityType")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :resource-base (s-url "http://data.lblod.info/toezicht-document-authenticity-types")
  :features `(include-uri)
  :on-path "toezicht-document-authenticity-types")

(define-resource toezicht-inzending-type ()
  :class (s-prefix "toezicht:InzendingType")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :resource-base (s-url "http://data.lblod.info/toezicht-inzending-types")
  :features `(include-uri)
  :on-path "toezicht-inzending-types")

(define-resource besluit-type ()
  :class (s-prefix "toezicht:DecisionType")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :has-many `((bestuurseenheid-classificatie-code :via ,(s-prefix "ext:decidableBy")
                                                  :as "decidable-by")
              (inzending-voor-toezicht-form-version :via ,(s-prefix "toezicht:formVersionScope")
                                                    :as "form-version"))
  :resource-base (s-url "http://data.lblod.info/besluit-types")
  :features `(include-uri)
  :on-path "besluit-types")

(define-resource toezicht-regulation-type ()
  :class (s-prefix "toezicht:RegulationType")
  :properties `((:label :string ,(s-prefix "skos:prefLabel"))
                (:position :number ,(s-prefix "schema:position")))
  :resource-base (s-url "http://data.lblod.info/toezicht-regulation-types")
  :features `(include-uri)
  :on-path "toezicht-regulation-types")

(define-resource tax-rate ()
  :class (s-prefix "toezicht:TaxRate")
  :properties `((:amount :float ,(s-prefix "toezicht:amoount"))
                (:unit :string ,(s-prefix "toezicht:unit"))
                (:base :string ,(s-prefix "toezicht:base"))
                (:remark :string ,(s-prefix "ext:remark")))
  :resource-base (s-url "http://data.lblod.info/tax-rates")
  :features `(include-uri)
  :on-path "tax-rates")

(define-resource simplified-tax-rate ()
  :class (s-prefix "toezicht:SimplifiedTaxRate")
  :properties `((:amount :string ,(s-prefix "toezicht:amoount")))
  :resource-base (s-url "http://data.lblod.info/simplified-tax-rates")
  :features `(include-uri)
  :on-path "simplified-tax-rates")

(define-resource form-solution ()
  :class (s-prefix "ext:FormSolution")
  :properties `((:has-owner :string ,(s-prefix "ext:hasOwnerAsString")))
  :has-one `((form-node :via ,(s-prefix "ext:hasForm")
                        :as "form-node")
             (inzending-voor-toezicht :via ,(s-prefix "ext:hasInzendingVoorToezicht")
                                      :as "inzending-voor-toezicht"))
  :resource-base (s-url "http://data.lblod.info/form-solutions/")
  :on-path "form-solutions")

(define-resource inzending-voor-toezicht-melding ()
  :class (s-prefix "toezicht:InzendingVoorToezichtMelding")
  :properties `((:description :string ,(s-prefix "dct:description")))
  :has-one `((melding-status :via ,(s-prefix "adms:status")
                             :as "status")
             (inzending-voor-toezicht :via ,(s-prefix "dct:subject")
                             :as "inzending-voor-toezicht"))
  :resource-base (s-url "http://data.lblod.info/inzending-voor-toezicht-meldingen/")
  :on-path "inzending-voor-toezicht-meldingen")

(define-resource melding-status ()
  :class (s-prefix "toezicht:MeldingStatus")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :has-many `((inzending-voor-toezicht-melding :via ,(s-prefix "adms:status")
                                               :inverse t
                                               :as "meldingen"))
  :resource-base (s-url "http://data.lblod.info/melding-statuses/")
  :features `(no-pagination-defaults include-uri)
  :on-path "melding-statuses")
