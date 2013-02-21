class Checkout
  attr_accessor :basket

  def initialize (price_rules)
    @rules = price_rules || []
    @basket = []

    file = 'products.json'
    @catalog = Catalog.new (file)
  end

  def scan (code)
    product = @catalog.get_product (code)

    item = {
      :code  => product['code'],
      :price => product['price']
    }

    @basket << item
  end

  def buyonegetonefree (code)
    @basket.each_with_index { |item, index|
      if item[:code] == code
        item[:price] = 0 if (index+1) % 2 == 0 
      end
    }
  end

  def bulkpurchase (code, nitems, new_price)
    totalitems = @basket.select { |item| item[:code] == code }.length

    if totalitems >= nitems
      @basket.each_with_index { |item, index|
        if item[:code] == code
          item[:price] = new_price
        end
      }
    else
      @basket
    end
  end

  def apply_rules
    @rules.each { |rule|
      case rule[:type] 
        when 'buyonegetonefree' then
          @basket = buyonegetonefree(rule[:product_code])
        when 'bulkpurchase' then
          @basket = bulkpurchase(rule[:product_code],
                                 rule[:items],
                                 rule[:price])
      end
    }

    @basket
  end

  def total
    bill = apply_rules.map { |item| item[:price] }
    total = bill.inject(:+)
  end
end
