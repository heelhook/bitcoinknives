$:.unshift File.dirname(__FILE__)
$:.unshift "#{File.dirname(__FILE__)}/lib"

require "rules_query"
require "rule_trader_policy"
require "rule_trader_service"

loop do
  bitcoin_prices = BitcoinPriceChange.all.to_h {|bpc| [bpc.period, bpc]}

  rules_to_trade_queue = []

  RulesQuery.ready_to_trade.each do |rule|
    if RuleTraderPolicy.should_execute_trade?(rule, bitcoin_prices[rule.change_period])
      rules_to_trade_queue << rule
    end
  end

  trader_service = RuleTraderService.new(rules_to_trade_queue, bitcoin_prices)
  trader_service.trade!

  sleep(10)
end
