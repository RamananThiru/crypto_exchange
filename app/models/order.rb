class Order < ApplicationRecord
  SIDE_MAPPING = { 1 => 'buy', 2 => 'sell' }
  STATUS_MAPPING = { 0 => 'pending', 1 => 'cancelled' }

  def as_json(options = {})
    payload = super(options).merge(
      side: side,
      price: price.to_s,
      volume: volume.to_s,
      state: status,
      buy_currency: Currency.find_by(id: base_currency_id).currency_type,
      sell_currency: Currency.find_by(id: quote_currency_id).currency_type,
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601
    )
    
    payload.reject { |key, _| ['base_currency_id', 'quote_currency_id'].include?(key) }
end


  # getter , setter methods for integer columns
  def side
    SIDE_MAPPING[read_attribute(:side)] || nil
  end

  def side=(value)
    write_attribute(:side, SIDE_MAPPING.key(value.downcase) || nil)
  end

  def status
    STATUS_MAPPING[read_attribute(:status)] || nil
  end

  def status=(value)
    write_attribute(:status, STATUS_MAPPING.key(value.downcase) || nil)
  end
end
