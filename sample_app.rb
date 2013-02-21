require 'rubygems'
require 'supermarket'

rules =
[
  {
    :type => 'buyonegetonefree',
    :product_code => 'FR1'
  },
  {
    :type => 'bulkpurchase',
    :product_code => 'SR1',
    :items => 3,
    :price => 4.50
  }
]

co = Checkout.new (rules)

co.scan ('SR1')
co.scan ('SR1')
co.scan ('SR1')
co.scan ('FR1')
co.scan ('FR1')

puts co.total
