class Currency < ApplicationRecord
  # Currencies has to be manually added for the requirement

=begin
  # Source of truth for currencies is added to a new table to main consistency and
  allow flexible updation of any additional attributes added specific to currency

  For eg: We may add country info for currency . Dollar maybe be adopted by any country
  

  Valid currencies used for development include:
    1. 'dollars'
    2. 'btc'
    3. 'eth'

  Run rails db:seed for populating records
=end
end
