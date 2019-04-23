;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEIDINGGEVENDEN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; this is a shared domain file, maintained in https://github.com/lblod/domain-files
(define-resource bestuursfunctie ()
  :class (s-prefix "lblodlg:Bestuursfunctie")
  :has-one `((bestuursfunctie-code :via ,(s-prefix "org:role")
                                   :as "rol")
             (contact-punt :via ,(s-prefix "schema:contactPoint")
                           :as "contactinfo"))
  :has-many `((bestuurorgaan :via ,(s-prefix "lblodlg:heeftBestuursfunctie")
                             :inverse t
                             :as "bevat-in"))
  :resource-base (s-url "http://data.lblod.info/id/bestuursfuncties/")
  :features '(include-uri)
  :on-path "bestuursfuncties")

(define-resource functionaris ()
  :class (s-prefix "lblodlg:Functionaris")
  :properties `((:start :datetime ,(s-prefix "mandaat:start"))
                (:einde :datetime ,(s-prefix "mandaat:einde")))
  :has-one `((bestuursfunctie :via ,(s-prefix "org:holds")
                              :as "bekleedt")
             (functionaris-status-code :via ,(s-prefix "mandaat:status")
                                     :as "status")
             (persoon :via ,(s-prefix "mandaat:isBestuurlijkeAliasVan")
                      :as "is-bestuurlijke-alias-van"))
  :resource-base (s-url "http://data.lbod.info/id/functionarissen/")
  :features '(include-uri)
  :on-path "functionarissen")

(define-resource contact-punt ()
  :class (s-prefix "schema:PostalAddress")
  :properties `((:land :string ,(s-prefix "schema:addressCountry"))
                (:gemeente :string ,(s-prefix "schema:addressLocality"))
                (:adres :string ,(s-prefix "schema:streetAddress"))
                (:postcode :string ,(s-prefix "schema:postalCode"))
                (:email :string ,(s-prefix "schema:email"))
                (:telephone :string ,(s-prefix "schema:telephone"))
                (:fax :string ,(s-prefix "schema:faxNumber"))
                (:website :string ,(s-prefix "schema:url")))
  :resource-base (s-url "http://data.lblod.info/id/contactpunt/")
  :features '(include-uri)
  :on-path "contact-punten"
  )

(define-resource functionaris-status-code ()
  :class (s-prefix "lblodlg:FunctionarisStatusCode")
  :properties `((:label :string ,(s-prefix "skos:prefLabel"))
                (:scope-note :string ,(s-prefix "skos:scopeNote")))
  :resource-base (s-url "http://data.vlaanderen.be/id/concept/MandatarisStatusCode/")
  :features '(include-uri)
  :on-path "mandataris-status-codes")
