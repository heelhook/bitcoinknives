class Trade < ApplicationRecord
  belongs_to :rule
  has_one :user, through: :rule

  delegate :change_period,
           :formula,
           :base_currency,
           :slug,
           :max_sats_per_trade,
           to: :rule, prefix: true

  delegate :base_currency,
           :exchange_name,
           :exchange_api_key,
           :exchange_api_secret,
           :exchange_api_passphrase,
           :trade_notification,
           to: :rule, prefix: false

  delegate :id,
           :email,
           to: :user, prefix: true

  default_scope -> { order(created_at: :desc) }
  scope :successful, -> { where(tx_status: TradeResult::STATUS::Success) }

  def successful?
    tx_status == TradeResult::STATUS::Success
  end
end
