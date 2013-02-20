require 'spec_helper'

describe Checkout do
  before :all do
    @rules =
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

  end

  it "should scan an item" do
    @co = Checkout.new (@rules)

    @co.scan ('FR1')
    @co.basket.any?.should be_true
  end

  it "should give the expected totals" do
    @co = Checkout.new (@rules)
    @co.scan ('FR1')
    @co.scan ('SR1')
    @co.scan ('FR1')
    @co.scan ('CF1')

    @co.total.should eql 22.45

    @co = Checkout.new (@rules)
    @co.scan ('FR1')
    @co.scan ('FR1')

    @co.total.should eql 3.11

    @co = Checkout.new (@rules)
    @co.scan ('SR1')
    @co.scan ('SR1')
    @co.scan ('FR1')
    @co.scan ('SR1')

    @co.total.should eql 16.61
  end

  it "should do buy-one-get-one-free offers" do
    @co = Checkout.new (@rules)
    @co.scan ('FR1')

    total = @co.total
    @co.scan ('FR1')

    @co.total.should eql total
  end

  it "should do discounts on bulk purchases" do
    @co = Checkout.new (@rules)
    @co.scan ('SR1')
    @co.scan ('SR1')
    @co.scan ('SR1')

    @co.total.should eql 13.5
  end
end

describe Catalog do
  before :all do
    file = 'products.json'
    @catalog = Catalog.new (file)
  end

  it "should have an array of products" do
    @catalog.products.is_a?(Array).should be_true
  end

  it "should return a product" do
    @catalog.get_product('FR1').any?.should be_true
  end
end
